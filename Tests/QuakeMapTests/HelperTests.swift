//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import XCTest
import struct Euclid.Vertex
import struct Euclid.Vector

@testable import QuakeMap

class HelperTests : XCTestCase {
    
    var testVertices1 : [Vertex] = []
    
    override func setUpWithError() throws {
        testVertices1 = [Vertex(position: Vector(256, 256, 0)), Vertex(position: Vector(256, 256, -64)), Vertex(position: Vector(256, 0, 0)), Vertex(position: Vector(256, 0, -64))]
    }

    override func tearDownWithError() throws {
        testVertices1 = []
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCombinations() throws {
        let combinations = Helper.combinations(count: 6, size: 3, start: 0)
        
        XCTAssertEqual(combinations.count, 20)
        XCTAssertEqual(combinations[0].count, 3)
        XCTAssertEqual(combinations[0][0], 0)
        XCTAssertEqual(combinations[0][1], 1)
        XCTAssertEqual(combinations[0][2], 2)
        
        XCTAssertEqual(combinations[5].count, 3)
        XCTAssertEqual(combinations[5][0], 0)
        XCTAssertEqual(combinations[5][1], 2)
        XCTAssertEqual(combinations[5][2], 4)
        
        XCTAssertEqual(combinations[12].count, 3)
        XCTAssertEqual(combinations[12][0], 1)
        XCTAssertEqual(combinations[12][1], 2)
        XCTAssertEqual(combinations[12][2], 5)
        
        XCTAssertEqual(combinations[19].count, 3)
        XCTAssertEqual(combinations[19][0], 3)
        XCTAssertEqual(combinations[19][1], 4)
        XCTAssertEqual(combinations[19][2], 5)

    }
    
    func testPermutations() throws {
        let permutations = Helper.permutations(count: 4, size: 2)
        XCTAssertEqual(permutations.count, 12)
        XCTAssertEqual(permutations[0].count, 2)
        XCTAssertEqual(permutations[0][0], 0)
        XCTAssertEqual(permutations[0][1], 1)
        XCTAssertEqual(permutations[5].count, 2)
        XCTAssertEqual(permutations[5][0], 1)
        XCTAssertEqual(permutations[5][1], 3)
        XCTAssertEqual(permutations[11].count, 2)
        XCTAssertEqual(permutations[11][0], 3)
        XCTAssertEqual(permutations[11][1], 2)
    }
    
    func testSortVertices1() throws {

        let sortedVertices = Helper.sortVertices(vertices: testVertices1, normal: Vector(1, 0, 0), winding: .CounterClockwise)
        XCTAssertEqual(sortedVertices.count, 4)
        XCTAssertEqual(sortedVertices[0], testVertices1[0])
        XCTAssertEqual(sortedVertices[1], testVertices1[2])
        XCTAssertEqual(sortedVertices[2], testVertices1[3])
        XCTAssertEqual(sortedVertices[3], testVertices1[1])
    }
    
    func testGetClockwiseAngles() throws {
        let pairs = Helper.permutations(count: 4, size: 2)
        let angles = Helper.getClockwiseAngles(vertices: testVertices1, pairs: pairs, center: Vector(256, 128, -32), normal: Vector(1, 0, 0))
        XCTAssertEqual(angles.count, 8)
        XCTAssertEqual(angles[pairs[1]], 151.92751306414706)
        XCTAssertEqual(angles[pairs[2]], 180)
        XCTAssertEqual(angles[pairs[3]], 28.072486935852954)
        XCTAssertEqual(angles[pairs[4]], 180)
        XCTAssertEqual(angles[pairs[7]], 180)
        XCTAssertEqual(angles[pairs[8]], 28.072486935852954)
        XCTAssertEqual(angles[pairs[9]], 180)
        XCTAssertEqual(angles[pairs[10]], 151.92751306414706)
    }
}

