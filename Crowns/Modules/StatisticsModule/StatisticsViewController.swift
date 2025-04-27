//
//  StatisticsViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let interactor: StatisticsBusinessLogic
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                    tapped: UIImageView(image: Images.backButtonTap))
    private let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Crowns", "Killer-Sudoku"])
    private let statisticCat: UIImageView = UIImageView(image: Images.statisticCat)
    private let tableView = UITableView()
    private var currentGameType: StatisticsModel.GameType = .crowns
    private var statistics: [StatisticsModel.StatisticItem] = []
    
    lazy var barButtonItem = UIBarButtonItem()
    
    init(interactor: StatisticsBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        interactor.getGameType(StatisticsModel.OpenStatistics.Request())
        updateStatistics(game: currentGameType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureUI() {
        configureBackground()
        configureTable()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = Colors.lightGray
        segmentedControl.selectedSegmentTintColor = Colors.yellow
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: Colors.white,
            .font: UIFont(name: Text.fontIrishGrover, size: 20)
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: Colors.darkGray,
            .font: UIFont(name: Text.fontIrishGrover, size: 20)
        ], for: .selected)
        
        view.addSubview(segmentedControl)
        view.addSubview(statisticCat)
        
        segmentedControl.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        segmentedControl.pinCenterX(to: view)
        statisticCat.pinCenterX(to: view)
        statisticCat.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 10)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func configureTable() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StatisticCell")
        tableView.backgroundColor = Colors.darkGray
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
        
        tableView.pinTop(to: segmentedControl.bottomAnchor, 20)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: statisticCat.topAnchor, 20)
    }
    
    func setGameType(_ viewModel: StatisticsModel.OpenStatistics.ViewModel) {
        currentGameType = viewModel.gameType
        if currentGameType == .crowns {
            segmentedControl.selectedSegmentIndex = 0
        } else {
            segmentedControl.selectedSegmentIndex = 1
        }
        updateStatistics(game: currentGameType)
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(StatisticsModel.RouteBack.Request())
    }
    
    @objc private func segmentChanged() {
        currentGameType = segmentedControl.selectedSegmentIndex == 0 ? .crowns : .killerSudoku
        updateStatistics(game: currentGameType)
    }
    
    private func updateStatistics(game: StatisticsModel.GameType) {
        if game == StatisticsModel.GameType.crowns {
            statistics = CoreDataCrownsStatisticStack.shared.getStatistics()
        } else {
            statistics = CoreDataSudokuStatisticStack.shared.getStatistics()
        }
        tableView.reloadData()
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statistics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stat = statistics[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: Text.fontIrishGrover, size: 20)
        cell.textLabel?.text = "\(stat.title): \(stat.value)"
        cell.textLabel?.textColor = Colors.white
        cell.backgroundColor = Colors.darkGray
        
        return cell
    }
}
