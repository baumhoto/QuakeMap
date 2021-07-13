//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import Euclid
import Foundation

// use euclid plane??
public class Plane {
    //let polygon: Polygon?
    public let points: [Vector]
    public let winding: Winding
    public let normal: Vector
    public let distanceFromOrigin: Double
    
    public var vertices: [Vertex]
    
    public static let intersectionTolerance: Double = 0.01
    
    convenience init(_ points: [Vector], _ winding: Winding) {
        self.init(points[0], points[1], points[2], winding)
    }
    
    public init(_ a: Vector, _ b: Vector, _ c: Vector, _ winding: Winding) {
        self.winding = winding
        self.points = [a, b, c]
        
        self.vertices = []
       
        var vectorA = points[2] - points[0]
        var vectorB = points[1] - points[0]
        
        if self.winding == Winding.CounterClockwise {
            let vectorC = vectorA
            vectorA = vectorB
            vectorB = vectorC
        }
        
        normal = vectorA.cross(vectorB).normalized()
        distanceFromOrigin = points[0].dot(normal)
    }
    
    public func isIntersectionValid(intersectionPoint: Vector) -> Bool {
        if intersectionPoint.isNaN {
            return false
        }
        
        var inFront = false
        
        let dot = normal.dot(intersectionPoint)
        let diff = dot - distanceFromOrigin
        inFront = diff > 0.0 && abs(diff) > Plane.intersectionTolerance
        
        return !inFront
    }
    
    public static func intersect(_ planes: [Plane]) throws -> Vector {
        if planes.count != 3 {
            throw MapParsingError.PlaneIntersectInvalidNumber
        }
        
        return intersect(planes[0], planes[1], planes[2])
    }
    
    public static func intersect(_ a: Plane, _ b: Plane, _ c: Plane) -> Vector {
        let denominator = a.normal.dot(b.normal.cross(c.normal))
        
        // Planes do not intersect
        if(Helper.approximatelyEquivalent(denominator, 0.0, 0.0001))
        {
            return Vector(Double.nan, Double.nan, Double.nan)
        }
        
        var crossAB = a.normal.cross(b.normal)
        crossAB *= c.distanceFromOrigin
        
        var crossBC = b.normal.cross(c.normal)
        crossBC *= a.distanceFromOrigin
        
        var crossCA = c.normal.cross(a.normal)
        crossCA *= b.distanceFromOrigin
        
        return (crossBC + crossCA + crossAB) / denominator
    }
}
