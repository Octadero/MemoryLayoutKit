/* Copyright 2017 The Octadero Authors. All Rights Reserved.
 Created by Volodymyr Pavliukevych on 2017.
 
 Licensed under the Apache License 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 https://github.com/Octadero/MemoryLayoutKit/blob/master/LICENSE
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

/// Feature to print data as hex array.
public extension Data {
	public func hexEncodedString() -> String {
		return map { String(format: " 0x%02hhx", $0) }.joined()
	}
}

public extension Data {
	public func decode<T>() -> T {
		let pointer = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
		NSData(data: self).getBytes(pointer, length: MemoryLayout<T>.size)
		let object = pointer.move()
		pointer.deallocate()
		return object
	}
	
	public init<T>(fromArray values: [T]) {
		var values = values
		self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
	}
	
	public func toArray<T>(type: T.Type) -> [T] {
		return self.withUnsafeBytes {
			[T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
		}
	}
	
	mutating func pointer() -> UnsafePointer<Int8> {
		return self.withUnsafeBytes({ (p : UnsafePointer<Int8>) -> UnsafePointer<Int8> in
			return p
		})
	}
}

