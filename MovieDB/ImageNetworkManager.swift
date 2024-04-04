//
//  ImageNetworkManager.swift
//  Tugas_1_Pram
//
//  Created by edts on 31/03/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

class ImageNetworkManager {
    let baseImageUrl = "https://image.tmdb.org/t/p/original"
    
    private init() {
    }
    
    public class shared {
        private static var _instance: ImageNetworkManager?
        public static var instance: ImageNetworkManager {
            if _instance == nil {
                _instance = ImageNetworkManager()
            }
            return _instance!
        }
    }
    
    func getImgUrl(_ path: String) -> URL {
        return URL(string:"\(baseImageUrl)\(path)")!
    }
}
