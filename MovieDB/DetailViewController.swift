//
//  DetailViewController.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/18/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var horizontalLine: UIView!
    @IBOutlet weak var commentSectionHeader: UIView!
    @IBOutlet weak var noCommentLabel: UILabel!
    @IBOutlet weak var toggleWatchListButton: RoundBorderedButton!
    @IBOutlet weak var loadingModal: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var posterImageConstraintTop: NSLayoutConstraint!
    
    lazy var detailViewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupCommentTableView()
        detailViewModel.delegate = self
        detailViewModel.getDetailData()
        
        if detailViewModel.isInWatchList() {
            self.setRemoveWatchListUI()
        } else {
            self.setAddWatchListUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let commentList = detailViewModel.getCommentList()
        
        if commentList.count == 0 {
            commentTableView.isHidden = true
            noCommentLabel.isHidden = false
        } else {
            commentTableView.isHidden = false
            noCommentLabel.isHidden = true
        }
        
        posterImageConstraintTop.constant = DeviceOrientation.isLandscape ? -300 : -100
        commentTableView.reloadData()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        posterImageConstraintTop.constant = DeviceOrientation.isLandscape ? -300 : -100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedWatchListButton(_ sender: Any) {
        let model = WatchListCoreModel(
            id: detailViewModel.getDetailId(),
            title: detailViewModel.getDetail()?.title ?? "",
            posterPath: detailViewModel.getDetail()?.posterPath ?? "",
            type: detailViewModel.getMediaType()
        )
        detailViewModel.saveWatchList(data: model)
        if detailViewModel.isInWatchList() {
            self.showAddSuccess(title: "Added!")
            self.setRemoveWatchListUI()
        } else {
            self.showAddSuccess(title: "Removed!")
            self.setAddWatchListUI()
        }
    }
    
    @IBAction func didWriteReviewTapped(_ sender: Any) {
        let commentVC = CommentViewController()
        commentVC.configureCommentData(nil, typeOfMedia: detailViewModel.getMediaType(), id: Int32(detailViewModel.getDetailId()))
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func configureMovieData(type: String, id: Int) {
        detailViewModel.setMediaType(type: type)
        detailViewModel.setDetailId(id: id)
    }
    
    func startLoading() {
        loadingModal.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func dismissLoading() {
        loadingModal.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    private func setupCommentTableView() {
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        commentTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func setRemoveWatchListUI() {
        DispatchQueue.main.async {
            self.toggleWatchListButton.backgroundColor = .red
            self.toggleWatchListButton.setTitle("Remove from Watch List", for: .normal)
        }
    }
    
    private func setAddWatchListUI() {
        DispatchQueue.main.async {
            self.toggleWatchListButton.backgroundColor = .clear
            self.toggleWatchListButton.setTitle("Add to Watch List", for: .normal)
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comment = detailViewModel.getCommentList()[indexPath.row]

        let commentVC = CommentViewController()
        commentVC.configureCommentData(comment, typeOfMedia: detailViewModel.getMediaType(),id: comment.movieId)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewModel.getCommentList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = detailViewModel.getCommentList()[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        cell.authorNameLabel.text = comment.authorName
        cell.commentBodyLabel.text = comment.bodyText
        
        return cell
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func didGetDetailSuccess() {
        dismissLoading()
        let data = detailViewModel.getDetail()
        DispatchQueue.main.async {
            self.titleLabel.text = data?.title ?? ""
            self.releaseDateLabel.text = data?.releaseDate ?? ""
            self.ratingLabel.text = "\(data?.rating ?? 0)"
            self.overviewLabel.text = data?.overview ?? ""
            
            if data?.backdropPath == "" {
                self.backdropImageView.image = UIImage(named: "backdrop placeholder")
            }
            if data?.posterPath == "" {
                self.posterImageView.image = UIImage(named: "no image placeholder")
                return
            }
            
            self.backdropImageView.kf.setImage(with: self.detailViewModel.getImageUrl(path: data?.backdropPath ?? ""), placeholder: UIImage(named: "backdrop placeholder"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            self.posterImageView.kf.setImage(with: self.detailViewModel.getImageUrl(path: data?.posterPath ?? ""), placeholder: UIImage(named: "image placeholder 9x16"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        }
    }
    
    func didGetDetailFailure(_ error: NSError) {
        dismissLoading()
        var errorMessage = ""
        switch error.domain {
        case "NetworkError":
            errorMessage = "Something wrong with your connection"
        case "InvalidResponse":
            errorMessage = "Server could not send the correct data"
        default:
            errorMessage = "Something wrong happened"
        }
        self.showAlert(title: "Error", message: errorMessage)
    }
}
