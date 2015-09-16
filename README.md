# app-updater
Swift iOS library checks the latest available version of your app on the AppStore, and shows the user alert to update the app.

## Why should I use it?
Just imagine adding writing <b>ONE LINE OF CODE</b> to let all your users keep track of your latest updates, and getting a huge number of updates once you released your app's update. Isn't great? ;)

## Features

- Simple
- Fast
- Redirecting user to the AppStore
- Ability to force the user to update, or nicly remind him

## Show Update Reminder

````swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    AppUpdater.showUpdateMessage()
    return true
}
````
![alt tag](https://cloud.githubusercontent.com/assets/3859305/9920657/ca33b03e-5cde-11e5-84a0-e4a670af6829.jpg)

## Force User To Update

````swift
func applicationDidBecomeActive(application: UIApplication) {
    AppUpdater.forceUpdate()
}
````
![alt tag](https://cloud.githubusercontent.com/assets/3859305/9920656/ca312ed6-5cde-11e5-90cb-aae1bc576b04.jpg)

*Note: This method should be called from `applicationDidBecomeActive(application:)` to show the update message every time the user tries to re-open the app.

## Installation

- Copy `AppUpdater` folder into your project.
- Link `SystemConfiguration.framework`.

## License

app-updater is released under the MIT license. See [LICENSE](LICENSE) for details.
