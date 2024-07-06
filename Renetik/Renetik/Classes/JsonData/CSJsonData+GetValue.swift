//
// Created by Rene Dohan on 12/9/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Renetik
import RenetikObjc

extension CSJsonData {
    func getStringValue(_ key: String) -> String { getString(key).asString }
}
