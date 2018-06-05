//
//  PickViewTC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 17/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

protocol PickViewTCDelegate : class {
    func didOpenPickView(sender: PickViewTC)
}


class PickViewTC: UITableViewCell {
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var fieldValue: UITextField!
    @IBOutlet weak var fieldValueWidth: NSLayoutConstraint!
    
    weak var delegate: PickViewTCDelegate?

    @IBAction func startEditing(_ sender: Any) {
        self.delegate?.didOpenPickView(sender: self)
    }
    
    func setupCell(fieldTitle: String, fieldValue: String, delegate: PickViewTCDelegate) {
        self.delegate = delegate
        self.fieldLabel.text = fieldTitle
        self.fieldValue.text = fieldValue
    }
}
