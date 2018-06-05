//
//  TargetSilhouetteTC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 23/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

protocol TargetSilhouetteTCDelegate : class {
    func didChangeValue(sender: TargetSilhouetteTC)
    func didStartCountTime(sender: TargetSilhouetteTC)
}

class TargetSilhouetteTC: UITableViewCell {
//    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var one: UIImageView!
    @IBOutlet weak var two: UIImageView!
    @IBOutlet weak var three: UIImageView!
    @IBOutlet weak var four: UIImageView!
    @IBOutlet weak var five: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var clock: UIImageView!
    
    var oneDropped: Bool!
    var twoDropped: Bool!
    var threeDropped: Bool!
    var fourDropped: Bool!
    var fiveDropped: Bool!
    var imageName: String!
    var imageDroppedName: String!
    
    weak var delegate: TargetSilhouetteTCDelegate?
    
    var total = 0
    
    func setupCell(target: TargetMO, imageName: String, imageDroppedName: String, delegate: TargetSilhouetteTCDelegate) {
        self.delegate = delegate
        self.imageName = imageName
        self.imageDroppedName = imageDroppedName
        self.total = Int(target.totalDropped)
        self.oneDropped = target.shotOneDropped
        self.twoDropped = target.shotTwoDropped
        self.threeDropped = target.shotThreeDropped
        self.fourDropped = target.shotFourDropped
        self.fiveDropped = target.shotFiveDropped
        if target.time == nil {
            self.time.text = "00:00"
        } else {
            self.time.text = target.time
        }
//        self.score.text = "\(total)"
        self.configureImage(imageView: self.one, tag: 1, dropped: self.oneDropped)
        self.one.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(targetTapped(recognizer:))))
        self.configureImage(imageView: self.two, tag: 2, dropped: self.twoDropped)
        self.two.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(targetTapped(recognizer:))))
        self.configureImage(imageView: self.three, tag: 3, dropped: self.threeDropped)
        self.three.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(targetTapped(recognizer:))))
        self.configureImage(imageView: self.four, tag: 4, dropped: self.fourDropped)
        self.four.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(targetTapped(recognizer:))))
        self.configureImage(imageView: self.five, tag: 5, dropped: self.fiveDropped)
        self.five.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(targetTapped(recognizer:))))
        self.clock.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countTime(recognizer:))))
    }
    
    func configureImage(imageView: UIImageView, tag: Int, dropped: Bool) {
        imageView.tag = tag
        imageView.isUserInteractionEnabled = true
        if dropped {
            UIView.transition(with: imageView,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { imageView.image = UIImage(named: self.imageDroppedName) },
                              completion: nil)
        } else {
            UIView.transition(with: imageView,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { imageView.image = UIImage(named: self.imageName) },
                              completion: nil)
        }
    }
    
    func updateTotal(dropped: Bool) {
        if dropped {
            self.total = self.total + 1
        } else {
            self.total = self.total - 1
        }
//        self.score.text = "\(total)"
        self.delegate?.didChangeValue(sender: self)
    }
    
    @objc func targetTapped(recognizer: UITapGestureRecognizer) {
        let sender = recognizer.view as! UIImageView
        switch sender.tag {
        case 1:
            self.oneDropped = !self.oneDropped
            self.configureImage(imageView: self.one, tag: 1, dropped: self.oneDropped)
            self.updateTotal(dropped: self.oneDropped)
        case 2:
            self.twoDropped = !self.twoDropped
            self.configureImage(imageView: self.two, tag: 2, dropped: self.twoDropped)
            self.updateTotal(dropped: self.twoDropped)
        case 3:
            self.threeDropped = !self.threeDropped
            self.configureImage(imageView: self.three, tag: 3, dropped: self.threeDropped)
            self.updateTotal(dropped: self.threeDropped)
        case 4:
            self.fourDropped = !self.fourDropped
            self.configureImage(imageView: self.four, tag: 4, dropped: self.fourDropped)
            self.updateTotal(dropped: self.fourDropped)
        default:
            self.fiveDropped = !self.fiveDropped
            self.configureImage(imageView: self.five, tag: 5, dropped: self.fiveDropped)
            self.updateTotal(dropped: self.fiveDropped)
        }
        
    }
    
    @objc func countTime(recognizer: UITapGestureRecognizer) {
        self.delegate?.didStartCountTime(sender: self)
    }
}
