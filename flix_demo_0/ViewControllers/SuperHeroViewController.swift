//
//  SuperHeroViewController.swift
//  flix_demo_0
//
//  Created by Fahit Ahmed on 10/7/18.
//  Copyright © 2018 CodePath. All rights reserved.
//

import UIKit

class SuperHeroViewController: UIViewController,
UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var movies: [[String:Any]] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
         refreshControl = UIRefreshControl()
          refreshControl.addTarget(self, action: #selector(SuperHeroViewController.didPullToRefresh(_refreshControl:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 3
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: (width * 3/2))
        fetchMovies()
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    @objc func didPullToRefresh(_refreshControl: UIRefreshControl){
        fetchMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
            
        }
        return cell
    }
    
    func fetchMovies(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=608629cc0f230b88228a4135194ff053&language=en-US&page=1")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, NetworkError) in
            //this will run when the network request returns
            if let error = NetworkError {
               // self.createAlert(errorTitle: "Warning", message: "Please Connect to the Internet")
                print(error.localizedDescription)
                print("No internet Connection")
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
