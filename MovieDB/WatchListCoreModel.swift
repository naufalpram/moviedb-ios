//
//  WatchListCoreModel.swift
//  Tugas_1_Pram
//
//  Created by edts on 01/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

struct WatchListCoreModel {
    let id: Int
    let title: String
    let posterPath: String
    let type: String
    
    init(id: Int, title: String, posterPath: String, type: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.type = type
    }
    
    init(id: Int) {
        self.id = id
        self.title = ""
        self.posterPath = ""
        self.type = ""
    }
}
