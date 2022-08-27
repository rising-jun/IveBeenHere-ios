//
//  PlaceAddMapViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import UIKit
import MapKit

final class PlaceAddMapViewController: UIViewController {
    static let id = String(describing: PlaceAddMapViewController.self)
    
    private let mapDelegate = PlaceAddMapDelegate()
    private let disposeBag = DisposeBag()
    
    var viewModel: PlaceAddMapViewModel? {
        didSet {
            binding()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
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
        viewModel?.setMapView
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mapView.delegate = self.mapDelegate
            })
            .disposed(by: disposeBag)

    }
    
    private func setCamera(by coordinate: Coordinate) {
        let centerCoordi = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard let latMeter = CLLocationDistance(exactly: 2000), let longMeter = CLLocationDistance(exactly: 2000) else { return }
        let region = MKCoordinateRegion(center: centerCoordi, latitudinalMeters: latMeter, longitudinalMeters: longMeter)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
}
