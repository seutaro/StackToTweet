//
//  ReusableTableViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/15.
//

import UIKit
import RealmSwift

class ReusableTableViewController: UITableViewController,TaskViewButtonDelegate {
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = Items?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("フラグのセーブに失敗しました")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        if let item = Items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "タスクを追加してください"
        }
        
        return cell
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
