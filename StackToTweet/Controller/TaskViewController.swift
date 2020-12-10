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
    let pagingViewController = PagingViewController()
    let recodeModel = ScreenRecodeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        recodeModel.loadCategories()
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
        recodeModel.updateModel()
        pagingViewController.reloadData()
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

}
