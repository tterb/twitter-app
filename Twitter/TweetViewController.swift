//
//  TweetViewController.swift
//  Twitter
//
//  Created by Brett Stevenson on 10/4/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var charLabel: UILabel!
    @IBOutlet weak var charCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
        
        tweetTextView.layer.cornerRadius = 10
        tweetTextView.clipsToBounds = true
        tweetTextView.textContainerInset = UIEdgeInsets(top: 10,left: 8,bottom: 10,right: 8)

        tweetButton.layer.cornerRadius = 4
        tweetButton.clipsToBounds = true
        
        charLabel.textColor = UIColor.gray
        charCount.textColor = UIColor.gray
    }

    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        if (count <= 140) {
            charCount.text = String(count)
            charCount.textColor = UIColor.gray
        } else {
            charCount.text = String(140 - count)
            charCount.textColor = UIColor.red
        }
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweet: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)*")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
        
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
