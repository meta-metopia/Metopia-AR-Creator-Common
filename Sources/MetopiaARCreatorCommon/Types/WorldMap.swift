//
//  File.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public protocol WorldMapProtocol: Codable, VersionProtocol, Equatable {
    var uid: UUID { get set }
    var name: String { get set }
    var file: String? { get set }
    var latitude: Double? { get set }
    var longitude: Double? { get set }
    var cloudAnchors: [CloudARAnchor]? { get set }
    var usedModels: [Int]? { get set }
    var preferCloudAnchor: Bool { get set }
}

public struct WorldMapCreateDto: WorldMapProtocol {
    public var uid: UUID

    public var name: String

    public var file: String?

    public var latitude: Double?

    public var longitude: Double?

    public var cloudAnchors: [CloudARAnchor]?

    public var usedModels: [Int]?

    public var preferCloudAnchor: Bool

    public var version: Int

    public init(uid: UUID, name: String, file: String? = nil, latitude: Double? = nil, longitude: Double? = nil, cloudAnchors: [CloudARAnchor]? = nil, usedModels: [Int]? = nil, preferCloudAnchor: Bool, version: Int) {
        self.uid = uid
        self.name = name
        self.file = file
        self.latitude = latitude
        self.longitude = longitude
        self.cloudAnchors = cloudAnchors
        self.usedModels = usedModels
        self.preferCloudAnchor = preferCloudAnchor
        self.version = version
    }
}

public struct WorldMap: Identifiable, WorldMapProtocol, DownloadableProtocol {
    public func downloadSource(type: DownloadTypeProtocol) -> URL? {
        guard let filename = file else {
            return nil
        }
        return URL(string: filename)
    }
    
    /**
     Map directory
     */
    private var mapDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var dir = paths[0]
        dir.appendPathComponent("maps")
        return dir
    }

    public static func == (lhs: WorldMap, rhs: WorldMap) -> Bool {
        lhs.id == rhs.id
    }

    public var id: Int
    public var uid: UUID
    public var name: String
    public var file: String?
    public var latitude: Double?
    public var longitude: Double?
    public var version: Int
    public var cloudAnchors: [CloudARAnchor]?
    /**
     List of models' id used in the worldMap
     */
    public var usedModels: [Int]?
    public var preferCloudAnchor: Bool

    public init(id: Int, uid: UUID, name: String, file: String? = nil, latitude: Double? = nil, longitude: Double? = nil, version: Int, cloudAnchors: [CloudARAnchor]? = nil, usedModels: [Int]? = nil, preferCloudAnchor: Bool) {
        self.id = id
        self.uid = uid
        self.name = name
        self.file = file
        self.latitude = latitude
        self.longitude = longitude
        self.version = version
        self.cloudAnchors = cloudAnchors
        self.usedModels = usedModels
        self.preferCloudAnchor = preferCloudAnchor
    }
    
    public func downloadDestination(type: DownloadTypeProtocol) -> URL? {
        var modelDir = mapDirectory
        modelDir.appendPathComponent("\(id)_version_\(version).worldmap")
        return modelDir
    }
}
