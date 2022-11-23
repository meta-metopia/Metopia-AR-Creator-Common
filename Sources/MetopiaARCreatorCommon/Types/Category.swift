//
//  Category.swift
//  metopia
//
//  Created by Qiwei Li on 8/16/22.
//

import Foundation

protocol CategoryProtocol: Codable, Equatable {
  var name: String { get set }
}

public struct Category: CategoryProtocol, Identifiable {
  public let id: Int
  public var name: String
  public let model: [Model]

  public init(id: Int, name: String, model: [Model]) {
    self.id = id
    self.name = name
    self.model = model
  }
}

public struct CategoryUpdateDto: CategoryProtocol {
  public var id: Int
  public var name: String

  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

public struct CategoryCreateDto: CategoryProtocol {
  public var name: String
  public var wid: Int
  public var uid: UUID

  public init(name: String, wid: Int, uid: UUID) {
    self.name = name
    self.wid = wid
    self.uid = uid
  }
}
