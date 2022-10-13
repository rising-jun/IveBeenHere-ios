# 지금 여기있어!
https://github.com/rising-jun/IveBeenHere-ios/wiki/About_IveBeenHere
1. 사용자가 앱 실행 시 위치권한을 요청한다.
2. 사용자가 게시물 작성을 시도하면, 로그인 요청을 한다.
3. 사용자가 현재 위치를 추가하고, 포스트를 작성한다.
4. 네트워크 요청 결과가 실패하거나, 사용자가 게시물 필수 작성 양식을 기재하지 않을 시 alert를 사용하여 사용자에게 전달한다.

## 사용한 ThirdPartyLibrary
 - Firebase
 - KakaoLogin
 
## 설계
 - MVVM구조, Builder패턴
<img width="641" alt="스크린샷 2022-10-13 오후 5 57 24" src="https://user-images.githubusercontent.com/62687919/195551597-70e14d61-270d-4bf4-bf65-6b9b7dc3a447.png">

----

## Index
화면 별 Flow
<img width="425" alt="스크린샷 2022-10-13 오후 5 58 10" src="https://user-images.githubusercontent.com/62687919/195551792-14b2bb1f-d783-4abb-bd6d-d7a2bfc1046e.png">

----

## 1. 포스트 화면.
### 객체관계  
> <img width="944" alt="스크린샷 2022-10-13 오후 5 05 41" src="https://user-images.githubusercontent.com/62687919/195538602-c2c3f9ed-6b99-46d8-b933-209c8eda0fd1.png">
> 
#### 점선은 추상타입, 실선은 의존관계를 표현하였습니다.

### 실행화면
![444](https://user-images.githubusercontent.com/62687919/195549656-f4d53556-adc6-4d93-bdcd-4accda2bf7e4.gif)


----

## 2. 메인 화면.
### 객체관계
> <img width="1149" alt="스크린샷 2022-10-13 오후 5 20 32" src="https://user-images.githubusercontent.com/62687919/195542427-55c8a6f1-d1a9-40fa-8a47-28925f17f39c.png">
>
### 실행화면
![222](https://user-images.githubusercontent.com/62687919/195542713-a5284d75-0850-4d78-9575-a52ec96e9413.gif)

----

## 3. 작성 화면.
### 객체관계
> <img width="1034" alt="스크린샷 2022-10-13 오후 5 39 43" src="https://user-images.githubusercontent.com/62687919/195547024-f42d5727-d7a2-4837-b6d4-f7ef46a8dfa0.png">
>
- FirebaseManager를 추상타입이 아닌 싱글톤으로 변경하였습니다.
- `FirebaseManager.shared`를 사용하면 실서버와 통신하는 객체를, `FirebaseManager.stub`을 사용하면 mock객체를 반환하도록 구현하였습니다.
- 테스트 뿐 아니라 실제 서비스에서도 Firebase서버가 끊기는 현상을 방지하기 위함입니다. + 설계복잡도도 낮추어졌습니다.

### 실행화면  
![333](https://user-images.githubusercontent.com/62687919/195547903-74289b6c-99f0-46ec-9ed7-9e77da5ec24b.gif)

----

## 4. 위치 추가 기능.
### 객체관계
> <img width="1003" alt="스크린샷 2022-10-13 오후 5 47 25" src="https://user-images.githubusercontent.com/62687919/195548967-d82efe89-bf5b-4047-bfbd-1727e5869329.png">

### 실행화면
> ![222](https://user-images.githubusercontent.com/62687919/195550208-f43a52b4-a0a4-429a-bc53-d0accaa6e16f.gif)



