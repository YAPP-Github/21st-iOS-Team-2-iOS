# FITFTY **Contributing Guide**

Contributor로서 다음과 같은 지침을 준수해주세요.

- [Submission Guidelines](#submission-guidelines)
- [Git Commit Message Convention](#git-commit-message-convention)
  
## **Submission Guidelines**

### **📌 Issue 제출하기**

만약 당신이 아이디어나 버그를 알고있다면, 다음 사항을 따라 알려주세요:

1. Issue를 생성합니다.
2. Assignee를 지정합니다.
3. 관련있는 Label를 추가합니다.
4. 템플릿 컨벤션을 준수하여 제출해주세요.

<br>

### **📌 Pull Request 제출하기**

당신의 Pull Request를 제출하기 전에 다음 사항을 따라주세요:

1. 이미 존재하는 하나의 Issue를 해결할 수 있는 것인지 확인해주세요.

2. 해결할 수 있으면 **git-flow 전략** 브랜치를 이용합니다.

   2-1. **git-flow 전략**

   > **master** : 기준이 되는 브랜치로 제품을 배포하는 브랜치
   >
   > **develop** : 개발 브랜치로 개발자들이 이 브랜치를 기준으로 각자 작업한 기능들을 Merge
   >
   > **feature** : 단위 기능을 개발하는 브랜치로 기능 개발이 완료되면 develop 브랜치에 Merge
   >
   > **release** : 배포를 위해 master 브랜치로 보내기 전에 먼저 QA(품질검사)를 하기위한 브랜치
   >
   > **hotfix** : master 브랜치로 배포를 했는데 버그가 생겼을 떄 긴급 수정하는 브랜치

3. 코드를 작성하여 해당 Issue를 해결해주세요.

4. [Git Commit Message Convention](notion://www.notion.so/yapp-workspace/CONTRIBUTING-md-a102c47fd03444b990545a2f74c7616c#git-commit-message-convention) 규칙을 따르는 커밋 메시지를 사용하여 커밋해주세요.

5. 해당 브랜치에 push해주세요.

6. Github에서 템플릿 컨벤션을 준수하여 Pull Request를 제출해주세요.
7. 리뷰 우선순위 판단을 돕는 `D-n 룰`을 사용하여 해당 label을 붙여주세요.

    7-1. **D-n룰**

    - **`D-0` (ASAP)**

      긴급한 수정사항으로 바로 리뷰해 주세요. 앱의 오류로 인해 장애가 발생하거나, 빌드가 되지 않는 등 긴급 이슈가 발생할 때 사용합니다.

    - **`D-N` (Within N days)**

      N일 이내에 리뷰해 주세요.

      일반적으로 D-2 태그를 많이 사용하며, 중요도가 낮거나 일정이 여유 있는 경우 D-3 ~ D-5 를 사용하기도 합니다.
  
<br>

### **📌 Pull Request 리뷰하기**

PR의 reivewer라면 다음 사항을 따라주세요:

1. 코드 리뷰는 [뱅크샐러드의 Pn룰](https://blog.banksalad.com/tech/banksalad-code-review-culture/)을 따릅니다.

   1-1. **Pn룰**

   - **`P1`: 꼭 반영해주세요 (Request changes)**

     리뷰어는 PR의 내용이 서비스에 중대한 오류를 발생할 수 있는 가능성을 잠재하고 있는 등 중대한 코드 수정이 반드시 필요하다고 판단되는 경우, P1 태그를 통해 리뷰 요청자에게 수정을 요청합니다. 리뷰 요청자는 p1 태그에 대해 리뷰어의 요청을 반영하거나, 반영할 수 없는 합리적인 의견을 통해 리뷰어를 설득할 수 있어야 합니다.

   - **`P2`: 적극적으로 고려해주세요 (Request changes)**

     작성자는 P2에 대해 수용하거나 만약 수용할 수 없는 상황이라면 적합한 의견을 들어 토론할 것을 권장합니다.

   - **`P3`: 웬만하면 반영해 주세요 (Comment)**

     작성자는 P3에 대해 수용하거나 만약 수용할 수 없는 상황이라면 반영할 수 없는 이유를 들어 설명하거나 다음에 반영할 계획을 명시적으로(JIRA 티켓 등으로) 표현할 것을 권장합니다. Request changes 가 아닌 Comment 와 함께 사용됩니다.

   - **`P4`: 반영해도 좋고 넘어가도 좋습니다 (Approve)**

     작성자는 P4에 대해서는 아무런 의견을 달지 않고 무시해도 괜찮습니다. 해당 의견을 반영하는 게 좋을지 고민해 보는 정도면 충분합니다.

   - **`P5`: 그냥 사소한 의견입니다 (Approve)**

     작성자는 P5에 대해 아무런 의견을 달지 않고 무시해도 괜찮습니다.

2. 코드를 리뷰하여 **Comment / Approve / Request changes** 를 남깁니다.

3. 해당 PR reviewer가 **Approve**를 하면 머지를 할 수 있습니다.

<br>
<br>


## **Git Commit Message Convention**

### **📌 Commit Message Header**

```
<이모지> <타입>: <제목>
         │       │
         │       │
         │       │
         │       └─⫸ 한글 명령문으로 작성해주세요. 끝에 마침표를 빼주세요.
         │
         └─⫸ Commit Type
```

<br>

### **타입**

다음 중 하나여야 합니다.

```
✨ [feat]    : 기능 추가
🐛 [fix]     : 버그 수정
♻️ [refactor]: 리팩토링 (함수 분리/이름수정 등 실행 결과의 변경 없이 코드 구조를 재조정)
🚚 [style]   : 파일 형식/네이밍, 폴더 구조/네이밍 수정하거나 옮기는 작업 비즈니스 로직에 변경 없음
💄 [style]   : 스타일 (UI 스타일 변경) 비즈니스 로직에 변경 없음
📝 [docs]    : 문서 (README 등 문서 추가/수정/삭제)
✅ [test]    : 테스트 (테스트 코드 추가/수정/삭제: 비즈니스 로직에 변경 없음)
🔧 [chore]   : 기타 사소한 변경사항 (빌드 스크립트 수정 등)
💡 [comment] : 필요한 주석 추가 및 변경
🔥 [remove]  : 파일, 폴더 삭제 작업
```

<br>

### **제목**

변경 사항에 대한 간략한 설명을 제공합니다.

- 제목은 명령문 한글로 작성합니다.
- 끝에는 마침표 (.)가 없습니다.

<br>

### **📌 Commit Message Body**

어떻게 변경했는지 보다 무엇을 변경했는지 또는 왜 변경했는지를 최대한 상세히 설명합니다.

- 한글로 현재 시제를 사용합니다.
- 한 줄 당 72자 내로 작성합니다.
- 여러 줄의 메시지를 작성할 땐 "-"로 구분합니다.

<br>

### **📌 Commit Message Footer**

현재 커밋과 관련된 이슈 번호로 작성합니다.

- ex) `#이슈번호`

<br>

## PR Merge Type

- Create a merge commit type을 사용합니다.
