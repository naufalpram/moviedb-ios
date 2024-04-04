//
//  PeopleDetailViewController.swift
//  Tugas_1_Pram
//
//  Created by MAC on 3/28/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import UIKit

class PeopleDetailViewController: UIViewController {
    
    @IBOutlet weak var peopleDetailTableView: UITableView!
    @IBOutlet weak var loadingModal: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private lazy var peopleViewModel = PeopleDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        peopleViewModel.detailDelegate = self
        peopleViewModel.getPeopleDetailData()
        setTableView()
        self.title = peopleViewModel.getDetailName()
        let textAttribute = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttribute
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configurePeopleData(name: String, id: Int, movieKnownFor: [KnownForMovie]) {
        peopleViewModel.setDetailName(name: name)
        peopleViewModel.setDetailId(id: id)
        peopleViewModel.setKnownFor(knownForList: movieKnownFor)
    }
    
    func startLoading() {
        loadingModal.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func dismissLoading() {
        loadingModal.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    private func setTableView() {
        peopleDetailTableView.delegate = self
        peopleDetailTableView.dataSource = self
        peopleDetailTableView.register(UINib(nibName: "BiodataCell", bundle: nil), forCellReuseIdentifier: "BiodataCell")
        peopleDetailTableView.register(UINib(nibName: "BiographyCell", bundle: nil), forCellReuseIdentifier: "BiographyCell")
        peopleDetailTableView.register(UINib(nibName: "KnownForCell", bundle: nil), forCellReuseIdentifier: "KnownForCell")
    }
}

extension PeopleDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PeopleDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Biography"
        case 2:
            return "Known For"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = peopleViewModel.getPeopleDetail()
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BiodataCell", for: indexPath) as? BiodataCell else { return UITableViewCell() }
            let configuredCell = setupBiodataCell(data: detail, cell: cell)
            return configuredCell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BiographyCell", for: indexPath) as? BiographyCell else { return UITableViewCell() }
            cell.biographyLabel.text = detail?.biography == "" ? "No biography yet" : detail?.biography
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "KnownForCell", for: indexPath) as? KnownForCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configureKnownForData(data: peopleViewModel.getKnownFor())
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func setupBiodataCell(data: PeopleDetail?, cell: BiodataCell) -> BiodataCell {
        cell.nameLabel.text = data?.name
        cell.birthPlaceLabel.text = data?.placeOfBirth
        
        let gender = data?.gender != nil ? data?.gender == 1 ? "Female" : "Male" : "Not Specified"
        cell.genderOccupationLabel.text = "\(gender), \(data?.knownForDept ?? "")"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateOfBirth = data?.birthDay == nil ? Date() : dateFormatter.date(from: data?.birthDay ?? "")!
        let age = dateOfBirth.age
        cell.birthdayAgeLabel.text = data?.birthDay == nil ? "" : "\(data?.birthDay ?? "") (\(age) years old)"
        
        cell.otherNameLabel.text = data?.alsoKnownAs.joined(separator: ", ")
        
        if data?.profilePath == nil || data?.profilePath == "" {
            cell.profileImageView.image = UIImage(named: "no image placeholder")
            return cell
        }
        cell.profileImageView.kf.setImage(with: peopleViewModel.getPeopleImageUrl(path: data?.profilePath ?? ""), placeholder: UIImage(named: "people placeholder 9x16"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        return cell
    }
}

extension PeopleDetailViewController: PeopleDetailDelegate {
    func didGetDetailSuccess() {
        dismissLoading()
        peopleDetailTableView.reloadData()
    }
    
    func didGetDetailFailure(_ error: NSError) {
        dismissLoading()
        self.showAlert(title: "Error", message: "Failed to get people data")
    }
}

extension PeopleDetailViewController: KnownForDelegate {
    func didTappedItem(type: String, withId id: Int) {
        let detailViewController = DetailViewController()
        detailViewController.configureMovieData(type: type, id: id)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
