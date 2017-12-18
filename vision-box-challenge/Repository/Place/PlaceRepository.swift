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
                print("fetchPlaces repository")
                print(_places)
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

