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
            return "details/json?placeid=\(params?["placeID"] as? String ?? "")" + "&key=\(apiKey)"
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURLString + self.getRelativePath())!
        var urlRequest = URLRequest(url: url)
        print("URL Request: \(String(describing: urlRequest.url))")
        return try! Alamofire.JSONEncoding.default.encode(urlRequest)
    }
}
