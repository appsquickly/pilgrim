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
* **Official successor to [Typhoon](https://github.com/appsquickly/typhoon), for Objective-C and based on the excellent [FieryCrucible](https://github.com/jkolb/FieryCrucible) by [jkolb](https://github.com/jkolb).**

You can use Pilgrim in apps that employ the object-oriented programming paradigm or that mix object-oriented and functional styles.

---------------------------------------

## Quick Start

Here's how to get up and running with Pilgrim in two minutes. There are three steps. 

## Bootstrap 

(Optionally) bootstrap the default assembly type when the app launches, for example in main.swift: 

```swift
class MyApplication: UIApplication {

    override init() {
        AssemblyHolder.defaultAssemblyType = QuestAssembly.self
    }
    
}
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, "MyApplication", "MyAppDelegate")
```
This step allows using the `Assembled` property wrapper (step 3) without explicitly specifying an assembly type. 

## Define Assemblies 

An assembly (also known as the [composition root](https://freecontent.manning.com/dependency-injection-in-net-2nd-edition-understanding-the-composition-root/)) is where we declare the key actors within an application architecture, their lifecycles and how they interact in order to fulfil their roles. 

```swift
class QuestAssembly: PilgrimAssembly {

  let childAssembly = ChildAssembly()

  override func makeBindings() {
    super.makeBindings()
    makeInjectable(knight, byType: Knight.self)
    makeInjectable(holyGrailQuest, byType: Quest.self)
    makeInjectable(holyGrailQuest, byKey: "damselQuest")
    importBindings(childAssembly)
  }

  func knight() -> Knight {
    weakShared(Knight(quest: damselInDistressQuest()))
  }

  /**
   HolyGrailQuest is a struct that conforms to the Quest protocol.
   */
  func holyGrailQuest() -> Quest {
    shared(HolyGrailQuest())
  }

  /**
   Damsel's name is Bruce and the Knight is a lovely lass named Fiona. 
   */
  func damselInDistressQuest() -> Quest {
    shared(DamselInDistressQuest())
  }
}
```

In the example above we can see: 

* Functions that define architectural components. For example a `Knight` can fulfil a role when provided with a `Quest`. Each of these components has a lifecycle. 
* `makeBindings` : We can obtain top-level build instances from the DI container using a property wrapper. This is described in the next step. Here we're providing the information on how to resolve - either by type, which is the default, or if necessary using keys. Note that you're binding the function that will emit the built instance, not the return value (so don't add brackets!). 

## Inject Assembled Instances

Now we can inject built instances into top-level classes using the `Assembled` property wrapper, as follows: 

```swift
class StoryViewController : UIViewController {

    /**
     The built instance is auto-injected from the QuestAssembly 
    */
    @Assembled var knight: Knight; 

    private(set) var story: Story 
  
    init(story: Story) {
      self.story = story
    }
}
```

The built instance is auto-injected from the QuestAssembly. That's it!

### Notes

* Use the assembly to define how components interact. For example a `Quest` is injected into a `Knight` - this happens within the assembly. 
* Use the `Assembled` property decorator to obtain built instances for injection into top-level components - eg a view controller, in a UIKit app. 
* Assemblies can be layered - I'll explain this concept in the User Guide. 

## Installation 

### CocoaPods 

```
pod 'Pilgrim-DI'
```

Other installation methods coming soon!

----

## Sample App

Coming soon!

----

## User Guide

The best way to get up and running is to try the quick start and sample app. After that the [User Guide](https://github.com/appsquickly/pilgrim/wiki/User-Guide) is your reference. 

---------------------------------------

## What is Dependency Injection? 

Many people have trouble getting the hang of dependency injection, at first. I think part of the problem is that it is actually so simple that we’re inclined to look for something more complicated. With that in mind, imagine that you’re writing an app that gives weather reports. You need a cloud-service (excuse the pun) to provide the data. At first, you go for a free weather report provider, but in future you’d like to integrate a weather service with better accuracy and more features. So like a good object-oriented developer, you make a WeatherClient protocol and back it initially with an implementation based on the free, online data provider.

### Without Dependency Injection

It might look like this: 

```swift
class WeatherReportController : UIViewController { 
  let weatherClient = WeatherReportClient(key: myApiKey) 
}
```

A problem with this approach is if you wanted to change to another weather client implementation you’d have to go and find all the places in your code that use the old one, and move them over to the new one. Each time, making sure to pass in the correct initialization parameters. A common approach is to have a centrally configured singleton:

```swift
class WeatherReportController : UIViewController {
    let weatherClient = WeatherReportClient.shared
}
```

This gets around the problem of having a single point of truth for configuration, but in order to test the WeatherReportController, you now have to test its collaborating class (the weather client) at the same time. This can get tricky, especially as your application gets more complex. Imagine testing Class A, depends on Class B, depends on Class C, depends on… Not much fun! 

### Enter Dependency Injection

Rather than seek out collaborators, they are provided externally. 

```swift
class WeatherReportController : UIViewController {
  private(set) var weatherClient: WeatherReportProvider
  init(client: weatherClient) {
    self.weatherClient = client 
  }
}
```

## Is that It? 

More or less (dependency injection is, as they say, a $25 dollar term, for a five cent concept) but let‘s look at what happens when we start to apply this approach. If we continue to replace internally resolved dependencies with ones that are provided externally, we arrive at a module where the key actors, their lifecycles and their interactions are defined. This is known as the assembly or [composition root](https://freecontent.manning.com/dependency-injection-in-net-2nd-edition-understanding-the-composition-root).

Pulling construction of these components to the composition root lets your application tell an architectural story. When the key actors are pulled up into an assembly the app's configuration is no longer fragmented, duplicated or tightly coupled. We can have the benefits of singletons, without the drawbacks. 

## Benefits of Dependency Injection 

* We can substitute another actor to fulfill a given role. If you want to change from one implementation of a class to another, you need only change a single declaration.
* By removing tight-coupling, we need not understand all of a problem at once, its easy to evolve our app’s design as the requirements evolve.
* Classes and structs are easier to test, because we can supply test doubles in place of concrete collaborators (unit tests). Or the real collaborators, but configured to be used in a test scenario (integration tests).
* It promotes separation of concerns with a clear contract between classes.
* It is easy to see what each class needs in order to do its job.
* We can quickly prototype an application architecture - designing the key actors by contract.

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
