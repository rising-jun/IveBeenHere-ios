//
//  KakaoLoginManager.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/23.
//

import KakaoSDKAuth
import KakaoSDKUser
import Foundation

final class KakaoLoginManager {
    var mapUsecaseLoginUpdatable: MapUsecaseLoginUpdatable?

    enum Key {
        static let token = "Token"
        static let appKey = "9d618f74a6d63d44fe745da0f480233f"
    }
}
extension KakaoLoginManager: KakaoLoginManagable {
    func loginCheck() {
        UserDefaults.standard.string(forKey: KakaoLoginManager.Key.token) != nil ?
            mapUsecaseLoginUpdatable?
            .loginResultRelay
            .accept(value: true) :
            mapUsecaseLoginUpdatable?
            .loginResultRelay
            .accept(value: false)
    }
    
    func loginRequest() {
        UserApi.shared.loginWithKakaoAccount(nonce: nil) { [weak self] token, error in
            guard let self = self else { return }
            UserDefaults.standard.setValue(token, forKey: KakaoLoginManager.Key.token)
            self.mapUsecaseLoginUpdatable?
                .loginResultRelay
                .accept(value: true)
        }
    }
}
protocol KakaoLoginManagable {
    func loginCheck()
    func loginRequest()
}
