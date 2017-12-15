//
//  Router.swift
//  vision-box-challenge
//
//  Created by Tiago Rocha on 15/12/2017.
//  Copyright © 2017 tiagorocha. All rights reserved.
//
import Foundation
import Alamofire
import RealmSwift

enum Route {
    case places(input: String)
    case placeDetails(placeID: String)
}
struct Router {
    // Google Places API Key - AIzaSyBd5yQ3S3hEzQTBPuVWvmQ9EXsQuxNJwHI
    fileprivate let baseURLString = "https://maps.googleapis.com/maps/api/place/"
    fileprivate let apiKey = "AIzaSyA0LOB6rBpupBzbBJBoaPalH_uO_g6gHMc"
    let postRouterType: Route
    let params: [Any]?
    
    fileprivate func getRelativePath() -> String  {
        switch self.postRouterType {
            
        case .places:
            return "autocomplete/json?key=\(apiKey)" + "&input=\(params![0] as! String)"
            
        case .placeDetails:
            return "details/json?key=\(apiKey)" + "&placeid=\(params![0] as! String)"
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURLString)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.getRelativePath()))
        print("URL Request: \(urlRequest)")
        return try! Alamofire.JSONEncoding.default.encode(urlRequest)
    }
}
