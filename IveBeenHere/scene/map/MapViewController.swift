//
//  ViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import UIKit

class MapViewController: UIViewController {
    static let id = String(describing: MapViewController.self)
    private let disposeBag = DisposeBag()
    var viewModel: MapViewModelType?
    
    static func instance() -> MapViewController {
        return MapViewController(nibName: id, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.action()
            .viewDidLoad
            .accept(value: ())
            .disposed(by: disposeBag)
    }
}
