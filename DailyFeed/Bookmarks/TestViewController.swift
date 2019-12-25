//
//  TestViewController.swift
//  DailyFeed
//
//  Created by Admin on 12/19/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import CoreSpotlight
import MobileCoreServices
import DZNEmptyDataSet

class TestViewController: UIViewController {
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    var newsItems: Results<ArticleRealmModel>!
    var notificationToken: NotificationToken? = nil
    var router: INewsBookmarkTestRouter? = nil
    var interactor: INewsBookmarkTestInteractor? = nil
    
    override func viewDidLoad() {
        config()
        bookmarkCollectionView.register(R.nib.bookmarkItemsCell)
        bookmarkCollectionView.emptyDataSetDelegate = self
        bookmarkCollectionView.emptyDataSetSource = self
        bookmarkCollectionView.dataSource = self
        bookmarkCollectionView.delegate = self
        if #available(iOS 11.0, *) {
            bookmarkCollectionView?.dropDelegate = self
        }
        
        onViewDidLoad()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    
    
    func onViewDidLoad() {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "isBookmark = %@", NSNumber(value: true))
        newsItems = realm.objects(ArticleRealmModel.self).filter(predicate)
        notificationToken = newsItems.observe { (changes) in
            self.handleChangesBookmark(changes: changes)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// MARK: - CollectionView Delegate Methods
extension TestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of item in section = \(newsItems.count)")
        return newsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.bookmarkItemsCell, for: indexPath)
        newsCell?.configure(with: newsItems![indexPath.row])
        newsCell?.cellTapped = { cell in
            if let cellToDelete = self.bookmarkCollectionView.indexPath(for: cell)?.row {
                let item = self.newsItems[cellToDelete]
                // MARK: to delete data
                self.interactor?.deleteData(item: item)
            }
        }
        return newsCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bookmarkCollectionView.bounds.width, height: bookmarkCollectionView.bounds.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        // MARK: to navigate to detail
        router?.navigateToDetail(sender: cell)
    }
}


// MARK: - DZNEmptyDataSet Delegate Methods
extension TestViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Articles Bookmarked"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Your Bookmarks will appear here."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "bookmark")
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.lightGray
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

// MARK: - Drop Delegate Methods
@available(iOS 11.0, *)
extension TestViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        for coordinatorItem in coordinator.items {
            let itemProvider = coordinatorItem.dragItem.itemProvider
            if itemProvider.canLoadObject(ofClass: DailyFeedModel.self) {
                itemProvider.loadObject(ofClass: DailyFeedModel.self) { (object, error) in
                    DispatchQueue.main.async {
                        if let dailyfeedmodel = object as? DailyFeedModel {
                            // MARK: - add data
                            self.interactor?.addData(item: dailyfeedmodel)
                        } else {
//                            self.displayError(error)
                        }
                    }
                }
            }
        }
    }
}

extension TestViewController{
    
        func config(){
            router = NewsBookmarkTestRouter()
            (router as! NewsBookmarkTestRouter).viewController = self
    
            interactor = NewsBookmarkTestInteractor(worker: NewsBookmarkTestWorker())
        }
    
    private func handleChangesBookmark(changes: RealmCollectionChange<Results<ArticleRealmModel>>){
        guard let collectionview = self.bookmarkCollectionView else { return }
        switch changes {
        case .initial:
            print("TestViewController handleChangesBookmark initial")
            collectionview.reloadData()
            break
        case .update( let data, let deletions, let insertions, let modifications):
            DispatchQueue.main.async {
                let predicate = NSPredicate(format: "isBookmark = %@", NSNumber(value: true))
                self.newsItems = self.newsItems.filter(predicate)
                collectionview.reloadData()
            }
            
            if self.newsItems.count == 0 || self.newsItems.count == 1 { collectionview.reloadEmptyDataSet() }
            break
        case .error(let error):
            fatalError("\(error)")
            break
        }
    }
}
