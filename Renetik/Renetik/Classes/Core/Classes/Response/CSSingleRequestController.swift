//
// Created by René Doháň on 9/28/19.
// Copyright (c) 2019 Renetik Software. All rights reserved.
//

import Renetik
import RenetikObjc
import UIKit

public class CSSingleRequestController<Data: AnyObject>: CSMainController {
    public var stringRequestLoading = CSStrings.requestLoading
    public var stringRequestFailed = CSStrings.requestFailed
    public var stringRequestRetry = CSStrings.requestRetry

    private var reloadResponse: CSResponse<Data>?
    private var data: Data?
    private var request: (() -> CSResponse<Data>)!
    private var progressBlockedView: (CSResponseController & CSHasDialog)!

    public func construct(_ parent: UIViewController,
                          _ progressBlockedView: CSResponseController & CSHasDialog,
                          _ request: @escaping () -> CSResponse<Data>) -> Self
    {
        super.constructAsViewLess(in: parent)
        self.progressBlockedView = progressBlockedView
        self.request = request
        return self
    }

    public func reload() {
        reloadResponse?.cancel()
        progressBlockedView.show(request(), title: stringRequestLoading, canCancel: data.notNil)
            .onSuccess(onSuccess).onFailed(onFailed).onDone(onDone)
    }

    public func onSuccess(data: Data) {
        self.data = data
    }

    public func onFailed(response _: CSResponseProtocol) {
        progressBlockedView.show(message: stringRequestFailed,
                                 positive: CSDialogAction(title: stringRequestRetry, action: reload))
    }

    public func onDone(data _: Data?) {
        reloadResponse = nil
    }
}
