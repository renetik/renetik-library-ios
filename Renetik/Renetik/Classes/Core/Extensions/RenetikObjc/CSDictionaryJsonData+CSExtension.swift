//
//  CSDictionaryJsonData+CSExtension.swift
//  Renetik
//
//  Created by Rene Dohan on 7/10/19.
//

import RenetikObjc

public extension CSDictionaryJsonData {
    func loadArray<DataType: CSDictionaryJsonData>(
        type: DataType.Type, key: String
    ) -> [DataType] {
        var dataArray = [DataType]()
        getArray(key).notNil {
            for (index, value) in $0.enumerated() {
                let data = type.init()
                data.load(value as! [AnyHashable: Any])
                data.index = index
                dataArray.append(data)
            }
        }
        return dataArray
    }
}
