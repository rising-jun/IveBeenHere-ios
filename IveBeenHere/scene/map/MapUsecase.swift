//
//  MapUsecase.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import Foundation

final class MapUsecase {
    var permissionManager: PermissionManager?
    var viewModelResponsable: MapViewModelOutput? {
        didSet {
            binding()
        }
    }
    var kakaoLoginManagable: KakaoLoginManager?
    
    private let disposeBag = DisposeBag()
    
    var coordiRelay = PublishRelay<Coordinate>()
    var loginResultRelay = PublishRelay<Bool>()
}
extension MapUsecase: MapManagable {
    private func binding() {
        coordiRelay
            .bind { [weak self] coordi in
                guard let self = self else { return }
                self.viewModelResponsable?
                    .setUserLocationCoordi
                    .accept(value: coordi)
            }
            .disposed(by: disposeBag)
        
        loginResultRelay
            .bind { [weak self] result in
                guard let self = self else { return }
                self.viewModelResponsable?.didLogin.accept(value: result)
            }
            .disposed(by: disposeBag)
    }
    
    func requestPermission() {
        permissionManager?.getLocationPermission()
    }
}

extension MapUsecase: MapUsecaseLoginUpdatable {
    func checkLogin() {
        kakaoLoginManagable?.loginCheck()
    }
    
    func requestKakaoLogin() {
        kakaoLoginManagable?.loginRequest()
    }
}

protocol MapUsecaseLoginUpdatable {
    var loginResultRelay: PublishRelay<Bool> { get }
}

protocol MapManagable: MapUsecaseCoordiUpdatable {
    func requestPermission()
}

protocol MapUsecaseCoordiUpdatable {
    var coordiRelay: PublishRelay<Coordinate> { get }
}
