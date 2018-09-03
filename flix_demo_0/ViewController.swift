//
//  ViewController.swift
//  flix_demo_0
//
//  Created by Fahit Ahmed on 8/31/18.
//  Copyright © 2018 CodePath. All rights reserved.
//

import UIKit
import AlamofireImage
import APESuperHUD

class ViewController: UIViewController,
                      UITableViewDataSource,
                      UITableViewDelegate,
                      UISearchBarDelegate

{
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
   
    
    
        func createAlert(errorTitle:String, message:String){
            let alert = UIAlertController(title: errorTitle, message:message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"Try Again", style: UIAlertActionStyle.default, handler: { action in self.fetchMovies()
            }))
            self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            APESuperHUD.dismissAll(animated: true)
        })
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.didPullToRefresh(_refreshControl:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchMovies()

       
    }
        @objc func didPullToRefresh(_refreshControl: UIRefreshControl){
        fetchMovies()
    }
    func fetchMovies(){
       
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=608629cc0f230b88228a4135194ff053")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
   
        let task = session.dataTask(with: request) { (data, response, NetworkError) in
            //this will run when the network request returns
            if let error = NetworkError {
                self.createAlert(errorTitle: "Warning", message: "Please Connect to the Internet")
                print(error.localizedDescription)
                print("No internet Connection")
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
                
                
            }
        }
        task.resume()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            let searchString = searchText.components(separatedBy: " ")
       
 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as!
//            MovieCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as!
          MovieCell
        let movie = movies[indexPath.row]

        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL )
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 180
    }
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
