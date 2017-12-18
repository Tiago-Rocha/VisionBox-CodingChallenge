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
    case places
    case placeDetails
}
struct Router {
    // Google Places API Key - AIzaSyBd5yQ3S3hEzQTBPuVWvmQ9EXsQuxNJwHI
    fileprivate let baseURLString = "https://maps.googleapis.com/maps/api/place/"
    fileprivate let apiKey = "AIzaSyA0LOB6rBpupBzbBJBoaPalH_uO_g6gHMc"
    let postRouterType: Route
    let params: [String:AnyObject]?
    
    fileprivate func getRelativePath() -> String  {
        switch self.postRouterType {
            
        case .places:
            return "autocomplete/json?key=\(apiKey)" + "&input=\(params?["input"] as? String ?? "")"
            
        case .placeDetails:
            return "details/json?key=\(apiKey)" + "&placeid=\(params?["placeID"] as? String ?? "")"
        }
    }
    func asURLRequest() throws -> URLRequest {
        print(self.getRelativePath())
        let url = URL(string: baseURLString + self.getRelativePath())!
        var urlRequest = URLRequest(url: url)
        print("URL Request: \(String(describing: urlRequest.url))")
        return try! Alamofire.JSONEncoding.default.encode(urlRequest)
    }
}
