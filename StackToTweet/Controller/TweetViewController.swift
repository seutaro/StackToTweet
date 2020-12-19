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
        tweetTableView.delegate = self
        tweetTableView.allowsMultipleSelectionDuringEditing = true
        tweetTableView.isEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recedeModel.updateCategoriesWithTweetItems()
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
        let numberOfSection = recedeModel.CategoriesWtihTweetItems.count
        return numberOfSection
    }
     
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = recedeModel.CategoriesWtihTweetItems[section]
        let titleForSection = category.name
        return titleForSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = recedeModel.CategoriesWtihTweetItems[section]
        let items = category.items
        let numberOfRows = items.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath)
        
        let tweetableCategories = recedeModel.CategoriesWtihTweetItems
        let categoryWithTweetItems = tweetableCategories[indexPath.section]
        let doneItems = recedeModel.getDoneItemList(from: categoryWithTweetItems)
        let tweetItem = doneItems[indexPath.row]
        cell.textLabel?.text = tweetItem.title
        cell.isEditing = tweetItem.tweet
//        if let categories = recedeModel.categories {
//            let items = categories[indexPath.section].items
//            let doneItems = items.filter("done = true")
//            let doneItem = doneItems[indexPath.row]
//            cell.textLabel?.text = doneItem.title
////            cell.accessoryType = doneItem.tweet ? .checkmark : .none
//            cell.isEditing = doneItem.tweet
//        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categories = recedeModel.CategoriesWtihTweetItems
        let category = categories[indexPath.section]
        let doneItems = recedeModel.getDoneItemList(from: category)
        let item = doneItems[indexPath.row]
        do {
            try realm.write {
                item.tweet = !item.tweet
            }
        } catch {
            print("ツイートのフラグ変更に失敗しました")
        }
//        if let categories = recedeModel.categories {
//            let items = categories[indexPath.section].items
//            let doneItems = items.filter("done = true")
//            let item = doneItems[indexPath.row]
//            do {
//                try realm.write {
//                    item.tweet = !item.tweet
//                }
//            } catch {
//                print("ツイートのフラグ変更に失敗しました")
//            }
//        }
    }


}
