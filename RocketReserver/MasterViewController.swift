//
//  MasterViewController.swift
//  RocketReserver
//
//  Created by Conrad Taylor on 5/6/20.
//  Copyright © 2020 Conrad Taylor. All rights reserved.
//

import UIKit
import Apollo

class MasterViewController: UITableViewController {

  var detailViewController: DetailViewController? = nil
  let apollo = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com/")!)
  var launches = [LaunchListQuery.Data.Launch.Launch]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.apollo.fetch(query: LaunchListQuery()) { [weak self] result in
      switch result {
      case .success(let graphQLResult):
        if let launches = graphQLResult.data?.launches.launches.compactMap({ $0 }) {
          self?.launches.append(contentsOf: launches)
          self?.tableView.reloadData()
        }
        print(graphQLResult)
      case .failure(let error):
        print(error)
      }
    }
    
    // Do any additional setup after loading the view.
    navigationItem.leftBarButtonItem = editButtonItem

    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
        if let indexPath = tableView.indexPathForSelectedRow {
//            let object = objects[indexPath.row] as! NSDate
//            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//            controller.detailItem = object
//            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//            controller.navigationItem.leftItemsSupplementBackButton = true
//            detailViewController = controller
        }
    }
  }

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return launches.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let launch = launches[indexPath.row]
    cell.textLabel!.text = launch.site
    return cell
  }
  
}
