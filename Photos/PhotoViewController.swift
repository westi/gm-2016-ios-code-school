//
//  ViewController.swift
//  Photos
//
//  Created by Peter Westwood on 16/09/2016.
//  Copyright © 2016 Follow The White Rabbit. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = photo else {
            return
        }
        imageView.image = photo.image
    }

    @IBAction func handleTrashImage() {
        guard let photo = photo else {
            return
        }
 
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext

        context.deleteObject( photo )
        app.saveContext()

        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func handleInfoButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        controller.photo = photo
        
        let navcontroller = UINavigationController(rootViewController: controller)
        navigationController?.presentViewController(navcontroller, animated: true, completion: nil)
        
    }
}

