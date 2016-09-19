//
//  MapViewController.swift
//  Photos
//
//  Created by Peter Westwood on 17/09/2016.
//  Copyright © 2016 Follow The White Rabbit. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapview: MKMapView?

    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let photo = photo else {
            return
        }

        let annotation = MKPointAnnotation()
        annotation.coordinate = photo.coordinate
        
        mapview?.addAnnotation( annotation )
        mapview?.setRegion( MKCoordinateRegionMakeWithDistance( photo.coordinate, 500.0, 500.0), animated: false)
    }

    @IBAction func handleDoneTapped() {
        dismissViewControllerAnimated(true, completion:nil)
    }
}
