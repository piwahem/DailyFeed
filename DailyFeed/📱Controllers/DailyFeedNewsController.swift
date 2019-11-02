//
//  ViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import UIKit
import Lottie
import DZNEmptyDataSet
import PromiseKit

protocol INewsView: class {
    func onLoading()
    func onList(_ list: [DailyFeedModel])
    func onError(_ message: String)
}

extension DailyFeedNewsController: INewsView{
    
    func onLoading() {
        if !self.refreshControl.isRefreshing {
            setupSpinner()
        }
        
        spinningActivityIndicator.start()
    }
    
    func onList(_ list: [DailyFeedModel]) {
        self.newsItems = list
        self.navBarSourceImage.downloadedFromLink(NewsSource.logo(source: (self.interactor?.source)!).url, contentMode: .scaleAspectFit)
        
        self.spinningActivityIndicator.stop()
        self.refreshControl.endRefreshing()
    }
    
    func onError(_ message: String) {
        showError(message)
        
        self.spinningActivityIndicator.stop()
        self.refreshControl.endRefreshing()
    }
}

class DailyFeedNewsController: UIViewController {
    
    // MARK: - Variable declaration
    var presenter: INewsPresenter?
    var interactor: INewsInteractor?
    var router: INewsRouter?
    
    var newsItems: [DailyFeedModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.newsCollectionView?.reloadData()
            }
        }
    }
    
    let spinningActivityIndicator = TSSpinnerView()
    
    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    var selectedIndexPath: IndexPath?
    
    private let transition = NewsDetailPopAnimator()
    
    var selectedCell = UICollectionViewCell()
    
    var isLanguageRightToLeft = Bool()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var newsCollectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    // MARK: - View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        config()
        
        //Setup UI
        setupUI()
        //Populate CollectionView Data
        loadNewsData()
        Reach().monitorReachabilityChanges()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        newsCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let navBarSourceImage: TSImageView = {
        let image = TSImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: -Config
    private func config() {
        presenter = NewsPresenter()
        interactor = NewsInteractor(worker: NewsWorker())
        router = NewsRouter()
        
        (router as! NewsRouter).viewController = self
        (presenter as! NewsPresenter).view = self
        (interactor as! NewsInteractor).presenter = presenter
    }
    
    // MARK: - Setup UI
    func setupUI() {
        setupNavigationBar()
        setupCollectionView()
    }
    
    // MARK: - Setup navigationBar
    func setupNavigationBar() {
        let sourceMenuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "sources"), style: .plain, target: self, action: #selector(sourceMenuButtonDidTap))
        navigationItem.rightBarButtonItem = sourceMenuButton
        navBarSourceImage.downloadedFromLink(NewsSource.logo(source: (self.interactor?.source)!).url, contentMode: .scaleAspectFit)
        navigationItem.titleView = navBarSourceImage
    }
    
    // MARK: - Setup CollectionView
    func setupCollectionView() {
        newsCollectionView?.register(R.nib.dailyFeedItemCell)
        newsCollectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(DailyFeedNewsController.refreshData(_:)),
                                 for: UIControl.Event.valueChanged)
        newsCollectionView?.emptyDataSetDelegate = self
        newsCollectionView?.emptyDataSetSource = self
        
        if #available(iOS 11.0, *) {
            newsCollectionView?.dragDelegate = self
            newsCollectionView?.dragInteractionEnabled = true
        }
    }
    
    // MARK: - Setup Spinner
    func setupSpinner() {
        spinningActivityIndicator.setupTSSpinnerView()
    }
    
    // MARK: - refresh news Source data
    @objc func refreshData(_ sender: UIRefreshControl) {
        loadNewsData()
    }
    
    // MARK: - Load data from network
    func loadNewsData(completion:((Bool)->(Void))?=nil) {
        interactor?.getNews()
    }
    
    deinit {
        newsCollectionView?.delegate = nil
        newsCollectionView?.dataSource = nil
    }
    
    // MARK: - sourceMenuButton Action method
    
    @objc func sourceMenuButtonDidTap() {
        self.performSegue(withIdentifier: R.segue.dailyFeedNewsController.newsSourceSegue, sender: self)
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }
    
    // MARK: - Unwind from Source View Controller
    @IBAction func unwindToDailyNewsFeed(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? NewsSourceViewController, let sourceId = sourceVC.selectedItem?.sid {
            
            let oldSource = (self.interactor?.source)!
            let oldIsLanguageRightToLeft = self.isLanguageRightToLeft
            
            isLanguageRightToLeft = sourceVC.selectedItem?.isoLanguageCode.direction == .rightToLeft
            self.interactor?.source = sourceId
            loadNewsData(){ success in
                if (!success){
                    self.showErrorWithDelay("Your Internet Connection appears to be offline.")
                    self.interactor?.source = oldSource
                    self.isLanguageRightToLeft = oldIsLanguageRightToLeft
                }
            }
        }
    }
}

extension DailyFeedNewsController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
            
        case (.regular, .regular), (.compact, .regular), (.compact, .compact):
            newsCollectionView?.collectionViewLayout.invalidateLayout()
            newsCollectionView?.collectionViewLayout = DailySourceItemiPadLayout()
            
        default:
            newsCollectionView?.collectionViewLayout.invalidateLayout()
            newsCollectionView?.collectionViewLayout = DailySourceItemLayout()
            
        }
    }
}

extension DailyFeedNewsController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    // MARK: - DZNEmptyDataSet Delegate Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Content 😥"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Connect to Internet or try another source."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "placeholder")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

extension DailyFeedNewsController: UIViewControllerTransitioningDelegate {
    
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


