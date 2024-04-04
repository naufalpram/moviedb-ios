//
//  PopularPeopleViewController.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/21/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

class PopularPeopleViewController: UIViewController {

    @IBOutlet weak var popularPeopleCollectionView: UICollectionView!
    @IBOutlet weak var loadingModal: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    
    lazy var peopleViewModel = PeopleListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        let searchPeopleNavigationItem = NavigationItemSearchView()
        searchPeopleNavigationItem.delegate = self
        self.navigationItem.titleView = searchPeopleNavigationItem
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        popularPeopleCollectionView.addSubview(refreshControl)
        
        peopleViewModel.delegate = self
        peopleViewModel.getPeopleListData()
        setCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh(_ sender: AnyObject) {
        startLoading()
        peopleViewModel.getPeopleListData()
        popularPeopleCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func startLoading() {
        loadingModal.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func dismissLoading() {
        loadingModal.isHidden = true
        loadingIndicator.stopAnimating()
    }

    private func setCollectionView() {
        let nib = UINib(nibName: "PopularPeopleViewCell", bundle: nil)
        
        popularPeopleCollectionView.delegate = self
        popularPeopleCollectionView.dataSource = self
        popularPeopleCollectionView.register(nib, forCellWithReuseIdentifier: "PopularPeopleViewCell")
    }
}

extension PopularPeopleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if peopleViewModel.getSearchQuery() != nil {
            return
        }
        let lastItems = collectionView.numberOfItems(inSection: 0) - 3
        if indexPath.item == lastItems {
            startLoading()
            peopleViewModel.getPeopleListData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let people = peopleViewModel.getPeopleList()[indexPath.item]
        let detailViewController = PeopleDetailViewController()
        detailViewController.configurePeopleData(name: people.name, id: people.id, movieKnownFor: people.knownFor)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

extension PopularPeopleViewController: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 121
        let height = width * 4/3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    
}

extension PopularPeopleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peopleViewModel.getPeopleList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let people = peopleViewModel.getPeopleList()[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularPeopleViewCell", for: indexPath) as? PopularPeopleViewCell else {
            return UICollectionViewCell()
        }
        
        cell.popularPeopleNameLabel.text = people.name
        
        if people.profilePath == nil || people.profilePath == "" {
            cell.popularPeopleImageView.image = UIImage(named: "no image placeholder")
            return cell
        }
        
        cell.popularPeopleImageView.kf.setImage(with: peopleViewModel.getPeopleImageUrl(path: people.profilePath), placeholder: UIImage(named: "people placeholder 9x16"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        return cell
    }
}

extension PopularPeopleViewController: PeopleViewModelDelegate {
    func didGetPeopleSuccess() {
        dismissLoading()
        DispatchQueue.main.async {
            self.popularPeopleCollectionView.reloadData()
        }
    }
    
    func didGetPeopleFailure(_ error: NSError) {
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

extension PopularPeopleViewController: NavigationItemSearchDelegate {
    func didTappedSearch(query: String?) {
        if query == nil || query == "" {
            self.showAlert(title: "Warning", message: "Please input a name")
        } else {
            startLoading()
            peopleViewModel.setSearchQuery(query: query!)
            peopleViewModel.getPeopleListData()
        }
    }
}
