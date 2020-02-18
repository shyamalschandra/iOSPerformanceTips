//
//  ClearingTextViewController.swift
//  PerformanceTests
//
//  Created by Paul Hudson on 18/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit

class ClearingTextViewController: UIViewController {
    var labels = [UILabel]()

    override func loadView() {
        // Creates 100 labels in a line, each with random text.
        // When our bar buttons are tapped, these are either hidden,
        // cleared then hidden, or reset and shown.
        //
        // Check: RAM usage when text is hidden vs cleared and hidden.

        view = UIView()
        view.backgroundColor = .systemBackground

        for i in 1...100 {
            let label = UILabel(frame: CGRect(x: 0, y: 150 + i * 5, width: 0, height: 0))

            // Try adding an emoji into the string to see very different results.
            label.text = "\(UUID().uuidString)"
            label.sizeToFit()
            view.addSubview(label)
            labels.append(label)
        }
    }

    @IBAction func hideText(_ sender: Any) {
        print("Hiding")

        labels.forEach {
            $0.isHidden = true
        }
    }

    @IBAction func hideAndClearText(_ sender: Any) {
        print("Hiding and clearing")

        labels.forEach { item in
            item.isHidden = true
            item.text = nil

//          Using the below instead of the two lines above
//          makes a difference!
//            item.text = nil
//
//            DispatchQueue.main.async {
//                item.isHidden = true
//            }
        }
    }

    @IBAction func resetText(_ sender: Any) {
        print("Resetting")

        labels.forEach {
            // If you add an emoji above, make sure you add it here too.
            $0.text = "\(UUID().uuidString)"
            $0.isHidden = false
        }
    }
}

