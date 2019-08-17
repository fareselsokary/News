//
//  topHeadlinesViewController.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import Kingfisher
import UIKit

class topHeadlinesViewController: UIViewController {
    // MARK: variable

    @IBOutlet weak var headlineTable: UITableView!
    // creat prsenter instance
    private let presenter = topHeadlinespresenter()
    private var headlineArray: [Article]? = []
    private var pageNum = 1
    private var fetchNextPage = true
    var countryCode = ""
    var navigationBarTitle = ""
    // TODO: create refresh Control for reload data
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()

    // MARK: - view did load

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = navigationBarTitle
        presenter.delegate = self
        headlineTable.refreshControl = refreshControl
        headlineTable.rowHeight = UITableView.automaticDimension
        headlineTable.estimatedRowHeight = 600
        handelOflineData()
    }

    // MARK: - view will appear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // create Observer to listen to internet connection
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(notification:)),
                                               name: .reachabilityChanged,
                                               object: ReachabilityManager.shared.reachability)
    }
}

extension topHeadlinesViewController {
    // TODO: - connection Changed notification
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        if reachability.connection == .wifi || reachability.connection == .cellular {
            // load data if connection back and we are in cached data
            if pageNum == 1 {
                headlineArray?.removeAll()
                DispatchQueue.main.async {
                    self.headlineTable.reloadData()
                }
            }
            presenter.getTopHeadlines(countryCode: countryCode, pageNum: pageNum)
        } else if reachability.connection == .none {
            AlertMessage(title: "please", userMessage: "check your internet connection...")
        }
    }

    // TODO: - handel refreshControl action
    @objc func handleRefresh() {
        // reset to first page
        pageNum = 1
        if ReachabilityManager.shared.isNetworkAvailable == true {
            presenter.getTopHeadlines(countryCode: countryCode, pageNum: pageNum)
        } else {
            refreshControl.endRefreshing()
        }
    }

    // TODO: - handel if no conection present cached data else get api data action
    private func handelOflineData() {
        // show cached data
        if ReachabilityManager.shared.isNetworkAvailable == false {
            headlineArray = presenter.GetCacheHeadlines(key: countryCode)
            DispatchQueue.main.async {
                self.headlineTable.reloadData()
            }
        } else {
            // get data from api
            showSpinner(onView: view)
            presenter.getTopHeadlines(countryCode: countryCode, pageNum: pageNum)
        }
    }
}

// MARK: - UITable View Data Source

extension topHeadlinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlineArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "headLineCell", for: indexPath) as? headLineCell {
            cell.selectionStyle = .none
            if let data = headlineArray?[indexPath.row] {
                cell.title.text = data.title
                cell.name.text = data.author
                cell.headLineDescription.text = data.articleDescription
                cell.headLineImage.kf.setImage(with: URL(string: data.urlToImage ?? ""))
                cell.headLineImage.kf.indicatorType = .activity
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITable View Delegate

extension topHeadlinesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = headlineArray?[indexPath.row] {
            if data.articleDescription != nil {
                // show dialoge to shoew article description
                let alert = customAlert.alert(title: data.articleDescription!)
                present(alert, animated: true, completion: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // if connection is good and there is new page get next page fom api
        if ReachabilityManager.shared.isNetworkAvailable == true {
            if fetchNextPage == true {
                if headlineArray?.isEmpty == false {
                    if indexPath.row == headlineArray!.count - 1 {
                        presenter.getTopHeadlines(countryCode: countryCode, pageNum: pageNum)
                    }
                }
            }
        }
    }
}

// MARK: - Top Headlines presenter Delegate

extension topHeadlinesViewController: topHeadlinespresenterDelegate {
    // get Headlines data  from api request
    func Headlines(headlines: [Article], count: Int) {
        // if refresh Control is refreshing and page equal 1
        // remove all data from array and reload table data and stop refreshing
        if refreshControl.isRefreshing && pageNum == 1 {
            headlineArray?.removeAll()
            DispatchQueue.main.async {
                self.headlineTable.reloadData()
            }
            refreshControl.endRefreshing()
        }

        // get first 5 head lines and save them
        presenter.saveCacheHeadlines(object: Array(headlines.prefix(5)), key: countryCode)

        // check if ter is no headline for selected country get headline for (US) as defaults
        if headlines.isEmpty == false {
            headlineArray?.append(contentsOf: headlines)
            DispatchQueue.main.async {
                self.headlineTable.reloadData()
            }
            if headlineArray!.count < count {
                fetchNextPage = true
                pageNum += 1
            } else {
                fetchNextPage = false
            }

        } else {
            presenter.getTopHeadlines(countryCode: "us", pageNum: pageNum)
        }
    }

    // remove spiner from view
    func hideProgressLoader() {
        removeSpinner()
    }

    // if ther is an error show it alert and print error in console
    func showError(error: String) {
        AlertMessage(title: "", userMessage: "error fetch data")
        print(error)
    }
}
