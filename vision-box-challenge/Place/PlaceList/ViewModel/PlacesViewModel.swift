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
    }
}
extension PlacesViewModel {
    var numberOfRows: Int {
        return places.count
    }
    func getCellViewModel(index: Int) -> PlacesCellViewModel? {
        return PlacesCellViewModel(place: places[index])
    }
    func getPlaces(input: String) {
        print("getPlaces")
        repository.fetchPlaces(input: input)
    }
}
extension PlacesViewModel {
    func setupBindings() {
        repository
            .places
            .asObservable()
            .subscribe(onNext: {
            _ in self.updateSubject.onNext(true)})
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

