//
//  NewsSourceViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 29/12/16.
//

import UIKit
import DZNEmptyDataSet
import PromiseKit
import PullToReach

protocol ISourceView: class {
    func onLoading()
    func onList(_ list: [DailySourceModel])
    func onError(_ message: String)
    func onShowDialog(type dialog: SourceTypeDialog, filterSources: [String])
}

extension NewsSourceViewController: ISourceView{
    
    func onLoading() {
        setupSpinner(hidden: true)
    }
    
    func onList(_ list: [DailySourceModel]) {
        self.sourceItems = list
        setupSpinner(hidden: false)
    }
    
    func onError(_ message: String) {
        self.showError(message) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        setupSpinner(hidden: false)
    }
    
    func onShowDialog(type dialog: SourceTypeDialog, filterSources: [String]){
        presentFilterDialog(dialog: dialog, source: filterSources)
    }
    
}

class NewsSourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, PullToReach {
    
    var scrollView: UIScrollView {
        return sourceTableView
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak private var sourceTableView: UITableView!
    
    private lazy var categoryBarButton =
        UIBarButtonItem(image: R.image.filter(), style: .plain,
                        target: self, action: #selector(NewsSourceViewController.handleClickCategory))
    
    private lazy var languageBarButton =
        UIBarButtonItem(image: R.image.language(), style: .plain,
                        target: self, action: #selector(NewsSourceViewController.handleClickLanguage))
    
    private lazy var countryBarButton =
        UIBarButtonItem(image: R.image.country(), style: .plain,
                        target: self, action: #selector(NewsSourceViewController.handleClickCountry))
    
    private lazy var closeBarButton =
        UIBarButtonItem(image: R.image.close(), style: .plain,
                        target: self, action: #selector(NewsSourceViewController.dismissViewController))
    
    // MARK: - Variable declaration
    private var sourceItems: [DailySourceModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.sourceTableView.reloadSections([0], with: .automatic)
                self.setupSpinner(hidden: true)
            }
        }
    }
    
    private var filteredSourceItems: [DailySourceModel] = [] {
        didSet {
            self.sourceTableView.reloadSections([0], with: .automatic)
        }
    }
    
    var selectedItem: DailySourceModel?
        
    private var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.placeholder = "Search Sources..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .black
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    private let spinningActivityIndicator = TSSpinnerView()
    
    // MARK: - ViewController Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupUI()
        loadSourceData(sourceRequestParams: NewsSourceParameters())
        setupPullToReach()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultsSearchController.delegate = nil
        resultsSearchController.searchBar.delegate = nil
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupSearch()
        setupTableView()
    }
    
    private func setupPullToReach() {
        self.navigationItem.rightBarButtonItems = [
            closeBarButton,
            categoryBarButton,
            languageBarButton,
            countryBarButton
        ]
        self.activatePullToReach(on: navigationItem)
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
    private func setupTableView() {
        sourceTableView.register(R.nib.dailySourceItemCell)
        sourceTableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: sourceTableView.bounds.width, height: 50))
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
        self.sourceTableView.delegate = nil
        self.sourceTableView.dataSource = nil
    }
    
    // MARK: - Show News Categories
    @objc private func handleClickCategory(){
        interactor?.showDialog(type: SourceTypeDialog.category)
    }
    
    @objc private func handleClickLanguage(){
        interactor?.showDialog(type: SourceTypeDialog.language)
    }
    
    @objc private func handleClickCountry(){
        interactor?.showDialog(type: SourceTypeDialog.country)
    }
    
    private func presentFilterDialog(dialog type: SourceTypeDialog, source: [String]){
        let popOver = showFilterDialog(sources: source, type: type) { (newsSourceParameters, source) in
            if (type == .country){
                self.countryBarButton.image = nil
                self.countryBarButton.title = source.countryFlagFromCountryCode
            }
            self.interactor?.getSources(params: newsSourceParameters)
        }
        
        // Popover for iPad only
        popOver?.barButtonItem = countryBarButton
    }
    
    @objc private func dismissViewController() {
        router?.passDataToNews()
    }
    
    // MARK: - Load data from network
    private func loadSourceData(sourceRequestParams: NewsSourceParameters) {
        interactor?.getSources(params: sourceRequestParams)
    }
    
    // MARK: - Status Bar Color and switching actions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsSearchController.isActive {
            return self.filteredSourceItems.count
        } else {
            return self.sourceItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.dailySourceItemCell, for: indexPath)
        if self.resultsSearchController.isActive {
            cell?.sourceImageView.downloadedFromLink(NewsSource.logo(source: filteredSourceItems[indexPath.row].sid ?? "").url)
        } else {
            cell?.sourceImageView.downloadedFromLink(NewsSource.logo(source: sourceItems[indexPath.row].sid!).url)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultsSearchController.isActive {
            self.selectedItem = filteredSourceItems[indexPath.row]
        } else {
            self.selectedItem = sourceItems[indexPath.row]
        }
        router?.passDataToNews()
    }
    
    
    // MARK: - SearchBar Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredSourceItems.removeAll(keepingCapacity: false)
        
        if let searchString = searchController.searchBar.text {
            let searchResults = sourceItems.filter { $0.name?.lowercased().contains(searchString.lowercased()) ?? false }
            filteredSourceItems = searchResults
        }
    }
    
    var router: ISourceRouter?
    var interactor: ISourceInteractor?
    private func config() {
        let presenter = SourcePresenter()
        interactor = SourceInteractor(worker: SourceWorker())
        router = SourceRouter()
        (router as! SourceRouter).viewController = self
        (presenter as! SourcePresenter).view = self
        (interactor as! SourceInteractor).presenter = presenter
    }
}
