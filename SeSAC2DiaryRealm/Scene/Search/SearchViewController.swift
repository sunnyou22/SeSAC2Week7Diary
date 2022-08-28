//
//  SearchViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 방선우 on 2022/08/28.
//

import UIKit
import RealmSwift
import SnapKit

class SearchViewController: BaseViewController {
    
    let repository = UserDiaryRepository()
    var tasks: Results<UserDiary_re>!
    
   lazy var searchBar: UISearchBar = {
       let view = UISearchBar()
        return view
    }()
    
    lazy var tableView: UITableView =  {
        let view = UITableView() // 커스텀으로 이후에 만들기
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        
        return view
    }()

    //MARK: 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        searchBar.searchTextField.addTarget(self, action: #selector(doKeyboardDown), for: .editingDidEndOnExit)
        [searchBar, tableView].forEach { view.addSubview($0) }
    }
    
    @objc func doKeyboardDown() {
        searchBar.resignFirstResponder()
        tableView.reloadData()
        print("키보드 내려감")
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(0)
            make.leading.trailing.equalTo(view.safeAreaInsets).offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    
    func fetchRealm() {
       tasks = repository.fetch()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let searchBarText = searchBar.searchTextField.text, !searchBarText.isEmpty else {
            print("=====> 검색창이 비어있습니다(cell 갯수)")
            return 0
        }
        return repository.fetchFilterKeyword(searchBarText).count
        print(repository.fetchFilterKeyword(searchBarText).count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        guard let searchBarText = searchBar.searchTextField.text, !searchBarText.isEmpty else {
            print("=====> 검색창이 비어있습니다(cellForRowAt")
            return UITableViewCell()
        }
        
        tasks = repository.fetchFilterKeyword(searchBarText)
//        tableView.reloadData()
        cell.setData(data: tasks[indexPath.row])
        
        
        return cell
    }
}
