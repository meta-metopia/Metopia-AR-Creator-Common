//
//  WorldMapTests.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import XCTest
@testable import MetopiaARCreatorCommon


final class WorldMapTests: XCTestCase {
    func testDownloadPath() throws {
        let worldMap = WorldMap(id:1, uid: UUID(), name: "test", version: 1, preferCloudAnchor: false)
        let downloadPath = worldMap.downloadDestination(type: ModelDownloadType.model)
        XCTAssertEqual(downloadPath!.lastPathComponent, "1_version_1.worldmap")
    }
    
    func testUploadPath() throws {
        let worldMap = WorldMap(id:1, uid: UUID(), name: "test", version: 1, preferCloudAnchor: false)
        let path = worldMap.uploadDestination(type: ModelUploadType.model)
        XCTAssertEqual(path!.lastPathComponent, "1.worldmap")
    }
    
    func testRemotePath() throws {
        let worldMap = WorldMap(id:1, uid: UUID(), name: "test", file: "a/b.worldmap", version: 1, preferCloudAnchor: false)
        let remotePath = worldMap.downloadSource(type: ModelDownloadType.model)!
        XCTAssertEqual(remotePath.absoluteString, "a/b.worldmap")
    }
}
