# Nshop
상품을 검색하고 마음에 드는 상품을 저장할 수 있는 앱
|<img width="200" src="https://github.com/ehvkddl/recap-assignment-2/assets/57763334/5e8e29c7-ab45-45f3-a3e1-f28fd0e795ee">|<img width="200" src="https://github.com/ehvkddl/recap-assignment-2/assets/57763334/37d43bb6-17b9-4e2c-8f08-97da5e9656cb">|<img width="200" src="https://github.com/ehvkddl/recap-assignment-2/assets/57763334/152793df-a0c6-46e0-9a04-91d800d4c5fa">|
|:-:|:-:|:-:|
|검색|상세 화면|무한 스크롤|
|<img width="200" src="https://github.com/ehvkddl/recap-assignment-2/assets/57763334/a996b532-1993-457c-9a8c-dd5120a82d94">|<img width="200" src="https://github.com/ehvkddl/recap-assignment-2/assets/57763334/73214e3a-b949-4a99-ac7a-f4126f93fd61">|<img width="200" src="https://github.com/ehvkddl/recap-assignment-2/assets/57763334/3cbf37bb-0db2-465e-bbe4-d2b765d20d0b">|
|찜목록|찜목록 검색|찜목록 삭제|


## 목차
1. [프로젝트 정보](#프로젝트-정보)
2. [주요 기능](#주요-기능)
3. [기술 스택](#기술-스택)
4. [구현 내용](#구현-내용)
5. [문제 및 해결](#문제-및-해결)

## 프로젝트 정보
- 최소 버전: iOS 13.0
- 개발 환경: Xcode 14.3.1, swift 5.8.1
- 개발 기간: 23.09.07 ~ 23.09.11 (5일)
- 개발 인원: 1명

## 주요 기능
- 상품 검색 기능
- 상품 정렬 기능
- 찜 목록 추가/삭제 기능

## 기술 스택
- `UIKit`
- `CodebaseUI`
- `MVC`
- `WebKit`, `Network`
- `SnapKit(5.6.0)`
- `Realm(13.17.1)`

## 구현 내용
- 네이버 쇼핑 검색 API를 이용한 상품 검색 기능
- WebKit을 이용한 상품 상세페이지 구현
- Network 프레임워크를 이용한 네트워크 연결 상태 확인 기능
- Realm DB를 이용한 마음에 드는 상품 저장 기능
- Realm의 filter 기능을 사용한 찜목록에 저장된 상품 검색 기능
- prefetchItemsAt 메서드를 사용하여 무한 스크롤 구현
  
## 문제 및 해결
### 1. 실시간 검색 기능
#### 🚨 문제 상황
UISearchBarDelegate에 있는 textDidChange 메서드를 사용하여 사용자가 검색어를 입력할 때마다 return key를 누르지 않더라도 네트워크 요청을 실행하고 상품이 View에 나타나도록 함
-> 모든 입력에 대해서 textDidChange 메서드가 실행되어 불필요하게 많은 네트워크 요청 발생 (ex. ‘아이폰' 검색시 ㅇ, 아, 앙, 아이, 아잎, 아이포, 아이폰 의 단어로 무려 7번의 요청 발생)
#### ✅ 해결
Debounce와 Throttle에 대해서 학습
- Debounce
	- 동일 이벤트가 반복적으로 시행되는 경우, 마지막 이벤트가 실행되고나서 일정 시간동안 이벤트가 다시 실행되지 않았을 때 콜백 함수 실행
- Throttle
	- 동일 이벤트가 반복적으로 시행되는 경우, 이벤트의 실제 반복 주기와 상관없이 임의로 설정한 시간 간격으로 콜백 함수 실행

입력이 연속적으로 들어오는 경우, 마지막 입력이 들어왔을 때만 네트워크 통신을 수행하기 위하여 debounce를 적용하여 메서드를 호출하기로 함

##### `DispatchWorkItem`를 이용하여 Debouncer 구현
```swift
class Debouncer { 
	private var workItem: DispatchWorkItem?
	private let seconds: Int
	
	init(seconds: Int) {
		self.seconds = seconds
	}
	
	func run(_ closure: @escaping () -> ()) {
		self.workItem?.cancel()
		
		let newWork = DispatchWorkItem(block: closure)
		workItem = newWork
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: newWork)
	}
}
```
- workItem이 있다면 작업 제거
- 클로저로 받은 작업을 seconds 후에 수행
##### Debouncer 사용
```swift
private let debouncer = Debouncer(seconds: 1)
```

```swift
extension ProductSearchingViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
	    debouncer.run { [unowned self] in
	        setFirstSearch()
	        firstFetch()
	    }
	}
}
```

|<img width="200" src="https://github.com/ehvkddl/recap-assignment-2/assets/57763334/09fa8082-4eff-4258-91f9-e5e283c49c4c">|<img width="200" src="https://github.com/ehvkddl/recap-assignment-2/assets/57763334/3d1e00a7-3c1f-4eb6-8742-dc038010cbb4">|
|:-:|:-:|
|before|after|
