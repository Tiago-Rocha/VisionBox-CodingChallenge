import Foundation
import RxSwift

class PlacesViewModel {
    var places = [Place]()
    var repository: PlaceRepository
    let disposeBag = DisposeBag()
    var updateSubject = PublishSubject<Bool>()
    var loadingSubject = PublishSubject<String>()
    init(repository: PlaceRepository) {
        self.repository = repository
        setupBindings()
    }
}
extension PlacesViewModel {
    var numberOfRows: Int {
        print(places.count)
        return places.count
    }
    func getCellViewModel(index: Int) -> PlacesCellViewModel? {
        return PlacesCellViewModel(place: places[index])
    }
    func getPlaces(input: String) {
        repository.fetchPlaces(input: input)
    }
}
extension PlacesViewModel {
    func setupBindings() {
        repository
            .places
            .asObservable()
            .subscribe(onNext: { _ in
                print("new places")
                self.places = self.repository.places.value
                self.updateSubject.onNext(true)})
            .disposed(by: disposeBag)
        
        repository
            .loadingSignal
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                title in
                self.loadingSubject.onNext(title)
            })
            .disposed(by: disposeBag)
    }
    
}

