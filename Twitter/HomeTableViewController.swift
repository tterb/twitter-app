//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Brett Stevenson on 9/25/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBOutlet var tweetTableView: UITableView!
    var tweetArray = [NSDictionary]()
    var tweetCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }

    func loadTweets() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": 10]

        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params,
            success: { (tweets: [NSDictionary]) in
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet)
//                    print(tweet["text"])
                }
                for tweet in self.tweetArray {
                    print(tweet["text"])
                }
                print(self.tweetArray.count)
                self.tableView.reloadData()
            },
            failure: { (Error) in
                print("Could not retrieve tweets.")
            }
        )
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweetArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = self.tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = self.tweetArray[indexPath.row]["text"] as? String
        
        // Set tweet image
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }

}
