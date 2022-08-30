//
//  PlaceAddMapViewModel.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import Foundation

final class PlaceAddMapViewModel: PlaceAddMapViewModelType {
    var placeAddMapManagable: PlaceAddMapUsecase?
    
    var viewDidLoad = PublishRelay<Void>()
    var draggedPoint = PublishRelay<Coordinate>()
    var keyboardAppear = PublishRelay<Float>()
    var addButtonTapped = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    var viewAttribute = PublishRelay<Void>()
    var updateConstraints = PublishRelay<Float>()
    var presentWriteView = PublishRelay<Void>()
    private var placePoint: Coordinate?
    
    init() {
        action().viewDidLoad
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewAttribute.accept(value: ())
            }
            .disposed(by: disposeBag)
        
        action().draggedPoint
            .bind { [weak self] coordi in
                guard let self = self else { return }
                self.placePoint = coordi
            }
            .disposed(by: disposeBag)
        
        action().keyboardAppear
            .bind { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.updateConstraints.accept(value: keyboardHeight)
            }
            .disposed(by: disposeBag)
        
        action().addButtonTapped
            .bind { [weak self] placeTitle in
                guard let self = self else { return }
                if let placePoint = self.placePoint {
                    self.placeAddMapManagable?.requestAdd(place: PlaceDTO(latitude: placePoint.latitude, name: placeTitle, longitude: placePoint.longitude))
                }
                self.presentWriteView.accept(value: ())
            }
            .disposed(by: disposeBag)
    }
}
extension PlaceAddMapViewModel {
    func action() -> PlaceAddMapViewModelInput {
        self
    }
    
    func state() -> PlaceAddMapViewModelOutput {
        self
    }
}

typealias PlaceAddMapViewModelType = PlaceAddMapViewModelInput & PlaceAddMapViewModelOutput & PlaceAddMapViewModelBinding

protocol PlaceAddMapViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
    var draggedPoint: PublishRelay<Coordinate> { get }
    var keyboardAppear: PublishRelay<Float> { get }
    var addButtonTapped: PublishRelay<String> { get }
}

protocol PlaceAddMapViewModelOutput {
    var viewAttribute: PublishRelay<Void> { get }
    var updateConstraints: PublishRelay<Float> { get }
    var presentWriteView: PublishRelay<Void> { get }
}

protocol PlaceAddMapViewModelBinding {
    func action() -> PlaceAddMapViewModelInput
    func state() -> PlaceAddMapViewModelOutput
}
