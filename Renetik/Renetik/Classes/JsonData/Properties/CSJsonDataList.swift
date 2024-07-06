//
// Created by Rene Dohan on 12/4/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Renetik

public class CSJsonDataList<T: CSJsonData>: NSObject {
    let data: CSJsonData, type: T.Type, key: String

    init(_ data: CSJsonData, _ type: T.Type, _ key: String) {
        self.data = data
        self.type = type
        self.key = key
    }

    var list: [T] {
        data.createJsonDataList(type, key)
    }
}
