import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let viewModel: PlaceDetailViewModel
    init(viewModel: PlaceDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension PlaceDetailViewController {
    func setupLayout() {
        if viewModel.hasCoordinates {
            setupMap()
        }
        nameLabel.text = viewModel.name
    }
    func setupMap() {
        let coordinates = CLLocationCoordinate2D(latitude: Double(viewModel.lat ?? 0.0),
                                                 longitude: Double(viewModel.long ?? 0.0))
        let region = MKCoordinateRegionMakeWithDistance(coordinates, 5000, 5000)
        let pointAnnotation:MKPointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinates
        pointAnnotation.title = viewModel.name
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView?.addAnnotation(pointAnnotation)
        self.mapView?.centerCoordinate = coordinates
        self.mapView?.selectAnnotation(pointAnnotation, animated: true)
        self.mapView.setRegion(region, animated: true)
    }
}
