//
//  MainMapBuilder.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import Foundation

protocol MainMapBuildingLogic {
    typealias Destination = MainMapViewController
    func build() -> Destination
}

class MainMapBuilder: MainMapBuildingLogic {
    func build() -> Destination {
        let viewController = MainMapViewController.instance()
        let viewModel = MainMapViewModel()
        let mainMapUsecase = MainMapUsecase()
        
        viewModel.usecase = mainMapUsecase
        mainMapUsecase.viewModelResponsable = viewModel
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}
