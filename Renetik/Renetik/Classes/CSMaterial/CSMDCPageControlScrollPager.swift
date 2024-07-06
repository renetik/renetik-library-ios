//
// Created by Rene Dohan on 12/14/19.
// Copyright (c) 2019 Renetik Software. All rights reserved.
//

import BlocksKit
import MaterialComponents
import MaterialComponents.MDCPageControl
import Renetik
import RenetikObjc
import UIKit

open class CSMDCPageControlScrollPager: CSMainController, UIScrollViewDelegate {
    var pageControl: MDCPageControl!
    var scrollView: UIScrollView!
    var createScrollViewContent: (() -> UIView)!
    var contentView: UIView?
    var currentPage = 0

    public func construct(_ parent: CSMainController, _ pageControl: MDCPageControl, _ scrollView: UIScrollView,
                          _ count: Int, _ createScrollViewContent: @escaping () -> UIView)
    {
        super.constructAsViewLess(in: parent)
        self.pageControl = pageControl
        pageControl.numberOfPages = count
        pageControl.alpha = count > 1 ? 1 : 0 // BUG! hide/visible not works for MDCPageControl BUG!
        self.scrollView = scrollView
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        pageControl.bk_addEventHandler({ _ in
            self.showPage(at: self.pageControl.currentPage)
        }, for: .valueChanged)
        self.createScrollViewContent = createScrollViewContent
    }

    override open func onViewWillAppear() { createContentView() }

    override open func onViewDidTransition(
        to _: CGSize, _: UIViewControllerTransitionCoordinatorContext?
    ) {
        animate { self.createContentView(animated: false) }
    }

    func createContentView(animated: Bool = true) {
        contentView?.removeFromSuperview()
        contentView = scrollView.content(horizontal: createScrollViewContent())
        showPage(at: currentPage, animated: animated)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidEndScrollingAnimation(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidEndDecelerating(scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
    }

    func showPage(at index: Int, animated: Bool = true) {
        currentPage = index
        scrollView.scrollTo(page: index, of: pageControl.numberOfPages, animated: animated)
    }
}
