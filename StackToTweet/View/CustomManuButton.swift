//
//  CustomManuButton.swift
//  StackToTweet
//
//  Created by shotaro takahashi on 2020/12/27.
//

import Foundation
import UIKit

class CustomButton: UIView {
    
    var manuButton: UIButton!
    var addButton = UIButton()
    var deleteButton = UIButton()
    var tweetButton = UIButton()
    
    let openImage = UIImage(named: "manuButton")
    let closeImage = UIImage(named: "close")
    
    var manuPosition: CGPoint!
    
    private var manuIsTapped: Bool = false
    
    func getButtonPositon(angle: CGFloat, radius: CGFloat) -> CGPoint {
        
        let radian = angle * .pi / 180
        
        let positionX = manuButton.center.x + cos(radian) * radius
        let positionY = manuButton.center.y + sin(radian) * radius
        
        let position = CGPoint(x: positionX, y: positionY)
        
        return position
    }
    
    func setButtonStatus() {
        addButton.frame = CGRect(origin: manuPosition, size: CGSize(width: 100, height: 100))
        deleteButton.frame = CGRect(origin: manuPosition, size: CGSize(width: 100, height: 100))
        tweetButton.frame = CGRect(origin: manuPosition, size: CGSize(width: 100, height: 100))
        
        addButton.center = manuButton.center
        deleteButton.center = manuButton.center
        tweetButton.center = manuButton.center
        
        addButton.layer.cornerRadius = 50
        deleteButton.layer.cornerRadius = 50
        tweetButton.layer.cornerRadius = 50
        
        addButton.isHidden = false
        deleteButton.isHidden = false
        tweetButton.isHidden = false
        
        self.addSubview(addButton)
        self.addSubview(deleteButton)
        self.addSubview(tweetButton)
    }
    
    @objc func movementWhenManuButtonTapped() {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.manuButton.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.manuButton.transform = .identity
        }, completion: nil)
        
        if manuIsTapped == false {

            setButtonStatus()
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                
                self.addButton.layer.position = self.getButtonPositon(angle: -90, radius: 150)
                self.deleteButton.layer.position = self.getButtonPositon(angle: -180, radius: 150)
                self.tweetButton.layer.position = self.getButtonPositon(angle: -135, radius: 150)
                
            }, completion:{ [self]_ in
                manuIsTapped = !manuIsTapped
            })
            
            self.manuButton.setImage(closeImage, for: .normal)
            
        } else {
            
            self.manuButton.setImage(self.openImage, for: .normal)
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                
                self.addButton.layer.position = self.manuButton.center
                self.deleteButton.layer.position = self.manuButton.center
                self.tweetButton.layer.position = self.manuButton.center
                
            }, completion: {_ in
                
                self.manuIsTapped = !self.manuIsTapped
                self.addButton.isHidden = true
                self.deleteButton.isHidden = true
                self.tweetButton.isHidden = true

            })
        }
    }
    
}
