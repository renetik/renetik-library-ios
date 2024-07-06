//
//  CSGetLocation.swift
//  Renetik
//
//  Created by Rene Dohan on 3/11/19.
//

import CoreLocation

public class CSGetLocation: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var locationCallback: ((CLLocation?) -> Void)!
    var locationServicesEnabled = false
    var didFailWithError: Error?

    public func run(callback: @escaping (CLLocation?) -> Void) {
        locationCallback = callback
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        if locationServicesEnabled { manager.startUpdatingLocation() }
        else { locationCallback(nil) }
    }

    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation])
    {
        locationCallback(locations.last!)
        manager.stopUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError = error
        logWarn(error)
        locationCallback(nil)
        manager.stopUpdatingLocation()
    }

    public func locationManager(_: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus)
    {
        logWarn(status)
    }

    deinit {
        manager.stopUpdatingLocation()
    }
}
