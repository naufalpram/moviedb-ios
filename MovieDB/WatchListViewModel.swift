//
//  WatchListViewModel.swift
//  Tugas_1_Pram
//
//  Created by edts on 02/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

class WatchListViewModel {
    
    private let watchListService = WatchListCoreDataService.shared.instance
    weak var delegate: WatchListDataSource?
    private var watchList: [WatchList] = []
    
    func getWatchListData() {
        watchList = watchListService.fetchWatchList()
        self.delegate?.didGetWatchListData()
    }
    
    func getWatchList() -> [WatchList] {
        return watchList
    }
    
    func deleteWatchList(id: Int) {
        let toBeDeleted = WatchListCoreModel(id: id)
        watchListService.saveWatchList(withData: toBeDeleted)
    }
    
    func getImageUrl(path: String) -> URL {
        return ImageNetworkManager.shared.instance.getImgUrl(path)
    }
}
