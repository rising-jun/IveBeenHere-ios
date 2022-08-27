//
//  PlaceAddMapViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import UIKit

final class PlaceAddMapViewController: UIViewController {
    static let id = String(describing: PlaceAddMapViewController.self)
    
    private let disposeBag = DisposeBag()
    
    var viewModel: PlaceAddMapViewModel? {
        didSet {
            binding()
        }
    }
    let mapViewController = MapBuilder().build()
    static func instance() -> PlaceAddMapViewController {
        return PlaceAddMapViewController(nibName: Self.id, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad.accept(value: ())
    }
}
extension PlaceAddMapViewController {
    private func binding() {
        viewModel?.viewAttribute
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewAttribute()
            })
            .disposed(by: disposeBag)
    }
    
    private func viewAttribute() {
        view.addSubview(mapViewController.view)
        guard let draggedPoint = viewModel?.draggedPoint else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapViewController.addAnnotationToUserLocation(draggedRelay: draggedPoint)
        }
    }
}
