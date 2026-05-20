//
//  ProductListInteractor.swift
//  ViperLearning
//
//  Created by Bilal on 19/05/2026.
//

import Foundation

class ProductListInteractor: ProductListInteractorInputProtocol {
    // Weak reference to avoid memory leaks
    weak var presenter: ProductListInteractorOutputProtocol?

    func fetchProducts() async {
        // Replace this with a real API call
        let dummyProducts = [
            Product(title: "VIPER Shoes", price: 120.0),
            Product(title: "Clean Watch", price: 250.0)
        ]
        presenter?.didFetchProductsSuccess(products: dummyProducts)
    }
}

