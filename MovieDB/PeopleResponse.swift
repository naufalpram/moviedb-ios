//
//  PeopleResponse.swift
//  Tugas_1_Pram
//
//  Created by edts on 31/03/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

struct PeopleResponse {
    let people: [People]
    let totalPage: Int
    let page: Int
}

struct People {
    let id: Int
    let name: String
    let profilePath: String
    let knownFor: [KnownForMovie]
    
    init(fromDict dict: [String: Any]) {
        self.id = dict["id"] as? Int ?? -1
        self.name = dict["name"] as? String ?? ""
        self.profilePath = dict["profile_path"] as? String ?? ""
        
        let movies = dict["known_for"] as? [[String: Any]] ?? [[String: Any]]()
        self.knownFor = movies.map { movie in
            let res = KnownForMovie(
                id: movie["id"] as? Int ?? -1,
                title: movie["title"] as? String ?? movie["name"] as? String ?? "",
                posterPath: movie["poster_path"] as? String ?? "",
                mediaType: movie["media_type"] as? String ?? ""
            )
            return res
        }
    }
}

struct KnownForMovie {
    let id: Int
    let title: String
    let posterPath: String
    let mediaType: String
    
    init(id: Int, title: String, posterPath: String, mediaType: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.mediaType = mediaType
    }
}

struct PeopleDetail: Codable {
    let id: Int
    let name: String?
    let gender: Int?
    let knownForDept: String?
    let birthDay: String?
    let placeOfBirth: String?
    let alsoKnownAs: [String]
    let biography: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, gender
        case knownForDept = "known_for_department"
        case birthDay = "birthday"
        case placeOfBirth = "place_of_birth"
        case alsoKnownAs = "also_known_as"
        case biography
        case profilePath = "profile_path"
    }
}
