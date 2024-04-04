//
//  CommentCoreDataService.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/26/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CommentCoreDataService {
    let context: NSManagedObjectContext
    let entityName: String = "Comment"
    
    private init(context:NSManagedObjectContext) {
        self.context = context
    }
    
    public class shared {
        private static var _instance: CommentCoreDataService?
        public static var instance: CommentCoreDataService {
            if _instance == nil {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                _instance = CommentCoreDataService(context: delegate.persistentContainer.viewContext)
            }
            return _instance!
        }
    }
    
    func fetchCommentsByMovie(withMovieId id: Int, mediaType: String) -> [Comment]{
        let fetchRequest =
            NSFetchRequest<Comment>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "movieId == %d AND mediaType == %@", Int32(id), mediaType)
        guard let comments = try? context.fetch(fetchRequest) else { return [Comment]() }
        return comments
    }
    
    
    func saveComment(withData data: CommentCoreModel) {
        let comment: Comment!
        let fetchRequest = NSFetchRequest<Comment>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", data.id)
        guard let comments = try? context.fetch(fetchRequest) else { return }
        
        if comments.count == 0 {
            comment = Comment(context: self.context)
        } else {
            comment = comments.first
        }
        comment?.setValue(data.id, forKey: "id")
        comment?.setValue(data.movieId, forKey: "movieId")
        comment?.setValue(data.authorName, forKey: "authorName")
        comment?.setValue(data.bodyText, forKey: "bodyText")
        comment.setValue(data.mediaType, forKey: "mediaType")
        
        saveContext()
    }
    
    func deleteComment(withId id: String) {
        let fetchRequest =
            NSFetchRequest<Comment>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        guard let comments = try? context.fetch(fetchRequest) else { return }
        
        if comments.count > 0 {
            context.delete(comments.first!)
        }
        saveContext()
    }
    
    func saveContext() {
        try! context.save()
    }
}
