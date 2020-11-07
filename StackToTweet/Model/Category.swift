//
//  Category.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/08.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var items = List<Item>()
}
