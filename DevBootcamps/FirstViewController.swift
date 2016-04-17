//
//  FirstViewController.swift
//  DevBootcamps
//
//  Created by Mark Price on 12/30/15.
//  Copyright © 2015 Mark Price. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var delegate = MapHelperDelegate()
        
        MapHelper.inflateMap(myView, address: "10 ly thuong kiet, phuong 7, quan 10", delegate: delegate)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreate
    }


}

