//
//  ViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/01.
//

import UIKit
import Parchment
import RealmSwift

class AddCategoryViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    

    @IBOutlet weak var categoryTextfield: UITextField!
    @IBOutlet weak var categoryAddButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        loadCategories()
        
        
    }
    
    //MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name
        
        return cell
    }
    
    
    
    //MARK: - tableview Delegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, complicationhandler) in
            self.deleteCategory(indexPath: indexPath)
            complicationhandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    

    
    
    //MARK: - ButtonAction
    //textfieldのデリゲートメソッドについて調べて実装
    @IBAction func categoryTextfieldEditAction(_ sender: Any) {
    }
    
    @IBAction func categoryAddButtonPressed(_ sender: Any) {
        
        do {
            try realm.write {
                let newCategory = Category()
                newCategory.name = categoryTextfield.text!
                realm.add(newCategory)
            }
            
            categoryTableView.reloadData()
        } catch {
            print("カテゴリの追加に失敗しました")
        }
        
        categoryTextfield.resignFirstResponder()
    }
    
    func deleteCategory(indexPath: IndexPath) {
        
        do {
            try realm.write {
                let deleteCategory = self.categories![indexPath.row]
                self.realm.delete(deleteCategory)
            }
        } catch {
            print("タスクの削除に失敗しました")
        }
        categoryTableView.reloadData()
    }
    
    //MARK: - callback
    func callback() {
        
    }

}

