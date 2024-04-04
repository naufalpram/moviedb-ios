//
//  KnownForCell.swift
//  Tugas_1_Pram
//
//  Created by edts on 03/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

protocol KnownForDelegate: AnyObject {
    func didTappedItem(type: String, withId id: Int)
}

class KnownForCell: UITableViewCell {

    @IBOutlet weak var knownForCollectionView: UICollectionView!
    
    weak var delegate: KnownForDelegate?
    private var knownForData: [KnownForMovie] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureKnownForData(data: [KnownForMovie]) {
        knownForData = data
    }
    
    private func setCollectionView() {
        knownForCollectionView.delegate = self
        knownForCollectionView.dataSource = self
        knownForCollectionView.register(UINib(nibName: "KnownForItemCell", bundle: nil), forCellWithReuseIdentifier: "KnownForItemCell")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.itemSize = CGSize(width: 148, height: 240)
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        knownForCollectionView.collectionViewLayout = flowLayout
    }
}

extension KnownForCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = knownForData[indexPath.item]
        self.delegate?.didTappedItem(type: movie.mediaType, withId: Int(movie.id))
    }
}

extension KnownForCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(knownForData.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = knownForData[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KnownForItemCell", for: indexPath) as? KnownForItemCell else {
            return UICollectionViewCell()
        }
        
        
        cell.titleLabel.text = movie.title
        if movie.posterPath == "" {
            cell.posterImageView.image = UIImage(named: "no image placeholder")
            return cell
        }
        
        cell.posterImageView.kf.setImage(with: ImageNetworkManager.shared.instance.getImgUrl(movie.posterPath), placeholder: UIImage(named: "image placeholder 9x16"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        return cell
    }
}
