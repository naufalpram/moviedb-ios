//
//  DetailViewModel.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/24/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation
import UIKit

protocol DetailViewModelDelegate: AnyObject {
    func didGetDetailSuccess()
    func didGetDetailFailure(_ error: NSError)
}

class DetailViewModel {
    
    private let networkManager: MoviesNetworkManager = MoviesNetworkManager.shared.instance
    private let commentCoreDataService = CommentCoreDataService.shared.instance
    private let watchListCoreDataService = WatchListCoreDataService.shared.instance
    
    private var selfId: Int = -1
    private var commentList: [Comment] = []
    private var mediaType: String = ""
    weak var delegate: DetailViewModelDelegate?
    private var detail: Movie?
    
    func getDetailData() {
        networkManager.fetchDetail(type: mediaType, id: selfId) { movie, error in
            if error != nil {
                self.delegate?.didGetDetailFailure(error ?? NSError(domain: "Error", code: -4, userInfo: nil))
            } else {
                self.detail = movie
                self.delegate?.didGetDetailSuccess()
            }
        }
    }
    
    func getDetail() -> Movie? {
        return detail
    }
    
    func setDetailId(id: Int) {
        selfId = id
    }
    
    func getDetailId() -> Int {
        return selfId
    }
    
    func getCommentList() -> [Comment] {
        return commentCoreDataService.fetchCommentsByMovie(withMovieId: selfId, mediaType: mediaType)
    }
    
    func setMediaType(type: String) {
        mediaType = type
    }
    
    func getMediaType() -> String {
        return mediaType
    }
    
    func isInWatchList() -> Bool {
        return watchListCoreDataService.isInWatchList(withId: selfId)
    }
    
    func saveWatchList(data: WatchListCoreModel) {
        watchListCoreDataService.saveWatchList(withData: data)
    }
    
    func getDetailImage(_ path: String, completion: @escaping (_ image: UIImage?, _ error: NSError?) -> Void) {
        networkManager.fetchImage(fromPath: path) { image, error in
            completion(image, error)
        }
    }
    
    func getImageUrl(path: String) -> URL {
        return ImageNetworkManager.shared.instance.getImgUrl(path)
    }
}
