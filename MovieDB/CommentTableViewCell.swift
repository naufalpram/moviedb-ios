//
//  CommentTableViewCell.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/26/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
