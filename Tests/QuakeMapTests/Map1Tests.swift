//
//  QuakeMapLoaderTests.swift
//  QuakeMapLoaderTests
//
//  Created by Tobias Baumhöver on 10.07.21.
//

import XCTest
import Euclid


@testable import QuakeMap

class QuakeMapLoaderTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMapLoaderNotNil() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "map1")
        XCTAssertNotNil(mapLoader)
    }
    
    func testMapLoaderParseMap1() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "map1")
        XCTAssertEqual(mapLoader!.lines?.count, 17)
    }
    
    func testMapLoaderParseMap1EntitiesCount() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "map1")
        let map = mapLoader?.parseMap()
        XCTAssertEqual(map?.entities.count, 1)
    }

    func testMapLoaderParseMap1CheckBrush() throws {
        let mapLoader = TestHelper.Instance().getMapLoaderforMapfile(fileName: "map1")
        let map = mapLoader?.parseMap()
        XCTAssertEqual(map?.entities.first?.brushes.count, 1)
        XCTAssertEqual(map?.entities.first?.brushes.first?.planes.count, 6)
        let planes = map?.entities.first?.brushes.first?.planes;
        
        XCTAssertEqual(planes![0].vectors.count, 3)
        XCTAssertEqual(planes![0].vectors[0], Vector(256, 64, 16))
        XCTAssertEqual(planes![0].vectors[1], Vector(256, 64, 0))
        XCTAssertEqual(planes![0].vectors[2], Vector(256, 0, 16))
        
        XCTAssertEqual(planes![1].vectors.count, 3)
        XCTAssertEqual(planes![1].vectors[0], Vector(0, 0, 0))
        XCTAssertEqual(planes![1].vectors[1], Vector(0, 64, 0))
        XCTAssertEqual(planes![1].vectors[2], Vector(0, 0, 16))
        
        XCTAssertEqual(planes![2].vectors.count, 3)
        XCTAssertEqual(planes![2].vectors[0], Vector(64, 256, 16))
        XCTAssertEqual(planes![2].vectors[1], Vector(0, 256, 16))
        XCTAssertEqual(planes![2].vectors[2], Vector(64, 256, 0))
        
        XCTAssertEqual(planes![3].vectors.count, 3)
        XCTAssertEqual(planes![3].vectors[0], Vector(0, 0, 0))
        XCTAssertEqual(planes![3].vectors[1], Vector(0, 0, 16))
        XCTAssertEqual(planes![3].vectors[2], Vector(64, 0, 0))
        
        XCTAssertEqual(planes![4].vectors.count, 3)
        XCTAssertEqual(planes![4].vectors[0], Vector(64, 64, 0))
        XCTAssertEqual(planes![4].vectors[1], Vector(64, 0, 0))
        XCTAssertEqual(planes![4].vectors[2], Vector(0, 64, 0))
        
        XCTAssertEqual(planes![5].vectors.count, 3)
        XCTAssertEqual(planes![5].vectors[0], Vector(0, 0, -64))
        XCTAssertEqual(planes![5].vectors[1], Vector(64, 0, -64))
        XCTAssertEqual(planes![5].vectors[2], Vector(0, 64, -64))
    }

    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    

}
