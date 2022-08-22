//
//  PermissionManager.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/19.
//

import CoreLocation

final class PermissionManager: NSObject {
    private let locationManager = CLLocationManager()
    var updatedLocation: ((Coordinate) -> ())?
    override init() {
        super.init()
        locationManager.delegate = self
    }
}
extension PermissionManager: CLLocationManagerDelegate {
    
    func getLocationPermission(){
        if CLLocationManager.locationServicesEnabled() {
            //delegate?.getPermission(status: CLLocationManager.authorizationStatus())
            print("use")
        } else {
            //delegate?.getPermission(status: .notDetermined)
            print("go to setting")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            //거부
            print("denied")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .authorized:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        updatedLocation?(coordinate)
    }
}

struct Coordinate {
    let latitude: Double
    let longitude: Double
}
