//
//  PlaneTests.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import XCTest
import struct Euclid.Vector


@testable import QuakeMap

class PlaneTests : XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPlaneConstructorClockwise() throws {
        let a = Vector(256, 64, 16)
        let b = Vector(256, 64, 0)
        let c = Vector(256, 0, 16)
        let plane = Plane(a, b, c, Winding.Clockwise)
        
        XCTAssertEqual(plane.points[0], a)
        XCTAssertEqual(plane.points[1], b)
        XCTAssertEqual(plane.points[2], c)
        XCTAssertEqual(plane.winding, Winding.Clockwise)
        XCTAssertEqual(plane.normal, Vector(1, 0, 0))
        XCTAssertEqual(plane.distanceFromOrigin, 256.0)
    }
    
    func testPlaneIntersectNegative() throws {
        let planeA = Plane(Vector(256, 64, 16), Vector(256, 64, 0), Vector(256, 0, 16), Winding.Clockwise)
        let planeB = Plane(Vector.zero, Vector(0, 64, 0), Vector(0, 0, 16), Winding.Clockwise)
        let planeC = Plane(Vector(64, 256, 16), Vector(0, 256, 16), Vector(64, 256, 0), Winding.Clockwise)
     
        let intersection = Plane.intersect(planeA, planeB, planeC)
        XCTAssertEqual(intersection.x.isNaN, true)
        XCTAssertEqual(intersection.y.isNaN, true)
        XCTAssertEqual(intersection.z.isNaN, true)
    }
    
    func testPlaneIntersectPositive() throws {
        let planeA = Plane(Vector(256, 64, 16), Vector(256, 64, 0), Vector(256, 0, 16), Winding.Clockwise)
        let planeB = Plane(Vector(64, 256, 16), Vector(0, 256, 16), Vector(64, 256, 0), Winding.Clockwise)
        let planeC = Plane(Vector(64, 64, 0), Vector(64, 0, 0), Vector(0, 64, 0), Winding.Clockwise)
     
        let intersection = Plane.intersect(planeA, planeB, planeC)
        XCTAssertEqual(intersection, Vector(256, 256, 0))
    }
}
