import UIKit

class TableViewCustomCell: UITableViewCell {
    
    @IBOutlet weak var address: UILabel?
    @IBOutlet weak var rateimg: UIImageView?
    @IBOutlet weak var name: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
