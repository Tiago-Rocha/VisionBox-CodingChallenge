import Foundation
import SwiftyJSON

struct APIPlaceProvider {
    func getCities(input: String, completionHandler: (([Place]?) -> ())?) {
        RequestHandler(data: ["input": input as AnyObject], route: .placeDetails).doRequest { success, dataReceived in
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
        }
    }
    func transform(_ data: [String: AnyObject]) -> [Place] {
        print(data)
        guard let placesData = JSON(data)["predictions"].array else {return []}
        print(placesData)
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
// "description": "Ponta Delgada, Portugal",
// "id": "54399fe54f38ab6f48865dd3a9f04bcebf163a93",
// "place_id": "ChIJlw6wdswqQwsRFsRvTvKAVXY",
// "reference": "CjQvAAAAZl7kgCuQMJB8y3hL-TIYRF_jpMbN4YbIlXoRBnckTfHOeeeCZNGMsARSo4sqfDLjEhDHrSsZ9k_IsmjHmFSuO32SGhRPsXL2E4A0nQcbXYi1lXKe4JxAeg",
// "structured_formatting": {
// "main_text": "Ponta Delgada",
// "main_text_matched_substrings": [
//
// "types": [
// "locality",
// "political",
// "geocode"
// ]
// }
// */

