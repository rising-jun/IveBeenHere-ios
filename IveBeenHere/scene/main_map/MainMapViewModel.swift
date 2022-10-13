//
//  MainMapViewModel.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import Foundation

final class MainMapViewModel {
    var usecase: MainMapUsecase?
    var viewDidLoad = PublishRelay<Void>()
    var addPostButtonTapped = PublishRelay<Void>()
    var userRequestLogin = PublishRelay<Void>()
    var postDidTapRelays: [PublishRelay<Void>] = []
    var uploadedPost = PublishRelay<VisitDTO>()
    
    private let disposeBag = DisposeBag()
    
    var setUserLocationCoordi = PublishRelay<Coordinate>()
    var viewAttirbute = PublishRelay<Void>()
    var didLogin = PublishRelay<Bool>()
    var firebaseError = PublishRelay<FireBaseError>()
    var updateVisits = PublishRelay<[VisitDTO]>()
    var presentPost = PublishRelay<VisitDTO>()
    
    init() {
        viewDidLoad
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.viewAttirbute.accept(value: ())
                Task {
                    await self.usecase?.requestVisitDTO()
                }
            }
            .disposed(by: disposeBag)
        
        addPostButtonTapped
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.usecase?.checkLogin()
            }
            .disposed(by: disposeBag)
        
        userRequestLogin
            .observe(on: DispatchQueue.main)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.usecase?.requestKakaoLogin()
            }
            .disposed(by: disposeBag)
        
        updateVisits
            .bind { [weak self] visitDTOs in
                guard let self = self else { return }
                self.postDidTapRelays = []
                self.registerAnnotationEvent(visitDTOs: visitDTOs)
            }
            .disposed(by: disposeBag)
        
        uploadedPost
            .bind { [weak self] visitDTO in
                guard let self = self else { return }
                Task {
                    await self.usecase?.requestVisitDTO()
                }
            }
            .disposed(by: disposeBag)
    }
}
extension MainMapViewModel {
    private func registerAnnotationEvent(visitDTOs: [VisitDTO]) {
        for index in 0 ..< visitDTOs.count {
            let tapEvent = PublishRelay<Void>()
            tapEvent
                .bind { [weak self] _ in
                    guard let self = self else { return }
                    self.presentPost.accept(value: visitDTOs[index])
                }
                .disposed(by: disposeBag)
            postDidTapRelays.append(tapEvent)
        }
    }
}


extension MainMapViewModel: MainMapViewModelType {
    func action() -> MainMapViewModelInput {
        return self
    }
    
    func state() -> MainMapViewModelOutput {
        return self
    }
}

typealias MainMapViewModelType = MainMapViewModelInput & MainMapViewModelOutput & MainMapViewModelBinding

protocol MainMapViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
    var addPostButtonTapped: PublishRelay<Void> { get }
    var userRequestLogin: PublishRelay<Void> { get }
    var postDidTapRelays: [PublishRelay<Void>] { get }
    var uploadedPost: PublishRelay<VisitDTO> { get }
}
protocol MainMapViewModelOutput {
    var viewAttirbute: PublishRelay<Void> { get }
    var setUserLocationCoordi: PublishRelay<Coordinate> { get }
    var didLogin: PublishRelay<Bool> { get }
    var firebaseError: PublishRelay<FireBaseError> { get }
    var updateVisits: PublishRelay<[VisitDTO]> { get }
    var presentPost: PublishRelay<VisitDTO> { get }
}
protocol MainMapViewModelBinding {
    func action() -> MainMapViewModelInput
    func state() -> MainMapViewModelOutput
}
enum LocationPermission {
    case available
    case unavailable
}
