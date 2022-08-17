//
//  WalkThroughViewController.swift
//  SeSAC2Week7Diary
//
//  Created by 방선우 on 2022/08/16.
//

import UIKit

class WalkThroughViewController: UIPageViewController {

    //배열 형태로 뷰컨트롤러를 추가
    var pageViewControllerList: [UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPageViewController()
        configurePageViewController()
        view.backgroundColor = .lightGray
    }
    
    // 배열에 뷰컨트롤러 추가
    func createPageViewController() {
        let sb = UIStoryboard(name: "WalkThrough", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: FirstViewController.reuseIdentifier) as! FirstViewController
        let vc2 = sb.instantiateViewController(withIdentifier: SecondViewController.reuseIdentifier) as! SecondViewController
        let vc3 = sb.instantiateViewController(withIdentifier: ThirdViewController.reuseIdentifier) as! ThirdViewController
        
        pageViewControllerList = [vc1, vc2, vc3]
    }
    
    func configurePageViewController() {
        delegate = self
        dataSource = self
        
        //display
        guard let first = pageViewControllerList.first else { return } // 배열에 0번 인덱스가 있는지 확인
        setViewControllers([first], direction: .forward, animated: true) //
    }
}

extension WalkThroughViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //현재 페이지뷰컨에 보이는 뷰컨의 인텍스 먼저 가져오기
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        // 이전 인덱스
        let previousIndex = viewControllerIndex - 1 //Before니까
        
        // nil로 설정하면 런타임오류 나는게 아니라 알아서 앞으로 안넘어가게 설정되나요? 넹
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        // 이후 인덱스
        let nextIndex = viewControllerIndex + 1 //Before니까
        
        // nil로 설정하면 런타임오류 나는게 아니라 알아서 앞으로 안넘어가게 설정되나요? 넹
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count // 인티케이터에 페이지 갯수 보여줌
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        //display된 뷰컨과 그 인덱스를 가져옴, PageCurl이 아니라 Scroll로 해야함
        //이 인디케이터 영역의 위치를 커스텀으로 해주려면 복잡합...
        //현재 보여지는 화면을 배열로 받아서 인덱스가 0으로 뜨는건가?
        //인디케이터가 검은색인 이유는 페이지컨트롤러의 색상임
        guard let first = viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        
        print(index, "=========") //page컨트롤러 생명ㄴ 주기와 연결됨
        
        return index
    }
}
