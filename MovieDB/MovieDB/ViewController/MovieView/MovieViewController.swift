//
//  MovieViewController.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    var presenter: MoviePresenter!
    var movie: Movie!
    var poster: UIImage!
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    var showingCast: Bool = true
    var people: [People] = []
    var credit: CreditsWrapper?
    let cellIdentifier: String = "PeopleTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peopleTableView.delegate = self
        self.peopleTableView.dataSource = self
        
        let nib = UINib.init(nibName: self.cellIdentifier, bundle: nil)
        self.peopleTableView.register(nib, forCellReuseIdentifier: self.cellIdentifier)
        
        self.setView()
        self.presenter.getData(callBack: self.getMovie(_:_:_:))
        if let id = self.movie.id {
            self.presenter.peopleUrl = "movie/" + id.description + "/credits"
        }
        self.presenter.getPeopleData(callBack: self.getCredits(_:_:_:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.peopleTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.peopleTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.peopleTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableHeightConstraint.constant = newSize.height
                }
            }
        }
    }
    
    @IBAction func controlChanged(_ sender: Any) {
        self.showingCast = !self.showingCast
        guard let list = self.showingCast ? self.credit?.cast : self.credit?.crew else { return }
        
        self.people = list
        self.peopleTableView.reloadData()
    }
    
    func setView() {
        self.title = self.movie.original_title
        self.dateLabel.text = "lançamento: " + (self.movie.release_date ?? "")
        self.runtimeLabel.text = (self.movie.runtime?.description ?? "") + " min"
        self.overviewLabel.text = self.movie.overview
        self.posterImage.image = self.poster
        self.statusLabel.text = "status: " + (self.movie?.status ?? "")
        
        //getting the poster in high quality
        if let imageURL = movie.poster_path {
            self.presenter.getImage(from: apiHighImageURL + imageURL) {
                (data, status, message) in
                if status {
                    if let imageData = data {
                        self.posterImage.image = UIImage(data: imageData)
                    }
                } else {
                    print(message)
                }
            }
        }
    }
    
    func getMovie(_ movie: Movie?, _ status: Bool, _ message: String) {
        if status {
            self.movie = movie
            self.setView()
        } else {
            print(message, self.description)
        }
    }
    
    func getCredits(_ credit: CreditsWrapper?, _ status: Bool, _ message: String) {
        if status {
            self.credit = credit
            self.people = credit!.cast!
            self.peopleTableView.reloadData()
        } else {
            print(message, self.description)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! PeopleTableViewCell
        
        let person = self.people[indexPath.row]
        
        cell.nameLabel.text = person.name
        cell.jobLabel.text = person.character ?? person.job
        cell.pictureImage.image = nil
        if let imageURL = person.profile_path {
            self.presenter.getImage(from: apiLowImageURL + imageURL) {
                (data, status, message) in
                if status {
                    if let imageData = data {
                        cell.pictureImage.image = UIImage(data: imageData)
                    }
                } else {
                    print(message)
                }
            }
        }
        
        return cell
    }
    
    
}
