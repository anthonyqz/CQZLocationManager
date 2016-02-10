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
    public func requestAlwaysAutorization (){
        locationManager.requestAlwaysAuthorization()
    }
    
    public func requestWhenInUseAutorization (){
        locationManager.requestWhenInUseAuthorization()
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
    
    public func setBlockToDidUpdateLocation(block:((location:CLLocation) -> ())?) {
        blockInDidUpdateLocations = block
    }
    
    //MARK: - private properties
    private let locationManager = CLLocationManager()
    
    private var blockInDidUpdateLocations:((location:CLLocation) -> ())?
    
    //MARK: - override methods
    public func configuration(withDesiredAccuracy desiredAccuracy:CLLocationAccuracy?, activityType:CLActivityType?, locationUpdates:Bool? ){
        // Set an accuracy level. The higher, the better for energy.
        if let desiredAccuracy = desiredAccuracy {
            locationManager.desiredAccuracy = desiredAccuracy
        }
        // Specify the type of activity your app is currently performing
        if let activityType = activityType {
            locationManager.activityType = activityType
        }
        if #available(iOS 9.0, *) {
            // Enable automatic pausing
            if let locationUpdates = locationUpdates {
                locationManager.allowsBackgroundLocationUpdates = locationUpdates
            }
        }
        locationManager.startUpdatingLocation()
        
    }
    
    @objc private override init(){
        super.init()
        locationManager.delegate = self
        // Set an accuracy level. The higher, the better for energy.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Specify the type of activity your app is currently performing
        locationManager.activityType = CLActivityType.Fitness
        if #available(iOS 9.0, *) {
            // Enable automatic pausing
            locationManager.allowsBackgroundLocationUpdates = true
        }
        locationManager.startUpdatingLocation()
    }
    
}

//MARK: - CLLocationManagerDelegate
extension CQZLocationManager:CLLocationManagerDelegate {
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            currentLocation = location
            if let blockInDidUpdateLocations = blockInDidUpdateLocations{
                blockInDidUpdateLocations(location:location)
            }
            delegate?.didUpdateLocation?(location)
        }
        
    }
    
    public func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            delegate?.didChangeAuthorizationStatus?(status)
    }
}