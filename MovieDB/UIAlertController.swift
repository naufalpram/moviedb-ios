//
//  UIAlertController.swift
//  Tugas_1_Pram
//
//  Created by edts on 01/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation
import UIKit


var currentLoading : UIAlertController?
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAddSuccess(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let color = title == "Removed!" ? UIColor.red : UIColor(red: 0.05, green: 0.51, blue: 0.27, alpha: 1.00)
        alert.setValue(NSAttributedString(string: alert.title ?? "", attributes: [NSAttributedString.Key.foregroundColor : color]), forKey: "attributedTitle")
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
    }
}
