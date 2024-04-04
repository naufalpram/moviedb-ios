//
//  MovieResponse.swift
//  MovieDB
//
//  Created by edts on 04/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

struct MovieResponse {
    let movies: [Movie]
    let totalPage: Int
    let page: Int
    
    init(movies: [Movie], totalPage: Int, page: Int) {
        self.movies = movies
        self.totalPage = totalPage
        self.page = page
    }
}

struct Movie {
    let id: Int
    let title: String
    let overview: String
    let rating: Double
    let releaseDate: String
    let backdropPath: String
    let posterPath: String
    
    init(fromDictionary dict: Dictionary<String, Any>) {
        self.id = dict["id"] as? Int ?? -1
        self.title = dict["title"] as? String ?? dict["name"] as? String ?? "Title"
        self.overview = dict["overview"] as? String ?? "Overview"
        self.rating = dict["vote_average"] as? Double ?? 0
        self.releaseDate = dict["release_date"] as? String ?? dict["first_air_date"] as? String ?? "Release Date"
        self.backdropPath = dict["backdrop_path"] as? String ?? ""
        self.posterPath = dict["poster_path"] as? String ?? ""
    }
    
    init(id: Int, title: String, overview: String, rating: Double, releaseDate: String, backdropPath: String, posterPath: String) {
        self.id = id
        self.title = title
        self.overview = overview
        self.rating = rating
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
        self.posterPath = posterPath
    }

}
