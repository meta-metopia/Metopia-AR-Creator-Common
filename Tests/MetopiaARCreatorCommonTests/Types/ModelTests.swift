//
//  ModelTests.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import XCTest
@testable import MetopiaARCreatorCommon

final class ModelTests: XCTestCase {
    func testDownloadPath() throws {
        let model = Model(id: 0, name: "a", uid: UUID(), cid: 1, thumbnail: "abc.png", model: "b.usdz", version: 1, objectType: .link)
        let url = model.downloadDestination!
        XCTAssertEqual(url.lastPathComponent, "0_version_1.usdz")
    }
    
    func testRemotePath() throws {
        let model = Model(id: 0, name: "a", uid: UUID(), cid: 1, thumbnail: "abc.png", model: "b.usdz", version: 1, objectType: .link)
        let url = model.downloadSource(baseURL: URL(string: "https://s3.endpoint.com")!)!
        XCTAssertEqual(url.absoluteString, "https://s3.endpoint.com/b.usdz")
    }
}
