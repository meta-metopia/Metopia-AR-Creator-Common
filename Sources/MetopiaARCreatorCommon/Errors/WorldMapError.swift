//
//  File.swift
//
//
//  Created by Qiwei Li on 11/23/22.
//

import Foundation

public struct WorldMapError: LocalizedError {

  public var title: String?
  public var code: Int
  public var errorDescription: String? { return _description }
  public var failureReason: String? { return _description }

  private var _description: String

  init(title: String?, description: String, code: Int) {
    self.title = title ?? "Error"
    self._description = description
    self.code = code
  }
}
