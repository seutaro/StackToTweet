//
//  AddTaskItem.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/20.
//

import Foundation

protocol TaskViewButtonDelegate {
    func addNewTaskItem(item: String)
    func deleteTaskItem()
}
