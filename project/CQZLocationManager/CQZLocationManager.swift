//
//  CQZLocationManager.swift
//  CQZLocationManager
//
//  Created by Christian Quicano on 12/28/15.
//  Copyright © 2015 ecorenetworks. All rights reserved.
//

import UIKit
import CoreLocation

@objc public protocol CQZLocationManagerDelegate {
    @objc optional func didUpdateLocation(_ location:CLLocation)
    @objc optional func didChangeAuthorizationStatus(_ status:CLAuthorizationStatus)
}

open class CQZLocationManager: NSObject {
    //MARK: - Singleton
    open static let shared = CQZLocationManager()
    
    //MARK: - public properties
    open var currentLocation:CLLocation = CLLocation()
    open weak var delegate:CQZLocationManagerDelegate?
    
    //MARK: - public methods
    open func requestAlwaysAutorization (){
        locationManager.requestAlwaysAuthorization()
    }
    
    open func requestWhenInUseAutorization (){
        locationManager.requestWhenInUseAuthorization()
    }
    
    open func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
    open func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }
    
    open func allowsBackground(_ allow:Bool) {
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = allow
        } else {
            // Fallback on earlier versions
        }
    }
    
    open func setBlockToDidUpdateLocation(_ block:((_ location:CLLocation) -> ())?) {
        blockInDidUpdateLocations = block
    }
    
    //MARK: - private properties
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var blockInDidUpdateLocations:((_ location:CLLocation) -> ())?
    
    //MARK: - override methods
    open func configuration(withDesiredAccuracy desiredAccuracy:CLLocationAccuracy?
        , activityType:CLActivityType?
        //, locationUpdates:Bool?
        ){
        // Set an accuracy level. The higher, the better for energy.
        if let desiredAccuracy = desiredAccuracy {
            locationManager.desiredAccuracy = desiredAccuracy
        }
        // Specify the type of activity your app is currently performing
        if let activityType = activityType {
            locationManager.activityType = activityType
        }
//        if #available(iOS 9.0, *) {
//            // Enable automatic pausing
//            if let locationUpdates = locationUpdates {
//                locationManager.allowsBackgroundLocationUpdates = locationUpdates
//            }
//        }
        locationManager.startUpdatingLocation()
        
    }
    
    @objc fileprivate override init(){
        super.init()
        locationManager.delegate = self
        // Set an accuracy level. The higher, the better for energy.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Specify the type of activity your app is currently performing
        locationManager.activityType = CLActivityType.fitness
        locationManager.startUpdatingLocation()
    }
    
}

//MARK: - CLLocationManagerDelegate
extension CQZLocationManager:CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            currentLocation = location
            if let blockInDidUpdateLocations = blockInDidUpdateLocations{
                blockInDidUpdateLocations(location)
            }
            delegate?.didUpdateLocation?(location)
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
            delegate?.didChangeAuthorizationStatus?(status)
    }
}
