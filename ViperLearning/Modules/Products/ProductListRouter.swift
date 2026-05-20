//
//  ProductListRouter.swift
//  ViperLearning
//
//  Created by Bilal on 19/05/2026.
//

import UIKit

class ProductListRouter: ProductListRouterProtocol {
    
    // Wires up all 5 VIPER layers and returns the ready-to-use module
    static func createProductListModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController

        let presenter: ProductListPresenterProtocol & ProductListInteractorOutputProtocol = ProductListPresenter()
        let interactor: ProductListInteractorInputProtocol = ProductListInteractor()
        let router: ProductListRouterProtocol = ProductListRouter()

        // Connect all layers
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }

    // Navigates to the product detail screen
    func navigateToDetailScreen(from view: ProductListViewProtocol, with product: Product) {
        // let detailVC = ProductDetailRouter.createModule(with: product)
        // sourceVC.navigationController?.pushViewController(detailVC, animated: true)
        print("Router navigating to detail screen for \(product.title)")
    }
}
