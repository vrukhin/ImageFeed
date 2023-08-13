import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol! { get set }
    
    func showImageDownloadErrorAlert(_ error: Error)
    func showImageLikeError(_ error: Error)
    func lockUI()
    func unlockUI()
    func changeLike(for cell: ImagesListCell, isLiked: Bool)
    func updateTableView(indexPaths: [IndexPath])
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImagesListPresenterProtocol!

    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private let dateFormatter = DateFormatterService.shared.outputImageDateFormatter
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let largeImageUrlString = presenter.photos[indexPath.row].largeImageURL,
                let largeImageUrl = URL(string: largeImageUrlString)
            else { return }
            viewController.imageUrl = largeImageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ImagesListPresenter(view: self)
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
        
        UIBlockingProgressHUD.show()
        presenter.fetchPhotosNextPage()
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter!.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self

        configCell(for: imageListCell, with: indexPath)

        return imageListCell
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard
            let imageURL = presenter.photos[indexPath.row].thumbImageURL,
            let url = URL(string: imageURL)
        else { return }

        cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "Stub"))
        
        if let date = presenter.photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }

        cell.changeIsLiked(isLiked: presenter!.photos[indexPath.row].isLiked)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = presenter!.photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = presenter.photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.photos.count - 1 {
            presenter.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController {
    
    func updateTableView(indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func changeLike(for cell: ImagesListCell, isLiked: Bool) {
        cell.changeIsLiked(isLiked: isLiked)
    }
    
    func showImageDownloadErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "Не удалось загрузить фото",
            message: "\(error.localizedDescription)",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImageLikeError(_ error: Error) {
        let alert = UIAlertController(
            title: "Не удалось лайкнуть фото",
            message: "\(error.localizedDescription)",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func lockUI() {
        UIBlockingProgressHUD.show()
    }
    
    func unlockUI() {
        UIBlockingProgressHUD.dismiss()
    }
}

extension ImagesListViewController {
    private func updateTableViewAnimated() {
        presenter.updateTableView()
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.changeLike(cell: cell, indexPath: indexPath)
    }
}
