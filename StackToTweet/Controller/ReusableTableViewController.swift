//
//  ReusableTableViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/15.
//

import UIKit
import RealmSwift

class ReusableTableViewController: UITableViewController,HomeViewButtonDelegate {
    
    let realm = try! Realm()
    var Items: Results<Item>?
    var setCurrentDisplayCategory: ((_ category: Category) -> Void)? // currentDisplayCategory = category taskviewcontroller内 RecodeModel.category = currentCategory
    var passFuncOfCurrentTableViewReloadData: (() -> Void)?
    var tableViewReloadData: (() -> Void) { tableView.reloadData} //こいつをScreenRecodeModelのプロパティに代入　そのためのcomplihentionが必要　taskviewcontroller内でcomplihention(recode) = complihention(tableview) となる
    var category: Category? {
        didSet {
            //ここにアイテムをロードする関数
            loadItems()
        }
    }
    
    
    func loadItems() {
        Items = category?.items.sorted(byKeyPath: "title")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.reloadData()
        tableView.register(UINib(nibName: "ReusableCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setCurrentDisplayCategory!(category!)
        passFuncOfCurrentTableViewReloadData!()
        tableView.reloadData() //もしかするといらないかもしれない
        print(category!)
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
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, complicationhandler) in
            self.deleteItem(indexPath: indexPath)
            complicationhandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func deleteItem(indexPath: IndexPath) {
        
        do {
            try realm.write {
                let deletedItem = self.Items![indexPath.row]
                self.realm.delete(deletedItem)
            }
        } catch {
            print("タスクの削除に失敗しました")
        }
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Items?.count ?? 0
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
    

    
    func deleteTaskItem() {
        if let currentCategory = category {
            do {
                try self.realm.write {
                    let deletedItems = currentCategory.items.filter("done == true")
                    self.realm.delete(deletedItems)
                }
            } catch {
                print("タスクの削除に失敗しました")
            }
        }
        tableView.reloadData()
    }
    


}
