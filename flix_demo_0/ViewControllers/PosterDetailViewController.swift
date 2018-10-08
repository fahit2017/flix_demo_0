//
//  PosterDetailViewController.swift
//  flix_demo_0
//
//  Created by Fahit Ahmed on 10/7/18.
//  Copyright © 2018 CodePath. All rights reserved.
//

import UIKit
enum MovieKey {
    static let title = "title"
    static let releaseDate = "release_date"
    static let overView = "overview"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

class PosterDetailViewController: UIViewController {

    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var releaseDateLable: UILabel!
    @IBOutlet weak var overviewLable: UILabel!
    
    var movie : [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLable.text = movie[MovieKey.title] as? String
            releaseDateLable.text = movie[MovieKey.releaseDate] as? String
            overviewLable.text = movie[MovieKey.overView] as? String
            let backdropPathString = movie[MovieKey.backdropPath] as! String
            let posterPathString = movie[MovieKey.posterPath] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backDropImageView.af_setImage(withURL: backdropURL)
            let posterPathURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterPathURL)
            
            
        }

    }

}
