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
    var mapUsecaseLoginUpdatable: MainMapUsecaseLoginUpdatable?

    enum Key {
        static let token = "Token"
        static let appKey = "f7ac66a6e2cda493737230543d1ac19e"
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
            UserDefaults.standard.setValue(token?.accessToken, forKey: KakaoLoginManager.Key.token)
            // to firebase 
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
