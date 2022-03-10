//
//  NetworkClient.swift
//  orderMe
//
//  Created by Bay-QA on 12/17/16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//


import Foundation
import Alamofire
import ObjectMapper
import AlamofireImage


enum HostURL {
    case heroku
    case digitalOcean
    case localhost(String)
    
    var baseURL: String {
        switch self {
        case .heroku:               return "https://peaceful-spire-96979.herokuapp.com"
        case .digitalOcean:         return "http://ec2-18-118-12-123.us-east-2.compute.amazonaws.com:3000"
        case .localhost(let value): return value
        }
    }
    
    var analyticsURL: String {
        switch self {
        case .digitalOcean:         return "http://ec2-18-118-12-123.us-east-2.compute.amazonaws.com:3000"
        case .localhost(let value): return value
        default: return ""
        }
    }
}

var defaultHost = HostURL.digitalOcean
var analyticsHost = HostURL.digitalOcean

class NetworkClient {
    
    static let baseURL = defaultHost.baseURL
    static let dateFormatter = DateFormatter() // for converting Dates to string
    
    // general request to the API, each function here will use this one
    static func send(api: String, method: HTTPMethod, parameters: Parameters?, token: String, completion: @escaping (_ result: String?, _ error: NSError?)->()) -> Void {
        
        let headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json",
            "Authorization": "Token " + token
        ]
        
        let url = (baseURL + api) as URLConvertible
        
        print("➡️ " + method.rawValue + ": " + baseURL + api)
        print(parameters ?? "No params")
        print(headers)
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseString { response in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error as NSError?)
                }
        }
    }
    
    // getting the list of Places from API
    static func getPlaces(completion: @escaping (_ places: Array<Place>?, _ error : NSError?) -> () ) {
        
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            
            guard let placesJSON = response_result else {
                return
            }
            let places: [Place]? = Mapper<Place>().mapArray(JSONString: placesJSON)
            
            completion(places, nil)
        }
        
        send(api: "/places", method: .get, parameters: nil, token: "", completion: response_completion )
        
    }
    
    
    static func downloadImage(url : String, completion: @escaping (_ image: UIImage? , _ error: NSError?) -> () ) {
        Alamofire.request(url).responseImage { (response) -> Void in
            guard let image = response.result.value else {
                completion(nil, response.result.error as NSError?)
                return
            }
            completion(image, nil)
        }
    }
    
    static func callAWaiter( placeId : Int, idTable: Int, date: Date, reason: Int, completion: @escaping (_ success: Bool? , _ error: NSError?) -> () )  {
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            completion(true, nil)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let created = dateFormatter.string(from: date)
        
        
        let parameters = [
            "placeId" : placeId,
            "idTable" : idTable,
            "created" : created,
            "reason" : reason
            
            ] as [String : Any]
        
        send(api: "/menu/waiter", method: .post, parameters: parameters, token: "", completion: response_completion)
        
    }
    
    
    // get a Menu
    static func getMenu(placeId: Int, completion: @escaping (_ menu: Menu?, _ error : NSError?) -> () ) {
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            
            guard let menuJson = response_result else {
                completion(nil, NSError())
                return
            }
            let menu: Menu? = Mapper<Menu>().map(JSONString: menuJson)
            
            guard let categories = menu?.categories,
                let dishes = menu?.dishes else {
                    completion(nil, NSError())
                    return
            }
            
            var newDishes: [Dish] = []
            for dish in dishes {
                
                let categoryId = dish.category_id
                
                for category in categories {
                    if categoryId == category.id {
                        dish.category = category
                        newDishes.append(dish)
                    }
                }
            }
            menu?.dishes = newDishes
            completion(menu, nil)
            
        }
        
        send(api: "/menu/\(placeId)", method: .get, parameters: nil, token: "", completion: response_completion )
        
    }
    
    // make an order
    static func makeOrder(order: Order, completion: @escaping (_ successId: Int?, _ error : NSError?) -> () ) {
        
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            if let jsonOrder = response_result {
                if let order = Order(JSONString: jsonOrder) {
                    if let id = order.id {
                        completion(id, nil)
                        return
                    }
                    completion(nil, NSError(domain: "Order ID Acquiring Error", code: 997, userInfo: nil))
                }
                completion(nil, NSError(domain: "Order Parsing Error", code: 998, userInfo: nil))
            }
            completion(nil, NSError(domain: "Response Error", code: 999, userInfo: nil))
            return
        }
        
        // make new bucket from DishId - Amount
        guard let oldBucket = order.bucket else { return }
        var newBucket : [String: Int] = [:]
        for (dish, amount) in oldBucket {
            guard let id = dish.id else { completion(nil, NSError())
                return }
            newBucket[String(id)] = amount
        }
        // make String Date
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let created = dateFormatter.string(from: Date())
        
        guard let comments = order.comments,
            let id = order.place?.id else {
                completion(nil, NSError())
                return
        }
        
        guard let sum = order.sum else { return }
        
        let parameters = ["placeId"  : id,
                          "idTable"  : SingletonStore.sharedInstance.tableID,
                          "bucket"   : newBucket,
                          "comments" : comments,
                          "created"  : created,
                          "sum"      : sum
                          ] as [String : Any]
        
        guard let token = SingletonStore.sharedInstance.user?.token else {
            completion(nil, NSError())
            return
        }
        send(api: "/menu/order", method: .post, parameters: parameters, token: token, completion: response_completion)
        
    }
    
    // make a Reservation
    static func makeReservation(reserve: Reserve, completion: @escaping (_ successId: Int?, _ error : NSError?) -> () ) {

        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            if let jsonReserve = response_result  {
                if let reserve = Reserve(JSONString: jsonReserve) {
                    if let id = reserve.id  {
                        completion(id, nil)
                        return
                    }
                }
            }
            completion(nil, NSError())
            return
        }
        
        // make String Dates
        guard let dateForReservation = reserve.date,
            let id = reserve.place?.id,
            let phoneNumber = reserve.phoneNumber,
            let people = reserve.numberOfPeople else {
                completion(nil, NSError())
                return
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.string(from : dateForReservation)
        let created = dateFormatter.string(from: Date())
        
        
        let parameters = ["placeId" : id,
                          "date"  : date,
                          "created" : created,
                          "phoneNumber" : phoneNumber,
                          "numberOfPeople" : people
            ] as [String : Any]
        
        guard let token = SingletonStore.sharedInstance.user?.token else {
            completion(nil, NSError())
            return
        }
        send(api: "/reserve", method: .post, parameters: parameters, token: token, completion: response_completion)
    }
    
    // Login to API after facebook registration
    static func login(accessToken: String, completion: @escaping (_ user: User?, _ error : NSError?) -> () ) {
        
        func response_completion(_ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            guard let jsonString = response_result else {
                completion(nil, NSError())
                return
            }
            let userOpt: User? = Mapper<User>().map(JSONString: jsonString)
            guard let user = userOpt else {
                completion(nil, NSError())
                return
            }
            completion(user, nil)
        }
        send(api: "/user?access_token=\(accessToken)", method: .get, parameters: nil, token: "", completion: response_completion)
    }
    
    // Get all Reservations
    static func getReservations(completion: @escaping (_ reservations: [Reserve]?, _ error : NSError?) -> () ) {
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            guard let json = response_result else {
                completion(nil, NSError())
                return
            }
            let reserves : [Reserve]? = Mapper<Reserve>().mapArray(JSONString: json)
        
            completion(reserves, nil)
        }
        
        
        guard let token = SingletonStore.sharedInstance.user?.token else {
            completion(nil, NSError())
            return
        }
        send(api: "/reserve", method: .get, parameters: nil, token: token, completion: response_completion )
    }
    
    // Delete reservation
    static func deleteReservation(id: Int, completion: @escaping (_ success: Bool?, _ error : NSError?) -> () ) {
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            completion(true, nil)
        }

        guard let token = SingletonStore.sharedInstance.user?.token else {
            completion(nil, NSError())
            return
        }
        send(api: "/reserve/\(id)", method: .delete, parameters: nil, token: token, completion: response_completion )
    }
    
    // Get all Orders
    static func getOrders(completion: @escaping (_ orders: [Order]?, _ error : NSError?) -> () ) {
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            guard let json = response_result else {
                completion(nil, NSError())
                return
            }
            let orders: [Order]? = Mapper<Order>().mapArray(JSONString: json)
            
            completion(orders, nil)
        }
        
        guard let token = SingletonStore.sharedInstance.user?.token else {
            completion(nil, NSError())
            return
        }
        send(api: "/menu/order", method: .get, parameters: nil, token: token, completion: response_completion )
    }

    // For Testing 
    
    static func addPlace(placeJson: [String: AnyObject], completion: @escaping (_ place: Place?, _ error : NSError?) -> () ) {
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            guard let json = response_result else {
                completion(nil, NSError())
                return
            }
            let place :Place? = Mapper<Place>().map(JSONString: json)
            
            completion(place, nil)
        }
        
        send(api: "/places", method: .post, parameters: placeJson, token: "", completion: response_completion)
        
    }
    
    static func deletePlace(id: Int, completion: @escaping (_ success: Bool?, _ error : NSError?) -> () ) {
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            completion(true, nil)
        }
        send(api: "/places\(id)", method: .delete, parameters: nil, token: "", completion: response_completion)
    }
    
    // analytics

    enum AnalyticsAction: String {
        case loginLaterTapped
        case facebookTapped
        case placesListShown
        case placeTapped
        case waiterCalled
    }
    
    static func analytics(action: AnalyticsAction, info: String? = nil) {
        let headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json",
            ]
        
        let url = (analyticsHost.analyticsURL + "/analytics") as URLConvertible
        
        print("➡️ ANALYTICS: \(action.rawValue) \(info ?? "") ")
        
        let params = [
            "action": action.rawValue,
            "info": info ?? ""
        ]
        
        Alamofire.request(url, method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseString { response in
                switch response.result {
                case .success:
                    print("➡️ ANALYTICS: Success")
                case .failure:
                    print("➡️ ANALYTICS: Failure")
                }
        }
    }
    
}
