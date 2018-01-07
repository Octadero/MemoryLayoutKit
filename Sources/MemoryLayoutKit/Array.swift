//
//  Array.swift
//  MemoryLayoutKitPackageDescription
//
//  Created by Volodymyr Pavliukevych on 1/7/18.
//

import Foundation

public struct CharStarConstStar: CustomStringConvertible {
    public enum CharStarConstStarError: Error {
        case canNotComputeCStringPointer
    }
    
    public let pointerList: UnsafeMutablePointer<UnsafePointer<Int8>?>
    public let count: Int
    public let encoding: String.Encoding
    
    public init(array: [String], using encoding: String.Encoding) throws {
        count = array.count
        pointerList = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: array.count)
        
        self.encoding = encoding
        for (i, value) in array.enumerated(){
            guard let cString = value.cString(using: encoding) else {
                throw CharStarConstStarError.canNotComputeCStringPointer
            }
            pointerList[i] = UnsafePointer<Int8>(strdup(cString))
        }
    }
    
    public var deallocator: (() -> Void) {
        return {
            self.pointerList.deinitialize()
            self.pointerList.deallocate(capacity: self.count)
        }
    }
    
    public var description: String {
        var description = ""
        for index in 0..<count {
            if let pointer = pointerList[index] {
                description += "[" + String(cString: pointer) + "]"
            }
        }
        return description
    }
}


extension Array where Element == String {
    /// Return C style array char* const* you can use it for const char* const* API.
    /// Do not forget to free memory at defer statement.
    public func cArray(using encoding: String.Encoding = .utf8) throws -> CharStarConstStar {
        return try CharStarConstStar(array: self, using: encoding)
    }
    
}
