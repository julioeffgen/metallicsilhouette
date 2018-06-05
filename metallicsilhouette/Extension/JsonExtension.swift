//
//  JsonExtension.swift
//  gape
//
//  Created by Julio Effgen on 29/04/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//
import SwiftyJSON

extension JSON {
    func hasRequestError(response: AnyObject) -> String {
        let json = JSON(response)
        var retorno = "";
        if json["errors"].exists() {
            var lineBreak = false
            for item in json["errors"].array! {
                if lineBreak {
                    retorno.append("\n")
                }
                retorno.append(item["Message"].stringValue)
                lineBreak = true
            }
            return retorno;
        }
        return "Desculpe, ocorreu um erro desconhecido. Se o problema persistir, entre em contato com o administrador do sistema."
    }
}
