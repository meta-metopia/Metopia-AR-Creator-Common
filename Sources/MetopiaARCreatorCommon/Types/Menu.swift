//
//  Menu.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public enum ARMenuType: String, CaseIterable, Codable {
  case link, web, text
}

public struct ARMenu: Codable, Identifiable {
  public var id: Int
  public var type: ARMenuType
  public var title: String
  public var cover: String

  public init(id: Int, type: ARMenuType, title: String, cover: String) {
    self.id = id
    self.type = type
    self.title = title
    self.cover = cover
  }
}
