//
//  CommentViewModel.swift
//  MovieDB
//
//  Created by edts on 04/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

class CommentViewModel {
    private var commentCoreDataService = CommentCoreDataService.shared.instance
    private var commentData: Comment?
    private var movieId: Int32 = -1
    private var mediaType: String = ""
    
    func setCommentData(comment: Comment?) {
        commentData = comment
    }
    
    func getCommentData() -> Comment? {
        return commentData
    }
    
    func setMovieId(id: Int32) {
        movieId = id
    }
    
    func getMovieId() -> Int32 {
        return movieId
    }
    
    func setMediaType(type: String) {
        mediaType = type
    }
    
    func getMediaType() -> String {
        return mediaType
    }
    
    func saveComment(data: CommentCoreModel) {
        commentCoreDataService.saveComment(withData: data)
    }
    
    func deleteComment(id: String) {
        commentCoreDataService.deleteComment(withId: id)
    }
}
