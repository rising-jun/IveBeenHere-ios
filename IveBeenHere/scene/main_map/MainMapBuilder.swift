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
        let loginManager = KakaoLoginManager()
        
        viewModel.usecase = mainMapUsecase
        mainMapUsecase.kakaoLoginManagable = loginManager
        mainMapUsecase.viewModelResponsable = viewModel
        loginManager.mapUsecaseLoginUpdatable = mainMapUsecase
        viewController.viewModel = viewModel
        return viewController
    }
}
