import UIKit

final class AlternativeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var criteriaLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(name: String, criteria: String) {
        nameLabel.text = name
        criteriaLabel.text = criteria
    }

}
