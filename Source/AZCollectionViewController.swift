//
//  AZTableViewController.swift
//  AZTableView
//
//  Created by Muhammad Afroz on 7/28/17.
//  Copyright © 2017 AfrozZaheer. All rights reserved.
//

import UIKit

open class AZCollectionViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet open var collectionView: UICollectionView?
    fileprivate var nextPageLoaderCell: UICollectionViewCell?

    
    //MARK: - Properties 
    
    let refresh: UIRefreshControl = UIRefreshControl()
    @IBOutlet open var noResults: UIView?
    @IBOutlet open var loadingView: UIView?
    @IBOutlet open var errorView: UIView?
    
    open var numberOfItemsBeforeFetch = 3
    
    open var nextLoadingCellNibName = "NextPageLoaderCell"
    open var nextLoadingCellIdentifier = "NextPageLoaderCell"
    open var nextLoadingCellSize : CGSize?
    
//    weak var delegate: AZCollectionViewDelegate? = nil
    
    var numberOfRows = 0
    open var haveMoreData = false
    open var isFetchingData = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        refresh.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        collectionView?.addSubview(refresh)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.contentInset = UIEdgeInsetsMake(4, 4, 4, 4)
        nextLoadingCellSize = CGSize(width: (collectionView?.frame.size.width)!, height: 44) // default cell size
        
        loadDefaultsViews()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func loadDefaultsViews(bundle: Bundle? = Utility.getBundle()) {
        
        loadNextPageLoaderCell(nibName: nextLoadingCellNibName, cellIdentifier: nextLoadingCellIdentifier , bundle: bundle)
        loadErrorView(nibName: "ErrorView", bundle: bundle)
        loadNoResultView(nibName: "NoResultView", bundle: bundle)
        loadLoadingView(nibName: "LoadingView" , bundle: bundle)
    }
    
    public func loadNextPageLoaderCell(nibName: String, cellIdentifier: String, bundle: Bundle? = Bundle.main) {
        
        if nextPageLoaderCell == nil {
            let loaderCell = UINib(nibName: nibName, bundle: bundle)
            collectionView?.register(loaderCell, forCellWithReuseIdentifier: cellIdentifier)
            nextPageLoaderCell = UICollectionViewCell()
        }
    }
    
    
    public func loadErrorView(nibName: String ,bundle: Bundle? = Bundle.main) {
        if errorView == nil {
            errorView = bundle?.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        }
    }
    
    
    public func loadNoResultView(nibName: String ,bundle: Bundle? = Bundle.main) {
        if noResults == nil {
            noResults = bundle?.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        }
    }
    
    
    public func loadLoadingView(nibName: String ,bundle: Bundle? = Bundle.main) {
        if loadingView == nil {
            loadingView = bundle?.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        }
    }
    
    
}

extension AZCollectionViewController {
   open func AZCollectionView(_ collectionView: UICollectionView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
   open func AZCollectionView(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
   open func AZCollectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension AZCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if showNextPageLoaderCell(collectionView: collectionView, section: indexPath.section, row: indexPath.row) {
            if !self.isFetchingData {
                fetchNextData()
            }
            
            nextPageLoaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: nextLoadingCellIdentifier, for: indexPath)
            return nextPageLoaderCell!
        }
        
        if shouldfetchNextData(collectionView: collectionView, indexPath: indexPath) {
            fetchNextData()
        }
        
        return AZCollectionView(collectionView, cellForRowAt: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if showNextPageLoaderCell(collectionView: collectionView, section: section) {
            return AZCollectionView(collectionView, numberOfRowsInSection: section) + 1
        }
        
        return AZCollectionView(collectionView, numberOfRowsInSection: section)
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if showNextPageLoaderCell(collectionView: collectionView, section: indexPath.section, row: indexPath.row) {
            return nextLoadingCellSize!
        }
        
        return AZCollectionView(collectionView, heightForRowAt: indexPath)
    }
}


//MARK: - For Api's
extension AZCollectionViewController {
    
    @objc open func fetchData()  {
        numberOfRows = 0
        refresh.endRefreshing()
        hideNoResultsView()
        hideErrorView()
        hideNoResultsLoadingView()
        showNoResultsLoadingView()
        
        isFetchingData = true
        
    }
    
    open func didfetchData(resultCount: Int, haveMoreData: Bool) {
        hideNoResultsLoadingView()
        isFetchingData = false
        self.haveMoreData = haveMoreData
        if resultCount > 0 {
            numberOfRows += resultCount
            hideNoResultsView()
            collectionView?.reloadData()
        }
        else {
            if numberOfRows <= 0 {
                showNoResultsView()
            }
        }
    }
    
    open func fetchNextData () {
        isFetchingData = true
        hideErrorView()
    }
    
    open func errorDidOccured(error: Error?) {
        isFetchingData = false
        hideNoResultsView()
        hideErrorView()
        hideNoResultsLoadingView()
        if numberOfRows > 0 {
            let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                
            })
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            showErrorView(error: error)
        }
    }
    
    
    open func showNextPageLoaderCell (collectionView: UICollectionView? = nil, section: Int? = nil, row: Int? = nil) -> Bool {
       
        if /*nextPageLoaderCell != nil,*/ haveMoreData {
        
            if let collectionView = collectionView, let section = section {
                // check if last section
                if self.numberOfSections(in: collectionView) != section + 1 {
                    return false
                }
                
                if let row = row {
                    // check if last row
                    if self.collectionView?.numberOfItems(inSection: section) != row + 1 {
                        return false
                    }
                }
            }
            
            return true
        }
        
        return false
    }
    
    open func shouldfetchNextData(collectionView: UICollectionView, indexPath: IndexPath) -> Bool {
        if self.isFetchingData || !self.haveMoreData || self.nextPageLoaderCell == nil {
            return false
        }
        
        // if not last section
        if self.numberOfSections(in: collectionView) != indexPath.section + 1 {
            return false
        }
        
        if indexPath.row >= self.collectionView(collectionView, numberOfItemsInSection: indexPath.section) - numberOfItemsBeforeFetch {
            return true
        }
        
        return false
    }
    
    
}

//MARK: - Show Hide error loading Views
extension AZCollectionViewController {
    
    func showNoResultsView() {
        if noResults != nil{
            noResults?.isHidden = false
            noResults?.frame = getFrame()
            collectionView?.addSubview(noResults!)
        }
    }
    func hideNoResultsView() {
        if noResults != nil{
            collectionView?.willRemoveSubview(noResults!)
            noResults?.removeFromSuperview()
        }
    }
    func showNoResultsLoadingView() {
        if loadingView != nil{

            loadingView?.isHidden = false
            loadingView?.frame = getFrame()
            collectionView?.addSubview(loadingView!)
            refresh.endRefreshing()
            collectionView?.isUserInteractionEnabled = false
        }
    }
    func hideNoResultsLoadingView() {
        if loadingView != nil{
            
            collectionView?.willRemoveSubview(loadingView!)
            loadingView?.removeFromSuperview()
            collectionView?.isUserInteractionEnabled = true
    
        }
    }
    func showErrorView(error: Error?) {
        if errorView != nil{

            errorView?.isHidden = false
            errorView?.frame = getFrame()
            collectionView?.addSubview(errorView!)
        }
    }
    func hideErrorView() {
        if errorView != nil{
            collectionView?.willRemoveSubview(errorView!)
            errorView?.removeFromSuperview()
        }
    }
    func getFrame() -> CGRect{
        return CGRect(x: 0, y: 0, width: (collectionView?.frame.size.width)!, height: (collectionView?.frame.size.height)!)
    }
}
