//
// Created by Rene Dohan on 12/4/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Renetik

public class CSJsonData: CSObject {
    let onValueChangedEvent: CSEvent<JsonDataOnValueChange> = event()
    let onChangedEvent: CSEvent<CSJsonData> = event()
    var index = 0
    private var _data: [String: CSAny?]!
    private var childDataKey: String? = nil
    private var dataChanged = false

    override public required init() {
        super.init()
    }

    @discardableResult
    func load(data: [String: CSAny?]) -> Self {
        _data = data
        return self
    }

    @discardableResult
    func construct() -> Self { load(data: [String: CSAny?]()) }

    open var data: [String: CSAny?] {
        childDataKey?.get { key in
            (_data[key] as? [String: CSAny?]) ??
                [String: CSAny?]().also { _data[key] = $0 }
        } ?? _data
    }

    open func setValue(_ key: String, _ value: CSAny?) {
        childDataKey.notNil { childKey in
            var childData = (_data[key] as? [String: CSAny?]) ?? [String: CSAny?]()
            childData[key] = value
            _data[childKey] = childData
        }.elseDo {
            _data[key] = value
        }
        onValueChangedEvent.fire(JsonDataOnValueChange(self, key, value))
        if !dataChanged {
            later {
                self.onChangedEvent.fire(self)
                self.dataChanged = false
            }
            dataChanged = true
        }
    }
}

class JsonDataOnValueChange {
    let data: CSJsonData, key: String, value: Any?

    init(_ data: CSJsonData, _ key: String, _ value: Any?) {
        self.data = data
        self.key = key
        self.value = value
    }
}
