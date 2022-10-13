# 지금 여기있어!
## 사용한 ThirdPartyLibrary
 - Firebase
 - KakaoLogin
 
## 설계
 - MVVM구조, Builder패턴

## Index
## 1. 포스트 화면.
### 객체관계 
> 
> <img width="944" alt="스크린샷 2022-10-13 오후 5 05 41" src="https://user-images.githubusercontent.com/62687919/195538602-c2c3f9ed-6b99-46d8-b933-209c8eda0fd1.png">
>
> ### 점선은 추상타입, 실선은 의존관계를 표현하였습니다.
> 
### 실행화면
> 
> ![111](https://user-images.githubusercontent.com/62687919/195540605-ae758ff6-b59b-4c35-995f-7506c9f70e25.gif)

----

## 2. 메인 화면.
### 객체관계
>
> <img width="1149" alt="스크린샷 2022-10-13 오후 5 20 32" src="https://user-images.githubusercontent.com/62687919/195542427-55c8a6f1-d1a9-40fa-8a47-28925f17f39c.png">
>
### 실행화면
>
> ![222](https://user-images.githubusercontent.com/62687919/195542713-a5284d75-0850-4d78-9575-a52ec96e9413.gif)
>

## 3. 작성 화면.
### 객체관계
> <img width="1034" alt="스크린샷 2022-10-13 오후 5 39 43" src="https://user-images.githubusercontent.com/62687919/195547024-f42d5727-d7a2-4837-b6d4-f7ef46a8dfa0.png">
>
- FirebaseManager를 추상타입이 아닌 싱글톤으로 변경하였습니다.
- `FirebaseManager.shared`를 사용하면 실서버와 통신하는 객체를, `FirebaseManager.stub`을 사용하면 mock객체를 반환하도록 구현하였습니다.
- 테스트 뿐 아니라 실제 서비스에서도 Firebase서버가 끊기는 현상을 방지하기 위함입니다. + 설계복잡도도 낮추어졌습니다.

### 실행화면 
> 
> ![333](https://user-images.githubusercontent.com/62687919/195547903-74289b6c-99f0-46ec-9ed7-9e77da5ec24b.gif)
>

### 4. 위치 추가 기능.

