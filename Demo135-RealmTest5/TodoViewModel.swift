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
    private var cancellables = Set<AnyCancellable>()
    
    // Realm Data
    var todoItems: Results<TodoItem>
    
    // Combine Subject
    // PassthroughSubject : 데이터를 유지하지 않음, send로 값이 들어올때만 방출
    // todoItemsPublisher : 캡슐화. todoItemsSubject 데이터 변경 제어
    private let todoItemsSubject = PassthroughSubject<[TodoItem], Never>()
    var todoItemsPublisher: AnyPublisher<[TodoItem], Never> {
        todoItemsSubject.eraseToAnyPublisher()
    }
    
    init() {
        // realm 초기화
        realm = try! Realm()
        print("open \(realm.configuration.fileURL!)") // realm 파일을 터미널로 열기 (realm studio)
        todoItems = realm.objects(TodoItem.self)
        fetchTodoItems()
    }
    
    private func fetchTodoItems() {
        // CollectionPublisher를 사용하여 데이터 변경 사항 구독
        todoItems.collectionPublisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { results in
                // 전체 컬렉션을 통해 데이터 처리
                self.todoItemsSubject.send(Array(results))
            })
            .store(in: &cancellables)
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
