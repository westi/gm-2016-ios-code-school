//
//  Photo+CoreDataProperties.swift
//  Photos
//
//  Created by Peter Westwood on 17/09/2016.
//  Copyright © 2016 Follow The White Rabbit. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var caption: String?
    @NSManaged var dateTaken: NSDate?
    @NSManaged var imageData: NSData?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double

}
