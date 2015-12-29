//
//  CQZLocationManager.swift
//  CQZLocationManager
//
//  Created by Christian Quicano on 12/28/15.
//  Copyright © 2015 ecorenetworks. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol CQZLocationManagerDelegate:NSObjectProtocol {
    optional func locationManagerDidUpdateLocation(location:CLLocation)
}

public class CQZLocationManager: NSObject {
    //MARK: - Singleton
    public static let sharedLocationManager = CQZLocationManager()
    
    //MARK: - public properties
    public var currentLocation:CLLocation = CLLocation()
    
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
    
    //MARK: - internal properties
    weak private var delegate:CQZLocationManagerDelegate?
    
    //MARK: - private properties
    private let locationManager = CLLocationManager()
    
    //MARK: - override methods
    @objc private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 15
    }
    
}

//MARK: - CLLocationManagerDelegate
extension CQZLocationManager:CLLocationManagerDelegate {
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            delegate?.locationManagerDidUpdateLocation?(location)
        }
    }
}