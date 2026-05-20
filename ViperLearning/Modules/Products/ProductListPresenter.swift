//
//  ProductListPresenter.swift
//  ViperLearning
//
//  Created by Bilal on 19/05/2026.
//

import Foundation

class ProductListPresenter: ProductListPresenterProtocol {
    weak var view: ProductListViewProtocol?
    var interactor: ProductListInteractorInputProtocol?
    var router: ProductListRouterProtocol?
    
    // Called when the view has finished loading
    func viewDidLoad() {
        Task {
            await interactor?.fetchProducts()
        }
    }

    // Called when the user taps on a product
    func didTapProduct(_ product: Product) {
        guard let view = view else { return }
        router?.navigateToDetailScreen(from: view, with: product)
    }
}

// Handles callbacks from the Interactor once data is ready
extension ProductListPresenter: ProductListInteractorOutputProtocol {
    func didFetchProductsSuccess(products: [Product]) {
        view?.showProducts(products)
    }
    
    func didFetchProductsFailure(with error: String) {
        view?.showError(error)
    }
}
