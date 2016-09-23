//
//  Photo.swift
//  Photos
//
//  Created by Peter Westwood on 17/09/2016.
//  Copyright © 2016 Follow The White Rabbit. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

class Photo: NSManagedObject {
    
    lazy var image: UIImage? = {
        if let data = self.imageData {
            return UIImage( data: data )
        }
        return nil
    } ()
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var daymonthyear: String{
        get{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            return dateFormatter.stringFromDate(self.dateTaken!)
        }
    }
}
