//
//  DisplayScreenRecoding.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/12/05.
//

import Foundation
import RealmSwift



struct DisplayScreenRecoding {
    let realm = try! Realm()
    weak var currentDisplayCategory: Category?
    
    func addNewTaskItem(with itemString:String) {
        if let DisplayedCategory = currentDisplayCategory {
            do {
                try realm.write {
                    let newItem = Item()
                    newItem.title = itemString
                    DisplayedCategory.items.append(newItem)
                }
            } catch {
                print("新しいタスクの追加に失敗しました")
            }
            //ここにtableviewをリロードする関数？
        }
    }
}
