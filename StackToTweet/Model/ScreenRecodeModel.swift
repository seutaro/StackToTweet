//
//  ScreenRecodeModel.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/12/08.
//

import Foundation
import RealmSwift

class ScreenRecodeModel {
    var categories: Results<Category>?
    var currentDisplayCategory: Category?
    var complihension: (() -> Void)?
    var PagingVCs: [UIViewController] = []
    var CategoriesString: [String] = []
    
    func getPagingVCs() -> [UIViewController] {
        return PagingVCs
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
        categoryVC.setCurrentDisplayCategory = {category in self.currentDisplayCategory = category}
        
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
    
    func setScreenCategory(with category:Category) -> Void {
        currentDisplayCategory = category
    }
}
