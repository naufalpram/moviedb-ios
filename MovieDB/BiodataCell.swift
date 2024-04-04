//
//  BiodataCell.swift
//  Tugas_1_Pram
//
//  Created by edts on 03/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

class BiodataCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderOccupationLabel: UILabel!
    @IBOutlet weak var birthdayAgeLabel: UILabel!
    @IBOutlet weak var birthPlaceLabel: UILabel!
    @IBOutlet weak var otherNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
