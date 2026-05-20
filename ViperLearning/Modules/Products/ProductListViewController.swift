//
//  ProductListViewController.swift
//  ViperLearning
//
//  Created by Bilal on 19/05/2026.
//

import UIKit

class ProductListViewController: UIViewController, ProductListViewProtocol {

    var presenter: ProductListPresenterProtocol?
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Notify the Presenter that the view is ready
        presenter?.viewDidLoad()
    }

    func showProducts(_ products: [Product]) {
        DispatchQueue.main.async {
            self.products = products
            // self.tableView.reloadData()
            print("TableView reloaded with \(products.count) items")
        }
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            print("Show error alert: \(message)")
        }
    }
}
