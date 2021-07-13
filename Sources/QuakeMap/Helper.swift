//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import Foundation
import Euclid

public class Helper {
    public static func approximatelyEquivalent(_ a: Double, _ b: Double, _ tolerance: Double) -> Bool {
        let upperBound = a + tolerance
        let lowerBound = a - tolerance
        
        return b >= lowerBound && b <= upperBound
    }
    
    public static func approximatelyEquivalent(_ a: Vector, _ b: Vector, _ tolerance: Double) -> Bool {
        return
            approximatelyEquivalent(a.x, b.x, tolerance) &&
            approximatelyEquivalent(a.y, b.y, tolerance) &&
            approximatelyEquivalent(a.z, b.z, tolerance)
    }
    
    
    public static func combinations(count: Int, size: Int) -> [[Int]] {
       return combinations(count: count, size: size, start: 0)
    }
    
    public static func combinations(count: Int, size: Int, start: Int) -> [[Int]] {
        var items: [Int] = []
        
        for i in 0..<count {
            items.append(i)
        }
        
        return combinations(items: items, size: size, start: start)
    }
    
    public static func combinations(items: [Int], size: Int, start: Int) -> [[Int]] {
        var result = [[Int]]()
        
        if(size == 1) {
            for i in start..<items.count {
                result.append([items[i]])
            }
            
            return result
        }
        
        for i in start..<items.count {
            let remainingCombos = combinations(items: items, size: size - 1, start: i + 1)
            
            for combo in remainingCombos {
                var output = [items[i]]
                output.append(contentsOf: combo)
                result.append(output)
            }
        }
        
        return result
    }
    
    public static func sortVertices(vertices: [Vertex], normal: Vector, winding: Winding) -> [Vertex] {
        var sorted : [Vertex] = []
        
        if (vertices.count == 0) {
            return sorted
        }
        
        sorted.append(vertices[0])
        
        let pairs = Helper.permutations(count: vertices.count, size: 2)
        
        let boundingBox = BoundingBox(vertices)
        print(boundingBox.center)
        
        let angles = getClockwiseAngles(vertices: vertices, pairs: pairs, center: boundingBox.center, normal: normal)
        
        var currentIndex = 0
        
        for _ in 0..<vertices.count-1 {
            var previousAngle = 181.0
            var nextIndex = 0
            for candidate in angles {
                if candidate.key[0] != currentIndex {
                   continue
                }
                
                if abs(candidate.value) < previousAngle {
                    nextIndex = candidate.key[1]
                    previousAngle = abs(candidate.value)
                }
            }
            
            sorted.append(vertices[nextIndex])
            currentIndex = nextIndex
        }
        
        if winding == Winding.Clockwise {
            // Reverse the order but keep the first vertex at index 0
            sorted.reverse()
            sorted.insert(sorted.removeLast(), at: 0)
        }
        
        return sorted
    }
    
    public static func permutations(count: Int, size: Int) -> [[Int]] {
        var items = [Int]()
        for i in 0..<count {
            items.append(i)
        }
        
        return permutations(items: items, size: size)
    }
    
    public static func permutations(items: [Int], size: Int) -> [[Int]] {
       var result = [[Int]]()
        
        if size == 1 {
            for item in items {
                result.append([Int](repeating: item, count: 1))
            }
            
            return result
        }
        
        for item in items {
            var others = items
            let firstIndex = others.firstIndex(of: item)!
            _ = others.remove(at: firstIndex)
            
            let remainingPerms = permutations(items: others, size: size - 1)
            
            for perm in remainingPerms {
                var output = [Int](repeating: item, count: 1)
                output.append(contentsOf: perm)
                result.append(output)
            }
        }
        
        return result
    }
    
    public static func getClockwiseAngles(vertices: [Vertex], pairs: [[Int]], center: Vector, normal: Vector) -> Dictionary<[Int], Double> {
        
        var points = [Vector]()
        for vertex in vertices {
            points.append(vertex.position)
        }
        
        return getClockwiseAngles(points: points, pairs: pairs, center: center, normal: normal)
    }
    
    public static func getClockwiseAngles(points: [Vector], pairs: [[Int]], center: Vector, normal: Vector) -> Dictionary<[Int], Double> {
        var result : [[Int]: Double] = [:]
        
        for pair in pairs {
            let a = points[pair[0]] - center
            let b = points[pair[1]] - center
            
            let angle = getClockwiseAngle(a: a, b: b, normal: normal)
            
            if !angle.isNaN {
                result[pair] = angle
            }
        }
        
        return result
    }
    
    public static func getClockwiseAngle(a: Vector, b: Vector, normal: Vector) -> Double {
        var result = Double.nan
        
        let angle = signedAngleBetweenVectors(a: a, b: b, normal: normal)
        
        if angle > 0.0 || Helper.approximatelyEquivalent(angle, -180.0, 0.001) {
            result = angle
        }
        
        return result
    }
    
    public static func signedAngleBetweenVectors(a: Vector, b: Vector, normal: Vector) -> Double {
        let dot1 = normal.dot(a.cross(b))
        let dot2 = a.dot(b)
        
        let angle = Angle.atan2(y: dot1, x: dot2)
        
        return angle.degrees
    }
}
