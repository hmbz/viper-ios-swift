# VIPER Architecture — iOS Swift

A clean, well-structured iOS project demonstrating the **VIPER** architectural pattern in Swift with full unit test coverage.

## What is VIPER?

VIPER is an architectural pattern that separates responsibilities into 5 distinct layers:

| Layer | Responsibility |
|---|---|
| **V**iew | Displays data, forwards user actions to Presenter |
| **I**nteractor | Contains business logic, fetches data |
| **P**resenter | Mediates between View and Interactor, formats data |
| **E**ntity | Plain data models (structs) |
| **R**outer | Handles navigation between screens |

## Project Structure

```
ViperLearning/
└── Modules/
    └── Products/
        ├── ProductListContract.swift       # All protocols defined in one place
        ├── ProductEntity.swift             # Product data model
        ├── ProductListViewController.swift # V — View layer
        ├── ProductListInteractor.swift     # I — Business logic
        ├── ProductListPresenter.swift      # P — Presenter layer
        └── ProductListRouter.swift        # R — Navigation + module wiring
```

## Data Flow

```
View → Presenter → Interactor
                       ↓
View ← Presenter ←────┘
```

## Unit Tests

All 7 test cases are in `ViperLearningTests/ViperLearningTests.swift`:

- `test_viewDidLoad_callsFetchProducts`
- `test_didFetchProductsSuccess_showsProductsOnView`
- `test_didFetchProductsFailure_showsErrorOnView`
- `test_didTapProduct_routerNavigates`
- `test_fetchProducts_returnsSuccess`
- `test_mockInteractor_returnsError`
- `test_productEntity_valuesAreCorrect`

Run tests with `Cmd + U` in Xcode.

## Requirements

- Xcode 15+
- iOS 16+
- Swift 5.9+
