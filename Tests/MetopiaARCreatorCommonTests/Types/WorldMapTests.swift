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
        let downloadPath = worldMap.downloadDestination!
        XCTAssertEqual(downloadPath.lastPathComponent, "1_version_1.worldmap")
    }
    
    func testRemotePath() throws {
        let worldMap = WorldMap(id:1, uid: UUID(), name: "test", filename: "a/b.worldmap", version: 1, preferCloudAnchor: false)
        let remotePath = worldMap.downloadSource(baseURL: URL(string:  "https://s3.endpoint.com")!)!
        XCTAssertEqual(remotePath.absoluteString, "https://s3.endpoint.com/a/b.worldmap")
    }
}
