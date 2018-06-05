//
//  SessionDateCC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 19/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

class TargetNameCC: UICollectionViewCell {
    @IBOutlet weak var labelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
    }
    
    func setupCell(value: String, alignment: NSTextAlignment) {
        self.labelValue.text = value
        self.labelValue.textAlignment = alignment
        self.backgroundColor = UIColor.clear
        self.labelValue.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    func setupCell(value: String, alignment: NSTextAlignment, backgroundColor: UIColor, font: UIFont) {
        self.labelValue.text = value
        self.labelValue.textAlignment = alignment
        
        self.backgroundColor = backgroundColor
        self.labelValue.font = font
    }
}
