//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import Foundation

public enum MapParsingError : Error {
    case EntityNotClosed
    case BrushNotClosed
    case VectorNotClosed
    case VectorElementMissing
    case VectorInvalidValue
    case PlaneIntersectInvalidNumber
}
