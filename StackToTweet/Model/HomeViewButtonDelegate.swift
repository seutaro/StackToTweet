//
//  AddTaskItem.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/20.
//

import Foundation

protocol HomeViewButtonDelegate {
    func addNewTaskItem(item: String)
    func deleteTaskItem()
}
