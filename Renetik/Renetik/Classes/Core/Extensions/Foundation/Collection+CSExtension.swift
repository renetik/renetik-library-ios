//
// Created by Rene on 2018-11-22.
// Copyright (c) 2018 Renetik Software. All rights reserved.
//

import Foundation

public extension Collection {
    var hasItems: Bool { !isEmpty }
    var length: Int { count }
    var size: Int { count }
    var lastIndex: Int { length - 1 }
}
