//
//  AppUpdater.swift
//  AppUpdater 1.0
//
//  Created by Ahmed Khalaf on 9/15/15.
//  Copyright (c) 2015 A.Khalaf. All rights reserved.
//

import UIKit
import SystemConfiguration

infix operator >> { associativity right precedence 90 }
func >> <T, R>(x: T, f: (T) -> R) -> R {
    return f(x)
}

class AppUpdater: NSObject {

    private static let sharedInstance = AppUpdater()
    
    class func forceUpdate()
    {
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.sharedInstance.checkAppUpdates(true)
        })
    }
    
    
    class func showUpdateMessage()
    {
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.sharedInstance.checkAppUpdates(false)
        })
    }
    
    private func checkAppUpdates(force: Bool)
    {
        if !connectedToNetwork() {
            return
        }
        checkNewAppVersionWithBlock({ (newVersion, appUrl, version, appName) -> Void in
            if newVersion {
                var alert = UIAlertController(title: String(format: NSLocalizedString("title", comment: ""), appName!),
                    message: String(format: NSLocalizedString("message", comment: ""), appName!, version!),
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: String(format: NSLocalizedString("update_action", comment: "")), style: .Default, handler: { action in
                    UIApplication.sharedApplication().openURL(NSURL(string: appUrl!)!)
                }))
                if !force {
                    alert.addAction(UIAlertAction(title: String(format: NSLocalizedString("cancel_action", comment: "")), style: .Destructive, handler: { action in
                    }))
                }
                let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
                
                vc!.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    private func string(object: AnyObject?) -> String? {
        return object as? String
    }

    private func connectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags : SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    private func checkNewAppVersionWithBlock(completion: (newVersion: Bool, appUrl: String?, version: String?, appName: String?) -> Void) {
        let bundleInfo = NSBundle.mainBundle().infoDictionary as! Dictionary<String, AnyObject>
        let bundleIdentifier = bundleInfo["CFBundleIdentifier"] >> string
        let currentVersion = bundleInfo["CFBundleShortVersionString"] >> string
        let appName = bundleInfo["CFBundleName"] >> string
        let lookupURLString = "http://itunes.apple.com/lookup?bundleId=\(bundleIdentifier!)"
        let lookupURL = NSURL(string: lookupURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        let lookupResults = NSData(contentsOfURL:lookupURL!)
        if (lookupResults == nil) {
            completion(newVersion: false, appUrl: nil, version: currentVersion, appName: appName)
            return
        }

        var _error: NSError?
        let jsonResults: NSDictionary? = NSJSONSerialization.JSONObjectWithData(lookupResults!, options: NSJSONReadingOptions.allZeros, error: &_error) as! NSDictionary?
        
        if _error != nil || jsonResults == nil {
            completion(newVersion: false, appUrl: nil, version: currentVersion, appName: appName)
            return
        }
        
        let resultCount = (jsonResults?["resultCount"] as! NSNumber).integerValue
        if resultCount > 0
        {
            let appDetails = (jsonResults?["results"] as! NSArray).firstObject as! Dictionary<String, AnyObject>
            let appItunesUrl = appDetails["trackViewUrl"]?.stringByReplacingOccurrencesOfString("&uo=4", withString: "")
            let latestVersion = appDetails["version"] as! String
            
            if latestVersion.compare(currentVersion!, options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending {
                completion(newVersion: true, appUrl: appItunesUrl, version: latestVersion, appName: appName);
            } else {
                completion(newVersion: false, appUrl: nil, version: currentVersion, appName: appName)
            }
        }
        else
        {
            completion(newVersion: false, appUrl: nil, version: currentVersion, appName: appName)
        }
    }

}
