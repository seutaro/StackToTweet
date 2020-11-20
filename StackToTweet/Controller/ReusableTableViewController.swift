//
//  ReusableTableViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/15.
//

import UIKit
import RealmSwift

class ReusableTableViewController: UITableViewController,AddButtonDelegate {
    
    let realm = try! Realm()
    var Items: Results<Item>?
    var category: Category? {
        didSet {
            //ここにアイテムをロードする関数
            loadItems()
        }
    }
    
    func loadItems() {
        Items = category?.items.sorted(byKeyPath: "title")
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Items?.count ?? 1
    }
    
    //MARK: - AddButtonDelegate
    
    func addNewTaskItem(item: String) {
        if let currentCategory = category {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = item
                    currentCategory.items.append(newItem)
                }
                
            } catch {
                print("新しいタスクの追加に失敗しました")
            }
        }
        self.tableView.reloadData()
    }


}
