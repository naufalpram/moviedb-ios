//
//  CommentViewController.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/26/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var commentInputField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    lazy var commentViewModel = CommentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if commentViewModel.getCommentData() != nil {
            setupEditableInputs()
        } else {
            deleteButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSubmitTapped(_ sender: Any) {
        var data: CommentCoreModel
        
        if nameInputField.text == nil || nameInputField.text! == "" || commentInputField.text == nil || commentInputField.text == "" {
            self.showAlert(title: "Alert", message: "Please input your name and comment")
            return
        }
        
        if commentViewModel.getCommentData() == nil {
            // create
            data = CommentCoreModel(
                UUID().uuidString,
                commentViewModel.getMovieId(),
                nameInputField.text!,
                commentInputField.text!,
                mediaType: commentViewModel.getMediaType()
            )
            commentViewModel.saveComment(data: data)
        } else {
            // edit
            let commentData = commentViewModel.getCommentData()
            data = CommentCoreModel(
                commentData?.id ?? "",
                commentData?.movieId ?? -1,
                nameInputField.text!, commentInputField.text!,
                mediaType: commentViewModel.getMediaType()
            )
            commentViewModel.saveComment(data: data)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didDeleteTapped(_ sender: Any) {
        if let comment = commentViewModel.getCommentData() {
            commentViewModel.deleteComment(id: comment.id ?? "")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureCommentData(_ data: Comment?, typeOfMedia: String, id: Int32) {
        commentViewModel.setCommentData(comment: data)
        commentViewModel.setMovieId(id: id)
        commentViewModel.setMediaType(type: typeOfMedia)
    }
    private func setupEditableInputs() {
        nameInputField.text = commentViewModel.getCommentData()?.authorName
        commentInputField.text = commentViewModel.getCommentData()?.bodyText
    }
}
