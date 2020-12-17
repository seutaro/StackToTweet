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
    
    func addNewTask(of item:String) {
        guard let category = currentDisplayCategory else {
            print("カテゴリを追加してください")  //delegateでtaskviewcontrollerにアラートを出させても良い
            return
        }
        
        do {
            try realm.write {
                let newItem = Item()
                newItem.title = item
                category.items.append(newItem)
            }
        } catch {
            print("タスクの追加に失敗しました")
        }
        doCurrentTableviewReloadData!()
    }
    
    func deleteTask() {
        guard let category = currentDisplayCategory else {
            print("カテゴリがありません")
            return
        }
        
        do {
            try realm.write {
                let Items = category.items.filter("done == true")
                self.realm.delete(Items)
            }
        } catch {
            print("タスクの削除に失敗しました")
        }
        doCurrentTableviewReloadData!()
    }
    
    func addCategory(with name:String) {
        do {
            try realm.write {
                let newCategory = Category()
                newCategory.name = name
                realm.add(newCategory)
            }
        } catch {
            //アラートで表示するか
            print("カテゴリの追加に失敗しました")
        }
    }
    
    func deleteCategory(for indexPath: IndexPath) {
        do {
            try realm.write() {
                let deletingCategory = categories![indexPath.row]
                let ItemInDeleteCategory = deletingCategory.items
                realm.delete(ItemInDeleteCategory)
                realm.delete(deletingCategory)
            }
        } catch {
            print("カテゴリの削除に失敗しました")
        }
    }
    
}

//MARK: - ScreenRecodeModelDelegate

//extension ScreenRecodeModel: ScreenRecodeModelDelegate {
//    func addNewTaskTest() {
//    }
//    
//    
//    func addNewTask(of item: String) {
//        guard let category = currentDisplayCategory else {
//            //アラートで”カテゴリを追加してください”
//            print("カテゴリを追加してください")
//            return
//        }
//        print(item)
//        do {
//            try self.realm.write {
//                let newItem = Item()
//                newItem.title = item
//                category.items.append(newItem)
//            }
//        } catch {
//            print("タスクの追加に失敗しました")
//        }
//    }
//
//    func deleteTaskItem() {
//    }
//
//
//}
