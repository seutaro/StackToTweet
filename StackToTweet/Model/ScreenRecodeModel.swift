//
//  ScreenRecodeModel.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/12/08.
//

import Foundation
import RealmSwift

class ScreenRecodeModel {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var currentDisplayCategory: Category?               //現在描画されているtableview内に表示されているカテゴリ
    
    var doCurrentTableviewReloadData: (() -> Void)?     //現在表示されているtableviewのtableview.reloadDataを保持する
    var PagingVCs: [UIViewController] = []              //カテゴリごとのtableViewをスタックする
    var CategoriesString: [String] = []                 //各カテゴリ名をStringとしてスタック
    
    
    
    func updateModel() {
        let numberOfCategories = getNumberOfCategories()
        CategoriesString = getArrayOfCategoryStrings(with: numberOfCategories)
        PagingVCs = getArrayOfViewControllers(with: numberOfCategories)
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
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
        categoryVC.setCurrentDisplayCategory = {category in self.currentDisplayCategory = category} //”ScreenRecodeModel.currentDisplayCategoryにcategoryVCのcategoryを代入する処理”をcategoryVCのプロパティに代入
        categoryVC.passFuncOfCurrentTableViewReloadData = {self.doCurrentTableviewReloadData = categoryVC.tableViewReloadData} //categoryVCのプロパティに"categoryVCのtableView.reloadDataをScreenRecodeModelのプロパティに代入する処理"を代入する
        
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
