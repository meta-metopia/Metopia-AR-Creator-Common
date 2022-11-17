//
//  File.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public struct CloudARAnchor: Codable, Identifiable, Hashable {
    public var id: UUID
    public var hostId: String?
    public var modelName: String
    public var hasError = false
    public var time = Date()

    public var hasUploaded: Bool {
        hostId != nil || hasError
    }

    public init(id: UUID, hostId: String?, modelName: String, hasError: Bool, time: Date) {
        self.id = id
        self.hostId = hostId
        self.modelName = modelName
        self.hasError = hasError
        self.time = time
    }
}
