import UIKit

class PlacesViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var placesTableView: UITableView!
    fileprivate var viewModel: PlacesViewModel
//    var disposeBag = DisposeBag()
    init(viewModel: PlacesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
