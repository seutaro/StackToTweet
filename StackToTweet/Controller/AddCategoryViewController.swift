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
    
    @IBOutlet weak var categoryTextfield: UITextField!
    @IBOutlet weak var categoryAddButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTextfield.delegate = self
        recodeModel.loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recodeModel.updateModel()
    }
    
    //MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nameOfCategories = recodeModel.CategoriesString
        return nameOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nameOfCategories = recodeModel.CategoriesString
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
    //textfieldのデリゲートメソッドについて調べて実装
    
    @IBAction func categoryAddButtonPressed(_ sender: Any) {
        
        if categoryTextfield.text != "" {
            let name = categoryTextfield.text!
            recodeModel.addCategory(with: name)
            recodeModel.updateModel()
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
        recodeModel.updateModel()
        categoryTableView.reloadData()
    }
    
    //MARK: - TextFieldDelegate
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        return true
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if self.categoryTextfield.isFirstResponder {
//            self.categoryTextfield.resignFirstResponder()
//        }
//    }
    
    func getFirstResponder(view:UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        
        for subView in view.subviews {
            if let _ = getFirstResponder(view: subView) {
                return subView
            }
        }
        
        return nil
    }
}

