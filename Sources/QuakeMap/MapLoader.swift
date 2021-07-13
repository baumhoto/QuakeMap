//
//  QuakeMap.swift
//  QuakeMap
//
//  Created by Tobias Baumhöver on 10.07.21.
//

import Foundation
import Euclid


public class MapLoader {
    public var mapFilePath : String
    var lines: [String]?
    public var errors: [Error]
    
    public init(_ mapFilePath: String) {
        self.mapFilePath = mapFilePath
        
        // Now you can access the file using e.g. String(contentsOfFile:)
        let data = try? String(contentsOfFile: mapFilePath, encoding: .utf8)
        self.lines = data?.components(separatedBy: .newlines)
        self.errors = []
        // or Data? using the FileManager
        //let data = FileManager.default.contents(atPath: mapFilePath)
    }
    
    public func parseMap() -> Map {
        guard let empty = lines?.isEmpty else { return Map() }
        
        if empty { return Map() }
        
        var map = Map()
        var entity : Entity
        var newIndex = 0
        
        do {
            for i in 0..<lines!.count {
                if i < newIndex { continue }
                
                guard let firstLineChar = lines![i].trimmed.first else {
                    continue
                }
                switch(firstLineChar) {
                    case "/" : continue // comment
                    case "{" : (newIndex, entity) = try ParseEntity(startLine: i+1); map.entities.append(entity)
                    default: continue
                }
            }
        }
        catch {
            errors.append(error)
        }
        
        return map
    }
    
    private func ParseEntity(startLine: Int) throws -> (Int, Entity) {
        var entity = Entity()
        var newIndex = 0
        var brush: Brush
        for i in startLine..<lines!.count {
            if i < newIndex { continue }
            switch(lines![i].first!) {
            case "{": (newIndex, brush) = try ParseBrush(startLine: i + 1); entity.brushes.append(brush);           //entity has brush
            case "}": return (i+1, entity);                                                                         //entity closed
            default: continue
            }
        }
        
        throw MapParsingError.EntityNotClosed
    }
    
    private func ParseBrush(startLine: Int) throws -> (Int, Brush) {
        var planes : [Plane] = []
        for i in startLine..<lines!.count {
            switch(lines![i].first!) {
            case "(": planes.append(try ParsePlane(planeString: lines![i]))                                   //entity has brushes
            case "}": return (i + 1, try Brush(planes))
            default: continue
            }
        }
        
        throw MapParsingError.BrushNotClosed
    }
    
    private func ParsePlane(planeString: String) throws -> Plane {
        var planePoints = [Vector](repeating: Vector.zero, count: 3)
        var newIndex = 0
        var pointIndex = 0
        for i in 0..<planeString.count {
            if i < newIndex { continue }
            switch(planeString[safe: i]) {
                case "(": (newIndex, planePoints[pointIndex]) = try ParseVector(planeSubString: planeString[safe: i+1..<planeString.count]!); pointIndex+=1;
                default: continue
                // TODO textures
            }
        }
        
        return Plane(planePoints, Winding.Clockwise)
    }
    
    private func ParseVector(planeSubString: String) throws -> (Int, Vector) {
        if let closingBracketIndex = planeSubString.firstIndex(of: ")") {
            let vectorString = planeSubString[...closingBracketIndex]
            let vectorParts = vectorString.split(separator: " ")
                    
            if vectorParts.count != 4 {
                throw MapParsingError.VectorElementMissing
            }
                    
            guard let x = Double(vectorParts[0]), let y = Double(vectorParts[1]), let z = Double(vectorParts[2]) else {
                throw MapParsingError.VectorInvalidValue
            }
            
            var closingBracket = closingBracketIndex.distance(in: planeSubString) + 1
            
            return (closingBracket, Vector(x, y, z))
        }
        
        throw MapParsingError.VectorNotClosed
    }
}

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}












