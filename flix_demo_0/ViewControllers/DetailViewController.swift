//
//  DetailViewController.swift
//  flix_demo_0
//
//  Created by Fahit Ahmed on 10/6/18.
//  Copyright © 2018 CodePath. All rights reserved.
//

import UIKit

enum MovieKeys {
    static let title = "title"
    static let releaseDate = "release_date"
    static let overView = "overview"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

class DetailViewController: UIViewController {

    @IBOutlet weak var BackDropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLable: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    var movie: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie[MovieKeys.title] as? String
            releaseDateLable.text = movie[MovieKeys.releaseDate] as? String
            overViewLabel.text = movie[MovieKeys.overView] as? String
            let backdropPathString = movie[MovieKeys.backdropPath] as! String
            let posterPathString = movie[MovieKeys.posterPath] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            BackDropImageView.af_setImage(withURL: backdropURL)
            
            let posterPathURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterPathURL)
            
            
        }
        
        
        
        
    }
    


}
