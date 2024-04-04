//
//  RoundBorderedCell.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/21/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

@IBDesignable
class RoundBorderedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
