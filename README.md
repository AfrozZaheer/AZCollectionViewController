# AZCollectionView Controller


[![Swift version](https://img.shields.io/badge/swift%20-4.0-orange.svg)](https://img.shields.io/badge/swift%20-4.0-orange.svg)
[![Support Dependecy Manager](https://img.shields.io/badge/support-CocoaPods-red.svg?style=flat.svg)](https://img.shields.io/badge/support-CocoaPods-red.svg?style=flat.svg)
[![Version](https://img.shields.io/cocoapods/v/AZTableView.svg?style=flat)](https://cocoapods.org/pods/AZTableView)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat.svg)](https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat.svg)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://cocoapods.org/pods/AZTableView)

<!--<p align="center">-->
<!--<a href="http://i.imgur.com/ECtCAYk.gif">-->
<!--<img src="http://i.imgur.com/ECtCAYk.gif" height="450">-->
<!--</a>-->
<!--</p>-->

<p align="center">
    <a href="http://i.imgur.com/rqSA6jv.gif">
        <img src="http://i.imgur.com/rqSA6jv.gif" height="480">
    </a>
</p>


## Features

* Automatic pagination handling 
* No more awkward empty CollectionView screen
* AZ CollectionVIew controller give you advantage to connect your (Loading, no result, error ) views via Interface builder
* You can also add your custom xib as dummy views (loading, error, no result)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```


To integrate AZ CollectionVIew controller into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
pod 'AZCollectionViewController'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

#### Step 1

* Extend your view controller from AZCollectionViewController
```swift 

class ViewController: AZCollectionViewController {

    var lastIndex = 0
    var results = [String]()

    override func viewDidLoad() {
    
        nextLoadingCellNibName = "LoadingCollectionViewCell"
        nextLoadingCellIdentifier = "LoadingCollectionViewCell"
        loadNextPageLoaderCell(nibName: nextLoadingCellNibName, cellIdentifier: nextLoadingCellIdentifier) // Only if you want personal NextPage loading cell
        
        super.viewDidLoad()
        self.fetchData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

```

#### Step 2

* Same as AZTableVIewController
* Set the next page loading cell outlet as given below,

![Alt text](http://i.imgur.com/SWYNa2W.png "AZTableView-step2")

![Alt text](http://i.imgur.com/Zi9RKJ2.png "AZTableView-step2")

* To load views from custom .xib files 

```swift 

class ViewController: AZCollectionViewController {
    override func viewDidLoad() {

        self.loadLoadingView(nibName: "your nib name") // if bundle is nil
        self.loadErrorView(nibName: "your nib name", bundle: yourBundle) // if custom bundle

        super.viewDidLoad()
        self.fetchData()
    }
}
```
* If your xibs are in main bundle than use 
```swift 
    self.loadLoadingView(nibName: "your nib name") // if bundle is nil
```
Else use 
```swift 
    self.loadLoadingView(nibName: "your nib name", bundle: yourBundle)
```

#### Step 3 


* And override AZCollectionView cellForRow function.

```swift 
extension ViewController {

    override func AZCollectionView(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestCollectionViewCell
        
        cell.feedImage.image = UIImage(named: self.results[indexPath.row])
        
        return cell
    }
    
    override func AZCollectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: (collectionView.frame.size.width / 3) - 6, height: (collectionView.frame.size.width / 3) - 4)
        
    }
}


```
#### Step 4

* Override two more functions "fetchData" and "fetchNextData" 

```swift 
//MARK: - API Call
extension ViewController {
    
    override func fetchData() {
        super.fetchData()
        
        FakeService.getData { (error, results) in
           
            if let resu = results {
                self.results.removeAll()
                self.results.append(contentsOf: resu)
                self.didfetchData(resultCount: resu.count, haveMoreData: true)
            }
                
            else if let error = error {
                self.errorDidOccured(error: error)
            }
        }
    }
    
    override func fetchNextData() {
        super.fetchNextData()
        
        FakeService.getData (offset: results.count) { (error, results) in
            
            if let resu = results {
                
                self.results.append(contentsOf: resu)
                if self.results.count < 45 { // you probably get next page exist from service.
                    self.didfetchData(resultCount: resu.count, haveMoreData: true)
                }
                else {
                    self.didfetchData(resultCount: resu.count, haveMoreData: false)
                }
            }
            else if let error = error {
                self.errorDidOccured(error: error)
            }
        }
    }
}

```

#### Done
Thats it, you successfully integrate AZCollectionViewController


## License

AZCollectionViewController is available under the MIT license. See the LICENSE file for more info.

## Author

**Afroz Zaheer** - (https://github.com/AfrozZaheer)

