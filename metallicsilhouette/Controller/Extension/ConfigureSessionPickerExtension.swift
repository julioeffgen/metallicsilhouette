//
//  ConfigureSessionExtension.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 19/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

extension ConfigureSessionTVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickUp(_ textField : UITextField){
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        textField.inputAccessoryView = self.toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.cellPicker?.fieldValue.text = self.pickerData[row]
        self.sessionModel?.type = self.pickerData[row]
    }
}
