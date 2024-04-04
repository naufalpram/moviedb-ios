//
//  HomeViewController.swift
//  Tugas_1_Pram
//
//  Created by edts on 31/03/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mainMenuTableView: UITableView!
    
    lazy var homeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        homeViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.getWatchListData()
        mainMenuTableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mainMenuTableView.reloadData()
    }
    
    private func setTableView() {
        mainMenuTableView.delegate = self
        mainMenuTableView.dataSource = self
        mainMenuTableView.register(UINib(nibName: "SearchBarCell", bundle: nil), forCellReuseIdentifier: "SearchBarCell")
        mainMenuTableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        mainMenuTableView.register(UINib(nibName: "WatchListCell", bundle: nil), forCellReuseIdentifier: "WatchListCell")
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 148
        case 1:
            return DeviceOrientation.isPortrait ? 410 : 640
        default:
            return 360
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarCell", for: indexPath) as? SearchBarCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setMenuData(data: homeViewModel.getMenuData())
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WatchListCell", for: indexPath) as? WatchListCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setWatchListData(data: homeViewModel.getWatchList())
            if homeViewModel.getWatchList().count == 0 {
                cell.emptyListLabel.isHidden = false
                cell.watchListCollectionView.isHidden = true
                return cell
            }
            cell.emptyListLabel.isHidden = true
            cell.watchListCollectionView.isHidden = false
            cell.watchListCollectionView.reloadData()
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension HomeViewController: SearchBarDelegate {
    func didTappedSearch(_ query: String?) {
        if query == nil || query == "" {
            self.showAlert(title: "Warning", message: "Please input movie title")
        } else {
            let listViewController = ListViewController()
            listViewController.configureSearchQuery(query: query!, category: "\(homeViewModel.getSearchType());search")
            self.navigationController?.pushViewController(listViewController, animated: true)
        }
    }
    
    func didTappedSearchTypeButton(mediaType: String = "movie") {
        homeViewModel.setSearchType(type: mediaType)
    }
}

extension HomeViewController: MenuCellDelegate {
    func didTappedMenu(title: String, category: String) {
        let listViewController = ListViewController()
        listViewController.configureCategory(title: title, category: category)
        self.navigationController?.pushViewController(listViewController, animated: true)
    }
    
    func didTappedPeopleMenu() {
        let popularPeopleController = PopularPeopleViewController()
        self.navigationController?.pushViewController(popularPeopleController, animated: true)
    }
}

extension HomeViewController: WatchListDataSource {
    func didGetWatchListData() {
        mainMenuTableView.reloadData()
    }
}

extension HomeViewController: WatchListDelegate {
    func didTappedShowAll() {
        let watchListViewController = WatchListViewController()
        self.navigationController?.pushViewController(watchListViewController, animated: true)
    }
    
    func didTappedItem(type: String, withId id: Int) {
        let detailViewController = DetailViewController()
        detailViewController.configureMovieData(type: type, id: id)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
