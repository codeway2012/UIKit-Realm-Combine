//
//  ViewController.swift
//  Demo131-RealmTest
//
//  Created by user on 8/9/24.
//

import UIKit
import Combine

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - declare
    
    private var viewModel = TodoViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    let textField = UITextField()
    let tableView = UITableView()
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TodoList"
        
        // 네비게이션 바에 '+' 버튼을 추가합니다.
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(addTodoItem)
        )
        
        // 뷰에 추가
        self.view.addSubview(textField)
        self.view.addSubview(tableView)
        
        // 테이블 뷰 설정
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // setup
        setupUI()
        setupBindings()
    }
    
    // MARK: - setup
    
    private func setupBindings() {
        // ViewModel의 todoItems가 변경될 때 UITableView를 업데이트합니다.
        viewModel.todoItemsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("tableView - reloadData")
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        // 텍스트 필드 설정
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter new todo"
        
        // 테이블 뷰 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // 오토레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    // 테이블 뷰의 행 수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableview - count : \(viewModel.todoItems.count)")
        return viewModel.todoItems.count
    }
    
    // 테이블 뷰의 셀을 설정합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = viewModel.todoItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isCompleted ? .checkmark : .none // 완료 체크마크
        cell.selectionStyle = .none
        return cell
    }
    
    // 셀을 삭제할 때 호출됩니다.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("tableview - editingStyle delete")
            let item = viewModel.todoItems[indexPath.row]
            viewModel.deleteTodoItem(item)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    // 셀을 선택했을 때 호출됩니다. 토글 기능
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableview - cell select and checkmark toggle")
        let item = viewModel.todoItems[indexPath.row]
        viewModel.toggleCompletion(of: item)
    }
    
    
    // MARK: - objc methods
    
    // 새로운 Todo 항목을 추가할 수 있는 메서드
    @objc private func addTodoItem() {
        guard let title = textField.text, !title.isEmpty else { return }
        viewModel.addTodoItem(title: title)
        textField.text = "" // 텍스트 필드 빈값으로 초기화
    }
}
