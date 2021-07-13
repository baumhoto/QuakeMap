//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//
import XCTest
import struct Euclid.Vector
import struct Euclid.Vertex


@testable import QuakeMap


class BrushTests : XCTestCase {
    
    var testPlanes1 : [Plane] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let plane1 = Plane(Vector(256, 64, 16), Vector(256, 64, 0), Vector(256, 0, 16), Winding.Clockwise)
                let plane2 = Plane(Vector.zero, Vector(0, 64, 0), Vector(0, 0, 16), Winding.Clockwise)
                let plane3 = Plane(Vector(64, 256, 16), Vector(0, 256, 16), Vector(64, 256, 0), Winding.Clockwise)
                let plane4 = Plane(Vector.zero, Vector(0, 0, 16), Vector(64, 0, 0), Winding.Clockwise)
                let plane5 = Plane(Vector(64, 64, 0), Vector(64, 0, 0), Vector(0, 64, 0), Winding.Clockwise)
                let plane6 = Plane(Vector(0, 0, -64), Vector(64, 0, -64), Vector(0, 64, -64), Winding.Clockwise)
         
        testPlanes1 = [plane1, plane2, plane3, plane4, plane5, plane6 ]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBrushCalculateIntersections() throws {
        
        // calling normal constructer will execute buildPolygons which changes order of vertices in planes thus
        // create empty brush and only call calculatePlaneIntersections
        let brush = Brush()
        brush.planes = testPlanes1
        
        try brush.calculatePlaneIntersections()
        
        XCTAssertEqual(brush.planes[0].vertices.count, 4)
        XCTAssertEqual(brush.planes[0].vertices[0], Vertex(Vector(256, 256, 0), Vector(0, 0, 1)))
        XCTAssertEqual(brush.planes[0].vertices[1], Vertex(Vector(256, 256, -64), Vector(0, 0, 1)))
        XCTAssertEqual(brush.planes[0].vertices[2], Vertex(Vector(256, 0, 0), Vector(0, 0, 1)))
        XCTAssertEqual(brush.planes[0].vertices[3], Vertex(Vector(256, 0, -64), Vector(0, 0, 1)))

        XCTAssertEqual(brush.planes[2].vertices.count, 4)
        XCTAssertEqual(brush.planes[2].vertices[0], Vertex(position: Vector(256, 256, 0)))
        XCTAssertEqual(brush.planes[2].vertices[1], Vertex(position: Vector(256, 256, -64)))
        XCTAssertEqual(brush.planes[2].vertices[2], Vertex(position: Vector(0, 256, 0)))
        XCTAssertEqual(brush.planes[2].vertices[3], Vertex(position: Vector(0, 256, -64)))
        
        XCTAssertEqual(brush.planes[5].vertices.count, 4)
        XCTAssertEqual(brush.planes[5].vertices[0], Vertex(position: Vector(256, 256, -64)))
        XCTAssertEqual(brush.planes[5].vertices[1], Vertex(position: Vector(256, 0, -64)))
        XCTAssertEqual(brush.planes[5].vertices[2], Vertex(position: Vector(0, 256, -64)))
        XCTAssertEqual(brush.planes[5].vertices[3], Vertex(position: Vector(0, 0, -64)))
    }
    
    func testBrushBuildPolygons() throws {
        let brush = try Brush(testPlanes1)

        XCTAssertEqual(brush.vertices.count, 24)
        XCTAssertEqual(brush.vertices[0], Vertex(Vector(256, 256, 0), Vector(1, 0, 0)))
        XCTAssertEqual(brush.vertices[11], Vertex(Vector(0, 256, 0), Vector(0, 1, 0)))
        XCTAssertEqual(brush.vertices[14], Vertex(Vector(0, 0, -64), Vector(0, -1, 0)))
        XCTAssertEqual(brush.vertices[20], Vertex(Vector(256, 256, -64), Vector(0, 0, -1)))
        XCTAssertEqual(brush.vertices[23], Vertex(Vector(0, 256, -64), Vector(0, 0, -1)))

        XCTAssertEqual(brush.polygons.count, 6)
        XCTAssertEqual(brush.polygons[0].indices.count, 6)
        XCTAssertEqual(brush.polygons[0].lineLoopIndices.count, 4)
        XCTAssertEqual(brush.polygons[0].normal, Vector(1, 0, 0))
        XCTAssertEqual(brush.polygons[0].indices[0], 0)
        XCTAssertEqual(brush.polygons[0].indices[1], 1)
        XCTAssertEqual(brush.polygons[0].indices[2], 2)
        XCTAssertEqual(brush.polygons[0].indices[3], 0)
        XCTAssertEqual(brush.polygons[0].indices[4], 2)
        XCTAssertEqual(brush.polygons[0].indices[5], 3)
        XCTAssertEqual(brush.polygons[0].lineLoopIndices[0], 0)
        XCTAssertEqual(brush.polygons[0].lineLoopIndices[1], 1)
        XCTAssertEqual(brush.polygons[0].lineLoopIndices[2], 2)
        XCTAssertEqual(brush.polygons[0].lineLoopIndices[3], 3)
        
        XCTAssertEqual(brush.polygons[4].indices.count, 6)
        XCTAssertEqual(brush.polygons[4].lineLoopIndices.count, 4)
        XCTAssertEqual(brush.polygons[4].normal, Vector(0, 0, 1))
        XCTAssertEqual(brush.polygons[4].indices[0], 16)
        XCTAssertEqual(brush.polygons[4].indices[1], 17)
        XCTAssertEqual(brush.polygons[4].indices[2], 18)
        XCTAssertEqual(brush.polygons[4].indices[3], 16)
        XCTAssertEqual(brush.polygons[4].indices[4], 18)
        XCTAssertEqual(brush.polygons[4].indices[5], 19)
        XCTAssertEqual(brush.polygons[4].lineLoopIndices[0], 16)
        XCTAssertEqual(brush.polygons[4].lineLoopIndices[1], 17)
        XCTAssertEqual(brush.polygons[4].lineLoopIndices[2], 18)
        XCTAssertEqual(brush.polygons[4].lineLoopIndices[3], 19)

    }
    
}
