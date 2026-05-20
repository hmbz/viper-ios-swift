//
//  ProductListContract.swift
//  ViperLearning
//
//  Created by Bilal on 19/05/2026.
//

import UIKit

// 1. Defines what the Presenter does (called by View and Interactor)
protocol ProductListPresenterProtocol: AnyObject {

    var view: ProductListViewProtocol? { get set }
    var interactor: ProductListInteractorInputProtocol? { get set }
    var router: ProductListRouterProtocol? { get set }

    func viewDidLoad()
    func didTapProduct(_ product: Product)
}

// 2. Defines what the View (ViewController) does (called by Presenter)
protocol ProductListViewProtocol: AnyObject {
    func showProducts(_ products: [Product])
    func showError(_ message: String)
}

// 3. Defines what the Interactor does (Presenter sends orders here)
protocol ProductListInteractorInputProtocol: AnyObject {
    var presenter: ProductListInteractorOutputProtocol? { get set }
    func fetchProducts() async
}

// 4. Defines how the Interactor sends data back to the Presenter
protocol ProductListInteractorOutputProtocol: AnyObject {
    func didFetchProductsSuccess(products: [Product])
    func didFetchProductsFailure(with error: String)
}

// 5. Defines what the Router (Navigation) does
protocol ProductListRouterProtocol: AnyObject {
    static func createProductListModule() -> UIViewController
    func navigateToDetailScreen(from view: ProductListViewProtocol, with product: Product)
}

