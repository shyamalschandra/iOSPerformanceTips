//
//  ClearingCellsViewController.swift
//  PerformanceTests
//
//  Created by Paul Hudson on 18/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit

class ClearingCellsViewController: UITableViewController {
    // This shows random labels in table view cells. I've made it
    // show three UUIDs so we have a fair amount of text. When
    // enabled, it automatically clears the text of each cell
    // as it leaves the screen.
    //
    // Check: RAM usage vs CPU usage when the option is toggled.

    @IBOutlet var toggleClear: UIBarButtonItem!
    var clearsOnEndDisplaying = false
    var rows = (1...1000).map { _ in "\(UUID().uuidString) \(UUID().uuidString) \(UUID().uuidString)" }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if clearsOnEndDisplaying {
            cell.textLabel?.text = nil
        }
    }

    @IBAction func toggleClear(_ sender: Any) {
        clearsOnEndDisplaying.toggle()

        if clearsOnEndDisplaying {
            toggleClear.title = "Stop clearing on endDisplaying"
        } else {
            toggleClear.title = "Start clearing on endDisplaying"
        }
    }
}
