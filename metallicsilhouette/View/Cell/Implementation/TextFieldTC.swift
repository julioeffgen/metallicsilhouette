//
//  TextFieldTC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 17/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

protocol TextFieldTCDelegate : class {
    func didEndEditing(sender: TextFieldTC)
}

class TextFieldTC: UITableViewCell {
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var fieldValue: UITextField!
    @IBOutlet weak var fieldValueWidth: NSLayoutConstraint!
    
    weak var delegate: TextFieldTCDelegate?
    
    func setupCell(fieldTitle: String, fieldValue: String, delegate: TextFieldTCDelegate) {
        self.delegate = delegate
        self.fieldLabel.text = fieldTitle
        self.fieldValue.text = fieldValue
    }

    @IBAction func fieldEdited(_ sender: Any) {
        self.delegate?.didEndEditing(sender: self)
    }
}
