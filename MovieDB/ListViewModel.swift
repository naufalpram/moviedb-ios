//
//  ListViewModel.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/22/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation
import UIKit


protocol ListViewModelDelegate: AnyObject {
    func didGetMoviesSuccess()
    func didGetMoviesFailure(_ error: NSError)
}

class ListViewModel {
    
    private let networkManager: MoviesNetworkManager = MoviesNetworkManager.shared.instance
    weak var delegate: ListViewModelDelegate?
    private var moviesData: [Movie] = []
    private var searchQuery: String?
    private var mediaType: String?
    private var selectedTitle: String = "movie:top_rated"
    private var category = ""
    private var totalPage: Int = 0
    private var currentPage: Int = 0
    
    
    func getMoviesData() {
        currentPage += 1
        networkManager.fetchMovies(page: currentPage, category: category, search: searchQuery) { movieResponse, error in
            if error != nil {
                self.delegate?.didGetMoviesFailure(error ?? NSError(domain: "Error", code: -4, userInfo: nil))
            } else {
                self.setTotalPage(page: movieResponse?.totalPage ?? 1)
                if self.currentPage < self.totalPage {
                    self.appendMovies(toBeAppended: movieResponse?.movies ?? [Movie]())
                    self.delegate?.didGetMoviesSuccess()
                }
            }
            self.setSearchQuery(search: nil)
        }
        
    }
    
    func appendMovies(toBeAppended: [Movie]) {
        moviesData.append(contentsOf: toBeAppended)
    }
    
    func getMovies() -> [Movie] {
        return moviesData
    }
    
    func setSearchQuery(search: String?) {
        searchQuery = search
    }
    
    func getSearchQuery() -> String? {
        return searchQuery
    }
    
    func setMediaType(type: String) {
        mediaType = type
    }
    
    func getMediaType() -> String? {
        return mediaType
    }
    
    func setSelectedTitle(selected: String) {
        selectedTitle = selected
    }
    
    func getSelectedTitle() -> String {
        return selectedTitle
    }
    
    func setCategory(withCategory: String) {
        category = withCategory
    }
    
    func getCategory() -> String {
        return category
    }
    
    func setCurrentPage(page: Int) {
        currentPage = page
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func setTotalPage(page: Int) {
        if currentPage == 1 {
            totalPage = page
        }
    }
    
    func getTotalPage() -> Int {
        return totalPage
    }
    
    func getImage(_ path: String, completion: @escaping (_ image: UIImage?, _ error: NSError?) -> Void) {
        networkManager.fetchImage(fromPath: path) { image, error in
            completion(image, error)
        }
    }
    
    func getImageUrl(path: String) -> URL {
        return ImageNetworkManager.shared.instance.getImgUrl(path)
    }
}
