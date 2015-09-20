# app-updater
app-updater is a swift iOS library. It checks the latest available version of your app on the App Store and notifies the user to update the app.

## Why should I use it?
Just imagine adding <b>ONE LINE OF CODE</b> to keep all your users up to date of your latest updates. This accelerates the adoption of your latest version as soon as it's released. Isn't that great? ;)

## Features

- Simple.
- Fast.
- Redirect user to the App Store.
- Force the update or just display a reminder.
- Localizable, and new languages can be added.

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

- Copy `AppUpdater` folder into your project, and remember to choose `Create Groups` for added folders.
- Link `SystemConfiguration.framework`.

## Localization

- English - base.
- Arabic.
- Spanish.

## License

app-updater is released under the MIT license. See [LICENSE](LICENSE) for details.
