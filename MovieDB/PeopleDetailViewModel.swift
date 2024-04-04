//
//  PeopleDetailViewModel.swift
//  MovieDB
//
//  Created by edts on 04/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

protocol PeopleDetailDelegate: AnyObject {
    func didGetDetailSuccess()
    func didGetDetailFailure(_ error: NSError)
}

class PeopleDetailViewModel {
    
    private let networkManager: PeopleNetworkManager = PeopleNetworkManager.shared.instance
    weak var detailDelegate: PeopleDetailDelegate?
    private var detail: PeopleDetail?
    private var selfName: String = ""
    private var selfId: Int = -1
    private var knownFor: [KnownForMovie] = []
    
    func getPeopleDetailData() {
        networkManager.fetchPeopleDetail(id: selfId) { detail, error in
            if error != nil {
                self.detailDelegate?.didGetDetailFailure(error ?? NSError(domain: "Error", code: -4, userInfo: nil))
            } else {
                self.detail = detail
                self.detailDelegate?.didGetDetailSuccess()
            }
        }
    }
    
    func getPeopleDetail() -> PeopleDetail? {
        return detail
    }
    
    func setDetailName(name: String) {
        selfName = name
    }
    
    func getDetailName() -> String {
        return selfName
    }
    
    func setDetailId(id: Int) {
        selfId = id
    }
    
    func getDetailId() -> Int {
        return selfId
    }
    
    func setKnownFor(knownForList: [KnownForMovie]) {
        knownFor = knownForList
    }
    
    func getKnownFor() -> [KnownForMovie] {
        return knownFor
    }
    
    func getPeopleImageUrl(path: String) -> URL {
        return ImageNetworkManager.shared.instance.getImgUrl(path)
    }
}
