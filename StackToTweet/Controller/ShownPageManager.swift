//
//  ShownScreenManager.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2021/01/06.
//

import Foundation
import RealmSwift

class ShownPageManager {
    var RecodeModel: DataManager!
    
    var IndexOfCurrentShownPageViewController: Int? //現在表示されているpageのインデックスを保持
    var pageVCs: [PageViewController] = []  //カテゴリごとのpageViewControllerを配列として保持
    var CategoryString: [String] = []   //上タブの項目（カテゴリ名）を配列として保持
    
    
    //現在表示されているpageViewControllerのtableview.reloadDataを実行する関数
    func tableViewReloadDataOnTheShownPage() {
        guard let Index = IndexOfCurrentShownPageViewController else {
            return
        }
        pageVCs[Index].tableView.reloadData()
    }
    
    //カテゴリが追加、削除された際に描画するpageを更新する関数
    func updatePageVCs() {
        let numberOfCategories = getNumberOfCategories()
        CategoryString = getArrayOfCategoryStrings(with: numberOfCategories)
        pageVCs = getArrayOfPageViewControllers(with: numberOfCategories)
    }
    
    //以下pageVCs,CategoryString更新のための関数
    
    func getNumberOfCategories() -> Int {
        guard let numberOfCategories = RecodeModel.categories?.count else {
            return 0
        }
        return numberOfCategories
    }
    
    
    func createPageViewController(of category: Category) -> PageViewController {
        let PageVC = PageViewController()
        PageVC.category = category
        
        
        return PageVC
    }
    
    
    func getArrayOfPageViewControllers(with numberOfCategories: Int) -> [PageViewController] {
        var controllers: [PageViewController] = []
        
        for i in 0 ..< numberOfCategories {
            if let category = RecodeModel.categories?[i] {
                let pageVC = createPageViewController(of: category)
                pageVC.pageIndex = i
                pageVC.setPageIndexToShownPageManager = {[unowned self,unowned pageVC] in self.IndexOfCurrentShownPageViewController = pageVC.pageIndex}
                //PageViewControllerからShownPageManagerへの参照を回避することを目的としてこのような表現になっているが、もしかしたらうまく動かないかもしれない
                
                controllers.append(pageVC)
            }
        }
        
        return controllers
    }
    
    func getArrayOfCategoryStrings(with numberOfCategories: Int) -> [String] {
        var namesOfCategories: [String] = []

        for i in 0 ..< numberOfCategories {
            if let category = RecodeModel.categories?[i].name {
                namesOfCategories.append(category)
            }
        }
        
        return namesOfCategories
    }
    
    
}
