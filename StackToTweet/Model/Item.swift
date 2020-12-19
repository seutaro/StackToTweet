//
//  Item.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/15.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var tweet: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
