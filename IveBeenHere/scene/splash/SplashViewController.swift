//
//  SplashViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import UIKit

class SplashViewController: UIViewController {
    static let id = String(describing: SplashViewController.self)
    
    static func instance() -> SplashViewController {
        return SplashViewController(nibName: id, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
