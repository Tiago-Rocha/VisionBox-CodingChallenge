import UIKit
import RxSwift

class PlacesViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var placesTableView: UITableView!
    fileprivate var viewModel: PlacesViewModel
    private var searchTimer: Timer?
    var disposeBag = DisposeBag()
    init(viewModel: PlacesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension PlacesViewController {
    func setupLayout() {
        placesTableView.delegate = self
        placesTableView.dataSource = self
        placesTableView.register(UINib(nibName: "PlacesCell", bundle: nil), forCellReuseIdentifier: "placesCell")
        placesTableView.estimatedRowHeight = 100
        placesTableView.rowHeight = UITableViewAutomaticDimension
        placesTableView.tableFooterView = UIView()
        searchBar.delegate = self
    }
    func setupBindings() {
        viewModel
            .loadingSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { title in
                LoadingView.show(withTitle: title, style: .indicatorOnly)
            })
            .disposed(by: disposeBag)
        viewModel
            .updateSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {_ in
                LoadingView.dismiss()
                self.placesTableView.reloadData()
            })
            .disposed(by: disposeBag)
        viewModel
        .showPlaceDetailSubject
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {_ in
            LoadingView.dismiss()
            self.showPlaceDetail()
        })
        .disposed(by: disposeBag)
    }
}
extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath) as? PlacesCell
        cell?.viewModel = viewModel.getCellViewModel(index: indexPath.row)
        cell?.layoutIfNeeded()
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.getPlaceDetail(index: indexPath.row)
    }
}
extension PlacesViewController: UISearchBarDelegate {
    @objc func fetchPlaces(timer: Timer) {
        guard let searchText = timer.userInfo as? String else {
            return
        }
        viewModel.getPlaces(input: searchText.replacingOccurrences(of: " ", with: "&"))
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.places = []
            placesTableView.reloadData()
            return
        }
        if let searchTimer = searchTimer {
            searchTimer.invalidate()
        }
        searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.fetchPlaces(timer:)), userInfo: searchText, repeats: false)
    }
}
extension PlacesViewController {
    func showPlaceDetail() {
        guard let _place = viewModel.selectedPlace else { return}
        let vm = PlaceDetailViewModel(place: _place)
        let vc = PlaceDetailViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        self.present(vc, animated: true, completion: nil)
    }
}


