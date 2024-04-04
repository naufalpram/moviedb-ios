//
//  WatchListViewController.swift
//  Tugas_1_Pram
//
//  Created by edts on 02/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

class WatchListViewController: UIViewController {

    @IBOutlet weak var watchListTableView: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    lazy var watchListViewModel = WatchListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Watch List"
        let textAttribute = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttribute
        
        setTableView()
        watchListViewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        watchListViewModel.getWatchListData()
        if watchListViewModel.getWatchList().count == 0 {
            emptyListLabel.isHidden = false
            watchListTableView.isHidden = true
            return
        }
        emptyListLabel.isHidden = true
        watchListTableView.isHidden = false
        watchListTableView.reloadData()
    }
    
    private func setTableView() {
        watchListTableView.delegate = self
        watchListTableView.dataSource = self
        watchListTableView.register(UINib(nibName: "WatchListTableCell", bundle: nil), forCellReuseIdentifier: "WatchListTableCell")
        watchListTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension WatchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = watchListViewModel.getWatchList()[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.configureMovieData(type: item.type ?? "", id: Int(item.id))
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension WatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchListViewModel.getWatchList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = watchListViewModel.getWatchList()[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WatchListTableCell", for: indexPath) as? WatchListTableCell else { return UITableViewCell() }
        
        cell.setItemId(id: Int(item.id))
        cell.titleLabel.text = item.title
        if item.posterPath == "" || item.posterPath == nil {
            cell.posterImageView.image = UIImage(named: "no image placeholder")
            return cell
        }
        
        cell.posterImageView.kf.setImage(with: watchListViewModel.getImageUrl(path: item.posterPath ?? ""), placeholder: UIImage(named: "movie placeholder"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        
        cell.delegate = self
        return cell
    }
}

extension WatchListViewController: WatchListDataSource {
    func didGetWatchListData() {
        watchListTableView.reloadData()
    }
}

extension WatchListViewController: WatchListPageItemDelegate {
    func didTappedRemove(id: Int) {
        watchListViewModel.deleteWatchList(id: id)
        self.showAlert(title: "Removed!", message: "")
        watchListViewModel.getWatchListData()
        watchListTableView.reloadData()
    }
}
