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
    
    var realmDataManager: RealmDataManager!
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetButton.layer.cornerRadius = 15
        tweetTableView.dataSource = self
        tweetTableView.delegate = self
        tweetTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        realmDataManager.updateCategoriesWithTweetItems()
    }
    
    
    
    @IBAction func pressedTweetButton(_ sender: Any) {
        
        let tweet = realmDataManager.getTweetText()
        let encodedText = tweet.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        do {
            try realm.write {
                let tweetedItems = realm.objects(Item.self).filter("tweet == true")
                realm.delete(tweetedItems)
            }
        } catch {
            print("ツイート済みのタスクの削除に失敗しました。")
        }
        realmDataManager.updateCategoriesWithTweetItems()
        tweetTableView.reloadData()
    }
    
    
    
    //MARK: - tableviewDatasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = realmDataManager.CategoriesWtihTweetItems.count
        return numberOfSection
    }
     
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = realmDataManager.CategoriesWtihTweetItems[section]
        let titleForSection = category.name
        return titleForSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = realmDataManager.CategoriesWtihTweetItems[section]
        let doneItems = realmDataManager.getDoneItemList(from: category)
        let numberOfRows = doneItems.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath)
        
        let tweetableCategories = realmDataManager.CategoriesWtihTweetItems
        let categoryWithTweetItems = tweetableCategories[indexPath.section]
        let doneItems = realmDataManager.getDoneItemList(from: categoryWithTweetItems)
        let tweetItem = doneItems[indexPath.row]
        cell.textLabel?.text = tweetItem.title
        cell.accessoryType = tweetItem.tweet ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categories = realmDataManager.CategoriesWtihTweetItems
        let category = categories[indexPath.section]
        let doneItems = realmDataManager.getDoneItemList(from: category)
        let item = doneItems[indexPath.row]
        do {
            try realm.write {
                item.tweet = !item.tweet
            }
        } catch {
            print("ツイートのフラグ変更に失敗しました")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            tableView.reloadData()
        }
    }
}
