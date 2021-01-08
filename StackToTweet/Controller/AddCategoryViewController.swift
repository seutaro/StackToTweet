//
//  ViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/01.
//

import UIKit

class AddCategoryViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
//    var recodeModel: ScreenRecodeModel
    weak var recodeModel: ScreenRecodeModel!
    weak var shownPageManager: ShownPageManager!
    
    @IBOutlet weak var categoryTextfield: UITextField!
    @IBOutlet weak var categoryAddButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryAddButton.layer.cornerRadius = 15.0
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTextfield.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shownPageManager.updatePageVCs()
        recodeModel.loadCategories()
    }
    
    //MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nameOfCategories = shownPageManager.CategoryString
        return nameOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nameOfCategories = shownPageManager.CategoryString
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = nameOfCategories[indexPath.row]
        
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
    
    @IBAction func categoryAddButtonPressed(_ sender: Any) {
        
        if categoryTextfield.text != "" {
            let name = categoryTextfield.text!
            recodeModel.addCategory(with: name)
            shownPageManager.updatePageVCs()
            categoryTableView.reloadData()
            categoryTextfield.resignFirstResponder()
            categoryTextfield.text = ""
        } else {
            //アラートでも良い
            print("１文字以上入力してください")
        }
    }
    
    func deleteCategory(indexPath: IndexPath) {
        
        recodeModel.deleteCategory(for: indexPath)
        shownPageManager.updatePageVCs()
        categoryTableView.reloadData()
    }
}

