//
//  SceneDelegate.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var dependency: AppDependency?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        KakaoSDK.initSDK(appKey: KakaoLoginManager.Key.appKey)
        let window = UIWindow(windowScene: scene)
        window.makeKeyAndVisible()
        window.rootViewController = SplashBuilder().build()
        window.backgroundColor = .white
        self.window = window
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dependency = self.dependency ?? CompositionRoot.resolve(scene: scene)
            self.window = self.dependency?.window
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

