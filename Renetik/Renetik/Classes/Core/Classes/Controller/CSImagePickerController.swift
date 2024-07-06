//
// Created by Rene Dohan on 12/22/19.
//

import Foundation
import RenetikObjc
import UIKit

public protocol CSImagePickerListener {
    func imagePicker(controller: CSImagePickerController, didFinishPickingMedia data: [UIImagePickerController.InfoKey: Any])
}

public typealias CSImagePickerParent = CSHasDialog & CSHasSheet & CSImagePickerListener & UIViewController

public class CSImagePickerController: NSObject, UIPopoverControllerDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    private let parent: CSImagePickerParent!
    private var picker: UIImagePickerController?

    public init(parent: CSImagePickerParent!) {
        self.parent = parent
    }

    @discardableResult
    public func show(from element: CSDisplayElement) -> CSHasDialogVisible {
        parent.show(actions: [
            CSDialogAction(title: localized("renetik_image_picker_choose_photo")) { self.onGalleryClick(from: element) },
            CSDialogAction(title: localized("renetik_image_picker_take_picture")) { self.onCaptureClick(from: element) },
        ], from: element)
    }

    private func onGalleryClick(from element: CSDisplayElement) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker = UIImagePickerController()
            picker!.delegate = self
            picker!.allowsEditing = true
            picker!.sourceType = .photoLibrary
            picker!.present(from: element)
        } else {
            parent.show(message: "Gallery not available")
        }
    }

    private func onCaptureClick(from element: CSDisplayElement) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker = UIImagePickerController()
            picker!.delegate = self
            picker!.allowsEditing = true
            picker!.sourceType = .camera
            picker!.present(from: element)
        } else {
            parent.show(message: "Camera not available")
        }
    }

    public func imagePickerController(_: UIImagePickerController,
                                      didFinishPickingMediaWithInfo data: [UIImagePickerController.InfoKey: Any])
    {
        dismiss()
        parent.imagePicker(controller: self, didFinishPickingMedia: data)
    }

    public func imagePickerControllerDidCancel(_: UIImagePickerController) { dismiss() }

    private func dismiss() { picker?.dismiss() }
}
