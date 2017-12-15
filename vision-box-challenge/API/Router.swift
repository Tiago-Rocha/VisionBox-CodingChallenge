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
    case categories
    case cities
    case geocode
    case locationDetails
    case cuisines
}
struct Router {
    // Google Places API Key - AIzaSyBd5yQ3S3hEzQTBPuVWvmQ9EXsQuxNJwHI
    //    fileprivate let baseURLString = "https://developers.zomato.com/api"
    fileprivate let baseURLString = "https://developers.zomato.com/api/v2.1/"
    let postRouterType: Route
    let params: [String: Any]?
    
    fileprivate func getRelativePath() -> String  {
        switch self.postRouterType {
        case .categories:
            return "categories"
        case .cities:
            return "cities"
        case .geocode:
            return "geocode"
        case .locationDetails:
            return "location_details"
        case .cuisines:
            return "cuisines"
        }
    }
    fileprivate func getDefaultParams(_ baseDic: [String: Any]?) -> [String: Any] {
        func addKey (_ baseDic: [String: Any]) -> [String: Any] {
            var dic = baseDic
            dic["user-key"] = "AIzaSyBd5yQ3S3hEzQTBPuVWvmQ9EXsQuxNJwHI"
            return dic
        }
        //add language per example || add number of results
        var dic:[String: Any] = baseDic ?? [:]
        switch postRouterType {
        default:
            dic = addKey(dic)
        }
        return dic
    }
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURLString)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.getRelativePath()))
        urlRequest.allHTTPHeaderFields = ["user-key": "4320ca1f3eb10513657eed84e055b6ab"]
        urlRequest.httpMethod = Alamofire.HTTPMethod.post.rawValue
        print("URL Request: \(urlRequest)")
        return try! Alamofire.JSONEncoding.default.encode(urlRequest, with: self.getParams())
    }
    
    func getParams() -> [String:Any] {
        return self.getDefaultParams(self.params)
    }
}
