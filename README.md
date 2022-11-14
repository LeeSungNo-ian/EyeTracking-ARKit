![꿈뻑이 깃허브](https://user-images.githubusercontent.com/78950704/200159285-41a630f2-664c-4c15-b9bd-d695292f707b.jpg)

# 꿈뻑이

<br>

<img width="30%" src="https://user-images.githubusercontent.com/78950704/200159751-7f54b468-1a53-40f1-8473-b66ab488f5cb.jpg">

> `v1.0.0` 2022.08.22 - 2022.09.02

> QR 코드로 앱 다운받기!

<br>

## 👤 Authors

<img width="100%" src="https://user-images.githubusercontent.com/78950704/200160548-e3c2965d-5751-4a18-a590-7d083bd7d05f.jpg"> |
:------------: 
**이안(ian)** | 

> `기획`, `디자인`, `개발` 을 담당했어요!

<br>

## 👀 프로젝트 소개

- 미디어 사용량이 많은 현대인들이 눈 피로를 풀 수 있도록 눈 깜빡임을 유도하는 앱 입니다.
- ‘ARKit’ 을 사용해 사용자의 시선을 추적하는 기능을 구현했으며, 눈 깜빡임을 인식해 화면에 보여지는 타겟을 제거하는 기능을 구현했습니다.
  
<br>

## ✨ 프로젝트 주요 기능

<img width="30%" src="https://user-images.githubusercontent.com/78950704/197410346-4c155cf5-9118-450a-b2c0-2ed58789f82a.gif">

- 사용자의 시선을 `True Depth` 전면 카메라로 추적합니다.
- 시선에 따라 `Cursor`가 이동합니다.
- UI 위에 타겟이 랜덤으로 생성됩니다.
- 생성이 된 타겟을 쳐다본 후 `Cursor`가 타겟 위에 올라오면 눈 깜빡임으로 타겟을 제거합니다!

---

<img width="20%" src="https://user-images.githubusercontent.com/78950704/200162194-906ab34d-f252-48fe-af86-0c34a38c2f7c.gif"> 

- 총 게임 소요 시간을 알려줍니다. 미션을 얼마나 빨리 깼는지 확인해보세요!

<br>

## 🛠 기술적 도전
> `ARKit`
- 시선 추적 기능
  - ‘hitTestWithSegment’ 메서드를 활용해 좌안, 우안 시선 포인트의 교차점 x, y 좌표값을 실시간으로 받아옵니다.
  - 좌표값들의 배열을 생성한 후 평균을 내어 사용자의 시선 좌표값을 측정합니다.

- 눈 깜빡임 인식 기능
  - ‘ARFaceAnchor’의 프로퍼티 ‘eyeBlinkRight’, ‘eyeBlinkLeft’ 의 값을 측정하여 눈 깜빡임을 감지합니다.

> `SceneKit`
- 사용자의 눈을 Node로 인식하기 위해 ‘SceneKit’를 사용했습니다.

> `ML 임계점`
- ML에서 최고의 성능을 낼 수 있도록 threshold를 바꿔 적당한 수치값을 찾는 과정을 Swift에서 함수 `suffix`를 통해 학습했습니다.
- 설정한 수치값에 따라 시선 추적 성능이 변화하는 걸 확인할 수 있었습니다. [PR](https://github.com/LeeSungNo-ian/EyeTracking-ARKit/pull/4)을 통해 학습 내용을 정리했습니다.

<br>

## 🤔 고민한 점
- [SCNNode Layer 계층구조는 어떻게 이루어져 있을까?](https://github.com/LeeSungNo-ian/EyeTracking-ARKit/pull/2)
- [ML 임계점을 조절하여 최상의 퍼포먼스를 낼 수 있을까?](https://github.com/LeeSungNo-ian/EyeTracking-ARKit/pull/4)

<br>

## 💡 앱 사용방법

꿈뻑이는 사용자의 시선을 쫓아 잦은 눈 깜빡임을 도와줍니다.
시선을 타겟에 둔 후, 눈을 깜빡이며 점수를 획득해보세요! (살짝 고개도 돌려보세요!)

**플레이 방법**
1. 전면 카메라를 통해 사용자의 눈을 인식합니다.
2. 기기를 정면에 위치한 후, 30cm 이상 떨어져주세요.
3. 화면에 나타나는 눈을 기다려주세요.
4. 나타난 눈을 바라보며 눈을 깜빡여주세요!
