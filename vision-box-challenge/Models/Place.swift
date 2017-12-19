import Foundation

class Place {
    var ID: String
    var name: String
    var rating: Float?
    var icon: URL?
    var url: URL?
    var website: URL?
    var address: String?
    var phone: String?
    var photos: [URL] = []
    var lat: Float?
    var long: Float?

    init(placeID: String, name: String) {
        self.ID = placeID
        self.name = name
    }
    init() {
        self.ID = ""
        self.name = ""
    }
}
