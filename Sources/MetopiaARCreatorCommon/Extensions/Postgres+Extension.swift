//
//  File.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation
import PostgREST

enum TableName: String {
    case worldMap = "worldmap"
    case category = "category"
    case user = "metopia_user"
    case model = "model"
}


extension PostgrestClient {
    func from(table: TableName) -> PostgrestQueryBuilder {
        self.from(table.rawValue)
    }
}
