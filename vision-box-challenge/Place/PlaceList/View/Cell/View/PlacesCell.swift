import UIKit

class PlacesCell: UITableViewCell {
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var viewModel: PlacesCellViewModel? {
        didSet {
            setupLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupLayout() {
        guard let _viewModel = viewModel else {
            return
        }
        placeNameLabel.text = _viewModel.name
    }
}
