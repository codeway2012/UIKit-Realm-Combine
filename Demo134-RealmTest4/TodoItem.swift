//
//  TodoItem.swift
//  Demo131-RealmTest
//
//  Created by user on 8/9/24.
//

import RealmSwift

// Realm 데이터 모델 정의
class TodoItem: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var isCompleted: Bool
}
