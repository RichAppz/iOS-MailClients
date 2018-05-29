# iOS-MailClients

> Mail Client Service - Connecting you to more than just Mail

[![Swift Version][swift-image]][swift-url]
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

This Pod allows you to connect to more than one mail client with ease.  Presenting a `UIAlertController` with multiple options based on what client is installed.

## Currently Available Clients

- [x] Mail
- [x] Gmail
- [x] Inbox
- [x] Outlook
- [x] Spark
- [x] Newton


## Requirements

- iOS 10.0+

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `iOSMailClients` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!
pod 'iOSMailClients'
```

To get the full benefits import `iOSMailClients` wherever you import UIKit

``` swift
import UIKit
import iOSMailClients
```

## Usage example

```swift
import iOSMailClients

/// To allow the service to just open the client
MailService.request(fromVC: self)

/// To allow the service to compose an email - (mailto is a requirement)
MailService.request(fromVC: self, subject: "Test Subject", body: "Test Body", mailto: "rich@richappz.com")
```

#### Plist Requirements

You will need to add this snippet to your project plist to enable the URL Schemes for the available clients

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>googlegmail</string>
    <string>cloudmagic</string>
    <string>inbox-gmail</string>
    <string>ms-outlook</string>
    <string>readdle-spark</string>
</array>
```

## Contribute

We would love you for the contribution to **iOSMailClients**, check the ``LICENSE`` file for more info.

## Meta

Rich Mucha – [@RichAppz](https://twitter.com/richappz) – rich@richappz.com

Distributed under the Apache License 2.0. See ``LICENSE`` for more information.

[https://github.com/richappz/](https://github.com/richappz/)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/



Copyright 2018 Rich Mucha, RichAppz Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
