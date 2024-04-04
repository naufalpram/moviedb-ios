//
//  PeopleNetworkManager.swift
//  Tugas_1_Pram
//
//  Created by edts on 31/03/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class PeopleNetworkManager {
    let popularPeopleUrl = "https://api.themoviedb.org/3/person"
    let baseImageUrl = "https://image.tmdb.org/t/p/original"
    let searchPeopleUrl = "https://api.themoviedb.org/3/search/person"
    
    private init() {
    }
    
    public class shared {
        private static var _instance: PeopleNetworkManager?
        public static var instance: PeopleNetworkManager {
            if _instance == nil {
                _instance = PeopleNetworkManager()
            }
            return _instance!
        }
    }
    
    func fetchPeople(page: Int, search: String?, completion: @escaping (_ peopleResponse: PeopleResponse?, _ error: NSError?) -> Void) {
        var useUrl: String
        var queryParams = [
            "api_key": "2a35719cd2c1e31362c38eeda7f0e117",
            "language": "en-US",
            "page": "\(page)"
        ]
        
        if search != nil {
            queryParams["include_adult"] = "true"
            queryParams["query"] = search
            print(search)
            useUrl = searchPeopleUrl
        } else {
            queryParams["limit"] = "1"
            useUrl = "\(popularPeopleUrl)/popular"
        }
        
        let urlComp = setupUrlComponents(withUrl: useUrl, queryParams: queryParams)
        guard let url = urlComp?.url else {
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        fetchPeopleData(url: url) { peopleResponse, error in
            completion(peopleResponse, error)
        }
    }
    
    private func fetchPeopleData(url: URL, completion: @escaping (_ peopleResponse: PeopleResponse?, _ error: NSError?) -> Void) {
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
                    
                    var people = [People]()
                    if result.count > 0 {
                        people = self.mapPeopleResult(result)
                    }
                    let peopleResponse = PeopleResponse(
                        people: people,
                        totalPage: jsonObject["total_pages"] as! Int,
                        page: jsonObject["page"] as! Int
                    )
                    completion(peopleResponse, nil)
                } catch {
                    completion(nil, NSError(domain: "InvalidResponse", code: -3, userInfo: nil))
                }
            case .failure(let error):
                completion(nil, error as NSError?)
            }
            
        }
    }
    
    func fetchPeopleDetail(id: Int, completion: @escaping (_ detail: PeopleDetail?, _ error: NSError?) -> Void) {
        let queryParams = [
            "api_key": "2a35719cd2c1e31362c38eeda7f0e117",
            "language": "en-US"
        ]
        
        let urlComp = setupUrlComponents(withUrl: "\(popularPeopleUrl)/\(id)", queryParams: queryParams)
        guard let url = urlComp?.url else {
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        AF.request(url).responseDecodable(of: PeopleDetail.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
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
    
    private func mapPeopleResult(_ result: [[String: Any]]) -> [People] {
        var peopleList = [People]()
        for peopleObject in result {
            let people = People(fromDict: peopleObject)
            peopleList.append(people)
        }
        return peopleList
    }
}
