# CheckoutSdkIos - Preview (WIP)

[![Build Status](https://travis-ci.org/floriel-fedry-cko/just-a-test.svg?branch=master)](https://travis-ci.org/floriel-fedry-cko/just-a-test)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CheckoutSdkIos.svg)](https://img.shields.io/cocoapods/v/CheckoutSdkIos)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/CheckoutSdkIos.svg?style=flat)](https://alamofire.github.io/CheckoutSdkIos)
[![codecov](https://codecov.io/gh/floriel-fedry-cko/just-a-test/branch/master/graph/badge.svg)](https://codecov.io/gh/floriel-fedry-cko/just-a-test)
[![codebeat badge](https://codebeat.co/badges/d9bae177-78c1-40bb-94a7-187a7759d549)](https://codebeat.co/projects/github-com-floriel-fedry-cko-just-a-test-master)
![license](https://img.shields.io/github/license/floriel-fedry-cko/just-a-test.svg)

## Requirements

* iOS 10.0+
* Xcode 9.0+
* Swift 4.1+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build CheckoutSdkIos 1.0+.

To integrate CheckoutSdkIos into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'CheckoutSdkIos', :git => 'https://github.com/floriel-fedry-cko/just-a-test.git'
end
```

Then, run the following command:

```bash
$ pod install
```

### Demo

You can find intructions on how to run the demo [here](./Documentation/Demo.md).

### Usage

Add your public key:

```swift
let publicKey = "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14"
```

Create api client and card utils instance:

```swift
var checkoutAPIClient: CheckoutAPIClient {
    return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox)
}
let cardUtils = CardUtils()
```

Get the values:

```swift
guard
    let cardNumber = cardNumberInputView.textField!.text,
    let expirationDate = expirationDateInputView.textField!.text,
    let cvv = cvvInputView.textField!.text
    else { return }
let (expiryMonth, expiryYear) = cardUtils.standardize(expirationDate: expirationDate)
```

Create the request object:

```swift
let card = CardRequest(number: cardUtils.standardize(cardNumber: cardNumber),
                       expiryMonth: expiryMonth,
                       expiryYear: expiryYear,
                       cvv: cvv,
                       name: nil)
```

Create the card token:

```swift
checkoutAPIClient.createCardToken(card: card, successHandler: { cardToken in
            let alert = UIAlertController(title: "Payment successful",
                                          message: "Your card token: \(cardToken.id)", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }, errorHandler: { error in
            let alert = UIAlertController(title: "Payment unsuccessful",
                                          message: "Error: \(error)", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        })
```

## License

CheckoutSdkIos is released under the MIT license. [See LICENSE](https://github.com/checkout/checkout-sdk-ios/blob/master/LICENSE) for details.
