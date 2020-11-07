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
    var categories:Category? {
        didSet {
            //ここにItemをロードする関数
        }
    }
    
    
    
    
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        <#code#>
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        <#code#>
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        <#code#>
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

