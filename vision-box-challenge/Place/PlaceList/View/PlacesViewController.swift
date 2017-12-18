import UIKit
import RxSwift

class PlacesViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var placesTableView: UITableView!
    fileprivate var viewModel: PlacesViewModel
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension PlacesViewController {
    func setupLayout() {
        searchBar.delegate = self
        placesTableView.delegate = self
    }
    func setupBindings() {
        viewModel
            .loadingSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { title in
                LoadingView.show(withTitle: title, style: .indicatorOnly)
            })
            .addDisposableTo(disposeBag)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
extension PlacesViewController: UISearchBarDelegate {
    @objc func fetchPlaces(input: String) {
        viewModel.getPlaces(input: input)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchPlaces(input:)), object: nil)
        self.perform(#selector(self.fetchPlaces(input:)), with: searchText, afterDelay: 0.5)
    }
}

