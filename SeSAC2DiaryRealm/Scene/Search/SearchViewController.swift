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
    
   lazy var searchBar: UISearchBar = {
       let view = UISearchBar()
        return view
    }()
    
    lazy var tableView: UITableView =  {
        let view = UITableView() // 커스텀으로 이후에 만들기
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.register(SearchTablaViewCell.self, forCellReuseIdentifier: SearchTablaViewCell.reuseIdentifier)
        
        return view
    }()

    //MARK: 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        [searchBar, tableView].forEach { view.addSubview($0) }
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
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTablaViewCell.reuseIdentifier, for: indexPath) as? SearchTablaViewCell else { return UITableViewCell() }
        cell.backgroundColor = .brown
        return cell
    }
    
    
}
