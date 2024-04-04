//
//  WatchListTableCell.swift
//  Tugas_1_Pram
//
//  Created by edts on 02/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

protocol WatchListPageItemDelegate: AnyObject {
    func didTappedRemove(id: Int)
}

class WatchListTableCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: WatchListPageItemDelegate?
    private var selfId: Int = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItemId(id: Int) {
        selfId = id
    }
    
    @IBAction func didTappedRemoveBtn(_ sender: Any) {
        self.delegate?.didTappedRemove(id: selfId)
    }
}
