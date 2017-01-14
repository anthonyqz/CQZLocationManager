//
//  ViewController.swift
//  CQZLocationManagerAppTest
//
//  Created by Christian Quicano on 1/14/17.
//  Copyright © 2017 ecorenetworks. All rights reserved.
//

import UIKit
import CQZLocationManager

class ViewController: UIViewController {

    @IBOutlet private var latitudLabel:UILabel!
    @IBOutlet private var longitudLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        updateLocation(nil)
    }

    @IBAction func updateLocation(_ sender: UIButton?) {
        latitudLabel.text = "\(CQZLocationManager.shared.currentLocation.coordinate.latitude)"
        longitudLabel.text = "\(CQZLocationManager.shared.currentLocation.coordinate.longitude)"
    }
}

