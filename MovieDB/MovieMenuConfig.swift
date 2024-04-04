//
//  MovieMenuConfig.swift
//  Tugas_1_Pram
//
//  Created by edts on 31/03/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

struct Menu {
    let id: String
    let name: String
    let icon: String
    
    init(id: String, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

struct MovieMenuConfig {
    
    private let menuMovie: [String: Menu] = [
        "top rated": Menu(id: "movie;top_rated", name: "Movie: Top Rated", icon: "icons8-imovie-50"),
        "upcoming": Menu(id: "movie;upcoming", name: "Movie: Upcoming", icon: "icons8-movie-projector-50"),
        "now playing": Menu(id: "movie;now_playing", name: "Movie: Now Playing", icon: "icons8-movie-theater-64"),
        "popular": Menu(id: "movie;popular", name: "Movie: Popular", icon: "icons8-movie-ticket-50")
    ]
    
    private let menuTv: [String: Menu] = [
        "popular": Menu(id: "tv;popular", name: "TV: Popular", icon: "icons8-retro-tv-filled-50"),
        "top rated": Menu(id: "tv;top_rated", name: "TV: Top Rated", icon: "icons8-popcorn-64"),
        "on the air": Menu(id: "tv;on_the_air", name: "TV: On The Air", icon: "icons8-clapperboard-50"),
        "airing today": Menu(id: "tv;airing_today", name: "TV: Airing Today", icon: "icons8-cinema-50"),
    ]
    
    private let menuPeople: [String: Menu] = [
        "popular": Menu(id: "person;popular", name: "Popular", icon: "icons8-charlie-chaplin-64")
    ]
    
    var data: [String: [String: Menu]] = [:]
    
    init() {
        data["Movie"] = menuMovie
        data["TV Show"] = menuTv
        data["Popular People"] = menuPeople
    }
}
