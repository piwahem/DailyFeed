//
//  DailyFeedNewsController+Extension.swift
//  DailyFeed
//
//  Created by Sumit Paul on 03/01/17.
//

import UIKit
import Foundation
import MobileCoreServices

// MARK: - CollectionView Delegate Methods
extension DailyFeedNewsController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return self.newsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.performBatchUpdates(nil, completion: nil)
        if let cell = collectionView.cellForItem(at: indexPath) {
            selectedCell = cell
            self.router?.navigateToDetail(sender: cell)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dailyFeedItemCell,
                                                          for: indexPath)
        gridCell?.configure(with: newsItems[indexPath.row], ltr: isLanguageRightToLeft)
        return gridCell!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            if (!isLastPage){
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.dailyFeedLoadingReusableView.identifier, for: indexPath) as! DailyFeedLoadingReusableView
                footerView.bind()
                return footerView
            }else{
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.dailyFeedBottomReusableView.identifier, for: indexPath) as! DailyFeedBottomReusableView
                footerView.bind()
                return footerView
            }
            
        default:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.dailyFeedBottomReusableView.identifier, for: indexPath) as! DailyFeedBottomReusableView
            footerView.bind()
            return footerView
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 10)
    }
}

// MARK: - Drag & Drop Delegate Methods

@available(iOS 11.0, *)
extension DailyFeedNewsController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let dragPreviewParameters = UIDragPreviewParameters()
        if let cell = collectionView.cellForItem(at: indexPath) {
            dragPreviewParameters.backgroundColor = UIColor.white
            dragPreviewParameters.visiblePath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius)
            
        }
        return dragPreviewParameters
    }
    
    func dragItems(indexPath: IndexPath) -> [UIDragItem] {
        let cell = newsCollectionView?.cellForItem(at: indexPath)
        cell?.clipsToBounds = true
        let draggedNewsItem = newsItems[indexPath.row]
        let itemProvider = NSItemProvider(object: draggedNewsItem)
        return [UIDragItem(itemProvider: itemProvider)]
    }
}

extension DailyFeedNewsController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Begin asynchronously fetching data for the requested index paths.
        if isLoadingCell(for: indexPath) {
            if (isLastPage || isLoadingMore) {
                return
            }
            paginationWorkItem?.cancel()
            isLoadingMore = true
            //            showLoading()
            
            let workerItem = DispatchWorkItem{
                self.interactor?.getNews()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workerItem)
            paginationWorkItem = workerItem
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == newsItems.count - 1
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = newsCollectionView.indexPathsForVisibleItems ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func showLoading() {
        self.newsItems.append(DailyFeedModel.itemBottom())
        newsCollectionView.reloadData()
    }
    
    func hideLoading() {
        self.newsItems = self.newsItems.filter{$0.url != DailyFeedItemType.itemBottom.rawValue}
        newsCollectionView.reloadData()
    }
}

