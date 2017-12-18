import Foundation
import RxSwift

class PlaceRepository {
    let apiProvider: APIPlaceProvider
    let errorSignal = PublishSubject<String>()
    let loadingSignal = PublishSubject<String>()
    let placeDetailSubject = PublishSubject<Bool>()
    let places = Variable<[Place]>([Place]())
    var place: Place?

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
    func fetchPlaceDetail(placeID: String) {
        loadingSignal.onNext("Loading..")
        apiProvider.getPlaceDetail(placeID: placeID) {
            place in
            if let _place = place {
                self.place = _place
                self.placeDetailSubject.onNext(true)
                return
            }
            else {
                self.errorSignal.onNext("An error occured")
                return
            }
        }
    }
}

