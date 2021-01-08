//
//  ScreenRecodeModel.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/12/08.
//

import Foundation
import RealmSwift

class DataManager {
    
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var categoriesString: [String] = []
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        categoriesString = getArrayOfCategoryStrings(with: categories?.count ?? 0)
        
    }
    
    func getNumberOfCategories() -> Int {
        
        guard let numberOfCategories = categories?.count else {
            return 0
        }
        return numberOfCategories
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
    
    //Itemを追加する関数
    func addNewTask(of item: String,in Category: String) {

        guard let category = categories?.filter("name == \"" + Category + "\"").first else {
            print("カテゴリを追加してください")
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
    }
    
    //Itemを削除する関数
    func deleteTask(in Category: String) {
        guard let category = categories?.filter("name == \"" + Category + "\"").first else {
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
    }
    
    //Categoryを追加する関数
    func addCategory(with name:String) {
        
        let result = categoriesString.filter({$0 == name})
        
        if result.count == 0 {
            do {
                try realm.write {
                    let newCategory = Category()
                    newCategory.name = name
                    realm.add(newCategory)
                }
            } catch {
                print("カテゴリの追加に失敗しました")
            }
        } else {
            print("カテゴリ名が重複しています")
        }
        
    }
    
    //Categoryを削除する関数
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
    
    
    //MARK: - tweet logic
    
    var CategoriesWtihTweetItems: [Category] = []      //tweet = trueであるItemを含むカテゴリの値をスタック
    
    func getDoneItemList(from category: Category) -> Results<Item> {
        let items = category.items.filter("done == true")
        return items
    }
    
    func getTweetableItemList(from category: Category) -> Results<Item> {
        let items = category.items.filter("tweet == true")
        return items
    }
    
    func getTweetCategories() -> [Category] {
        var tweetCategoryArray: [Category] = []
        if let Categories = categories {
            for category in Categories {
               let items = getDoneItemList(from: category)
                if items.count != 0 {
                    tweetCategoryArray.append(category)
                }
            }
        }
        return tweetCategoryArray
    }
    
    func updateCategoriesWithTweetItems() {
        CategoriesWtihTweetItems = getTweetCategories()
    }
    
    func createTweetItemText(of category: Category) -> String {
        let tweetableItems = getTweetableItemList(from: category)
        var tweet = ""
        
        for item in tweetableItems {
            tweet = tweet + "- \(item.title)\n"
        }
        return tweet
    }
    
    func createTweetCategoryText(with category: Category) -> String {
        
        var tweet = "【#\(category.name)】\n"
        let itemsText = createTweetItemText(of: category)
        
        if itemsText != "" {
            tweet = tweet + "\(itemsText)\n"
        } else {
            tweet = ""
        }
        
        return tweet
    }
    
    //ツイートするテキストを生成する関数
    func getTweetText() -> String {
        let tweetCategories = CategoriesWtihTweetItems
        
        var tweet = """
                    #今日の積み上げ\n
                    """
        
        for category in tweetCategories {
            let textByCategory = createTweetCategoryText(with: category)
            tweet = tweet + "\(textByCategory)"
        }
        return tweet
    }
    
}
