//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import struct Euclid.Vertex
import Foundation

public class Brush {
    public var planes: [Plane]
    public var vertices: [Vertex]
    public var lineLoopIndices: [Int]
    public var indices: [Int]
    public var polygons: [Polygon]
    
    static let defaultPlaneCombinations: [[Int]] = Helper.combinations(count: 6, size: 3)
    static let tolerance = 0.01
    
    internal init() {
        self.planes =  []
        self.vertices = []
        self.indices = []
        self.polygons = []
        self.lineLoopIndices = []
    }
    
    public init(_ planes: [Plane]) throws {
        self.planes = planes
        self.vertices = []
        self.indices = []
        self.polygons = []
        self.lineLoopIndices = []
        
        try calculatePlaneIntersections()
        
        buildPolygons()
    }
    
    internal func calculatePlaneIntersections() throws {
        
        for combo in Brush.defaultPlaneCombinations {
            let planeCombination = planes.enumerated().filter( { combo.contains($0.offset) }).map({ $0.element })
            
            let intersection = try Plane.intersect(planeCombination)
            
            if intersection.isNaN {
                continue
            }
            
            var isIntersectionValid = false
            
            for plane in planes {
                isIntersectionValid = plane.isIntersectionValid(intersectionPoint: intersection)
                if isIntersectionValid {
                    break
                }
            }
            
            if !isIntersectionValid {
                continue
            }
            
            for i in 0..<3 {
                let plane = planes[combo[i]]
                
                var sideContainsVertex = false
                
                for sideVertex in plane.vertices {
                    if Helper.approximatelyEquivalent(intersection, sideVertex.position, Brush.tolerance) {
                        sideContainsVertex = true
                        break
                    }
                }
                
                if !sideContainsVertex {
                    plane.vertices.append(Vertex(position: intersection))
                }
            }
        }
    }
    
    internal func buildPolygons() {
        for plane in planes {
            if plane.vertices.count < 3 {
                continue
            }
            
            var polygon = Polygon(plane.normal)
            
            plane.vertices = Helper.sortVertices(vertices: plane.vertices, normal: plane.normal, winding: Winding.CounterClockwise)
            
            let offset = self.vertices.count
            
            for i in 0..<plane.vertices.count {
                var v = plane.vertices[i]
                v.normal = plane.normal
                polygon.lineLoopIndices.append(offset + i)
                vertices.append(v)
            }
            
            self.lineLoopIndices.append(contentsOf: polygon.lineLoopIndices)
            
            for i in 0..<polygon.lineLoopIndices.count - 2 {
                let indexA = 0
                let indexB = i + 1
                let indexC = i + 2
                
                polygon.indices.append(offset + indexA)
                polygon.indices.append(offset + indexB)
                polygon.indices.append(offset + indexC)
            }
           
            self.indices.append(contentsOf: polygon.indices)
            self.polygons.append(polygon)
        }
    }
}
