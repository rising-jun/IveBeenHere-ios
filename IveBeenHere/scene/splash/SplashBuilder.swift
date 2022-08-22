//
//  SplashBuilder.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/20.
//

import Foundation

protocol SplashBuildingLogic {
    typealias Destination = SplashViewController
    func build() -> Destination
}

class SplashBuilder: SplashBuildingLogic {
    func build() -> Destination {
        return SplashViewController.instance()
    }
}

