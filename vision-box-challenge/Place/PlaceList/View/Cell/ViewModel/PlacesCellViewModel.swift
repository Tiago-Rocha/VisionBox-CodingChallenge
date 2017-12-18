import Foundation

struct PlacesCellViewModel {
    let place: Place
    init(place: Place) {
        self.place = place
    }
}
extension PlacesCellViewModel {
    var name: String {
        return place.name
    }
}
