//
//  SearchBarCell.swift
//  Tugas_1_Pram
//
//  Created by edts on 31/03/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: AnyObject {
    func didTappedSearch(_ query: String?)
    func didTappedSearchTypeButton(mediaType: String)
}

class SearchBarCell: UITableViewCell {

    @IBOutlet weak var searchInputText: UITextField!
    @IBOutlet weak var movieButton: RoundBorderedButton!
    @IBOutlet weak var tvShowButton: RoundBorderedButton!
    
    weak var delegate: SearchBarDelegate?
    private var selectedType: String = "movie"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setSearchByUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedSearchButton(_ sender: Any) {
        self.delegate?.didTappedSearch(searchInputText.text ?? "")
    }
    
    
    @IBAction func tappedMovieSearch(_ sender: Any) {
        selectedType = "movie"
        setSearchByUI()
        self.delegate?.didTappedSearchTypeButton(mediaType: selectedType)
    }
    
    @IBAction func tappedTvShowSearch(_ sender: Any) {
        selectedType = "tv"
        setSearchByUI()
        self.delegate?.didTappedSearchTypeButton(mediaType: selectedType)
    }
    
    private func setSearchByUI() {
        if selectedType == "movie" {
            movieButton.backgroundColor = .systemBlue
            movieButton.borderColor = .systemBlue
            tvShowButton.backgroundColor = .clear
            tvShowButton.borderColor = .white
            searchInputText.placeholder = "Search Movie..."
            return
        }
        movieButton.backgroundColor = .clear
        movieButton.borderColor = .white
        tvShowButton.backgroundColor = .systemBlue
        tvShowButton.borderColor = .systemBlue
        searchInputText.placeholder = "Search TV Show..."
    }
}
