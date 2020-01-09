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
    func onList(_ list: [DailySourceModel],_ isLastPage: Bool)
    func onError(_ message: String)
    func onShowDialog(type dialog: SourceTypeDialog, filterSources: [String])
}

extension NewsSourceViewController: ISourceView{
    
    func onLoading() {
        setupSpinner(hidden: false)
        isLoadingMore = true
    }
    
    func onList(_ list: [DailySourceModel],_ isAtLastPage: Bool) {
        isLastPage = isAtLastPage
        self.sourceItems = list
        setupSpinner(hidden: true)
        hideLoading()
        isLoadingMore = false
    }
    
    func onError(_ message: String) {
        self.showError(message) { _ in
            //            self.dismiss(animated: true, completion: nil)
        }
        self.setupSpinner(hidden: true)
        hideLoading()
        isLoadingMore = false
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
                self.sourceTableView.reloadData()
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
        params = NewsSourceParameters()
        setupPullToReach()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultsSearchController.delegate = nil
        resultsSearchController.searchBar.delegate = nil
        paginationWorkItem?.cancel()
        
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
        sourceTableView.tableFooterView = getBottomView()
        sourceTableView.prefetchDataSource = self
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
            self.params = newsSourceParameters
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
        if (isLoading(sourceItems[indexPath.row])){
            let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.dailySourceLoadingCell, for: indexPath)
            cell?.bind()
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.dailySourceItemCell, for: indexPath)
            if self.resultsSearchController.isActive {
                cell?.bind(item: filteredSourceItems[indexPath.row], position: indexPath.row)
            } else {
                cell?.bind(item: sourceItems[indexPath.row], position: indexPath.row)
            }
            return cell!
        }
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
    var searchExcutor: ISearchExecutor?
    func updateSearchResults(for searchController: UISearchController) {
        filteredSourceItems.removeAll(keepingCapacity: false)
        searchExcutor?.execute(action: { (searchString) in
            let searchResults = self.sourceItems.filter { $0.name?.lowercased().contains(searchString.lowercased()) ?? false }
            self.filteredSourceItems = searchResults
        })
    }
    
    var params: NewsSourceParameters = NewsSourceParameters() {
        didSet{
            self.interactor?.getSources(params: params)
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
        
        searchExcutor = SourceSearchExecutor(searchController: self.resultsSearchController)
    }
}

extension NewsSourceViewController: UITableViewDataSourcePrefetching{
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            if (isLastPage || isLoadingMore) {
                return
            }
            
            paginationWorkItem?.cancel()
            isLoadingMore = true
            showLoading()
            
            let workerItem = DispatchWorkItem{
                self.interactor?.getSources(params: self.params)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workerItem)
            paginationWorkItem = workerItem
        }
    }
    
}

var isLoadingMore = false
var isLastPage = false
var paginationWorkItem: DispatchWorkItem?

private extension NewsSourceViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        let lastRow = sourceTableView.indexPathsForVisibleRows?.last
        let isLastVisible =  lastRow?.row ?? 0 == sourceItems.count - 1
        return isLastVisible
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = sourceTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    var loadingItem: DailySourceModel {
        get {
            return DailySourceModel(sid: "loading", name: nil, category: nil, description: nil, isoLanguageCode: nil, country: nil, url: nil)
        }
    }
    
    func showLoading() {
        //        self.sourceItems.append(loadingItem)
        //        sourceTableView.reloadData()
        sourceTableView.tableFooterView = getLoadingView()
    }
    
    func hideLoading() {
        //        self.sourceItems = self.sourceItems.filter{$0.sid != "loading"}
        //        sourceTableView.reloadData()
        sourceTableView.tableFooterView = getBottomView()
    }
    
    func isLoading(_ loadingItem: DailySourceModel) -> Bool {
        return loadingItem.sid == "loading"
    }
    
    func getTextLoadingView() -> UIView{
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: sourceTableView.frame.width, height: 60))
        customView.backgroundColor = UIColor.clear
        let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:customView.frame.width,height:40))
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        titleLabel.text  = "Loading...."
        titleLabel.textAlignment = .center
        customView.addSubview(titleLabel)
        return customView
    }
    
    func getLoadingView() -> UIView {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.startAnimating()
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: sourceTableView.bounds.width, height: 40.0)
        indicator.center = view.center
        return indicator
    }
    
    func getBottomView() -> UIView {
        return UIView(frame: CGRect.init(x: 0, y: 0, width: sourceTableView.bounds.width, height: 50))
    }
}
