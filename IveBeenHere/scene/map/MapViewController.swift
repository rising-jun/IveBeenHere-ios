//
//  ViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    static let id = String(describing: MapViewController.self)
    private let disposeBag = DisposeBag()
    private let mapViewDelegate = MapViewDelegate()
    var viewModel: MapViewModelType? {
        didSet {
            binding()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    static func instance() -> MapViewController {
        return MapViewController(nibName: id, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.action()
            .viewDidLoad
            .accept(value: ())
    }
}
extension MapViewController {
    private func binding() {
        viewModel?.state()
            .setUserLocationCoordi
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] coordinate in
                guard let self = self else { return }
                self.setMapView(by: coordinate)
            })
            .disposed(by: disposeBag)
    }
    
    private func setMapView(by coordinate: Coordinate) {
        setCamera(by: coordinate)
        mapView.delegate = mapViewDelegate
        mapView.showsUserLocation = true
    }
    
    private func setCamera(by coordinate: Coordinate) {
        let centerCoordi = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard let latMeter = CLLocationDistance(exactly: 2000), let longMeter = CLLocationDistance(exactly: 2000) else { return }
        let region = MKCoordinateRegion(center: centerCoordi, latitudinalMeters: latMeter, longitudinalMeters: longMeter)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
}
