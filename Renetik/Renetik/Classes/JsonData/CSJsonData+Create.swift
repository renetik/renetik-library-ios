//
// Created by Rene Dohan on 12/9/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Renetik
import RenetikObjc

extension CSJsonData {
    func createJsonDataList<T: CSJsonData>(_ type: T.Type, _ key: String, defaultDataList _: [T]? = nil) -> [T] {
        let mapDataArray: [[String: CSAny?]]? = getList(key)
        var jsonDataArray = [T]()
        mapDataArray?.enumerated().forEach { index, item in
            jsonDataArray.add(type.init().construct().load(data: item).also { $0.index = index })
        }
        return jsonDataArray
    }
}
