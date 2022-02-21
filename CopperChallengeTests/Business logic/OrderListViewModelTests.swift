//
//  OrderListViewModelTests.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 21/02/2022.
//

import XCTest
@testable import CopperChallenge

@MainActor
final class OrderListViewModelTests: CombineXCTestCase {
    func testHasCachedOrdersInitialValue() {
        // Given a mock OrdersDataProvider whose hasCachedOrders is set up to return true
        let dataProviderMock = OrdersDataProviderMock(hasCachedOrders: true)
        // When initialising an OrdersListViewModel with this data provider
        let viewModelWithCachedOrders = OrdersListViewModel(dataProvider: dataProviderMock)
        // Then its hasCachedOrders property is initialised to the value returned by OrdersPersistentStorage
        XCTAssertTrue(viewModelWithCachedOrders.hasCachedOrders)
        // And its loadingState is initialised to loaded
        XCTAssertEqual(viewModelWithCachedOrders.loadingState, .loaded)

        // Given a mock OrdersDataProvider whose hasCachedOrders is set up to return false
        dataProviderMock.hasCachedOrdersValue = false
        // When initialising an OrdersListViewModel with this data provider
        let viewModelNoCachedOrders = OrdersListViewModel(dataProvider: dataProviderMock)
        // Then its hasCachedOrders property is initialised to the value returned by OrdersPersistentStorage
        XCTAssertFalse(viewModelNoCachedOrders.hasCachedOrders)
        // And its loadingState is initialised to initial
        XCTAssertEqual(viewModelNoCachedOrders.loadingState, .initial)
    }

    func testFetchOrdersSuccess() async {
        // Given a mock OrdersDataProvider whose hasCachedOrders is set up to return false and whose fetchOrders is set up to succeed
        let dataProviderMock = OrdersDataProviderMock(hasCachedOrders: false, fetchOrdersResult: .success(Void()))
        // And an OrdersListViewModel initialised with this data provider
        let viewModel = OrdersListViewModel(dataProvider: dataProviderMock)

        var loadingStates: [LoadingState] = []
        viewModel.$loadingState.sink { loadingStates.append($0) }.store(in: &subscriptions)

        // When calling fetchOrders on the view model
        await viewModel.fetchOrders()
        // Then dataProvider.fetchOrders is called, loadingState is first set to loading, then to loaded and hasCachedOrders is updated to the value from the dataProvider
        XCTAssertTrue(dataProviderMock.fetchOrdersCalled)
        XCTAssertTrue(viewModel.hasCachedOrders)
        let expectedLoadingStates: [LoadingState] = [.initial, .loading, .loaded]
        XCTAssertEqual(expectedLoadingStates, loadingStates)
    }

    func testFetchOrdersFailure() async {
        // Given a mock OrdersDataProvider whose hasCachedOrders is set up to return false and whose fetchOrders is set up to fail
        let expectedError = OrdersError.networking(.unexpectedStatusCode(400))
        let dataProviderMock = OrdersDataProviderMock(hasCachedOrders: false, fetchOrdersResult: .failure(expectedError))
        // And an OrdersListViewModel initialised with this data provider
        let viewModel = OrdersListViewModel(dataProvider: dataProviderMock)

        var loadingStates: [LoadingState] = []
        viewModel.$loadingState.sink { loadingStates.append($0) }.store(in: &subscriptions)

        // When calling fetchOrders on the view model
        await viewModel.fetchOrders()
        // Then dataProvider.fetchOrders is called, loadingState is first set to loading, then to error and hasCachedOrders is not updated
        XCTAssertTrue(dataProviderMock.fetchOrdersCalled)
        XCTAssertFalse(viewModel.hasCachedOrders)
        let expectedLoadingStates: [LoadingState] = [.initial, .loading, .error(expectedError)]
        XCTAssertEqual(expectedLoadingStates, loadingStates)
    }

    func testFetchOrdersCalledWhileHavingCachedOrders() async {
        // Given a mock OrdersDataProvider whose hasCachedOrders is set up to return true
        let dataProviderMock = OrdersDataProviderMock(hasCachedOrders: true)

        // And an OrdersListViewModel initialised with this data provider
        let viewModel = OrdersListViewModel(dataProvider: dataProviderMock)

        var loadingStates: [LoadingState] = []
        viewModel.$loadingState.sink { loadingStates.append($0) }.store(in: &subscriptions)

        // When calling fetchOrders on the view model
        await viewModel.fetchOrders()
        // Then dataProvider.fetchOrders is NOT called, loadingState is not updated, nor is hasCachedOrders
        XCTAssertFalse(dataProviderMock.fetchOrdersCalled)
        XCTAssertTrue(viewModel.hasCachedOrders)
        // Just the initial value set in the init of the VM
        XCTAssertEqual(loadingStates, [.loaded])
    }
}
