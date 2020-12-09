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

    
    
    let realm = try! Realm()
    var categories: Results<Category>?
    let pagingViewController = PagingViewController()
    var PagingVCs: [UIViewController] = []
    var CategoriesString: [String] = []
    
    let recodeModel = ScreenRecodeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        loadCategories()
        pagingViewController.dataSource = self
        
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        //以下の文で描画処理を定義？ないと描画されない。
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateModel()
    }

    //MARK: - PagingViewControllerDatasSource
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return CategoriesString.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return PagingVCs[index] // デフォルト作成　→　ここのUIViewController() と差し替える？
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: CategoriesString[index])
    }
    
    //MARK: - データのupdate
    //HomeViewControllerからの通知を受けてReusableTableViewControllerからもらったcategoryにhomeviewcontrollerからもらったitemを保存
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func updateModel() {
        let numberOfCategory = getNumberOfCategories()
        CategoriesString = getArrayOfCategoryStrings(with: numberOfCategory)
        PagingVCs = getArrayOfViewControllers(with: numberOfCategory)
        
        
        pagingViewController.reloadData()
    }
    
    
    func getNumberOfCategories() -> Int {
        
        guard let numberOfCategories = categories?.count else {
            return 0
        }
        return numberOfCategories
    }
    
    func createViewController(of category: Category) -> ReusableTableViewController {
        let categoryVC = ReusableTableViewController()
        categoryVC.category = category
        
        return categoryVC
    }
    
    func getArrayOfViewControllers(with numberOfCategories: Int) -> [UIViewController] {
        var controllers:[UIViewController] = []
        
        for i in 0 ..< numberOfCategories {
            if let category = categories?[i] {
                let VC = createViewController(of: category)
                controllers.append(VC)
            }
        }
        return controllers
    }
    
    func getArrayOfCategoryStrings(with numberOfCategories: Int) -> [String] {
        var namesOfCategories: [String] = []

        for i in 0 ..< numberOfCategories {
            if let category = categories?[i].name {
                namesOfCategories.append(category)
            }
        }
        return namesOfCategories
    }
    

}
