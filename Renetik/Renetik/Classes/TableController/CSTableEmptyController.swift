//
//  Renetik
//
//  Created by Renetik Software on 3/10/19.
//

import ChameleonFramework.Chameleon
import DZNEmptyDataSet.UIScrollView_EmptyDataSet
import RenetikObjc
import UIKit

public class CSTableEmptyController<Row: CSTableControllerRow, Data>: NSObject,
    DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    public var emptyText: String?
    public var emptyDescription: String?
    public var table: CSTableController<Row, Data>!
    public var reloadImage = UIImage()
    public var reloadImageTintColor: UIColor?
    public var backgroundColor: UIColor? = .clear
    public var titleFont = UIFont.preferredFont(forTextStyle: .title3).bold()
    public var descriptionFont = UIFont.preferredFont(forTextStyle: .body)
    public var titleColor = UIColor.black
    public var descriptionColor = UIColor.black.lighten(byPercentage: 0.05)

    @discardableResult
    public func construct(_ table: CSTableController<Row, Data>,
                          _ title: String? = nil,
                          _ description: String? = nil) -> Self
    {
        self.table = table
        emptyText = title
        emptyDescription = description
        table.tableView.emptyDataSetDelegate = self
        table.tableView.emptyDataSetSource = self
        return self
    }

    public func emptyDataSetShouldDisplay(_: UIScrollView!) -> Bool {
        !table.isLoading
    }

    public func title(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        titleText.attributed([
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.foregroundColor: titleColor,
        ])
    }

    private var titleText: String {
        if table.isFailed {
            return table.failedMessage ?? "Loading of list content was not successful, click to try again"
        }
        return emptyText ?? "No items in list to display at this time"
    }

    public func description(forEmptyDataSet _: UIScrollView!) -> NSAttributedString? {
        emptyDescription?.attributed([
            NSAttributedString.Key.font: descriptionFont,
            NSAttributedString.Key.foregroundColor: descriptionColor,
            NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle().also {
                $0.lineBreakMode = .byWordWrapping
                $0.alignment = .center
            },
        ])
    }

    public func imageAnimation(forEmptyDataSet _: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D:
            CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = 4
        return animation
    }

    public func image(forEmptyDataSet _: UIScrollView!) -> UIImage! {
        reloadImage
    }

    public func imageTintColor(forEmptyDataSet _: UIScrollView!) -> UIColor? {
        reloadImageTintColor
    }

    public func emptyDataSetShouldAnimateImageView(_: UIScrollView!) -> Bool {
        true
    }

    public func backgroundColor(forEmptyDataSet _: UIScrollView!) -> UIColor! {
        backgroundColor
    }

    public func emptyDataSetDidTap(_: UIScrollView!) {
        table.reload().onDone { _ in self.table.tableView.reloadEmptyDataSet() }
    }

    public func emptyDataSetDidTapButton(_: UIScrollView!) {
        table.reload().onDone { _ in self.table.tableView.reloadEmptyDataSet() }
    }

    public func verticalOffset(forEmptyDataSet _: UIScrollView!) -> CGFloat { 0 }

    public func emptyDataSetShouldAllowScroll(_: UIScrollView!) -> Bool { true }
}
