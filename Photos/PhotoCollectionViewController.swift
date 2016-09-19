//
//  PhotoCollectionViewController.swift
//  Photos
//
//  Created by Peter Westwood on 16/09/2016.
//  Copyright © 2016 Follow The White Rabbit. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PhotoCollectionViewController: UICollectionViewController {
    
    lazy var resultsController: NSFetchedResultsController = {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        
        let fetchrequest = NSFetchRequest(entityName: "Photo")
        let sortdescriptor = NSSortDescriptor(key: "dateTaken", ascending: false)
        fetchrequest.sortDescriptors = [ sortdescriptor  ]
        
        let fetchcontroller = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: "daymonthyear", cacheName: nil)
        
        fetchcontroller.delegate = self
        
        do {
            try fetchcontroller.performFetch()
        } catch let error as NSError {
            print("Couldn't load photos!")
        }
        
        return fetchcontroller
    }()
        
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return resultsController.sections?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier( "PhotoCellIdentifier", forIndexPath: indexPath) as! PhotoCell
            let photo = resultsController.objectAtIndexPath( indexPath ) as! Photo
            cell.imageView.image = photo.image
            return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
        let photo = resultsController.objectAtIndexPath( indexPath ) as! Photo
        controller.photo = photo
        navigationController?.pushViewController( controller, animated: true)
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionElementKindSectionHeader:
                let headerview = collectionView.dequeueReusableSupplementaryViewOfKind( UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionheader", forIndexPath: indexPath) as! PhotoSectionReusableView
                headerview.label?.text = resultsController.sections?[indexPath.section].name

                return headerview
            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    @IBAction func handleCameraButton( ) {
        
        guard UIImagePickerController.isSourceTypeAvailable( .Camera ) else {
            saveImage( UIImage(named: "IMG_3278.jpg")! )
            return
        }
        
        let controller = UIImagePickerController()
        controller.sourceType = .Camera
        controller.cameraCaptureMode = .Photo
        controller.delegate = self
        navigationController?.presentViewController(controller, animated: true, completion: nil)
        
    }

    func saveImage( image: UIImage ) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SavePhotoViewController") as! SavePhotoViewController
        controller.image = image
        let navcontroller = UINavigationController(rootViewController: controller)
        navigationController?.presentViewController(navcontroller, animated: true, completion: nil)
    }
}

extension PhotoCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated( true, completion: {
                guard let image = info[ UIImagePickerControllerOriginalImage ] as? UIImage else {
                    return
                }
                self.saveImage( image )
            }
        )
    }
}

extension PhotoCollectionViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView?.reloadData()
    }
}