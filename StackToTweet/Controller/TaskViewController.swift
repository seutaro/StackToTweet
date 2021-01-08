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

    
    @IBOutlet weak var defaultMessage: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tweetButton: UIButton!
    
    let recodeModel = DataManager()
    let shownPageManager = ShownPageManager()
    let pagingViewController = PagingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButton()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        setUpPagingViewController()
        
        shownPageManager.RecodeModel = self.recodeModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recodeModel.loadCategories()
        shownPageManager.updatePageVCs()
        pagingViewController.reloadData()
        defaultMessageWillShow()
    }
    
    //カテゴリ追加画面遷移時にrecodeModelをAddCategoryVCに渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddCategory" {
            
            let addCategoryVC = segue.destination as? AddCategoryViewController
            addCategoryVC?.recodeModel = self.recodeModel
            addCategoryVC?.shownPageManager = self.shownPageManager
            
        } else if segue.identifier == "toTweetView" {
            
            let tweetVC = segue.destination as? TweetViewController
            tweetVC?.recedeModel = self.recodeModel
            
        }
    }
    
    func defaultMessageWillShow() {
        let NumberOfCategories = shownPageManager.CategoryString.count
        
        if NumberOfCategories == 0 {
            defaultMessage.isHidden = false
        } else {
            defaultMessage.isHidden = true
        }
    }
}


//MARK: - PagingViewControllerDataSource


extension TaskViewController {
    //pagingviewcontrollerの描画処理
    func setUpPagingViewController() {
        pagingViewController.dataSource = self
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        self.view.sendSubviewToBack(pagingViewController.view)
        
        pagingViewController.indicatorColor = UIColor(named: "Custom light")!
        pagingViewController.selectedTextColor = UIColor(named: "Custom light")!
        pagingViewController.backgroundColor = UIColor.systemBackground
        pagingViewController.menuBackgroundColor = UIColor.systemBackground
        pagingViewController.selectedBackgroundColor = UIColor.systemBackground
        pagingViewController.textColor = UIColor(named: "textColor")!
        
        
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    //以下paigingviewcontrollerのdatasource
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        let numberOfCategories = shownPageManager.CategoryString.count
        return numberOfCategories
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let controllers = shownPageManager.pageVCs
        return controllers[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let nameOfCategories = shownPageManager.CategoryString
        return PagingIndexItem(index: index, title: nameOfCategories[index])
    }
    
}



//MARK: - ボタンアクション

extension TaskViewController {
    
    func setUpButton() {
        menuButton.addTarget(self, action: #selector(self.movementWhenMenuButtonTapped(_:)), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(self.movementWhenCloseButtonTapped(_:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped), for: .touchUpInside)
    }
    //飛び出すボタンの座標計算用関数
    func getButtonPosition(angle: CGFloat, radius: CGFloat) -> CGPoint {
        let radian = angle * .pi / 180
        
        let positionX = menuButton.layer.position.x + cos(radian) * radius
        let positionY = menuButton.layer.position.y + sin(radian) * radius
        
        let position = CGPoint(x: positionX, y: positionY)
        
        return position
    }
    
    //manuButtonを押したときのアニメーション処理
    @objc func movementWhenMenuButtonTapped(_ sender: UIButton) {
        //manuButtonの被タップ表現
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.menuButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.menuButton.transform = .identity
        }, completion: nil)
        
        //以下のアニメーションでmanuButtonから複数のボタンが飛び出る。
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.addButton.layer.position = self.getButtonPosition(angle: -90, radius: 120)
            self.deleteButton.layer.position = self.getButtonPosition(angle: -180, radius: 120)
            self.tweetButton.layer.position = self.getButtonPosition(angle: -135, radius: 120)
        }, completion: {_ in
            self.closeButton.isHidden = false
            self.addButton.isHidden = false
            self.tweetButton.isHidden = false
            self.deleteButton.isHidden = false
            self.menuButton.isHidden = true
        })
    }
    
    //closeButtonをタップしたときの処理。
    @objc func movementWhenCloseButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.closeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.closeButton.transform = .identity
        }, completion: nil)
        
        //以下のアニメーションで展開したボタン類を閉じる
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.addButton.layer.position = self.menuButton.layer.position
            self.deleteButton.layer.position = self.menuButton.layer.position
            self.tweetButton.layer.position = self.menuButton.layer.position
        }, completion: {_ in
            self.addButton.isHidden = true
            self.tweetButton.isHidden = true
            self.deleteButton.isHidden = true
            self.closeButton.isHidden = true
            self.menuButton.isHidden = false
        })
    }
    
    //タスクの追加処理。アラートでテキストボックスを出す。
    @objc func addButtonTapped(_ sender:UIButton) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "新しいタスクを追加", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            let item = textfield.text!
            if item == "" {
                print("1文字以上入力してください")
            } else {
                if let pageIndex = self.shownPageManager.IndexOfCurrentShownPageViewController {
                    let categoryName = self.shownPageManager.CategoryString[pageIndex]
                    self.recodeModel.addNewTask(of: item, in: categoryName)
                    self.shownPageManager.tableViewReloadDataOnTheShownPage()
                }
            }
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "新しいタスクを記入"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //描画されているチェックした項目を削除
    @objc func deleteButtonTapped(_ sender:UIButton) {
        
        if let pageIndex = shownPageManager.IndexOfCurrentShownPageViewController {
            let categoryName = shownPageManager.CategoryString[pageIndex]
            recodeModel.deleteTask(in: categoryName)
            shownPageManager.tableViewReloadDataOnTheShownPage()
        }
    }
}
