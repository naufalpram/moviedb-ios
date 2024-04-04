//
//  MenuCell.swift
//  Tugas_1_Pram
//
//  Created by edts on 31/03/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit
protocol MenuCellDelegate: AnyObject {
    func didTappedMenu(title: String, category: String)
    func didTappedPeopleMenu()
}

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var topRatedMovieMenu: RoundBorderedCell!
    @IBOutlet weak var upcomingMovieMenu: RoundBorderedCell!
    @IBOutlet weak var nowPlayingMovieMenu: RoundBorderedCell!
    @IBOutlet weak var popularMovieMenu: RoundBorderedCell!
    
    @IBOutlet weak var popularTvMenu: RoundBorderedCell!
    @IBOutlet weak var topRatedTvMenu: RoundBorderedCell!
    @IBOutlet weak var onTheAirTvMenu: RoundBorderedCell!
    @IBOutlet weak var airingTvMenu: RoundBorderedCell!
    
    @IBOutlet weak var peopleMenu: RoundBorderedCell!
    
    weak var delegate: MenuCellDelegate?
    var movieMenuData: [String: Menu]?
    var tvMenuData: [String: Menu]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setGestureMovieMenu()
        setGestureTvMenu()
        setGesturePeopleMenu()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMenuData(data: [String: [String: Menu]]) {
        movieMenuData = data["Movie"]
        tvMenuData = data["TV Show"]
    }
    
    @objc func clickTopRatedMovie(sender: UITapGestureRecognizer) {
        let data = movieMenuData?["top rated"]
        self.delegate?.didTappedMenu(title: data?.name ?? "", category: data?.id ?? "search")
    }
    
    @objc func clickUpcomingMovie(sender: UITapGestureRecognizer) {
        let data = movieMenuData?["upcoming"]
        self.delegate?.didTappedMenu(title: data?.name ?? "", category: data?.id ?? "search")
    }
    
    @objc func clickNowPlayingMovie(sender: UITapGestureRecognizer) {
        let data = movieMenuData?["now playing"]
        self.delegate?.didTappedMenu(title: data?.name ?? "", category: data?.id ?? "search")
    }
    
    @objc func clickPopularMovie(sender: UITapGestureRecognizer) {
        let data = movieMenuData?["popular"]
        self.delegate?.didTappedMenu(title: data?.name ?? "", category: data?.id ?? "search")
    }
    
    @objc func clickPopularTv(sender: UITapGestureRecognizer) {
        let data = tvMenuData?["popular"]
        self.delegate?.didTappedMenu(title: data?.name ?? "", category: data?.id ?? "search")
    }
    
    @objc func clickTopRatedTv(sender: UITapGestureRecognizer) {
        let data = tvMenuData?["top rated"]
        self.delegate?.didTappedMenu(title: data?.name ?? "", category: data?.id ?? "search")
    }
    
    @objc func clickOnTheAirTv(sender: UITapGestureRecognizer) {
        let data = tvMenuData?["on the air"]
        self.delegate?.didTappedMenu(title: data?.name ?? "", category: data?.id ?? "search")
    }
    
    @objc func clickAiringTv(sender: UITapGestureRecognizer) {
        let data = tvMenuData?["airing today"]
        self.delegate?.didTappedMenu(title: data?.name ?? "", category: data?.id ?? "search")
    }
    
    @objc func clickPopularPeople(sender: UITapGestureRecognizer) {
        self.delegate?.didTappedPeopleMenu()
    }
    
    private func setGestureMovieMenu() {
        let tapGestureTopRated = UITapGestureRecognizer(target: self, action: #selector(self.clickTopRatedMovie(sender:)))
        self.topRatedMovieMenu.addGestureRecognizer(tapGestureTopRated)
        
        let tapGestureUpcoming = UITapGestureRecognizer(target: self, action: #selector(self.clickUpcomingMovie(sender:)))
        self.upcomingMovieMenu.addGestureRecognizer(tapGestureUpcoming)
        
        let tapGestureNowPlaying = UITapGestureRecognizer(target: self, action: #selector(self.clickNowPlayingMovie(sender:)))
        self.nowPlayingMovieMenu.addGestureRecognizer(tapGestureNowPlaying)
        
        let tapGesturePopular = UITapGestureRecognizer(target: self, action: #selector(self.clickPopularMovie(sender:)))
        self.popularMovieMenu.addGestureRecognizer(tapGesturePopular)
    }
    
    private func setGestureTvMenu() {
        let tapGesturePopular = UITapGestureRecognizer(target: self, action: #selector(self.clickPopularTv(sender:)))
        self.popularTvMenu.addGestureRecognizer(tapGesturePopular)
        
        let tapGestureTopRated = UITapGestureRecognizer(target: self, action: #selector(self.clickTopRatedTv(sender:)))
        self.topRatedTvMenu.addGestureRecognizer(tapGestureTopRated)
        
        let tapGestureOnTheAir = UITapGestureRecognizer(target: self, action: #selector(self.clickOnTheAirTv(sender:)))
        self.onTheAirTvMenu.addGestureRecognizer(tapGestureOnTheAir)
        
        let tapGestureAiring = UITapGestureRecognizer(target: self, action: #selector(self.clickAiringTv(sender:)))
        self.airingTvMenu.addGestureRecognizer(tapGestureAiring)
    }
    
    private func setGesturePeopleMenu() {
        let tapGesturePeople = UITapGestureRecognizer(target: self, action: #selector(self.clickPopularPeople(sender:)))
        self.peopleMenu.addGestureRecognizer(tapGesturePeople)
    }
    
}
