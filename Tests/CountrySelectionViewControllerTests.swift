//
//  CountrySelectionViewControllerTests.swift
//  CheckoutSdkIosTests
//
//  Created by Floriel Fedry on 15/05/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest
@testable import CheckoutSdkIos

class MockDelegate: CountrySelectionViewControllerDelegate {

    public var methodCalledTimes = 0
    public var methodLastCalledWith = ""

    func onCountrySelected(country: String) {
        methodCalledTimes += 1
        methodLastCalledWith = country
    }
}

class CountrySelectionViewControllerTests: XCTestCase {

    var countrySelectionViewController = CountrySelectionViewController()
    let numberOfCountries = 256

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        countrySelectionViewController = CountrySelectionViewController()
        countrySelectionViewController.viewDidLoad()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let countrySelectionViewController = CountrySelectionViewController()
        countrySelectionViewController.viewDidLoad()
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count, numberOfCountries)
    }

    func testNumberOfSectionsInTableView() {
        XCTAssertEqual(countrySelectionViewController.numberOfSections(in: countrySelectionViewController.tableView), 1)
    }

    func testNumberOfRowsInSection() {
       let actual = countrySelectionViewController.tableView(countrySelectionViewController.tableView,
                                                             numberOfRowsInSection: 0)
    XCTAssertEqual(actual, numberOfCountries)
    }

    func testCallDelegateMethodOnCountrySelected() {
        let delegate = MockDelegate()
        countrySelectionViewController.delegate = delegate
        countrySelectionViewController.tableView(countrySelectionViewController.tableView,
                                                 didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(delegate.methodCalledTimes, 1)
        XCTAssertEqual(delegate.methodLastCalledWith, countrySelectionViewController.countries[0])
    }

    func testUpdateSearchResults() {
        /// Initial list
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count,
                       countrySelectionViewController.countries.count)
        /// Search with nothing
        countrySelectionViewController.updateSearchResults(text: nil)
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count,
                       countrySelectionViewController.countries.count)
        /// Search with 'A'
        countrySelectionViewController.updateSearchResults(text: "A")
        XCTAssertLessThan(countrySelectionViewController.filteredCountries.count,
                          countrySelectionViewController.countries.count)
    }
}
