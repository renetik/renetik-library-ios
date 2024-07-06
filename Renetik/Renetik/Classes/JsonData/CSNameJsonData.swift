//
// Created by Rene Dohan on 12/4/19.
// Copyright (c) 2019 Renetik Software. All rights reserved.
//

import Foundation

public class CSNameJsonData: CSJsonData {
    var nameKey: String!

    public func construct(_ nameKey: String) -> Self {
        super.construct()
        self.nameKey = nameKey
        return self
    }

    override public func construct() -> Self { construct("name") }

    public var id: String { getStringValue("id") }

    public var name: String { getStringValue(nameKey) }

    override public var description: String { name }
}
