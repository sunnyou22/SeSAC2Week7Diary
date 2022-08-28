//
//  HomeViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift //Realm 1. import
import FSCalendar

class HomeViewController: BaseViewController {
    
    let repository = UserDiaryRepository() // 위에꺼대신 쓰기
    
    lazy var calendar: FSCalendar = { //딜리게이트 등때문에 lazy로 함
        let view = FSCalendar()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var tableView: UITableView = { //초기화 이후에 실행될 수 있다는 lazy 이렇게 옮기는게 답은 아님
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    var tasks: Results<UserDiary_re>! {
        didSet {
            tableView.reloadData() // 테이블이 바뀌면 갱신을 해라 -> 여러군데에서 할 필요가 사라짐
            print("Tasks Changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDocumentZipFile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        //화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
        //present, overCurrentContext, overFullScreen > viewWillAppear X
        //        tableView.reloadData()
        
        //Realm 3. Realm 데이터를 정렬해 tasks 에 담기
        fetchRealm()
        //
        //        tableView.reloadData()
    }
    
    func fetchRealm() {
        
        // Realm3. 데이터를 정렬해 tasks에 담기
        tasks = repository.fetch()
    }
    
    override func configure() {
        view.addSubview(tableView)
        view.addSubview(calendar)
        
        let plus = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        let backUp = UIBarButtonItem(image: UIImage(systemName: "archivebox.fill"), style: .plain, target: self, action: #selector(goBackUpPage))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let sortedButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        navigationItem.leftBarButtonItems = [filterButton, sortedButton]
        navigationItem.rightBarButtonItems = [plus, backUp]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(calendar.snp.bottom).offset(0)
        }
        calendar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }
    
    //MARK: - 버튼
    
    @objc func goBackUpPage() {
        let vc = BackupViewController()
        transition(vc, transitionStyle: .push)
    }
    
    @objc func plusButtonClicked() {
        let vc = WriteViewController()
        vc.transitionFetchfunction = fetchRealm
        transition(vc, transitionStyle: .presentNavigation)
    }
    
    //realm filter query, NSPredicate

    @objc func sortButtonClicked() {
        tasks = repository.fetchSort("regdate")
    }
    
    // ==이 아니라 몽고의 조건문 규칙을 써줘야함
    // 띄어쓰기하면 ''로 묶어줘야 찾을 수 있음
    @objc func filterButtonClicked() {
        //        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle = '오늘의 일기171'")
        tasks = repository.fetchFilterKeyword("일기")
    }
}

//MARK: - 테이블뷰 extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tasks.count)
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeTableViewCell else { return UITableViewCell() }
        
        let item = tasks[indexPath.row]
        print(item.objectId)
        
            //이미지 화면에 반영하기
            cell.diaryImageView.image = loadImageFromDocument(fileName: "\(item.objectId).jpg")
            cell.setData(data: item)
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let item = tasks[indexPath.row]
        
        if editingStyle == .delete {
            repository.deleteRecord(item: self.tasks[indexPath.row])
        }
        
        self.fetchRealm()
    }
    
    //뷰안에 버튼이 들어가는 식이라고 했나?
    //칸이 좁으면 버튼의 타이틀이 짤리기도 함
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("favorite ButtonClicked")
            
            //real data update
            self.repository.updateFavortie(item: self.tasks[indexPath.row])
            
            // 1.스와이프한 셀 하나만 reloadRows 코드 구현 -> 상대적으로 효율적
            //2, 데이터가 변경됐으니 다시 Realm에서 데이터 가져오기 => didset 일관적 형태로 갱신
            self.fetchRealm()
        }
        
        let example = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            print("example ButtonClicked")
        }
        
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [favorite, example])
    }
    
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
    //            print("favorite ButtonClicked")
    //        }
    //
    //        let example = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
    //            print("favorite ButtonClicked")
    //        }
    //
    //        return UISwipeActionsConfiguration(actions: [favorite, example])
    //
    //    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let vc = WriteViewController()
    //
    //        present(vc, animated: true)
    //
    //    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        return repository.fetchDate(date: date).count
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "새싹"
//    }
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star.fill")
//    }
    
//    //캘린더도 컬렉션뷰셀임 그래서 크기를 변경할 수 있음
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        <#code#>
//    }

    //date: yyyyMMdd hh:mm:ss까지 맞아야 가져와줌 -> dateFormatter로 매칭하기 쉬운 형태로 바꿔줌
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return formatter.string(from: date) == "220907" ? "오프라인 모임" : nil
    }

    // 날짜 기준으로 필터를 해서 3개만 보여주기
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchDate(date: date)
        tableView.reloadData()
    }
}

// 캘린더 쓰고 나니까 일기 삭제하면 오류가 나요 -> 현재 데이터들이 꼬여있음
