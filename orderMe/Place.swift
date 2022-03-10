//
//  Place.swift
//  iOrder
//
//  Created by Bay-QA on 31.03.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import ObjectMapper

public class Place: Mappable {
    
    var id: Int?
    var name: String?
    var address: String?
    var phone: String?
    var latitude: String?
    var longitude: String?
    var imagePath: String?  // path to image for async downloading
    var image: UIImage?
 
    
    var distance: Double?  = -1 // distance User-Place
    
    required public init?(map: Map) {
        
    }
    
    init(id: Int, name: String, address: String, phone: String, latitude: String, longitude: String, imagePath: String, image: UIImage? ) {
        self.id = id
        self.name = name
        self.address = address
        self.phone = phone
        self.latitude = latitude
        self.longitude = longitude
        self.imagePath = imagePath
        self.image = image
    }

    // Mark: Mappable
    
    public func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        address     <- map["address"]
        phone       <- map["phone"]
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
        imagePath   <- map["imagePath"]
    }
}


// Mark :  Equatable
extension Place: Equatable {
    public static func ==(lhs:Place, rhs:Place) -> Bool {
        return lhs.id == rhs.id
    }
}
