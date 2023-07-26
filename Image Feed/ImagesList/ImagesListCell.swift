import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    
    private enum LikeImage: String {
        case isLiked = "like_button_on"
        case isNotLiked = "like_button_off"
    }
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func changeIsLiked(isLiked: Bool) {
        let likeImage = isLiked
        ? UIImage(named: LikeImage.isLiked.rawValue)
        : UIImage(named: LikeImage.isNotLiked.rawValue)
        
        likeButton.setImage(likeImage, for: .normal)
    }
}
