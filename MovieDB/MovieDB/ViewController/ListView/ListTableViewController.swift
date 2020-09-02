//
//  ListTableViewController.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    var presenter: ListPresenter!

    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!

    var list: [Movie] = []
    
    let cellIdentifier : String = "ListTableViewCell"
    
    var actualMovie: Movie?
    var actualPoster: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ListPresenter()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib.init(nibName: self.cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: self.cellIdentifier)
        
        self.presenter.getData(callBack: self.getData(_:_:_:))
    }
    
    func getData(_ list: [Movie]?, _ status: Bool, _ message: String) {
         if status {
            self.list = list ?? []
            self.nextButton.isEnabled = self.presenter.actualPage < self.presenter.pages
            self.previousButton.isEnabled  = self.presenter.actualPage > 1
            self.tableView.reloadData()
        } else {
            print(message, self.description)
        }
    }

    @IBAction func nextAction(_ sender: Any) {
        self.presenter.changePage(isNext: true, callBack: self.getData(_:_:_:))
    }
    
    @IBAction func previousAction(_ sender: Any) {
        self.presenter.changePage(isNext: false, callBack: self.getData(_:_:_:))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! ListTableViewCell

        let movie = self.list[indexPath.row]
        cell.name.text = movie.title
        cell.img.image = nil
        if let imageURL = movie.poster_path {
            self.presenter.getImage(from: apiLowImageURL + imageURL) {
                (data, status, message) in
                if status {
                    if let imageData = data {
                        cell.img.image = UIImage(data: imageData)
                    }
                } else {
                    print(message)
                }
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! ListTableViewCell
        
        self.actualPoster = cell.img.image
        self.actualMovie = self.list[indexPath.row]
        
        performSegue(withIdentifier: "toMovieSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMovieSegue" {
            let movieView = segue.destination as! MovieViewController
            movieView.movie = self.actualMovie
            movieView.presenter =
                MoviePresenter(url: apiURL + "movie/" + (self.actualMovie?.id?.description ?? ""))
            movieView.poster = self.actualPoster
        }
    }
}
