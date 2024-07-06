//
// Created by Rene Dohan on 4/10/20.
//

import Foundation
import RenetikObjc

public typealias TagIndex = (startTagIndex: Int, endTagIndex: Int)

public extension String {
    func findTags(startTag: String, endTag: String,
                  where condition: ((_ tag: String) -> Bool)? = nil) -> [TagIndex]
    {
        var tags = [TagIndex]()
        process(startTag: startTag, endTag: endTag) { startTagIndex, endTagIndex in
            let shouldAdd = condition.isNil ? true :
                condition!(substring(from: startTagIndex + startTag.length, to: endTagIndex))
            if shouldAdd {
                tags.add((startTagIndex: startTagIndex, endTagIndex: endTagIndex))
            }
        }
        return tags
    }

    func process(startTag: String, endTag: String,
                 with function: (_ startTagIndex: Int, _ endTagIndex: Int) -> Void) -> [(startTagIndex: Int, endTagIndex: Int)]
    {
        var tags = [(startTagIndex: Int, endTagIndex: Int)]()
        var startTagCursor: Int? = -1
        repeat {
            startTagCursor = index(of: startTag, from: startTagCursor! + 1)
            if let startTagIndex = startTagCursor {
                startTagCursor! += startTag.size
                if let endTagIndex = endTag.isEmpty ? length
                    : index(of: endTag, from: startTagIndex + 1)
                {
                    function(startTagIndex, endTagIndex)
                    startTagCursor = endTagIndex + endTag.size
                }
            }
        } while startTagCursor.notNil
        return tags
    }

    func htmlToText(_ encoding: String.Encoding) -> String? {
        if let data = data(using: encoding) {
            return (try? NSAttributedString(data: data,
                                            options: [.documentType: NSAttributedString.DocumentType.html],
                                            documentAttributes: nil))?.string
        }
        return nil
    }

    func replaceTagsWithEmptySpace(startTag: String, endTag: String) -> Self {
        let string = NSMutableString(string: self)
        process(startTag: startTag, endTag: endTag) { startTagIndex, endTagIndex in
            let endTagEndIndex = endTagIndex + endTag.length
            string.replace(from: startTagIndex, to: endTagEndIndex,
                           with: String(repeating: " ", count: endTagEndIndex - startTagIndex))
        }
        return string as String
    }
}
