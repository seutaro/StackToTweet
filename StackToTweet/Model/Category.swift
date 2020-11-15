//
//  Category.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/15.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
