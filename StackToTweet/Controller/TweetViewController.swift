//
//  TweetViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/12/15.
//

import UIKit
import RealmSwift

class TweetViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    

    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var tweetTableView: UITableView!
    
    var recedeModel: ScreenRecodeModel!
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTableView.dataSource = self
        
    }
    
    
    
    
    @IBAction func pressedTweetButton(_ sender: Any) {
//        let category = "swift"
//        let test = ["test","teすと"]
//        let text = getTweetText(from: category, items: test)
//        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        if let encodedText = encodedText,
//            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        
        
        let predicate = NSPredicate(format: "done = false")
        let filtered = realm.objects(Item.self).filter(predicate)
        
        for item in filtered {
            let test = item.parentCategory
            print(test)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = recedeModel.CategoriesString.count
        return numberOfSection
    }
     
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let categories = recedeModel.categories {
            let titleForSection = categories[section].name
            return titleForSection
        } else {
            return "カテゴリなし"
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = recedeModel.categories {
            let items = categories[section].items
            let numberOfRows = items.filter("done = true").count
            return numberOfRows
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath)
        if let categories = recedeModel.categories {
            let items = categories[indexPath.section].items
            let doneItems = items.filter("done = true")
            let doneItem = doneItems[indexPath.row]
            cell.textLabel?.text = doneItem.title
            cell.accessoryType = doneItem.tweet ? .checkmark : .none
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    


}
