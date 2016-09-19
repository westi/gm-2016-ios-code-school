//
//  SavePhotoViewController.swift
//  Photos
//
//  Created by Peter Westwood on 16/09/2016.
//  Copyright © 2016 Follow The White Rabbit. All rights reserved.
//
import UIKit
import CoreData
import CoreLocation

class SavePhotoViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet var captionView: UITextField!

    var image: UIImage?
    var coordinate: CLLocationCoordinate2D?

    // Set up a location manager to request location services
    lazy var locationmgr: CLLocationManager = {
        let locationmgr = CLLocationManager()
        locationmgr.delegate = self
        locationmgr.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationmgr.requestWhenInUseAuthorization()
        return locationmgr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = image else {
            return
        }
        imageView.image = image

        locationmgr.requestLocation()
    }

    @IBAction func handleCancelTapped() {
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    @IBAction func handleSaveTapped() {
        dismissViewControllerAnimated(true, completion:nil)
        guard let image = image else {
            // Should handle the actual failure here
            return
        }
        
        // Push slow work onto background thread
        // UI will refresh before (and after) this completes as the UI code listens to the save events
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let imagedata = UIImagePNGRepresentation( image )

            // Push rest of work onto main thread
            dispatch_async( dispatch_get_main_queue(), {
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                let context = app.managedObjectContext
                let photo = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as! Photo
                
                photo.dateTaken = NSDate()
                photo.caption = self.captionView.text
                photo.imageData = imagedata

                if let coordinate = self.coordinate {
                    photo.latitude = coordinate.latitude
                    photo.longitude = coordinate.longitude
                }

                app.saveContext()
            } )
        } )

        // Push work onto background thread (not thread safe ;))
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0 ), {
            UIImageWriteToSavedPhotosAlbum( image, nil, nil, nil )
        } )
    }
}

extension SavePhotoViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            coordinate = location.coordinate
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print( "error: \(error)" )
    }
}