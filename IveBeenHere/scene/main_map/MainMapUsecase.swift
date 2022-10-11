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
    var firebaseManager: FirebaseManagable?
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
    
    func requestVisitDTO() async {
        guard let result = await firebaseManager?.readVisitDTO() else {
            self.viewModelResponsable?.firebaseError.accept(value: .nilDataError)
            return
        }
        switch result {
        case .success(let dto):
            self.viewModelResponsable?.updateVisits.accept(value: dto)
        case .failure(let error):
            self.viewModelResponsable?.firebaseError.accept(value: error)
        }
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
    func requestVisitDTO() async
}

protocol MainMapUsecaseLoginUpdatable {
    var loginResultRelay: PublishRelay<Bool> { get }
}
