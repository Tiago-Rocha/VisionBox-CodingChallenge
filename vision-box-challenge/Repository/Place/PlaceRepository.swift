import Foundation
import RxSwift

class PlaceRepository {
    let apiProvider: APIPlaceProvider
    let errorSignal = PublishSubject<String>()
    let loadingSignal = PublishSubject<String>()
    let places = Variable<[Place]>([Place]())
    init(apiProvider: APIPlaceProvider) {
        self.apiProvider = apiProvider
    }
}
extension PlaceRepository {
    func fetchPlaces(input: String) {
        loadingSignal.onNext("Loading...")
        apiProvider.getPlaces(input: input) {
            places in
            if let _places = places {
                self.places.value = _places
                return
            }
            else {
                self.errorSignal.onNext("An error occured")
                return
            }
        }
    }
}


/*
 {
 "description": "Ponta Delgada, Portugal",
 "id": "54399fe54f38ab6f48865dd3a9f04bcebf163a93",
 "matched_substrings": [
 {
 "length": 13,
 "offset": 0
 }
 ],
 "place_id": "ChIJlw6wdswqQwsRFsRvTvKAVXY",
 "reference": "CjQvAAAAZl7kgCuQMJB8y3hL-TIYRF_jpMbN4YbIlXoRBnckTfHOeeeCZNGMsARSo4sqfDLjEhDHrSsZ9k_IsmjHmFSuO32SGhRPsXL2E4A0nQcbXYi1lXKe4JxAeg",
 "structured_formatting": {
 "main_text": "Ponta Delgada",
 "main_text_matched_substrings": [
 {
 "length": 13,
 "offset": 0
 }
 ],
 "secondary_text": "Portugal"
 },
 "terms": [
 {
 "offset": 0,
 "value": "Ponta Delgada"
 },
 {
 "offset": 15,
 "value": "Portugal"
 }
 ],
 "types": [
 "locality",
 "political",
 "geocode"
 ]
 }
 */
