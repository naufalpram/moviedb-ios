//
//  WatchListCell.swift
//  Tugas_1_Pram
//
//  Created by edts on 01/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

protocol WatchListDelegate: AnyObject {
    func didTappedItem(type: String, withId id: Int)
    func didTappedShowAll()
}

class WatchListCell: UITableViewCell {

    @IBOutlet weak var watchListCollectionView: UICollectionView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    var watchListData: [WatchList]?
    weak var delegate: WatchListDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setWatchListData(data: [WatchList]) {
        watchListData = data
    }
    
    @IBAction func didTappedShowAll(_ sender: Any) {
        self.delegate?.didTappedShowAll()
    }
    
    private func setCollectionView() {
        watchListCollectionView.delegate = self
        watchListCollectionView.dataSource = self
        watchListCollectionView.register(UINib(nibName: "WatchListItemCell", bundle: nil), forCellWithReuseIdentifier: "WatchListItemCell")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.itemSize = CGSize(width: 148, height: 240)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        watchListCollectionView.collectionViewLayout = flowLayout
    }
    
}

extension WatchListCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = watchListData?[indexPath.item] else { return }
        self.delegate?.didTappedItem(type: movie.type ?? "", withId: Int(movie.id))
    }
}

extension WatchListCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(watchListData?.count ?? 0, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = watchListData?[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchListItemCell", for: indexPath) as? WatchListItemCell else {
            return UICollectionViewCell()
        }
        
        
        cell.titleLabel.text = movie?.title ?? ""
        if movie?.posterPath == "" || movie?.posterPath == nil {
            cell.imageView.image = UIImage(named: "no image placeholder")
            return cell
        }
        
        cell.imageView.kf.setImage(with: ImageNetworkManager.shared.instance.getImgUrl(movie?.posterPath ?? ""), placeholder: UIImage(named: "image placeholder 9x16"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        return cell
    }
}
