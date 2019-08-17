//
//  CountryCodeViewController.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import UIKit

class CountryCodeViewController: UIViewController {
    // MARK: variable

    @IBOutlet weak var countryCodeTable: UITableView!
    // creat prsenter instance
    private let presenter = CountryCodePresenter()
    private var countryCodeArray: [[CountryCodeElement]]? = []
    let letterSections = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    // MARK: - view did load

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        handelOflineData()
        setupNavigationBar()
        countryCodeTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - view will appear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(notification:)),
                                               name: .reachabilityChanged,
                                               object: ReachabilityManager.shared.reachability)
    }
}

extension CountryCodeViewController {
    // TODO: -  set up navigation bar apperance
    private func setupNavigationBar() {
        navigationItem.title = "Countries code"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // TODO: - connection Changed notification
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        if reachability.connection == .wifi || reachability.connection == .cellular {
            if countryCodeArray?.isEmpty == true {
                presenter.getCountryCode()
            }
        } else if reachability.connection == .none {
            AlertMessage(title: "please", userMessage: "check your internet connection...")
        }
    }

    // TODO: - handel if no conection present cached data else get api data action
    private func handelOflineData() {
        if ReachabilityManager.shared.isNetworkAvailable == false {
            configCountryCodeArray(code: presenter.GetCountryCode(key: "countryCode"))
            DispatchQueue.main.async {
                self.countryCodeTable.reloadData()
            }
        } else {
            presenter.getCountryCode()
        }
    }
}

extension CountryCodeViewController {
    // TODO: -  make table scetion by split country depend on letters
    private func configCountryCodeArray(code: [CountryCodeElement]) {
        countryCodeArray?.removeAll()
        DispatchQueue.main.async {
            if code.isEmpty == false {
                for leter in self.letterSections {
                    let index = code.filter({ $0.name?.first?.lowercased() == leter.lowercased() })
                    self.countryCodeArray?.append(index)
                }
                DispatchQueue.main.async {
                    self.countryCodeTable.reloadData()
                }
            }
        }
    }
}

// MARK: -  set up Country Code Presenter Delegate

extension CountryCodeViewController: CountryCodePresenterDelegate {
    func CountryCode(code: [CountryCodeElement]) {
        //   presenter.stopMonitoring()
        configCountryCodeArray(code: code)
    }

    // TODO: - show Progress Loader on main view
    func showProgressLoader() {
        showSpinner(onView: view)
    }

    // TODO: - hide Progress Loader from main view
    func hideProgressLoader() {
        removeSpinner()
    }

    // if ther is an error show it alert and print error in console
    func showError(error: Error) {
        AlertMessage(title: "", userMessage: "error fetch data")
        print(error.localizedDescription)
    }
}

// MARK: - setup UITableView Delegate

extension CountryCodeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryCodeArray?[section].count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return countryCodeArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let data = countryCodeArray?[indexPath.section][indexPath.row] {
            cell.textLabel?.text = data.name
        }
        return cell
    }
}

// MARK: - setup UITableView DataSource

extension CountryCodeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return letterSections[section]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = countryCodeArray?[indexPath.section][indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "topHeadlinesViewController") as? topHeadlinesViewController {
                vc.countryCode = data.code ?? ""
                vc.navigationBarTitle = data.name ?? ""
                navigationController?.pushViewController(vc, animated: true)
                countryCodeTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}
