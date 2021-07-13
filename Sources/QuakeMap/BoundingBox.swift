//
//  BoundingBox.swift (Axis Aligned)
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import Euclid

public struct BoundingBox {
    public var min: Vector = Vector.zero
    public var max: Vector = Vector.zero
    public var center: Vector {
        return min + ((max - min) / 2.0)
    }
    
    public init() {
    }
    
    public init(_ vertices: [Vertex]) {
        var points = [Vector]()
        
        for vertex in vertices {
            points.append(vertex.position)
        }
    
        (self.min, self.max) = initialize(points: points)
    }
    
    private func initialize(points: [Vector]) -> (min: Vector, max: Vector) {
        var newMin = points[0]
        var newMax = points[0]
        
        for point in points {
            if point.x < newMin.x {
                newMin.x = point.x
            }
            if point.x > newMax.x {
                newMax.x = point.x
            }
            
            if point.y < newMin.y {
                newMin.y = point.y
            }
            if point.y > newMax.y {
                newMax.y = point.y
            }
            
            if point.z < newMin.z {
                newMin.z = point.z
            }
            if point.z > newMax.z {
                newMax.z = point.z
            }
        }
        
        return (newMin, newMax)
    }
    
}
