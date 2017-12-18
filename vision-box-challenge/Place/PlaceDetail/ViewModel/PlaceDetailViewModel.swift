import Foundation

class PlaceDetailViewModel {
    let place: Place
    init(place: Place) {
        self.place = place
    }
}
extension PlaceDetailViewModel {
    var long: Float? {
        return place.long
    }
    var lat: Float? {
        return place.lat
    }
    var hasCoordinates: Bool {
        return place.lat != nil && place.long != nil ? true : false
    }
    var name: String {
        return place.name
    }
}
