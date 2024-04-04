//
//  WatchListCoreDataService.swift
//  Tugas_1_Pram
//
//  Created by edts on 01/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WatchListCoreDataService {
    let context: NSManagedObjectContext
    let entityName: String = "WatchList"
    
    private init(context:NSManagedObjectContext) {
        self.context = context
    }
    
    public class shared {
        private static var _instance: WatchListCoreDataService?
        public static var instance: WatchListCoreDataService {
            if _instance == nil {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                _instance = WatchListCoreDataService(context: delegate.persistentContainer.viewContext)
            }
            return _instance!
        }
    }
    
    func fetchWatchList() -> [WatchList]{
        let fetchRequest =
            NSFetchRequest<WatchList>(entityName: entityName)
        guard let movies = try? context.fetch(fetchRequest) else { return [WatchList]() }
        return movies
    }
    
    func saveWatchList(withData data: WatchListCoreModel) {
        let watchList: WatchList!
        let fetchRequest = NSFetchRequest<WatchList>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %d", data.id)
        guard let list = try? context.fetch(fetchRequest) else { return }
        
        if list.count == 0 {
            watchList = WatchList(context: self.context)
        } else {
            context.delete(list.first!)
            saveContext()
            return
        }
        watchList?.setValue(data.id, forKey: "id")
        watchList?.setValue(data.title, forKey: "title")
        watchList?.setValue(data.posterPath, forKey: "posterPath")
        watchList.setValue(data.type, forKey: "type")
        
        saveContext()
    }
    
    func isInWatchList(withId id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<WatchList>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        let result = try? context.fetch(fetchRequest)
        return result?.count ?? 0 > 0
    }
    
    func saveContext() {
        try! context.save()
    }
}
