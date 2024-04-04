//
//  NetworkManager.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/24/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MoviesNetworkManager {
    
    let baseUrl = "https://api.themoviedb.org/3"
    let baseImageUrl = "https://image.tmdb.org/t/p/original"
    let urlSearchMovies = "https://api.themoviedb.org/3/search"
    
    private init() {
    }
    
    public class shared {
        private static var _instance: MoviesNetworkManager?
        public static var instance: MoviesNetworkManager {
            if _instance == nil {
                _instance = MoviesNetworkManager()
            }
            return _instance!
        }
    }

    
    func fetchMovies(page: Int, category: String?, search: String?, completion: @escaping (_ movieResponse: MovieResponse?, _ error: NSError?) -> Void) {
        var useUrl = ""
        
        var queryParams = [
            "api_key": "2a35719cd2c1e31362c38eeda7f0e117",
            "language": "en-US",
            "page": "\(page)",
            "limit": "1",
        ]
        let useCategory = category?.components(separatedBy: ";")
        let mediaType = useCategory?[0] ?? "movie"
        
        if search != nil {
            queryParams["include_adult"] = "false"
            queryParams["query"] = search
            useUrl = "\(urlSearchMovies)/\(mediaType)"
        } else {
            let categoryType = useCategory?[1] ?? "top_rated"
            useUrl = "\(baseUrl)/\(mediaType)/\(categoryType)"
        }
        
        let urlComp = setupUrlComponents(withUrl: useUrl, queryParams: queryParams)
        guard let url = urlComp?.url else {
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        
        fetchMoviesData(url: url) { response, error in
            completion(response, error)
        }
    }
    
    private func fetchMoviesData(url: URL, completion: @escaping (_ response: MovieResponse?, _ error: NSError?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonObject = json as? [String: Any] else {
                        completion(nil, NSError(domain: "InvalidResponse", code: -3, userInfo: nil))
                        return
                    }
                    let result = jsonObject["results"] as? [[String: Any]] ?? [[String: Any]]()
                    
                    var movies = [Movie]()
                    if result.count > 0 {
                        movies = self.mapMovieResult(result)
                    }
                    let movieResponse = MovieResponse(
                        movies: movies,
                        totalPage: jsonObject["total_pages"] as! Int? ?? 1,
                        page: jsonObject["page"] as! Int? ?? 1
                    )
                    completion(movieResponse, nil)
                } catch {
                    completion(nil, NSError(domain: "InvalidResponse", code: -3, userInfo: nil))
                }
            case .failure(let error):
                completion(nil, error as NSError?)
            }
            
        }
    }
    
    
    func fetchImage(fromPath imagePath: String, completion: @escaping (_ image: UIImage?, _ error: NSError?) -> Void) {
        guard let url = URL(string: "\(baseImageUrl)\(imagePath)") else {
            completion(nil, NSError(domain: "InvalidImageURL", code: -1, userInfo: nil))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error as NSError?)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, NSError(domain: "NetworkError", code: -2, userInfo: nil))
                return
            }
            
            completion(UIImage(data: data), nil)
        }
        
        task.resume()
        
    }
    
    func fetchDetail(type: String, id: Int, completion: @escaping (_ movie: Movie?, _ error: NSError?) -> Void) {
        let urlString = "\(baseUrl)/\(type)/\(id)"
        let queryParams = [
            "api_key": "2a35719cd2c1e31362c38eeda7f0e117",
            "language": "en-US"
        ]
        
        let urlComp = setupUrlComponents(withUrl: urlString, queryParams: queryParams)
        guard let url = urlComp?.url else {
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        fetchDetailData(url: url) { movie, error in
            completion(movie, error)
        }
    }
    
    private func fetchDetailData(url: URL, completion: @escaping (_ movie: Movie?, _ error: NSError?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonObject = json as? [String: Any] else {
                        completion(nil, NSError(domain: "InvalidResponse", code: -3, userInfo: nil))
                        return
                    }
                    let movie = Movie(fromDictionary: jsonObject)
                    
                    completion(movie, nil)
                } catch {
                    completion(nil, NSError(domain: "InvalidResponse", code: -3, userInfo: nil))
                }
            case .failure(let error):
                completion(nil, error as NSError?)
            }
            
        }
    }
    
    private func setupUrlComponents(withUrl url: String, queryParams params: [String: String]) -> URLComponents? {
        var urlComponents = URLComponents(string: url)
        var queryItems: [URLQueryItem] = []
        for key in params.keys {
            queryItems.append(URLQueryItem(name: key, value: params[key]))
        }
        urlComponents?.queryItems = queryItems
        
        return urlComponents
    }
    
    private func mapMovieResult(_ result: [[String: Any]]) -> [Movie] {
        var movieList = [Movie]()
        for movieObject in result {
            let movie = Movie(fromDictionary: movieObject)
            movieList.append(movie)
        }
        return movieList
    }
}
