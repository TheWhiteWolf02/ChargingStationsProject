import Foundation
import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    private let viewModel: DetailsViewModel
    
    init?(coder: NSCoder, detailsViewModel: DetailsViewModel) {
        viewModel = detailsViewModel
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    private func updateUI() {
        titleLabel.text = "Title: " + viewModel.getTitle()
        numberLabel.text = "Number of Charging Stations: \(viewModel.getNumberOfChargingStations())"
        addressLabel.text = "Address: " + viewModel.getAddress()
    }
}
