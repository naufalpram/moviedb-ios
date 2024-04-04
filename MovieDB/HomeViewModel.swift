//
//  HomeViewModel.swift
//  Tugas_1_Pram
//
//  Created by edts on 01/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

protocol WatchListDataSource: AnyObject {
    func didGetWatchListData()
}

class HomeViewModel {
    private let menuData = MovieMenuConfig().data
    private let watchListService = WatchListCoreDataService.shared.instance
    
    weak var delegate: WatchListDataSource?
    private var watchList: [WatchList] = []
    private var searchType: String = "movie"
    
    func getMenuData() -> [String: [String: Menu]] {
        return menuData
    }
    
    func getWatchList() -> [WatchList] {
        return watchList
    }
    
    func setSearchType(type: String) {
        searchType = type
    }
    
    func getSearchType() -> String {
        return searchType
    }
    
    func getWatchListData() {
        watchList = watchListService.fetchWatchList()
        self.delegate?.didGetWatchListData()
    }
    
    func getImageUrl(path: String) -> URL {
        return ImageNetworkManager.shared.instance.getImgUrl(path)
    }
}
