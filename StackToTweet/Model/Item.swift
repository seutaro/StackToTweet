//
//  Item.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/08.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
