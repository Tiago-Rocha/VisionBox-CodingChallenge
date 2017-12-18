import Foundation
import RxSwift

class PlacesViewModel {
    var places = [Place]()
    var repository: PlaceRepository
    let disposeBag = DisposeBag()
    var updateSubject = PublishSubject<Bool>()
    var loadingSubject = PublishSubject<String>()
    var showPlaceDetailSubject = PublishSubject<Bool>()
    
    init(repository: PlaceRepository) {
        self.repository = repository
        setupBindings()
    }
}
extension PlacesViewModel {
    var numberOfRows: Int {
        return places.count
    }
    var selectedPlace: Place? {
        return repository.place
    }
    func getCellViewModel(index: Int) -> PlacesCellViewModel? {
        return PlacesCellViewModel(place: places[index])
    }
    func getPlaces(input: String) {
        repository.fetchPlaces(input: input)
    }
    func getPlaceDetail(index: Int) {
        repository.fetchPlaceDetail(placeID: places[index].ID)
    }
}
extension PlacesViewModel {
    func setupBindings() {
        repository
            .places
            .asObservable()
            .subscribe(onNext: { _ in
                self.places = self.repository.places.value
                self.updateSubject.onNext(true)})
            .disposed(by: disposeBag)
        
        repository
            .loadingSignal
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { title in
                self.loadingSubject.onNext(title)
            })
            .disposed(by: disposeBag)
        
        repository
            .placeDetailSubject
            .observeOn(MainScheduler.instance)
            .subscribe({ success in
                self.showPlaceDetailSubject.onNext(true)
            })
            .disposed(by: disposeBag)
    }
}

