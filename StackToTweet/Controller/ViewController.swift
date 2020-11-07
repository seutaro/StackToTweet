//
//  ViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/01.
//

import UIKit
import Parchment
import RealmSwift

class ViewController: UIViewController, PagingViewControllerDataSource {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    
    func loadCategories() {
        categories = realm.objects(Category.self) //カテゴリをロードする
    }
    
    func createViewController(category: Category) -> ReusableTableViewController {
        
        let categoryVC = ReusableTableViewController()
        categoryVC.category = category
        
        return categoryVC
    }
    
    //MARK: - PagingViewControllerDataSource
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return categories?.count ?? 0
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let numberOfCategory = categories?.count ?? 1
        var controllers:[UIViewController?] = []
        
        //以下のシーケンスの範囲は要確認
        for i in 0...numberOfCategory {
            if let category = categories?[i] {
                let VC = createViewController(category: category)
                controllers.append(VC)
            }
        }
        
        return controllers[index] ?? UIViewController() // デフォルト画面作成　→　差し替える
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
        let numberOfCategory = categories?.count ?? 1
        var categoriesString:[String] = []
        for i in 0...numberOfCategory {
            if let category = categories?[i] {
                let categoryName = category.name
                categoriesString.append(categoryName)
            }
        }
        
        return PagingIndexItem(index: index, title: categoriesString[index])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let pagingViewController = PagingViewController()
        
        pagingViewController.dataSource = self
        
        
        
        
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        //以下の文は全体に必要。ないと描画されない。
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }


}

