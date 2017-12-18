import Foundation
import SwiftyJSON

struct APIPlaceProvider {
    func getPlaces(input: String, completionHandler: (([Place]?) -> ())?) {
        RequestHandler(data: ["input": input as AnyObject], route: .places).doRequest { success, dataReceived in
            guard success else {
                guard let error = dataReceived["error"] as? String
                    else {
                        completionHandler?(nil)
                        return
                }
                completionHandler?(nil)
                return
            }
            completionHandler?(self.transform(dataReceived))
            return
        }
    }
    func transform(_ data: [String: AnyObject]) -> [Place] {
        guard let placesData = JSON(data)["predictions"].array else {return []}
        var places = [Place]()
        for place in placesData {
            if let unmarshal = transformPlace(place) {
                places.append(unmarshal)
            }
        }
        return places
        
    }
    func transformPlace(_ data: JSON) -> Place? {
        let place = Place()
        guard
            let ID = data["id"].string,
            let name = data["structured_formatting"]["main_text"].string
            else {return nil}
        place.ID = ID
        place.name = name
        return place
    }
}

