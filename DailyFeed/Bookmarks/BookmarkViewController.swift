//
//  BookmarkViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 09/02/17.
//

import UIKit
import RealmSwift
import CoreSpotlight
import MobileCoreServices
import DZNEmptyDataSet

protocol IBookmarkViewController {
    func showConfirmDeleteDialog(item: ArticleRealmModel)
}

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    var newsItems: Results<ArticleRealmModel>!
    
    var notificationToken: NotificationToken? = nil
    
    var router: INewsBookmarkRouter? = nil
    var interactor: INewsBookmarkInteractor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        bookmarkCollectionView.register(R.nib.bookmarkItemsCell)
        bookmarkCollectionView.emptyDataSetDelegate = self
        bookmarkCollectionView.emptyDataSetSource = self
        if #available(iOS 11.0, *) {
            bookmarkCollectionView?.dropDelegate = self
        }
        observeDatabase()
    }
    
    func observeDatabase() {
        newsItems = interactor?.observerData(action: { (changes) in
            self.handleChangesBookmark(changes: changes)
        }, completion: { (notificationToken) in
            self.notificationToken = notificationToken
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - CollectionView Delegate Methods

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.bookmarkItemsCell, for: indexPath)
        newsCell?.configure(with: newsItems[indexPath.row])
        newsCell?.cellTapped = { cell in
            if let cellToDelete = self.bookmarkCollectionView.indexPath(for: cell)?.row {
                let item = self.newsItems[cellToDelete]
                self.interactor?.handleDeleteData(item: item)
            }
        }
        return newsCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bookmarkCollectionView.bounds.width, height: bookmarkCollectionView.bounds.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        router?.navigateToDetail(sender: cell)
    }
}

// MARK: - DZNEmptyDataSet Delegate Methods
extension BookmarkViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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
extension BookmarkViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        for coordinatorItem in coordinator.items {
            let itemProvider = coordinatorItem.dragItem.itemProvider
            if itemProvider.canLoadObject(ofClass: DailyFeedModel.self) {
                itemProvider.loadObject(ofClass: DailyFeedModel.self) { (object, error) in
                    DispatchQueue.main.async {
                        if let dailyfeedmodel = object as? DailyFeedModel {
                            self.interactor?.addData(item: dailyfeedmodel)
                        } else {
                            //self.displayError(error)
                        }
                    }
                }
            }
        }
    }
}

extension BookmarkViewController: IBookmarkViewController{
    
    func showConfirmDeleteDialog(item: ArticleRealmModel) {
        confirmToDelete(deletedItem: item)
    }
}

extension BookmarkViewController{
    
    func config(){
        router = NewsBookmarkRouter()
        (router as! NewsBookmarkRouter).viewController = self
        
        interactor = NewsBookmarkInteractor(worker: NewsBookmarkWorker(), view: self)
    }
    
    private func handleChangesBookmark(changes: RealmCollectionChange<Results<ArticleRealmModel>>){
        guard let collectionview = self.bookmarkCollectionView else { return }
        switch changes {
        case .initial:
            print("BookmarkViewController handleChangesBookmark initial")
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
    
    private func confirmToDelete(deletedItem: ArticleRealmModel){
        self.showConfirmDialog(title: "", message: "Are you sure to delete this bookmark ?".localized, labelOk: "Ok".localized, labelCancel: "Cancel".localized, confirmAction: {
            self.interactor?.deleteData(item: deletedItem)
        }, cancelAction: {
            print("cancel, not delete anymore")
        })
    }
}

