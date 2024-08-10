# 간단한 TodoList 샘플

## 소개
- UIkit의 MVVM 패턴 사용
- Realm과 Combine 연결해서 활용하는 샘플용 코드

## Target별 중점 코드
1. RealmTest - @Published, Observe
2. RealmTest2 - PassthroughSubject, Observe
3. RealmTest3 - CurrentValueSubject, Observe
4. RealmTest4 - PassthroughSubject, changesetPublisher
5. RealmTest5 - PassthroughSubject, collectionPublisher

objectPublisher


## 사진

<p>
<img height="200" alt="스크린샷 2024-08-09 오후 5 37 50" src="https://github.com/user-attachments/assets/7b98302d-0e36-40c5-8cd3-ae2498f792bf">
<img height="200" alt="스크린샷 2024-08-09 오후 5 37 12" src="https://github.com/user-attachments/assets/fee4bd34-75ca-4ab6-a967-6c0d44e28939">
</p>


## 문법

### 1. 데이터 상태 유지 변수 : @Published vs Results<T>

- @Published
  - 장점 :
    - 간단한 데이터 흐름
  - 단점 :
    - 세부 데이터 변경 감지 어려움 : 배열이나 객체의 전체에 대한 변경을 감지. 세부 항목에 대한 개별 감지는 어려움
  
- Results<T>
  - 장점 :
    - 세부 데이터 변경 감지 가능 : changesetPublisher와 collectionPublisher의 keyPath 옵션을 통해 데이터의 세부 변경 사항을 추적할 수 있습니다.
  - 단점 :
    - 데이터 흐름이 좀더 복잡


### 2. 데이터 변경 감지 : observe vs changesetPublisher

- observe : 콜백 방식
- changesetPublisher : Combine Publisher 방식

