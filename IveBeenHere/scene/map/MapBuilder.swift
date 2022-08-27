//
//  MapBuilder.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/22.
//

import Foundation

protocol MapBuildingLogic {
    typealias Destination = MapViewController
    func build() -> Destination
}

class MapBuilder: MapBuildingLogic {
    func build() -> Destination {
        let viewController = MapViewController.instance()
        let viewModel = MapViewModel()
        let mapUsecase = MapUsecase()
        let permissionManager = PermissionManager()
        
        viewModel.usecase = mapUsecase
        mapUsecase.permissionManager = permissionManager
        mapUsecase.viewModelResponsable = viewModel
        viewController.viewModel = viewModel
        permissionManager.coordiUpdatable = mapUsecase
        
        return viewController
    }
}

