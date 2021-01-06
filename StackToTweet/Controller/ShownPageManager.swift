//
//  ShownScreenManager.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2021/01/06.
//

import Foundation
import UIKit
import RealmSwift

class ShownPageManager {
    var RecodeModel: ScreenRecodeModel!
    
    var IndexOfCurrentShownPageViewController: Int?
    var pageVCs: [PageViewController] = []
    var CategoryString: [String] = []
    
    func tableViewReloadDataOnTheShownPage() {
        guard let Index = IndexOfCurrentShownPageViewController else {
            return
        }
        pageVCs[Index].tableView.reloadData()
    }
    
    func updatePageVCs() {
        let numberOfCategories = getNumberOfCategories()
        CategoryString = getArrayOfCategoryStrings(with: numberOfCategories)
        pageVCs = getArrayOfPageViewControllers(with: numberOfCategories)
    }
    
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
