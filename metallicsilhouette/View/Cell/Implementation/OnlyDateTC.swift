//
//  OnlyDateTC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 17/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

protocol OnlyDateTCDelegate : class {
    func didOpenDatePicker(sender: OnlyDateTC)
}

class OnlyDateTC: UITableViewCell {
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var fieldValue: UITextField!
    @IBOutlet weak var fieldValueWidth: NSLayoutConstraint!
    
    weak var delegate: OnlyDateTCDelegate?
    
    func setupCell(fieldTitle: String, dateValue: String, datePicker: UIDatePicker, delegate: OnlyDateTCDelegate, toolBar: UIToolbar) {
        self.delegate = delegate
        self.fieldLabel.text = fieldTitle
        self.fieldValue.text = dateValue
        self.fieldValue.inputView = datePicker
        self.fieldValue.inputAccessoryView = toolBar
    }
    
    @IBAction func startEditingFieldValue(_ sender: Any) {
        self.delegate?.didOpenDatePicker(sender: self)
    }
}
