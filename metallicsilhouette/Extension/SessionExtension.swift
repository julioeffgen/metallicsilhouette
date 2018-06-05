//
//  SessionExtension.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 19/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import Foundation
import CoreData

extension SessionMO {
    func entityTODictionaty(model: NSManagedObject) -> Dictionary<String, Any> {
        let modelKeys = Array(model.entity.attributesByName.keys)
        let modelDict = model.dictionaryWithValues(forKeys: modelKeys)
        return modelDict
    }
}
