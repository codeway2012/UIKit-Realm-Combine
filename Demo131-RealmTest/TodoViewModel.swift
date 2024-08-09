//
//  TodoViewModel.swift
//  Demo131-RealmTest
//
//  Created by user on 8/9/24.
//

import Combine
import RealmSwift

// ViewModel 정의
class TodoViewModel: ObservableObject {
    private var realm: Realm
    private var todoNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    // Combine의 @Published로 상태 변경을 알림
    @Published var todoItems: [TodoItem] = []
    
    init() {
        // realm 초기화
        realm = try! Realm()
        print("open \(realm.configuration.fileURL!)") // realm 파일을 터미널로 열기 (realm studio)
        fetchTodoItems()
    }
    
    deinit {
        // 뷰 모델이 해제될 때 todoNotificationToken을 해제합니다.
        todoNotificationToken?.invalidate()
    }
    
    // Todo 항목을 가져와서 @Published 속성에 업데이트합니다.
    private func fetchTodoItems() {
        let results = realm.objects(TodoItem.self)
        
        // Realm 데이터베이스의 변경을 관찰합니다.
        todoNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .initial(let collection): // 초기화시
                    print("results.observe - initial")
                    self?.todoItems = Array(collection) // combine <- realm
                case .update(let collection, _, _, _): // 값 변경이 있을시
                    print("results.observe - update")
                    self?.todoItems = Array(collection) // combine <- realm
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
    
    // Todo 항목을 추가합니다.
    func addTodoItem(title: String) {
        print("addTodoItem")
        let newItem = TodoItem()
        newItem.title = title
        newItem.isCompleted = false
        
        // 트랜잭션에서 realm에 add
        try! realm.write {
            realm.add(newItem)
        }
    }
    
    // Todo 항목의 완료 상태를 토글합니다.
    func toggleCompletion(of item: TodoItem) {
        print("toggleCompletion")
        
        // 트랜잭션에서 realm에 toggle
        try! realm.write {
            item.isCompleted.toggle()
        }
    }
    
    // Todo 항목을 삭제합니다.
    func deleteTodoItem(_ item: TodoItem) {
        print("deleteTodoItem")
        
        // 트랜잭션에서 realm에 delete
        try! realm.write {
            realm.delete(item)
        }
    }
}
