//
//  MapViewModel.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import Foundation

final class MapViewModel {
    var usecase: MapUsecase?
    var viewDidLoad = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    var setUserLocationCoordi = PublishRelay<Coordinate>()
    
    init() {
        viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            self.usecase?.requestPermission()
        }.disposed(by: disposeBag)
        
    }
}

extension MapViewModel: MapViewModelType {
    func action() -> MapViewModelInput {
        return self
    }
    
    func state() -> MapViewModelOutput {
        return self
    }
}

typealias MapViewModelType = MapViewModelInput & MapViewModelOutput & MapViewModelBinding

protocol MapViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
}
protocol MapViewModelOutput {
    var setUserLocationCoordi: PublishRelay<Coordinate> { get }
}
protocol MapViewModelBinding {
    func action() -> MapViewModelInput
    func state() -> MapViewModelOutput
}

enum LocationPermission {
    case available
    case unavailable
}
