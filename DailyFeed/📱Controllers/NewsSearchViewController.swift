//
//  NewsSearchViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 14/05/19.
//

import UIKit
import PromiseKit
import DZNEmptyDataSet

protocol INewsSearchView: class {
    func onLoading()
    func onList(_ list: [DailyFeedModel])
    func onError(_ message: String)
}

extension NewsSearchViewController: INewsSearchView{
    func onLoading() {
        setupSpinner(hidden: false)
    }
    
    func onList(_ list: [DailyFeedModel]) {
        self.searchItems = list
        setupSpinner(hidden: true)
    }
    
    func onError(_ message: String) {
        self.showError(message)
        setupSpinner(hidden: true)
    }
}

class NewsSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating {
    
    var scrollView: UIScrollView {
        return searchCollectionView
    }
    
    //MARK: - Config
    var router: INewsSearchRouter?
    var interactor: INewsSearchInteractor?
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    // MARK: - Variable declaration
    var searchItems: [DailyFeedModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchCollectionView.reloadSections([0])
                self.searchCollectionView.reloadEmptyDataSet()
                self.setupSpinner(hidden: true)
            }
        }
    }
    
    private let transition = NewsDetailPopAnimator()
    
    var selectedCell = UICollectionViewCell()
    
    
    private var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.placeholder = "Search Anything..."
        controller.searchBar.searchBarStyle = .prominent
        controller.searchBar.tintColor = .black
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    private let spinningActivityIndicator = TSSpinnerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        //setup UI
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !resultsSearchController.isActive else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.resultsSearchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultsSearchController.delegate = nil
        resultsSearchController.searchBar.delegate = nil
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupSearch()
        setupCollectionView()
    }
    
    // MARK: - Setup SearchBar
    private func setupSearch() {
        resultsSearchController.searchResultsUpdater = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultsSearchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = resultsSearchController.searchBar
        }
        definesPresentationContext = true
    }
    
    // MARK: - Setup TableView
    private func setupCollectionView() {
        searchCollectionView.register(R.nib.dailyFeedItemCell)
        searchCollectionView.emptyDataSetDelegate = self
        searchCollectionView.emptyDataSetSource = self
    }
    
    // MARK: - Setup Spinner
    private func setupSpinner(hidden: Bool) {
        DispatchQueue.main.async {
            self.spinningActivityIndicator.containerView.isHidden = hidden
            if !hidden {
                self.spinningActivityIndicator.setupTSSpinnerView()
                self.spinningActivityIndicator.start()
            } else {
                self.spinningActivityIndicator.stop()
            }
        }
    }
    
    deinit {
        self.searchCollectionView.delegate = nil
        self.searchCollectionView.dataSource = nil
    }
    
    // MARK: - Status Bar Color and switching actions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dailyFeedItemCell, for: indexPath)
        cell?.configure(with: searchItems[indexPath.row], ltr: false)
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            router?.navigateToDetail(sender: cell)
        }
        
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }
    
    
    // MARK: - SearchBar Delegate
    var searchWorkItem: DispatchWorkItem?
    func updateSearchResults(for searchController: UISearchController) {
        searchItems.removeAll(keepingCapacity: false)
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem{
            if let searchString = searchController.searchBar.text, searchString.count > 3 {
                self.loadNews(with: searchString)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: workItem)
        searchWorkItem = workItem
    }
    
    // MARK: - Load data from network
    func loadNews(with query: String) {
        interactor?.searchNews(query)
    }
    
}


extension NewsSearchViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
            
        case (.regular, .regular), (.compact, .regular), (.compact, .compact):
            searchCollectionView?.collectionViewLayout.invalidateLayout()
            searchCollectionView?.collectionViewLayout = DailySourceItemiPadLayout()
            
        default:
            searchCollectionView?.collectionViewLayout.invalidateLayout()
            searchCollectionView?.collectionViewLayout = DailySourceItemLayout()
            
        }
    }
}

extension NewsSearchViewController: UIViewControllerTransitioningDelegate {
    
    // MARK: - UIViewController Transitioning Delegate Methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedCell.superview!.convert(selectedCell.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

// MARK: - DZNEmptyDataSet Delegate Methods
extension NewsSearchViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Search for Articles above"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "search")
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.lightGray
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

extension NewsSearchViewController{
    
    private func config() {
        let presenter = NewsSearchPresenter()
        interactor = NewsSearchInteractor(worker: NewsSearchWorker())
        router = NewsSearchRouter()
        (router as! NewsSearchRouter).viewController = self
        (presenter as! NewsSearchPresenter).view = self
        (interactor as! NewsSearchInteractor).presenter = presenter
    }
}
