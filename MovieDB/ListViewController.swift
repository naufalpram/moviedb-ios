//
//  ListViewController.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/20/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit
import Kingfisher

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var loadingModal: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    lazy var listViewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        startLoading()
        if listViewModel.getSearchQuery() == nil {
            self.title = listViewModel.getSelectedTitle()
            listViewModel.setCategory(withCategory: listViewModel.getMediaType() ?? "movie;top_rated")
        } else {
            self.title = "Search: \(listViewModel.getSearchQuery()!)"
            listViewModel.setCategory(withCategory: listViewModel.getMediaType() ?? "movie;search")
        }
        
        let textAttribute = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttribute
        
        setupTableViewUI()
        listViewModel.delegate = self
        listViewModel.getMoviesData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh(_ sender: AnyObject) {
        startLoading()
        listViewModel.getMoviesData()
        if listViewModel.getMovies().count == 0 {
            emptyListLabel.isHidden = false
            tableView.isHidden = true
            dismissLoading()
            return
        }
        emptyListLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func configureSearchQuery(query: String, category: String) {
        listViewModel.setSearchQuery(search: query)
        listViewModel.setMediaType(type: category)
    }
    
    func configureCategory(title: String, category: String) {
        listViewModel.setSelectedTitle(selected: title)
        listViewModel.setMediaType(type: category)
    }
    
    func startLoading() {
        loadingModal.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func dismissLoading() {
        loadingModal.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    private func setupTableViewUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.title?.components(separatedBy: ":")[0] == "Search" {
            return
        }
        let numberOfSections = tableView.numberOfSections
        let numberOfRows = tableView.numberOfRows(inSection: numberOfSections - 1)
        if indexPath.row == numberOfRows - 1 && indexPath.section == numberOfSections - 1 {
            startLoading()
            listViewModel.getMoviesData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let mediaType = listViewModel.getMediaType()?.components(separatedBy: ";")[0] ?? "movie"
        detailViewController.configureMovieData(type: mediaType, id: listViewModel.getMovies()[indexPath.row].id)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.getMovies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = listViewModel.getMovies()[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        cell.movieCellTitleLabel.text = movie.title
        cell.movieCellRatingLabel.text = "Rating: \(movie.rating)"
        cell.movieCellOverviewLabel.text = movie.overview
        
        if movie.posterPath == "" {
            cell.movieCellImageView.image = UIImage(named: "no image placeholder")
            return cell
        }
        
        cell.movieCellImageView.kf.setImage(with: listViewModel.getImageUrl(path: movie.posterPath), placeholder: UIImage(named: "image placeholder 9x16"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)

        return cell
    }
}

extension ListViewController: ListViewModelDelegate {
    func didGetMoviesSuccess() {
        dismissLoading()
        DispatchQueue.main.async {
            if self.listViewModel.getMovies().count == 0 {
                self.emptyListLabel.isHidden = false
                self.tableView.isHidden = true
                return
            }
            self.emptyListLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func didGetMoviesFailure(_ error: NSError) {
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
