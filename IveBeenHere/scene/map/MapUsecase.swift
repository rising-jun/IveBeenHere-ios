//
//  MapUsecase.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import Foundation

final class MapUsecase {
    var permissionManager: PermissionManager?
}
extension MapUsecase {
    func requestPermission() {
        permissionManager?.getLocationPermission()
    }
}
