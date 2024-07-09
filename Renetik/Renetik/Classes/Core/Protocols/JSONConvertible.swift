import Foundation

public protocol JSONConvertible {
    func jsonString() -> String?
}

public extension JSONConvertible {
    func jsonString() -> String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Error converting object to JSON string: \(error)")
            return nil
        }
    }
}

extension Array: JSONConvertible {}
extension Dictionary: JSONConvertible {}
extension String: JSONConvertible {}
extension NSNumber: JSONConvertible {}
extension NSNull: JSONConvertible {}
