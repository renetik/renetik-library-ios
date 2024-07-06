//
//  CSHtmlLabel.swift
//  Motorkari
//
//  Created by Rene Dohan on 2/7/19.
//  Copyright © 2019 Renetik Software. All rights reserved.
//

import ARChromeActivity
import DTCoreText
import DTCoreText.DTAttributedLabel
import Renetik
import TUSafariActivity
import UIKit

public class CSHtmlLabel: DTAttributedLabel,
    DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate
{
    public var font = UIFont.preferredFont(forTextStyle: .body)
    public var textColor: UIColor = .darkText
    public var linkColor: UIColor = .blue
    public var linkHighlightedColor: UIColor = .purple
    public var encoding: String.Encoding = .utf8
    public var defaultLinkColor: UIColor = .blue
    public var linksActive = true

    override public func construct() -> Self {
        super.construct()
        delegate = self
        backgroundColor = .clear
        return self
    }

    public var html = "" {
        didSet {
            let corrected = html.addSizeToHtmlImageTags(width)
            attributedString = NSAttributedString(
                htmlData: corrected.data(using: encoding),
                options: attributedOptions, documentAttributes: nil
            )
        }
    }

    public var attributedOptions: [AnyHashable: Any] {
        [
            DTUseiOS6Attributes: true,
            DTDefaultFontName: font.fontName,
            DTDefaultFontFamily: font.familyName,
            DTDefaultFontSize: font.pointSize,
            DTDefaultTextColor: textColor,
            DTDefaultLinkColor: linkColor,
            DTDefaultLinkHighlightColor: linkHighlightedColor,
            DTDefaultLinkDecoration: false,
        ]
    }

    @discardableResult
    public func heightToFit(lines: Int) -> Self {
        height(UILabel.construct().width(width).font(font).heightToFit(lines: lines).height)
        numberOfLines = lines
        lineBreakMode = .byTruncatingTail
        return self
    }

    @discardableResult
    public func link(color: UIColor) -> Self { invoke { self.linkColor = color } }

    @discardableResult
    public func linkHighlighted(color: UIColor) -> Self { invoke { self.linkHighlightedColor = color } }

    @discardableResult
    public func textColor(_ color: UIColor) -> Self { invoke { self.textColor = color } }

    @discardableResult
    public func defaultLink(color: UIColor) -> Self { invoke { self.defaultLinkColor = color } }

    @discardableResult
    public func encoding(_ encoding: String.Encoding) -> Self { invoke { self.encoding = encoding } }

    @discardableResult
    public func html(_ html: String) -> Self { invoke { self.html = html } }

    @discardableResult
    public func fontStyle(_ fontStyle: UIFont.TextStyle) -> Self {
        font = UIFont.preferredFont(forTextStyle: fontStyle)
        return self
    }

    @discardableResult
    public func withBoldFont(if condition: Bool = true) -> Self {
        font = condition ? font.bold() : font.normal()
        return self
    }

    public func attributedTextContentView(_:
        DTAttributedTextContentView!,
        viewForLink url: URL!, identifier _: String!, frame: CGRect) -> UIView!
    {
        if !linksActive { return nil }
        return UIView.construct().frame(frame).also { view in
            view.onClick {
                let controller = UIActivityViewController(
                    activityItems: [url], applicationActivities: [TUSafariActivity(), ARChromeActivity()]
                )
                controller.popoverPresentationController?.sourceView = view
                navigation.last!.present(controller, animated: true, completion: nil)
            }
        }
    }

    public func attributedTextContentView(_: DTAttributedTextContentView!,
                                          viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView!
    {
        if attachment is DTImageTextAttachment {
            let imageView = DTLazyImageView(frame: frame)
            imageView.contentMode = .scaleAspectFit
            imageView.delegate = self as DTLazyImageViewDelegate
            imageView.url = attachment.contentURL
            return imageView
        }
        return nil
    }

    public func lazyImageView(_ lazyImageView: DTLazyImageView,
                              didChangeImageSize: CGSize)
    {
        for attachment in layoutFrame.textAttachments() {
            let textAttachment = (attachment as! DTTextAttachment)
            if textAttachment.contentURL.absoluteString ==
                lazyImageView.url.absoluteString
            {
                textAttachment.displaySize =
                    CGSize(width: didChangeImageSize.width + 10,
                           height: didChangeImageSize.height)
                textAttachment.verticalAlignment = .center
            }
        }
        relayoutText()
    }
}
