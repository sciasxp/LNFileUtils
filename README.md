# LNFileUtils

Just some tools to make handling Data storage easier.

## Minimum Requirements

This framework will be usable by iOS 13 and above or MacOS 10.15 and above.

## Installing

### SPM

****LNFileUtils is available via SwiftPackage.****

Add the following to you Package.swift file's dependencies:

```swift
.package(url: "https://github.com/sciasxp/LNSFileUtils.git", from: "0.1.0"),
```

## Features

- Save/Retrieve/Remove Data to UserDefaults with Key identifier
  
- Save/Retrieve/Remove Data to FileSystem with Key identifier
  

## How to Use

```swift
import LNFileUtils
```

### Store / Retrieve / Remove Data on UserDefaults

```swift
let utils = FileUtils.shared
do {
    try utils.store (
        key: "defaultStorageTest", 
        data: <#Your Data Here#>, 
        on: .userDefaults
    )
} catch {}
```

```swift
let utils = FileUtils.shared
do {
    let data: Data? = try utils.retrieve (
        key: "defaultStorageTest", 
        on: .userDefaults
    )
} catch {}
```

```swift
let utils = FileUtils.shared
do {
    try utils.remove (
        key: "defaultStorageTest",
        on: .userDefaults
    )
} catch {}
```

### Store / Retrieve / Remove Data on File System

```swift
let utils = FileUtils.shared
do {
    let url = try utils.store (
        key: "fileSystemCacheStorageTest", 
        data: <#Your Data Here#>, 
        on: .fileSystem(place: .cache)
    )
} catch {}
```

```swift
let utils = FileUtils.shared
do {
    let data: Data? = try utils.retrieve (
        key: "fileSystemCacheStorageTest",
        on: .fileSystem(place: .cache)
    )
} catch {}
```

```swift
let utils = FileUtils.shared
do {
    try utils.remove (
        key: "fileSystemCacheStorageTest",
        on: .fileSystem(place: .cache)
    )
} catch {}
```

**place** can be one of three values:

1. cache
  
2. document
  
3. library
  

## ## Future Work

1. Improve unit tests.
  
2. Improve documentation.
  
3. Support for cocoapods
  

## Contributing

You are most welcome in contributing to this project with either new features (maybe one mentioned from the future work or anything else), refactoring and improving the code. Also, feel free to give suggestions and feedbacks. 

Created with ❤️ by Luciano Nunes.

Get in touch on [Email](mailto: sciasxp@gmail.com)

Visit:  [LinkdIn](https://www.linkedin.com/in/lucianonunesdev/)
