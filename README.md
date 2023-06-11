# Update Gate
A convenient Update Gate written with Swift Protocol Oriented Programing and Generics for SwiftUI/UIKit projects

## Features
- Show a recommendation update alert
- Show a mandatory update alert 
- Show a Maintenance Alert

## Usage
- Provide a simple endpoints or a simple json local file with following format:
```
{
    "title": "",
    "notify": "always",
    "app-store-id": "6448284417",
    "min-required-app-version":"1.0.9",
    "min-optional-app-version": "1.0.10",
    "version": "1.0.11",
    "min-required-app-notes": "You are using an outdated version of the Update Gate app. To continue using this app, please ensure you update to the latest version.",
    "min-optional-app-notes": "You are using an outdated version of the Update Gate app. For the best experience, please ensure you are using the latest version.",
    "version-notes": "Thank you for updating! This version includes some major bug fixes and sets the groundwork for the impending iPhone update.",
    "is-maintenance": 1,
    "reason-maintenance": "We're under *maintenance*. We'll be back ~~online~~ on ***August 26, 2050*** at 18:00. [Sorry for the inconvenience](https://www.mongodb.com/developer/products/realm/realm-ios15-swiftui/)!"
}
```
- Update gate will read above configurations and return result for you to use accordingly
