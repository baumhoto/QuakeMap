//
//  Map2Tests.swift
//  QuakeMapLoaderTests
//
//  Created by Tobias Baumhöver on 11.07.21.
//

import XCTest
import Euclid

@testable import QuakeMap

class Map2Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMapLoaderParseMap2() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "map2")
        XCTAssertEqual(mapLoader!.lines?.count, 145)
    }
    
    func testMapLoaderParseMap2EntitiesCount() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "map2")
        let map = mapLoader?.parseMap()
        XCTAssertEqual(map?.entities.count, 4)
    }
    
    func testMapLoaderParseMap2WorldspawnBrushesCount() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "map2")
        let map = mapLoader?.parseMap()
        XCTAssertEqual(map?.entities.first?.brushes.count , 13)
    }
    
    func testMapLoaderParseMap2CheckBrush5() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "map2")
        let map = mapLoader?.parseMap()
        let brush = map?.entities.first?.brushes[10]
        XCTAssertEqual(brush?.planes.count, 6)
        let planes = brush?.planes;
        
        XCTAssertEqual(planes![0].vectors.count, 3)
        XCTAssertEqual(planes![0].vectors[0], Vector(-288, -192, -96))
        XCTAssertEqual(planes![0].vectors[1], Vector(-288, -160, -96))
        XCTAssertEqual(planes![0].vectors[2], Vector(-288, -192, 256))
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
