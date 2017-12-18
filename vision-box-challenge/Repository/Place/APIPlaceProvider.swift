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
    func getPlaceDetail(placeID: String, completionHandler: ((Place?) -> ())?) {
        RequestHandler(data: ["placeID": placeID as AnyObject], route: .placeDetails).doRequest { success, dataReceived in
            guard success else {
                guard let error = dataReceived["error"] as? String
                    else {
                        completionHandler?(nil)
                        return
                }
                completionHandler?(nil)
                return
            }
            completionHandler?(self.transformPlace(dataReceived))
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
            let ID = data["place_id"].string,
            let name = data["structured_formatting"]["main_text"].string
            else {return nil}
        place.ID = ID
        place.name = name
        return place
    }
    func transformPlace(_ data: [String: AnyObject]) -> Place? {
        guard let placeData = JSON(data)["result"].dictionary else { return nil }
        let place = Place()
        
        guard
            let id = placeData["place_id"]?.string,
            let photos = placeData["photos"]?.array,
            let name = placeData["formatted_address"]?.string,
            let lat = placeData["geometry"]?["location"]["lat"].float,
            let long = placeData["geometry"]?["location"]["lng"].float
            else {return nil}
        place.ID = id
        place.name = name
        place.lat = lat
        place.long = long
        return place
    }
}

