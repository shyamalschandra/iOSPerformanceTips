//
//  TagsViewController.swift
//  PerformanceTests
//
//  Created by Paul Hudson on 18/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
}

class TagsViewController: UIViewController {
    override func viewDidLoad() {
        // Once our simple storyboard view is created, add 500 new
        // UIViews of random colors, with each one inside another.
        // This will force UIKit to dig through a deep stack of
        // views to find a single tagged view.
        //
        // Check: how long it takes to find all tags.

        var parentView = view

        for i in 1...500 {
            let childView = UIView(frame: CGRect(x: 0, y: 0, width: 500 - i, height: 500 - i))
            childView.backgroundColor = UIColor.random()
            childView.tag = i
            parentView?.addSubview(childView)

            if i.isMultiple(of: 5) {
                parentView = childView
            }
        }
    }

    @IBAction func findTag(_ sender: Any) {
        // Attempts to find views tagged 1 through 1000 in
        // a random order. Appends them to an array and
        // prints the count just in case the compiler is
        // considering optimizing it away.
        // NB: We only create views 1 through 500, so half these
        // checks will force UIKit to check every view
        // unsuccessfully.
        let startTime = CFAbsoluteTimeGetCurrent()

        let tagList = (1...1000).shuffled()
        // Comment out the above and use the line below
        // if you just want to test one tag search.
        // let tagList = [1000]

        var foundTags = [UIView]()

        for tag in tagList {
            if let vw = view.viewWithTag(tag) {
                foundTags.append(vw)
            }
        }

        let timeTaken = CFAbsoluteTimeGetCurrent() - startTime
        print("Found \(foundTags.count) views in \(timeTaken) seconds")
    }
}
