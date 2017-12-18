import Foundation
import Alamofire
import SwiftyJSON

struct RequestHandler {
    let router: Router
    init(data: [String:AnyObject]?, route: Route) {
        self.router = Router(postRouterType: route, params: data)
    }
    func doRequest(_ completionHandler: @escaping (Bool, [String: AnyObject]) -> ()) {
        var responseData = [String:AnyObject]()
        var success = false
        Alamofire.request(try! self.router.asURLRequest())
            .validate()
            .responseJSON {
                response in switch response.result {
                case .success(let JSON):
                    guard let data = JSON as? [String:AnyObject] else {
                        completionHandler(false, [:])
                        return
                    }
                    responseData = data
                    
                    success = true
                    completionHandler(success, responseData)
                case .failure(_):
                    success = false
                    //TODO: Implement Server Error Messages
                    // UNKNOWN_ERROR, ZERO_RESULTS, OVER_QUERY_LIMIT, REQUEST_DENIED, INVALID_REQUEST, NOT_FOUND
                    if let data = response.data {
                        let responseJSON = try! JSON(data: data)
                        let message = responseJSON["message"].stringValue
                        if !message.isEmpty {
                            responseData["error"] = message as AnyObject?
                        }
                    } else {
                        responseData["error"] = "General Error" as AnyObject?
                    }
                    completionHandler(success, responseData)
                }
        }
    }
}
