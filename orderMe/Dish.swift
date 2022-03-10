//
//  Dish.swift
//  iOrder
//
//  Created by Bay-QA on 02.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import ObjectMapper

class Dish : Mappable {
    
    var id : Int?
    var category: Category?
    var name : String?
    var price : Double?
    var dishDescription : String?
    
    var category_id : Int?
    
    required init?(map: Map) {
        
    }
    
    init ( id: Int , category: Category? = nil,  name: String, price: Double, description: String, category_id: Int? = nil){
        self.id = id
        self.category = category
        self.name = name
        self.price = price
        self.dishDescription = description
        self.category_id = category_id
    }
  
    func mapping(map: Map) {
        id              <- map["id"]
        category_id     <- map["categoryId"]
        name            <- map["name"]
        price           <- map["price"]
        dishDescription <- map["description"]
    }
    
}

// Mark : Equatable

extension Dish : Equatable {
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.id == rhs.id
    }
}


// Mark : Hashable

extension Dish : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id ?? -1)
    }
}

