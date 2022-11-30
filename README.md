# 1️⃣ 프로젝트 소개

## 1. 문제 상황

- 크레이지레이싱 카트라이더는 2004년에 서비스를 시작한 레이싱 비디오게임으로 18년째 많은 유저들에게 사랑을 받고 있습니다. 그러나 오랜 시간 서비스를 하고 있는 만큼 장점과 동시에 단점도 가지고 있습니다. 그 중 하나는 최근 출시된 스피드전 트랙들이 많이 플레이되지 않고 있다는 것입니다.
- 실제로 최근 5년간 출시된 스피드전 트랙 44개중 32개는 스피드 개인전 상위 50개 트랙에 이름을 올리지 못했습니다.

  <img src =https://user-images.githubusercontent.com/111565156/204594242-6d2f35c8-c6e3-47d8-b7ea-cb773e5d9394.png>


## 2. 프로젝트 목적

- 위의 문제상황을 포착한 팀 ‘카트타고 출근’은 최근에 출시된 트랙들이 상위 트랙에 포함되지 못하는 문제점을 해결하고자 분석 프로젝트를 기획하였습니다.
- 해당 문제를 해결하기 위해 **유저가 선호하는 트랙의 특징을 파악하려** 합니다.  그리고 신규 트랙을 출시 할때 고민인 트랙 디자이너에게 어떤 것을 고려해야하는지 분석 결과를 통해 제안하고자합니다. 분석을 통해 파악한 상위 트랙의 특징을 신규 트랙에 적용한다면, 지속적으로 사랑받는 트랙을 제작할 수 있을 것입니다.  
   
<br/>
 <br/>
 
# 2️⃣ 가설 설정

- **유저가 선호하는 트랙에는 특징이 있을 것이다.**
    - 유저가 ‘트랙을 선호한다’ 를 `트랙 사용 수`가 많다로 정의
    - `트랙 사용수` = 경기에서 유저가 트랙을 선택한 횟수  
   
<br/>
 <br/>

# 3️⃣ 사용 기술

  <img src =https://user-images.githubusercontent.com/111565156/204595760-13f0047a-357f-430a-8cae-5bf901754166.png>


  <img src =https://user-images.githubusercontent.com/111565156/204595683-53f3bdc9-d30c-458a-b6b5-bac4c9a2df74.png>
  
<br/>
<br/>
   <br/>
   
# 4️⃣ 데이터

## 1. 사용한 데이터

  <img src =https://user-images.githubusercontent.com/111565156/204595889-4129b2e0-2117-4ceb-8f24-96c035043350.png>


## 2. ERD 테이블
_*ERD와 관련하여 자세한 내용을 확인하고 싶으시면, [ERD 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/12.-ERD)를 참고해주세요._

- ERD 구조
    
    <img src =https://user-images.githubusercontent.com/111565156/204596261-d6ac7a68-5a90-4c2d-a94f-308c9750d80a.png>

    
- ERD 구조 설명
    
    
    <img src =https://user-images.githubusercontent.com/111565156/204596067-5ed5931d-787f-4e60-9f7a-6e88f93f7f98.png>

  
<br/>
 <br/>
     
# 5️⃣ 디렉토리 설명
_*디렉토리와 관련하여 자세한 내용을 확인하고 싶으시면, [디렉토리 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/13.-Github-%EB%94%94%EB%A0%89%ED%86%A0%EB%A6%AC-%EC%84%A4%EB%AA%85)를 참고해주세요._

```html
├── api
│	├── api-data-collecting-functions.ipynb
│	├── api-data-calculated-metrics-extraction.sql
│	└── match-indicator-extraction.csv
├── data-analysis
│	├── data-analysis-regression-cnt_match.ipynb
│	├── data-analysis-regression-AVG_record.ipynb
│	└── data-analysis-regression-difficulty.ipynb
├── data
│	├── match.csv
│	├── match_type.csv
│	├── track.csv
│	├── track_curve.csv
│	├── track_obstacle.csv
│	├── track_road.csv
│	├── track_shortcut.csv
│	├── track_straight.csv
│	└── track_trigger.csv
├── raw-data
│	├── api-rawdata-singleplay.csv
│	├── scraping-rawdata-error-track.csv
│	└── scraping-rawdata.csv
├── scraping
│	├── scraping-data-collecting-functions.ipynb
│	├── scraping-text-preprocessing.ipynb
│	└── scraping.csv
├──survey
│	├── survey.csv
│	└── survey-wordcloud.ipynb
└── README.md
```
  
<br/>
<br/>
     
# 6️⃣ 분석 내용

## 1. 분석 정의

- 유저가 ‘트랙을 선호한다’를 ‘트랙 사용 수가 많다’로 정의하였습니다.
- 트랙 사용 수를 종속변수로 두고 어떠한 요소들이 영향을 주는지 알아보고자 합니다.

---

## 2. 독립변수 선정을 위한 설문조사 진행
_*설문조사와 관련하여 자세한 내용을 확인하고 싶으시면, [설문조사 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/02.-%EC%84%A4%EB%AC%B8%EC%A1%B0%EC%82%AC)를 참고해주세요._

- 독립변수를 설정하기 위해 크레이지레이싱 카트라이더 유저를 대상으로 설문조사 진행했습니다.
     
- 설문조사는 10/19~10/25 동안 진행하였고, 총 120명의 응답을 확보하였습니다. 이를 통해 유저가 트랙을 선택할 때 중요하게 생각하는 요소를 파악해 워드클라우드로 표현했습니다.  
  <img src =https://user-images.githubusercontent.com/111565156/204596933-accd40b1-4b4a-4d41-9434-14a92b40ee0c.png>


- 위의 워드클라우드를 반영하여 분석에 필요한 독립변수를 아래와 같이 선정하였습니다.  
  <img src =https://user-images.githubusercontent.com/111565156/204596998-d0ff363b-d533-4459-b1a1-de17f8c726ac.png>

    

---

## 3. 데이터 수집

- 선정한 독립변수와 관련하여 데이터를 수집하기 위해 api, scraping, 트랙 데이터 자체수집을 진행하였습니다.
- 각 데이터와 관련하여 자세한 내용을 확인하고 싶으시면, 아래 위키 페이지를 참고해주세요.
    - [api 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/03.-api)
    - [scraping 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/04.-scraping)
    - [트랙 데이터 자체수집 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/05.-%ED%8A%B8%EB%9E%99-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EC%9E%90%EC%B2%B4-%EC%88%98%EC%A7%91)
- ‘*데이터간의 관계’ 관련 자세한 내용을 확인하고 싶으시면, 아래 위키 페이지를 참고해주세요.*
    - [ERD 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/12.-ERD)

---

## 4. 데이터 분석

### 1) **종속변수가 ‘트랙 사용 수’인 회귀분석 진행.**
_*종속변수가 `트랙 사용 수`인 회귀분석과 관련하여 자세한 내용을 확인하고 싶으시면, ['트랙 사용 수' 분석 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/06.-'%EC%A2%85%EC%86%8D-%EB%B3%80%EC%88%98-:-%ED%8A%B8%EB%9E%99-%EC%82%AC%EC%9A%A9-%EC%88%98'-%ED%9A%8C%EA%B7%80-%EB%B6%84%EC%84%9D)를 참고해주세요._

- 다음과 같은 분석 결과를 도출하였습니다.
  <img src =https://user-images.githubusercontent.com/111565156/204597334-361f303a-ca33-466f-8e6a-9239740ed725.png>
  ![image](https://user-images.githubusercontent.com/45919197/204792155-03322240-a611-474d-990b-7a4db24e4ad4.png)


- 특히 주목해야하는 점은 단일 회귀 분석으로 `트랙 사용 수` 를 21% 설명하는 `평균 주행시간`이 증가할수록 `트랙 사용 수`가 감소한다는 것입니다. 
다시 말해, “평균 주행시간을 낮춰야 트랙을 많이 사용한다.” 는 것을 알 수 있습니다.  
 <br/>
  
---

### 2) **종속변수가 ‘평균 주행시간’인 회귀분석 진행**
_*종속변수가 `평균 주행 시간` 인 회귀분석과 관련하여 자세한 내용을 확인하고 싶으시면, ['평균 주행 시간' 분석 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/07.-'%EC%A2%85%EC%86%8D-%EB%B3%80%EC%88%98-:-%ED%8F%89%EA%B7%A0-%EC%A3%BC%ED%96%89-%EC%8B%9C%EA%B0%84'-%ED%9A%8C%EA%B7%80-%EB%B6%84%EC%84%9D)를 참고해주세요._

- 다음과 같은 분석 결과를 도출하였습니다.
  <img src =https://user-images.githubusercontent.com/111565156/204597517-bb856d0a-39b8-4858-bbdc-e3869fab53e3.png>
  ![image](https://user-images.githubusercontent.com/45919197/204791957-d66d70fc-3140-479d-a91f-da11254aacc8.png)

    
- 특히 흥미로웠던 결과는 아래의 두가지 포인트입니다. 
  * ✅ `직선 구간 비율` 이 높을수록 `평균 주행 시간`이 늘어납니다.  
      **즉, “`평균 주행 시간`을 줄이기 위해서는 `직선 구간 비율`을 줄여야 함”을 알 수 있습니다.** 
  * ✅ `내리막길 비율`이 높을수록 `평균 주행 시간`이 늘어납니다.  
     **따라서 `평균 주행 시간`을 줄이기 위해서는 `내리막길 비율`을 줄여야 합니다.**

<br/>

---

- 그러나 `직선 구간 비율`을 줄이고, `내리막길 비율`을 줄여 `평균 주행 시간`만을 낮추면 유저들이 그 트랙을 많이 이용할까요? **⇒ 아닙니다.**
- 트랙을 플레이하는 유저들의 레벨이 다르기 때문에, 각 레벨별 유저들에게 재미를 제공할 수 있도록 트랙의  `난이도` 또한 고려하여야 합니다. 그렇다면 `난이도`에는 어떤 변수들이 영향을 줄까요?

---

### 3) **종속변수가 ‘난이도’인 회귀분석 진행**
_*종속변수가 `난이도` 인 회귀분석과 관련하여 자세한 내용을 확인하고 싶으시면, ['난이도' 분석 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/08.-'%EC%A2%85%EC%86%8D-%EB%B3%80%EC%88%98-:-%EB%82%9C%EC%9D%B4%EB%8F%84'-%ED%9A%8C%EA%B7%80-%EB%B6%84%EC%84%9D)를 참고해주세요._

- 다음과 같은 분석 결과를 도출하였습니다.
  <img src =https://user-images.githubusercontent.com/111565156/204597648-993f748e-bf69-4e1d-96d7-39890dee3bfe.png>
  ![image](https://user-images.githubusercontent.com/45919197/204792534-18532c39-b38e-4ac3-b833-8c24ea825e99.png)

    
- 트랙의 `난이도` 에는 `펜스 없는 구간 유무` , `내리막길 개수` , `전체 직선 개수` , `트랙 이동 개수` , `감속 트리거 개수` , `점프 트리거 개수` , `헤어핀 구간 개수`, `전체 곡선 구간 개수`, `전체 장애물 개수` 가 영향을 준다는 것을 알 수 있었습니다.
 <br/>
 
---

## 5. 분석 결과 정리

- 분석 결과를 정리하자면 크게 다음과 같습니다.
  * `트랙 사용 수` 에는 `난이도`, `평균 주행시간`, `테마` 가 영향을 미친다.
  * `평균 주행 시간` 에는 `내리막길 비율`, `예각 커브 개수` , `헤어핀 구간 개수`, `둔각 커브 개수`, `직선 구간 비율`, `펜스 구간 유무`, `고정 장애물 개수` 가 영향을 미친다.
  * `난이도` 에는 `내리막길 개수`, `전체 직선 개수`, `전체 곡선 개수`, `헤어핀 구간 개수`, `총 장애물 개수`, `펜스 구간 유무`, `트랙 이동 개수`, `감속 트리거`, `점프 트리거` 가 영향을 미친다.  
  <img src =https://user-images.githubusercontent.com/111565156/204597744-f1b96034-d3e7-49b3-ad80-cad4569e1f86.png>

---

## 6. 트랙 계산기와 트랙 제작
_*‘트랙 계산기 개발’과 관련 자세한 내용을 확인하고 싶으시면, [트랙 계산기 개발 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/09.-%ED%8A%B8%EB%9E%99-%EA%B3%84%EC%82%B0%EA%B8%B0-%EA%B0%9C%EB%B0%9C)를 참고해주세요._  
_*‘트랙 제작’과 관련 자세한 내용을 확인하고 싶으시면, [트랙 제작 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/10.-%ED%8A%B8%EB%9E%99-%EC%A0%9C%EC%9E%91)를 참고해주세요._  

- 분석 결과를 활용하여 트랙 계산기를  개발하였습니다.
    [트랙 계산기 링크](https://track-calculator.bubbleapps.io/version-test/calculator)로 접속하면 트랙 계산기를 이용할 수 있습니다.  
    트랙 계산기 화면은 아래와 같이 구성되어 있습니다. 트랙 구성요소들을 계산기에 넣으면 평균 주행시간과 난이도를 알 수 있습니다 
    <img src = "https://user-images.githubusercontent.com/111565156/204597897-c55c3a81-7a3a-4d95-b51f-60e7eadcfd28.png" width = "20%" height = "20%">


- 트랙 계산기를 활용하여 ‘빌리지 테마’의 ‘난이도2’ 트랙을 제작하였습니다.   
  팀 ‘카트 타고 출근’이 제작한 트랙 **‘빌리지 해마의 여행’** 입니다.  
  <img src =https://user-images.githubusercontent.com/111565156/204599654-65de149b-fd6d-4fb2-ba92-a52062836e5d.png>


  
<br/>
 <br/>
 
# 7️⃣ 팀원 소개 및 컨택트 정보
_*팀원에 관련하여 자세한 내용을 확인하고 싶으시면 [팀원 소개 위키 페이지](https://github.com/KartTrack-lap/Kartrider-game-analysis/wiki/%EC%B9%B4%ED%8A%B8%ED%83%80%EA%B3%A0-%EC%B6%9C%EA%B7%BC-%ED%8C%80-%EC%86%8C%EA%B0%9C)를 참고해주세요._

<p align="center"><img src =https://user-images.githubusercontent.com/111565156/204600307-7f57840a-57cc-46de-ad40-8a57152ef1b4.png>
