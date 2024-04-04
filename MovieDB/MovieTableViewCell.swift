//
//  MovieTableViewCell.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/20/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieCellImageView: UIImageView!
    @IBOutlet weak var movieCellTitleLabel: UILabel!
    @IBOutlet weak var movieCellRatingLabel: UILabel!
    @IBOutlet weak var movieCellOverviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
