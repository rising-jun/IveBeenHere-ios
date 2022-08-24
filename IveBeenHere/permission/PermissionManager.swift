//
//  PermissionManager.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import CoreLocation

final class PermissionManager: NSObject {
    private let locationManager = CLLocationManager()
    var coordiUpdatable: MapUsecaseCoordiUpdatable?
    private let disposeBag = DisposeBag()
    override init() {
        super.init()
        locationManager.delegate = self
    }
}
extension PermissionManager: CLLocationManagerDelegate {
    
    func getLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            //print("Yet")
            locationManager.requestWhenInUseAuthorization()
        } else {
           // print("X?")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            //거부
            //print("denied")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .authorized:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        coordiUpdatable?.coordiRelay
            .accept(value: coordinate)
    }
}

struct Coordinate {
    let latitude: Double
    let longitude: Double
}
