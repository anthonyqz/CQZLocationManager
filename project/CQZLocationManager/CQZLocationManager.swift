//
//  CQZLocationManager.swift
//  CQZLocationManager
//
//  Created by Christian Quicano on 12/28/15.
//  Copyright © 2015 ecorenetworks. All rights reserved.
//

import UIKit
import CoreLocation

@objc public protocol CQZLocationManagerDelegate:NSObjectProtocol {
    optional func didUpdateLocation(location:CLLocation)
    optional func didChangeAuthorizationStatus(status:CLAuthorizationStatus)
}

public class CQZLocationManager: NSObject {
    //MARK: - Singleton
    public static let sharedLocationManager = CQZLocationManager()
    
    //MARK: - public properties
    public var currentLocation:CLLocation = CLLocation()
    weak public var delegate:CQZLocationManagerDelegate?
    
    //MARK: - public methods
    public func requestAutorization (type type:CQZLocationManagerRequest){
        switch type {
        case CQZLocationManagerRequest.AlwaysAuthorization:
            locationManager.requestAlwaysAuthorization()
            break
        case CQZLocationManagerRequest.WhenInUseAutorization:
            locationManager.requestWhenInUseAuthorization()
            break
        }
    }
    
    public func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }
    
    public func allowsBackground(allow:Bool) {
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = allow
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: - private properties
    private let locationManager = CLLocationManager()
    
    //MARK: - override methods
    @objc private override init(){
        super.init()
        locationManager.delegate = self
        // Set an accuracy level. The higher, the better for energy.
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Enable automatic pausing
//        locationManager.pausesLocationUpdatesAutomatically = true
        // Specify the type of activity your app is currently performing
//        locationManager.activityType = CLActivityType.OtherNavigation
        locationManager.activityType = CLActivityType.AutomotiveNavigation
        // Enable background location updates
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        // Start location updates
        locationManager.startUpdatingLocation()
    }
    
}

//MARK: - CLLocationManagerDelegate
extension CQZLocationManager:CLLocationManagerDelegate {
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            currentLocation = location
            delegate?.didUpdateLocation?(location)
        }
        
    }
    
    public func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            delegate?.didChangeAuthorizationStatus?(status)
    }
}