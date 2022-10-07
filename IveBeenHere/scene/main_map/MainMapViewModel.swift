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
    
    private let disposeBag = DisposeBag()
    
    var setUserLocationCoordi = PublishRelay<Coordinate>()
    var viewAttirbute = PublishRelay<Void>()
    var didLogin = PublishRelay<Bool>()
        
    init() {
        viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            self.viewAttirbute.accept(value: ())
        }
        .disposed(by: disposeBag)
        
        addPostButtonTapped.bind { [weak self] _ in
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
}
protocol MainMapViewModelOutput {
    var viewAttirbute: PublishRelay<Void> { get }
    var setUserLocationCoordi: PublishRelay<Coordinate> { get }
    var didLogin: PublishRelay<Bool> { get }
}
protocol MainMapViewModelBinding {
    func action() -> MainMapViewModelInput
    func state() -> MainMapViewModelOutput
}
enum LocationPermission {
    case available
    case unavailable
}
