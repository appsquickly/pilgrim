<a href="https://pilgrim.ph"> ![PilgrimSplash](https://pilgrim.ph/splash.jpg)</a>
# <a href="https://pilgrim.ph">pilgrim.ph</a>

Pilgrim is a dependency injection library for Swift with the following features:

* Minimal runtime-only library that works with pure Swift (structs, classes, protocols) as well as ObjC base classes, when necessary.
* Easy to install. Works on iOS, Mac & Linux. No compile-time weaving required.   
* Type safe. No reflection or ObjC runtime, because it is pure swift. (Uses higher-order functions.) 
* Lifecycles management: `shared`, `weakShared`, `objectGraph` (a DI concept introduced by [Typhoon](https://github.com/appsquickly/typhoon), for desktop and pocket apps) & `unshared`. 
* Can be used with SwiftUI, UIKit and Cocoa based apps.     
* Simple and flexible. For example, it is easy to have two injectable instances that conform to the same protocol. 
* Provides the notion of a [composition root](https://freecontent.manning.com/dependency-injection-in-net-2nd-edition-understanding-the-composition-root/) in which the key actors, and their interactions in an application architecture are defined as a graph. This is where your app's architectural story is told. Assembled instances can then be injected into top level classes, such as a view controller, in a UIKit app, using property wrappers. 
* Runtime args. Can act as a factory for emitting new instances derived from a mix of runtime parameters and key architectural actors. 
* **Official successor to [Typhoon](https://github.com/appsquickly/typhoon) and based on the excellent [FieryCrucible](https://github.com/jkolb/FieryCrucible) by [jkolb](https://github.com/jkolb).**

You can use Pilgrim in apps that employ the object-oriented programming paradigm or that mix object-oriented and functional styles.

---------------------------------------

## Quick Start

Want to start applying dependency injection to your code in two minutes? **Follow the [Quick Start](https://github.com/appsquickly/pilgrim/wiki) guide!**

```swift 
class AppDelegate: UIResponder, UIApplicationDelegate {

    @Assembled var assembly: ApplicationAssembly
    @Assembled var cityRepo: CityRepository
    @Assembled var rootViewController: RootViewController

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        window = assembly.window()
        window?.makeKeyAndVisible()

        if (cityRepo.loadSelectedCity() == nil) {
            rootViewController.showCitiesListController()
        }
        return true
    }
}
```
_Here's how your code might look, when you're done with the [quick start](https://github.com/appsquickly/pilgrim/wiki)._


## Installation 

### CocoaPods 

```
pod 'Pilgrim-DI'
```

Other installation methods (Swift Package Manager, etc) coming soon!

----

## Sample App

Here's a [sample app](https://github.com/appsquickly/pilgrim-starter) / starter template, to get up and running quickly. 

----

## User Guide

The best way to get up and running is to try the quick start and sample app. After that the [User Guide](https://github.com/appsquickly/pilgrim/wiki/) is your reference. 

---------------------------------------

## What is Dependency Injection? 

Not sure? There's an introduction on the [pilgrim.ph](https://pilgrim.ph) website. Head on over and take a look. We'll meet back here. 

## Feedback

#### I'm not sure how to do [xyz]

> If you can't find what you need in the Quick Start or User Guides, please [post a question on StackOverflow](https://stackoverflow.com/questions/tagged/pilgrim?sort=newest&pageSize=15), using the pilgrim tag.

#### Interested in contributing?

> Great! A contribution guide, along with detailed documentation will be published in the coming days.

#### I've found a bug, or have a feature request

> Please raise a <a href="https://github.com/appsquickly/pilgrim/issues">GitHub</a> issue.

----

## Who is using it?

Are you using Pilgrim and would like to support free & open-source software? Send us an email or PR to add your logo here.

----

### Have you seen the light?

Pilgrim is a non-profit, community driven project. We only ask that if you've found it useful to star us on Github or send a tweet mentioning us (<a href="https://twitter.com/@doctor_cerulean">@doctor_cerulean</a>). If you've written a Pilgrim related blog or tutorial, or published a new Pilgrim-powered app, we'd certainly be happy to hear about that too.

Pilgrim is sponsored and led by <a href="https://appsquick.ly">AppsQuick.ly</a> with <a href="https://github.com/appsquickly/pilgrim/graphs/contributors">contributions from around the world</a>.
 
---------------------------------------

## License

Copyright (c) 2020 Pilgrim Contributors
