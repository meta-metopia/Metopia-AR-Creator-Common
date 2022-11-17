//
//  Model.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//
import Foundation

/**
 Action type defines the action that the ar model can operate.
 */
public enum ARObjectType: String, Codable, CaseIterable, Identifiable {
    public var id: Self { self }
    
    /**
     Model will show a  list of ``ARMenu``
     */
    case menus
    /**
     Model will open a in-app-browser
     */
    case link
    /**
     Model will show an alert
     */
    case text
    /**
     No action applied
     */
    case none
}

protocol ModelProtocol: Codable {
    var name: String { get set }
    var objectType: ARObjectType { get set }
    var menus: [ARMenu]? { get set }
    var content: String? { get set }
}

public struct ModelCreateDto: ModelProtocol {
    public var name: String
    public var uid: UUID
    public var cid: Int
    public var thumbnail: String?
    public var model: String
    public var menus: [ARMenu]?
    public var content: String?
    public var objectType: ARObjectType
    
    public init(name: String, uid: UUID, cid: Int, thumbnail: String?, model: String, menus: [ARMenu]?, content: String?, objectType: ARObjectType) {
        self.name = name
        self.uid = uid
        self.cid = cid
        self.thumbnail = thumbnail
        self.model = model
        self.menus = menus
        self.content = content
        self.objectType = objectType
    }
}

public struct ModelUpdateDto: ModelProtocol {
    public var name: String
    
    public var thumbnail: String?
    
    public var model: String?
    
    public var objectType: ARObjectType
    
    public var menus: [ARMenu]?
    
    public var content: String?
    
    public init(name: String, thumbnail: String? = nil, model: String? = nil, objectType: ARObjectType, menus: [ARMenu]? = nil, content: String? = nil) {
        self.name = name
        self.thumbnail = thumbnail
        self.model = model
        self.objectType = objectType
        self.menus = menus
        self.content = content
    }
}

public struct Model: Equatable, Identifiable, ModelProtocol, VersionProtocol, DownloadableProtocol {
    public static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.name == rhs.name
    }
    
    public var id: Int
    public var name: String
    /**
     Owner id for the model
     */
    public var uid: UUID
    /**
     Category id for the model
     */
    public var cid: Int
    /**
     Thumbnail path
     */
    public var thumbnail: String
    /**
     Model path
     */
    public var model: String
    /**
     Version of the model
     */
    public var version: Int
    /**
     Model's action type
     */
    public var objectType: ARObjectType
    /**
     ARMenus if the ``actionType`` is set to ``ActionType.menus``
     */
    public var menus: [ARMenu]?
    
    /**
     Model's content if ``actionType`` is not set to ``actionType.none`` or ``ActionType.menus``
     */
    public var content: String?
    
    /**
     Create a model
     - parameter id: Model ID
     - parameter name: Model Name
     - parameter uid: User ID
     - parameter cid: Category ID
     - parameter thumbnail: Model's thumbnail
     - parameter model: Model Object's url
     - parameter version: Model Version
     - parameter actionType: Model onclick action type
     - parameter content: Model's content
     */
    public init(id: Int, name: String, uid: UUID, cid: Int, thumbnail: String, model: String, version: Int, objectType: ARObjectType, menus: [ARMenu]? = nil, content: String? = nil) {
        self.id = id
        self.name = name
        self.uid = uid
        self.cid = cid
        self.thumbnail = thumbnail
        self.model = model
        self.version = version
        self.objectType = objectType
        self.menus = menus
        self.content = content
    }
    
    /**
     Model directory
     */
    public var modelDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var dir = paths[0]
        dir.appendPathComponent("models")
        return dir
    }
    
    /**
     Local model path
     */
    public var downloadDestination: URL? {
        var modelDir = modelDirectory
        modelDir.appendPathComponent("\(id)_version_\(version).usdz")
        return modelDir
    }
    
    public func downloadSource(baseURL: URL) -> URL? {
        if #available(iOS 16.0, *) {
            return baseURL.appending(path: model)
        } else {
            return baseURL.appendingPathComponent(model)
        }
    }
}
