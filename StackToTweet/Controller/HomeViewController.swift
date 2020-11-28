//
//  HomeViewController.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/11/26.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    var homeViewButtonDelegate: HomeViewButtonDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - ボタンアクション
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "新しいタスクを追加", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            let item = textfield.text!
            self.homeViewButtonDelegate?.addNewTaskItem(item: item)
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "新しいタスクを追加する"
            textfield = alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.homeViewButtonDelegate?.deleteTaskItem()
    }
    
    

}
