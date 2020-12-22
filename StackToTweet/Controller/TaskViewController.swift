//
//  TaskViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/15.
//

import UIKit
import Parchment
import RealmSwift

class TaskViewController: UIViewController, PagingViewControllerDataSource {

    
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var AddButton: UIButton!
    
    let recodeModel = ScreenRecodeModel()
    let pagingViewController = PagingViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        recodeModel.loadCategories()
        pagingViewController.dataSource = self
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        self.view.sendSubviewToBack(pagingViewController.view)
        
        pagingViewController.indicatorColor = UIColor(named: "Custom hard")!
        pagingViewController.selectedTextColor = UIColor(named: "Custom hard")!
        
        
        
        
        //以下の文で描画処理を定義？ないと描画されない。
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recodeModel.updateModel()
        pagingViewController.reloadData()
    }
    
    
    //カテゴリ追加画面遷移時にrecodeModelをAddCategoryVCに渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddCategory" {
            let addCategoryVC = segue.destination as? AddCategoryViewController
            addCategoryVC?.recodeModel = self.recodeModel
        } else if segue.identifier == "toTweetView" {
            let tweetVC = segue.destination as? TweetViewController
            tweetVC?.recedeModel = self.recodeModel
        }
    }

    //MARK: - PagingViewControllerDatasSource
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        let numberOfCategories = recodeModel.CategoriesString.count
        return numberOfCategories
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let controllers = recodeModel.PagingVCs
        return controllers[index] // デフォルト作成　→　ここのUIViewController() と差し替える？
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let nameOfCategories = recodeModel.CategoriesString
        return PagingIndexItem(index: index, title: nameOfCategories[index])
    }

//MARK: - ボタンアクション
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "新しいタスクを追加", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            let item = textfield.text!
            if item == "" {
                print("1文字以上入力してください")
            } else {
                self.recodeModel.addNewTask(of: item)
            }
            
            }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "新しいタスクを記入"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func DeleteButtonPressed(_ sender: Any) {
        recodeModel.deleteTask()
    }
    
    
}

//MARK: - ScreenRecodeModelDelegate
//
//extension TaskViewController: ScreenRecodeModelDelegate {
//    func addNewTask(of item: String) {
//
//    }
//
//    func deleteTaskItem() {
//
//    }
//
//    func addNewTaskTest() {
//        var textfield = UITextField()
//
//        let alert = UIAlertController(title: "新しいタスクを追加", message: "", preferredStyle:.alert)
//        let action = UIAlertAction(title: "追加", style: .default) { (action) in
//            let item = textfield.text!
//            self.screenRecodeModelDelegate?.addNewTask(of: item)
//            }
//
//        alert.addTextField { (alertTextfield) in
//            alertTextfield.placeholder = "新しいタスクを記入"
//            textfield = alertTextfield
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//
//
//}
