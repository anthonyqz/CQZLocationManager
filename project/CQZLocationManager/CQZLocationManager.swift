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

public class CQZLocationManager: NSObject {
    //MARK: - Singleton
    public static let shared = CQZLocationManager()
    
    //MARK: - public properties
    public var currentLocation:CLLocation = CLLocation()
    public weak var delegate: CQZLocationManagerDelegate?
    
    //MARK: - public methods
    public func requestAlwaysAutorization (completedRequest: ((_ status: CLAuthorizationStatus) -> ())?) {
        self.completedRequest = completedRequest
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
    
    public func setBlockToDidUpdateLocation(_ block:((_ location:CLLocation) -> ())?) {
        blockInDidUpdateLocations = block
    }
    
    //return the placemark
    public func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }

    public func getStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    //MARK: - private properties
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var blockInDidUpdateLocations:((_ location:CLLocation) -> ())?
    private var completedRequest:((_ status: CLAuthorizationStatus) -> ())?
    
    //MARK: - override methods
    public func configuration(withDesiredAccuracy desiredAccuracy:CLLocationAccuracy?
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
            
            //get the placemark
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        completedRequest?(status)
        delegate?.didChangeAuthorizationStatus?(status)
    }
    
}
