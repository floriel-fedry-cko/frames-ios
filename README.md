# CheckoutSdkIos - Beta

> Beta - Do not use before speaking to integration@checkout.com

[![Build Status](https://travis-ci.org/floriel-fedry-cko/just-a-test.svg?branch=master)](https://travis-ci.org/floriel-fedry-cko/just-a-test)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CheckoutSdkIos.svg)](https://img.shields.io/cocoapods/v/CheckoutSdkIos)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/CheckoutSdkIos.svg?style=flat)](https://alamofire.github.io/CheckoutSdkIos)
[![codecov](https://codecov.io/gh/floriel-fedry-cko/just-a-test/branch/master/graph/badge.svg)](https://codecov.io/gh/floriel-fedry-cko/just-a-test)
[![codebeat badge](https://codebeat.co/badges/d9bae177-78c1-40bb-94a7-187a7759d549)](https://codebeat.co/projects/github-com-floriel-fedry-cko-just-a-test-master)
![license](https://img.shields.io/github/license/floriel-fedry-cko/just-a-test.svg)

## Requirements

- iOS 10.0+
- Xcode 9.0+
- Swift 4.1+

## Documentation

You can find the CheckoutSdkIos [on this website]().

- [Usage](https://floriel-fedry-cko.github.io/just-a-test/usage.html)
- [Customizing the card view](https://floriel-fedry-cko.github.io/just-a-test/customizing-the-card-view.html)
- [Demo](https://floriel-fedry-cko.github.io/just-a-test/demo.html)
- Walkthrough
  - [iOS Example](https://floriel-fedry-cko.github.io/just-a-test/ios-example-frames.html)

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

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate CheckoutSdkIos into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "floriel-fedry-cko/just-a-test" ~> 0.2
```

Run `carthage update` to build the framework and drag the built `CheckoutSdkIos` into your Xcode project.

## Demo

You can find intructions on how to run the demo [here](./Documentation/Demo.md).

## Usage

Create the API Client `CheckoutAPIClient`:

```swift
// replace "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14" by your own public key
let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14",
                                          environment: .sandbox)
```

Create the `CardUtils` instance:

```swift
let cardUtils = CardUtils()
```

Create the card token request `CardTokenRequest`:

```swift
// create the phone number
let phoneNumber = CkoPhoneNumber(countryCode:number:)
// create the address
let address = CkoAddress(name:addressLine1:addressLine2:city:state:postcode:country:phone:)
// create the card token request
let cardTokenRequest = CkoCardTokenRequest(number:expiryMonth:expiryYear:cvv:name:billingAddress:)
```

Create a card token

```swift
let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_......", environment: .live)
checkoutAPIClient.createCardToken(card: cardTokenRequest, successHandler: { cardTokenResponse in
    // success
}, errorHandler { error in
    // error
})
```

## License

CheckoutSdkIos is released under the MIT license. [See LICENSE](https://github.com/checkout/checkout-sdk-ios/blob/master/LICENSE) for details.
