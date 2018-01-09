//
//  ViewController.swift
//  AZ-CollectionViewController
//
//  Created by Muhammad Afroz on 8/21/17.
//  Copyright © 2017 AfrozZaheer. All rights reserved.
//

import UIKit
import AZCollectionViewController
import ADMozaicCollectionViewLayout

class ViewController: AZCollectionViewController {
   
    var lastIndex = 0
    var results = [String]()
    @IBOutlet var mozaikLayout: ADMozaikLayout!

    override func viewDidLoad() {
        
        nextLoadingCellNibName = "LoadingCollectionViewCell"
        nextLoadingCellIdentifier = "LoadingCollectionViewCell"
        loadNextPageLoaderCell(nibName: nextLoadingCellNibName, cellIdentifier: nextLoadingCellIdentifier)
        
        super.viewDidLoad()
        self.fetchData()
        
        self.automaticallyAdjustsScrollViewInsets = false
        mozaikLayout.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

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

extension ViewController: ADMozaikLayoutDelegate {
    //MARK: - ADMozaikLayoutDelegate
    
    func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo {
        let rowHeight: CGFloat = (collectionView.frame.size.width/3)
        let columns = [ADMozaikLayoutColumn(width: rowHeight), ADMozaikLayoutColumn(width: rowHeight), ADMozaikLayoutColumn(width: rowHeight)]
        let geometryInfo = ADMozaikLayoutSectionGeometryInfo(rowHeight: rowHeight,
                                                             columns: columns,
                                                             minimumInteritemSpacing: 1,
                                                             minimumLineSpacing: 1,
                                                             sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                                             headerHeight: 0, footerHeight: 0)
        return geometryInfo
    }
    
    func collectionView(_ collectionView: UICollectionView, mozaik layout: ADMozaikLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize {
       
        if showNextPageLoaderCell(collectionView: collectionView, section: indexPath.section, row: indexPath.row) {
            return ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 1)
        }
        else {
            if indexPath.item == 1 {
                return ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2)

            }
            else if indexPath.item == 21 {
                return ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2)

            }
            return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1)
        }

    }
}

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
                if self.results.count < 50 { // you probably get next page exist from service.
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
