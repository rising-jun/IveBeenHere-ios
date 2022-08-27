//
//  CompositionRoot.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/22.
//

import UIKit

struct AppDependency {
    let window: UIWindow
}

enum CompositionRoot {
    static func resolve(scene: UIWindowScene) -> AppDependency {
        let navigationController = UINavigationController(
            rootViewController: MainMapBuilder().build()
        )
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = .dark
        return AppDependency(window: window)
    }
}
