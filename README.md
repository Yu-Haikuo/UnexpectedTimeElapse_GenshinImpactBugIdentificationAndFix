# Unexpected internal game time elapse when iOS Genshin Impact is switched to the background / iOS 原神切换到后台后异常的应用内时间流逝

### Introduction 介绍

This repository contains the bug description and a simple demo iOS application that shows the comparison between cold value progress bar before fix and after fix. 

这个代码仓库包含了 bug 的描述信息以及一个展示寒冷值进度条修复前和修复后对比的简易 iOS 演示应用。

## Environment 环境

- **Device 设备:** iPhone 12 Pro Max
- **OS Version 系统版本:** iOS 15.4.1
- **Application 应用:** Genshin Impact (Singapore App Store)
- **Application Version 应用版本:** OSRELiOS2.8.0\_R9182063\_S9770078_D9770078
- **Application Language 应用内语言:** Chinese for both Game Language and Voice-Over Language
- **Internet Connection 网络连接:** Wi-Fi and 4G
- **Rate of Reproduction 复现概率:** 100%

**Priority 等级:** Medium to Low

## Steps to Reproduce 复现步骤

Run Genshin Impact, go to any `Teleport Waypoint` in `Dragonspine` except Statues of The Seven. Then climb to any high point, jump off and record cold value (blue progress bar above health).

运行原神并前往任何`龙脊雪山`除七天神像外的任何`传送锚点`，爬到任何高处，然后跳下并记录寒冷值（生命值上面的蓝色进度条）。

![IMG_7144.PNG](https://github.com/Yu-Haikuo/UnexpectedTimeElapse_GenshinImpactBugIdentificationAndFix/blob/main/_resources/IMG_7144-1.PNG)

Then after gliding some time with Wind Glider, swipe up from the bottom edge of the screen to return to the iPhone home screen. Below shows the screenshot right before returning back to home screen. 

在使用风之翼滑翔一段时间后，在屏幕底部上划返回 iPhone 主屏幕。下图是在上划前的截图。

![IMG_7145.PNG](https://github.com/Yu-Haikuo/UnexpectedTimeElapse_GenshinImpactBugIdentificationAndFix/blob/main/_resources/IMG_7145.PNG)

Next, spend some time with other applications (approximately 1min). After that, return to Genshin Impact. 

随后使用其他应用一段时间（大约1分钟）。随后，返回原神。

<p align="center">
    <img height="700" src="https://github.com/Yu-Haikuo/UnexpectedTimeElapse_GenshinImpactBugIdentificationAndFix/blob/main/_resources/IMG_7146.PNG">
</p>

Wait for Genshin Impact to load and restore from the snapshot. It can be seen that the cold value has increased by some value compared to when we jumped off, and the sky also gets dark. 

等待原神加载并从快照中恢复。可以看到寒冷值和我们在山上跳下的时候相比增加了一些，并且天空也变暗了。

![IMG_7147.PNG](https://github.com/Yu-Haikuo/UnexpectedTimeElapse_GenshinImpactBugIdentificationAndFix/blob/main/_resources/IMG_7147.PNG)

### Expected Result 期望结果

When Genshin Impact restores from snapshot, all properties of the character and surroundings should also get restored.

当原神从快照中恢复的时候，所有的角色的属性以及环境应该也被恢复。

![IMG_7144.PNG](https://github.com/Yu-Haikuo/UnexpectedTimeElapse_GenshinImpactBugIdentificationAndFix/blob/main/_resources/IMG_7144.PNG)

### Actual Result 实际结果

Time-related properties (including cold value and sky) are not restored correctly. It can be inferred that time continues to elapse for a while after Genshin Impact was switched to the background.

和时间有关的属性（包括寒冷值和天空）并没有被正确恢复。可以推断出在原神切入后台后时间仍然在持续流逝。

![IMG_7147.PNG](https://github.com/Yu-Haikuo/UnexpectedTimeElapse_GenshinImpactBugIdentificationAndFix/blob/main/_resources/IMG_7147.PNG)

## Possible Cause 可能的原因

Base on my own speculation, Genshin Impact handles most of the calculations in the iOS application, which includes battles, game plots, materials collection, etc. Every once in a while, the server will communicate with the iOS application to get data, verify its authenticity, and save a `snapshot` of it. In addition, the sever will also communicate with the iOS application and save a `snapshot` right before the character jumps off from height, jumps into the water, starts a new plot or a new battle. At this point, the server will not save a `snapshot` until the current event is completed. 

根据我个人的推断，原神在 iOS 应用端处理大部分的计算，包括战斗、游戏剧情、材料采集等等。每隔一段时间，服务器就会与 iOS 应用进行通信，从而获取数据、验证数据真实性、并且存储一个`快照`。此外，在角色从高处跳下、跳入水中、开启一段新剧情或者新的战斗之前，服务器也会与 iOS 应用通信并且保存一个`快照`。此时直到当前事件完成前服务器将不会保存`快照`。

***

The game has to maintain the communication with the server when it runs, and if the communication is disconnected, the server will mark the current account as "offline", and force to overwrite the iOS application local data with the latest `snapshot` the next time when communication resumes. This is to ensure the authenticity of the data and avoid local tampering. 

游戏运行中需要一直保持与服务器的通信，如果服务器与 iOS 应用的通信断开，服务器会将当前账号标记称为“离线”，并且再下次与 iOS 应用通信的时候使用最新的`快照`强制覆盖 iOS 本地数据。这样做是为了保证数据的真实性，避免用户本地进行篡改。

***

In theory, the game should be able to restore all the state from the `snapshot`, including character state, location, collected materials, etc. But we notice that all time-related attributes are not restored properly, and the time continues to elapse for a while. **Therefore, it can be inferred that the timer in Genshin Impact is implemented locally and the time-related attributes will not be uploaded and saved in the `snapshot`, either (because if the `snapshot` contains time-related attributes, this problem might not exist).**

理论上，游戏应该能从`快照`中恢复到保存快照时的所有状态，包括角色状态、位置、已有材料等等。但是在我们注意到，所有和时间有关的属性并没有被正确恢复，并且时间继续流逝了一段时间。**因此可以推断出，原神中的计时器实现于本地，并且和时间有关的属性并不会被上传并保存在`快照`里（因为如果`快照`保存有时间有关的属性的话，这个问题可能并不存在）。**

***

Based on my limited knowledge, there are mainly two ways to implement `timer` for iOS Genshin Impact, one way is to implemented inside `Unity`, and the other way is to implement natively via `NSTimer`. Both implementations should be quite similar, using a `counter` variable to save the increment and a `coldValueIncrement()` function to be triggered by `timer` at a certain frequency. However, when the application is not in the foreground, the `timer` will continue to work and `coldValueIncrement()` will still be triggered by the `timer` for a while, which depends on [how many tasks need to be finished](https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/extending_your_app_s_background_execution_time). **As a result, the unexpected internal game time elapse occurs.**

根据我个人有限的知识，iOS 原神本地 `timer` 主要有两种实现方式，一种是在 `Unity` 中实现，另一种是使用 `NSTimer` 以原生的方式实现。两种实现应该十分类似，均采用一个 `counter` 变量来存储增量以及一个 `coldValueIncrement()` 来被 `timer` 以一个特定频率触发。然而，当应用并不在前台时，`timer` 仍然会继续工作一段时间并且 `coldValueIncrement()` 仍然会被触发，具体时间取决于[有多少需要完成的任务](https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/extending_your_app_s_background_execution_time)。**因此，异常的应用内时间流逝出现了。**

## Suggestions to Fix 修复建议

First of all, as Genshin Impact supports iOS 9.0+, so the application UI should be constructed with `UIKit`. Before the foreground iOS application is temporarily interrupted, `UIKit` will send a `Notification` called `UIScene.willDeactivateNotification`; after background iOS application is switched to foreground, `UIKit` will send a `Notification` called `UIScene.didActivateNotification`. Hence, we can take advantage of this feature, first add `resume()` and `pause()` for `ColdValueIncrementTimer`, then add the `Observers` and `@objc selector functions` for those `Notifications` in `ViewController`. 

首先由于原神支持 iOS 9.0+，因此原神应用 UI 是使用 `UIKit` 构建。当前台 iOS 应用被暂时打断前，`UIKit` 会发送 `UIScene.willDeactivateNotification`；当后台 iOS 应用被切换到前台后，`UIKit` 会发送 `UIScene.didActivateNotification`。因此我们可以利用这个特性，先为 `ColdValueIncrementTimer` 添加 `resume()` 和 `pause()`，然后在 `ViewController` 中添加这两个 `Notification` 的 `Observer` 和相应的 `@objc selector function`。

***

First we add two methods for `ColdValueIncrementTimer`, which are `ColdValueIncrementTimer:: resume()` and `ColdValueIncrementTimer:: pause()`. 

首先为旧有 `ColdValueIncrementTimer` 添加两个 method，分别是 `ColdValueIncrementTimer:: resume()` 和 `ColdValueIncrementTimer:: pause()`：

```Swift
// Added resume() and pause() and overrided coldValueIncrement() to fix unwanted time elapse.
class FixedColdValueIncrementTimer: ColdValueIncrementTimer {
    
    internal func resume() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1 / refreshRate, target: self, selector: #selector(coldValueIncrement), userInfo: nil, repeats: true)
        timer?.tolerance = tolerance
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    internal func pause() {
        timer?.invalidate()
    }
    
    override func coldValueIncrement() {
        counter = counter &+ 1
        notification.post("After Fix Cold Value Increment", object: counter)
    }
}
```

Then add `Observers` for `UIScene.willDeactivateNotification` and `UIScene.didActivateNotification` in `ViewController`. 

然后在 `ViewController` 中添加 `UIScene.willDeactivateNotification` 和 `UIScene.didActivateNotification` 的 `Observer`。

```Swift
override func viewDidAppear(_ animated: Bool) {
        beforeFixTimer.start()
        afterFixTimer.start()
        
        if #available(iOS 13.0, *) {
            notification.addObserver(self, #selector(applicationWillBecomeInactive), UIScene.willDeactivateNotification, object: nil)
            notification.addObserver(self, #selector(applicationDidBecomeActive), UIScene.didActivateNotification, object: nil)
        } else {
            notification.addObserver(self, #selector(applicationWillBecomeInactive), UIApplication.willResignActiveNotification, object: nil)
            notification.addObserver(self, #selector(applicationDidBecomeActive), UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
```

Finally, add corresponding `@objc selector function`. 

最后再添加相应的 `@objc selector function`。

```Swift
// Added functions that fix the unwanted time elapse problem.
// They will be triggered when the application active state changes.
extension ViewController {
    
    @objc private func applicationWillBecomeInactive() {
        afterFixTimer.pause()
        print("Application will become inactive!")
    }
    
    @objc private func applicationDidBecomeActive() {
        afterFixTimer.resume()
        print("Application did become active!")
    }
}
```

## Running Result 运行效果

<p align="center">
    <img height="700" width="324" src="https://github.com/Yu-Haikuo/UnexpectedTimeElapse_GenshinImpactBugIdentificationAndFix/blob/main/_resources/DemoApplication.gif">
</p>

## References 参考

[Apple Developer Documentation - willDeactivateNotification](https://developer.apple.com/documentation/uikit/uiscene/3197924-willdeactivatenotification)

> UIKit posts this notification for **temporary interruptions**, such as when displaying system alerts. It also posts this notification before transitioning your app to the background state. UIKit places the scene object in the object property of the notification.
> 
> Use this notification to quiet your interface and prepare it to stop interacting with the user. Specifically, pause ongoing tasks, **disable timers**, and decrease frame rates or stop updating your interface altogether. Games should use this notification to pause the game. By the time your handler method returns, your app should be doing minimal work while it waits to transition to the background or to the foreground again.

[Apple Developer Documentation - didActivateNotification](https://developer.apple.com/documentation/uikit/uiscene/3197920-didactivatenotification)

> Use this notification to prepare your scene to be onscreen. UIKit posts this notification after loading the interface for your scene, but **before that interface appears onscreen**. Use it to refresh the contents of views, **start timers**, or increase frame rates for your UI. UIKit places the scene object in the object property of the notification.
