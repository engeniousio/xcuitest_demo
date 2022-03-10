//
//  Category.swift
//  iOrder
//
//  Created by Bay-QA on 03.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//
import ObjectMapper

class Category : Mappable{
    var id : Int?
    var place : Place?
    var name : String?
    
    required init?(map: Map) {
        
    }
    
    init (id: Int , place : Place, name: String){
        self.id = id
        self.place = place
        self.name = name
    }
    
    // Mark : Mappable
    func mapping(map: Map) {
        id   <- map["id"]
        name   <- map["name"]
        place <- (map["place_id"], PlaceIdJsonTransform())
        
    }
    
}

// Mark : Equatable

extension Category : Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}


// Mark : Hashable

extension Category : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id ?? -1)
    }
}


