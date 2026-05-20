//
//  ViperLearningTests.swift
//  ViperLearningTests
//
//  Created by Bilal on 19/05/2026.
//

import XCTest
@testable import ViperLearning

// MARK: - Mock View

class MockProductListView: ProductListViewProtocol {
    var showProductsCalled = false
    var showErrorCalled = false
    var receivedProducts: [Product] = []
    var receivedErrorMessage: String?

    func showProducts(_ products: [Product]) {
        showProductsCalled = true
        receivedProducts = products
    }

    func showError(_ message: String) {
        showErrorCalled = true
        receivedErrorMessage = message
    }
}

// MARK: - Mock Interactor

class MockProductListInteractor: ProductListInteractorInputProtocol {
    // Strong reference is safe in tests — no retain cycle risk in a short-lived test scope
    var presenter: ProductListInteractorOutputProtocol?
    var fetchProductsCalled = false
    var shouldReturnError = false

    func fetchProducts() async {
        fetchProductsCalled = true
        if shouldReturnError {
            presenter?.didFetchProductsFailure(with: "Network Error")
        } else {
            let products = [
                Product(title: "Test Shoes", price: 99.0),
                Product(title: "Test Watch", price: 199.0)
            ]
            presenter?.didFetchProductsSuccess(products: products)
        }
    }
}

// MARK: - Mock Router

class MockProductListRouter: ProductListRouterProtocol {
    var navigateCalled = false
    var navigatedProduct: Product?

    static func createProductListModule() -> UIViewController {
        return UIViewController()
    }

    func navigateToDetailScreen(from view: ProductListViewProtocol, with product: Product) {
        navigateCalled = true
        navigatedProduct = product
    }
}

// MARK: - Presenter Spy (used in Interactor test to capture output)

// Defined at file level to avoid Swift runtime issues with local class + weak var
private class PresenterSpy: ProductListInteractorOutputProtocol {
    var receivedProducts: [Product] = []
    var receivedError: String?

    func didFetchProductsSuccess(products: [Product]) {
        receivedProducts = products
    }

    func didFetchProductsFailure(with error: String) {
        receivedError = error
    }
}

// MARK: - Tests

final class ViperLearningTests: XCTestCase {

    var presenter: ProductListPresenter!
    var mockView: MockProductListView!
    var mockInteractor: MockProductListInteractor!
    var mockRouter: MockProductListRouter!

    override func setUpWithError() throws {
        presenter = ProductListPresenter()
        mockView = MockProductListView()
        mockInteractor = MockProductListInteractor()
        mockRouter = MockProductListRouter()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        mockInteractor.presenter = presenter
    }

    override func tearDownWithError() throws {
        // Clear all cross-references before releasing objects
        mockInteractor.presenter = nil
        presenter.view = nil
        presenter.interactor = nil
        presenter.router = nil
    }

    // MARK: - Presenter Tests

    func test_viewDidLoad_callsFetchProducts() async throws {
        // Interactor's fetchProducts should be called after viewDidLoad
        presenter.viewDidLoad()
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertTrue(mockInteractor.fetchProductsCalled)
    }

    func test_didFetchProductsSuccess_showsProductsOnView() {
        // When data arrives, View's showProducts should be called with correct data
        let products = [Product(title: "Shoes", price: 50.0)]
        presenter.didFetchProductsSuccess(products: products)

        XCTAssertTrue(mockView.showProductsCalled)
        XCTAssertEqual(mockView.receivedProducts.count, 1)
        XCTAssertEqual(mockView.receivedProducts.first?.title, "Shoes")
        XCTAssertEqual(mockView.receivedProducts.first?.price, 50.0)
    }

    func test_didFetchProductsFailure_showsErrorOnView() {
        // When an error occurs, View's showError should be called with the message
        presenter.didFetchProductsFailure(with: "Something went wrong")

        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.receivedErrorMessage, "Something went wrong")
    }

    func test_didTapProduct_routerNavigates() {
        // When user taps a product, Router should navigate to the detail screen
        let product = Product(title: "VIPER Shoes", price: 120.0)
        presenter.didTapProduct(product)

        XCTAssertTrue(mockRouter.navigateCalled)
        XCTAssertEqual(mockRouter.navigatedProduct?.title, "VIPER Shoes")
    }

    // MARK: - Interactor Tests

    func test_fetchProducts_returnsSuccess() async {
        // Real Interactor should return 2 dummy products on success
        let interactor = ProductListInteractor()
        let spy = PresenterSpy()
        interactor.presenter = spy

        await interactor.fetchProducts()

        XCTAssertEqual(spy.receivedProducts.count, 2)
        XCTAssertEqual(spy.receivedProducts.first?.title, "VIPER Shoes")
        XCTAssertEqual(spy.receivedProducts.last?.title, "Clean Watch")
    }

    func test_mockInteractor_returnsError() async {
        // When shouldReturnError is true, View should display the error message
        mockInteractor.shouldReturnError = true
        await mockInteractor.fetchProducts()

        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.receivedErrorMessage, "Network Error")
    }

    // MARK: - Entity Tests

    func test_productEntity_valuesAreCorrect() {
        // Entity should correctly store its title and price values
        let product = Product(title: "Clean Watch", price: 250.0)
        XCTAssertEqual(product.title, "Clean Watch")
        XCTAssertEqual(product.price, 250.0)
    }
}
