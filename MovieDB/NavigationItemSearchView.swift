//
//  NavigationItemSearchView.swift
//  MovieDB
//
//  Created by edts on 04/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationItemSearchDelegate: AnyObject {
    func didTappedSearch(query: String?)
}

class NavigationItemSearchView: UIView {
    weak var delegate: NavigationItemSearchDelegate?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var searchInput: UITextField = {
        let searchInput = UITextField()
        searchInput.attributedPlaceholder = NSAttributedString(
            string: "Search People...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        searchInput.textColor = .white
        searchInput.autocapitalizationType = UITextAutocapitalizationType.none
        searchInput.autocorrectionType = UITextAutocorrectionType.no
        return searchInput
    }()
    
    lazy var searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.setTitle("", for: .normal)
        searchButton.setImage(UIImage(named: "icons8-search-filled-50"), for: .normal)
        searchButton.backgroundColor = .clear
        searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        return searchButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: 320).isActive = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        addSubview(searchButton)
        addSubview(searchInput)
        setupSearchButtonConstraints()
        setUpSearchInputConstrains()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedSearchButton() {
        self.delegate?.didTappedSearch(query: searchInput.text)
    }
    
    private func setupSearchButtonConstraints() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
    
    private func setUpSearchInputConstrains() {
        searchInput.translatesAutoresizingMaskIntoConstraints = false
        searchInput.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchInput.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        searchInput.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        searchInput.trailingAnchor.constraint(equalTo: self.searchButton.leadingAnchor, constant: 8).isActive = true
    }
}
