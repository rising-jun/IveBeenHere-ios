//
//  MainMapUsecase.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import Foundation

final class MainMapUsecase {
    var viewModelResponsable: MainMapViewModelOutput? {
        didSet {
            binding()
        }
    }
    var kakaoLoginManagable: KakaoLoginManager?
    
    private let disposeBag = DisposeBag()
    
    var loginResultRelay = PublishRelay<Bool>()
}
extension MainMapUsecase: MainMapManagable {
    private func binding() {
        loginResultRelay
            .bind { [weak self] result in
                guard let self = self else { return }
                self.viewModelResponsable?.didLogin.accept(value: result)
            }
            .disposed(by: disposeBag)
    }
}
extension MainMapUsecase: MainMapUsecaseLoginUpdatable {
    func checkLogin() {
        kakaoLoginManagable?.loginCheck()
    }
    
    func requestKakaoLogin() {
        kakaoLoginManagable?.loginRequest()
    }
}
protocol MainMapManagable {
    func checkLogin()
    func requestKakaoLogin()
}

protocol MainMapUsecaseLoginUpdatable {
    var loginResultRelay: PublishRelay<Bool> { get }
}
