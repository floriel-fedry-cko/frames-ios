# CheckoutSdkIos

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CheckoutSdkIos.svg)](https://img.shields.io/cocoapods/v/CheckoutSdkIos)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/CheckoutSdkIos.svg?style=flat)](https://alamofire.github.io/CheckoutSdkIos)
![license](https://img.shields.io/github/license/mashape/apistatus.svg)

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
    pod 'CheckoutSdkIos', '~> 1.0'
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
github "checkout/checkout-sdk-ios" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `CheckoutSdkIos.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but CheckoutSdkIos does support its use on supported platforms.

Once you have your Swift package set up, adding CheckoutSdkIos as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

#### Swift 3

```swift
dependencies: [
    .Package(url: "https://github.com/checkout/checkout-sdk-ios.git", majorVersion: 1)
]
```

#### Swift 4

```swift
dependencies: [
    .package(url: "https://github.com/checkout/checkout-sdk-ios.git", from: "1.0.0")
]
```

## License

CheckoutSdkIos is released under the MIT license. [See LICENSE](https://github.com/checkout/checkout-sdk-ios/blob/master/LICENSE) for details.
