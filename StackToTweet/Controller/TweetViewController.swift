//
//  TweetViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/12/15.
//

import UIKit

class TweetViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    

    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var tweetTableView: UITableView!
    
    var recedeModel: ScreenRecodeModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTableView.dataSource = self
        
    }
    
    
    
    
    @IBAction func pressedTweetButton(_ sender: Any) {
        let category = "swift"
        let test = ["test","teすと"]
        let text = getTweetText(from: category, items: test)
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func getTweetText(from category: String,items:[String]) -> String {
        
        var tweet = """
                    #今日の積み上げ
                    【#\(category)】
                    """
        
        for item in items {
            tweet = tweet + "\n\(item)"
        }
        
        return tweet
    }
    
    
    //MARK: - tableviewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    

}
