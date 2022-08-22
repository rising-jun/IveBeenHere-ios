//
//  SplashBuilder.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/20.
//

import Foundation

protocol MapBuildingLogic {
    typealias Destination = MapViewController
    func build() -> Destination
}

class MapBuilder: MapBuildingLogic {
    func build() -> Destination {
        let viewController = MapViewController.init()
        let viewModel = MapViewModel()
        let mapUsecase = MapUsecase()
        let permissionManager = PermissionManager()
        viewModel.usecase = mapUsecase
        mapUsecase.permissionManager = permissionManager
        viewController.viewModel = viewModel
        return viewController
    }
}

