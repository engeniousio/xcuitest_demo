//
//  User.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 1/11/17.
//  Copyright © 2017 Boris Gurtovoy. All rights reserved.
//

import ObjectMapper

class User : Mappable{
    var id : Int?
    var name : String?
    var token : String?
    var userId : String?
    
    required init?(map: Map) {
        
    }
    
    init (id: Int , name : String, token: String, userId: String){
        self.id = id
        self.name = name
        self.token = token
        self.userId = userId
    }
    
    // Mark : Mappable
    func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
        token   <- map["token"]
        userId  <- map["userid"]
    }
    
}




