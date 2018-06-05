//
//  TargetTC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 19/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

protocol TargetTCDelegate : class {
    func didChangeValue(sender: TargetTC)
}


class TargetTC: UITableViewCell {
    @IBOutlet weak var targetTitle: UILabel!
    @IBOutlet weak var targetScore: UILabel!
    @IBOutlet weak var tartgetOne: UISwitch!
    @IBOutlet weak var targetTwo: UISwitch!
    @IBOutlet weak var targetThree: UISwitch!
    @IBOutlet weak var targetFour: UISwitch!
    @IBOutlet weak var targetFive: UISwitch!
    
    weak var delegate: TargetTCDelegate?
    
    var total = 0

    func setupCell(target: TargetMO, delegate: TargetTCDelegate) {
        self.delegate = delegate
        self.total = Int(target.totalDropped)
        self.targetTitle.text = target.type
        self.tartgetOne.isOn = target.shotOneDropped
        self.targetTwo.isOn = target.shotTwoDropped
        self.targetThree.isOn = target.shotThreeDropped
        self.targetFour.isOn = target.shotFourDropped
        self.targetFive.isOn = target.shotFiveDropped
        self.targetScore.text = "\(total) pontos"
    }
    
    @IBAction func changeTargetPoint(_ sender: Any) {
        if (sender as! UISwitch).isOn {
            self.total = self.total + 1
        } else {
            self.total = self.total - 1
        }
        self.targetScore.text = "\(total) pontos"
        self.delegate?.didChangeValue(sender: self)
    }
    
}
