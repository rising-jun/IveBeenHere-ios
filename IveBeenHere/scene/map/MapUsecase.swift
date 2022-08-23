//
//  MapUsecase.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import Foundation

final class MapUsecase {
    var permissionManager: PermissionManager?
    var coordiRelay = PublishRelay<Coordinate>()
    var viewModelResponsable: MapViewModelOutput?
    init() {
        coordiRelay.bind { [weak self] coordi in
            guard let self = self else { return }
            self.viewModelResponsable?
                .setUserLocationCoordi
                .accept(value: coordi)
        }
    }
    
}
extension MapUsecase: MapManagable {
    func requestPermission() {
        permissionManager?.getLocationPermission()
    }
}

protocol MapManagable: MapUsecaseCoordiUpdatable {
    func requestPermission()
}

protocol MapUsecaseCoordiUpdatable {
    var coordiRelay: PublishRelay<Coordinate> { get }
}
