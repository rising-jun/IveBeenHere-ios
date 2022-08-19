//
//  SplashViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import UIKit

class SplashViewController: UIViewController {
    static let id = String(describing: SplashViewController.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        presentMapViewController()
    }
}
private extension SplashViewController {
    func presentMapViewController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let storyboard = UIStoryboard(name: "MapStoryBoard", bundle: nil)
            let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapStoryBoard")
            self.navigationController?.setViewControllers([mapViewController], animated: true)
        }
    }
}
