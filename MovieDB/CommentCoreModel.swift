//
//  CommentCoreData.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/26/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

struct CommentCoreModel {
    var id: String
    var movieId: Int32
    var authorName: String
    var bodyText: String
    var mediaType: String
    
    init(_ id: String,_ movieId: Int32,_ authorName: String,_ bodyText: String, mediaType: String) {
        self.id = id
        self.movieId = movieId
        self.authorName = authorName
        self.bodyText = bodyText
        self.mediaType = mediaType
    }
}
