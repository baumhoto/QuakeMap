//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 13.07.21.
//

import XCTest
import Euclid


@testable import QuakeMap

class StartMapTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMapLoaderNotNil() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "start")
        XCTAssertNotNil(mapLoader)
    }
    
    func testMapLoaderParseMap1() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "start")
        XCTAssertEqual(mapLoader!.lines?.count, 13714)
    }
    
    func testMapLoaderParseMap1EntitiesCount() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "start")
        let map = mapLoader?.parseMap()
        XCTAssertEqual(map?.entities.count, 385)
    }
    
    
}
