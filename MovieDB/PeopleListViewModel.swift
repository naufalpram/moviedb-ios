//
//  PopularPeopleViewModel.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/21/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

protocol PeopleViewModelDelegate: AnyObject {
    func didGetPeopleSuccess()
    func didGetPeopleFailure(_ error: NSError)
}

class PeopleListViewModel {
    private let networkManager: PeopleNetworkManager = PeopleNetworkManager.shared.instance
    weak var delegate: PeopleViewModelDelegate?
    private var peopleData: [People] = []
    private var searchQuery: String?
    private var totalPage: Int = 0
    private var currentPage: Int = 0
    
    func getPeopleListData() {
        currentPage += 1
        networkManager.fetchPeople(page: currentPage, search: searchQuery) { peopleResponse, error in
            if error != nil {
                self.delegate?.didGetPeopleFailure(error ?? NSError(domain: "Error", code: -4, userInfo: nil))
            } else {
                self.checkResetPeopleData()
                self.setTotalPage(page: peopleResponse?.totalPage ?? 1)
                if self.currentPage < self.totalPage {
                    self.appendPeople(toBeAppended: peopleResponse?.people ?? [People]())
                    self.delegate?.didGetPeopleSuccess()
                }
            }
        }
    }
    
    func appendPeople(toBeAppended: [People]) {
        peopleData.append(contentsOf: toBeAppended)
    }
    
    func getPeopleList() -> [People] {
        return peopleData
    }
    
    func setSearchQuery(query: String) {
        searchQuery = query
    }
    
    func getSearchQuery() -> String? {
        return searchQuery
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
    
    private func checkResetPeopleData() {
        if searchQuery != nil {
            peopleData = [People]()
        }
    }
    
    func getPeopleImageUrl(path: String) -> URL {
        return ImageNetworkManager.shared.instance.getImgUrl(path)
    }
}
