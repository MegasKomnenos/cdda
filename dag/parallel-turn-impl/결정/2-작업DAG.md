---
유형: 결정
종류: 게이트 2
상태: 결정됨
---

# 병렬 턴 구현 작업 DAG 승인

## 브리핑

행 2의 네 렌즈는 운전성 중대 1건·경미 1건, 충족성 중대 4건, 정합성 중대 3건·경미 1건을 제기했다. 승인 대조 렌즈는 지적 없이 통과했다. 운전성·충족성·정합성 재검은 추가 결함을 제기했고, 행 2.5.11~2.5.13이 수리와 독립 검증을 완료했다. 아래 표는 원 판정 10건의 최종 처분이다.

| ID | 판정 좌표와 지적 | 처분 | 근거와 후행 |
|---|---|---|---|
| O-01 | 2.1 중대. 렌즈 FAIL 등록 계약에 도달할 수 없다. | 수리 완료 | 2.17의 예약 번호 계약·회귀 시험을 현재 운전성 수리 보고가 확인했다. |
| O-02 | 2.1 경미. 2.14가 정의하지 않은 CK-6을 지목한다. | 수리 완료 | 2.14는 CK-6과 V-06의 내용 게이트를 현재 완료 기준으로 정의한다. |
| S-01 | 2.2 중대. 기준 실행이 구현 편집 뒤에 있다. | 수리 완료 | 2.19가 구현 전 기준 실행과 시작 커밋 기록을 단독 소유한다. 기준 출력 선재·기존 테스트 실패는 예외로 2.19.z와 2.6을 미완결로 남긴다. |
| S-02 | 2.2 중대. 13개 측정 요소 감사표와 fail-closed 판정이 없다. | 수리 완료 | 2.7, 2.9~2.13과 S-02가 감사표와 fail-closed 처분을 현재 문면으로 정한다. |
| S-03 | 2.2 중대. 명령 생성 비용의 메모리·분할 기준이 없다. | 수리 완료 | 2.7/C-06~C-08과 S-03이 버퍼 재사용, 대상별 버킷, 추가 전역 정렬 금지를 정한다. |
| S-04 | 2.2 중대. 상태 검증값이 상수나 불완전 직렬화를 배제하지 않는다. | 수리 완료 | 2.7/C-09와 S-14가 등록부, 정규화, 축자 직렬화, 변이·주소 불변성 시험을 정한다. |
| C-01 | 2.3 중대. 기준 프로파일과 기존 실패 게이트가 구현 뒤에 있다. | 수리 완료 | 2.19와 `2.g2 → 2.19 → 2.19.z → 2.6`이 구현 전 성공만 후행에 연결한다. |
| C-02 | 2.3 중대. 렌즈 FAIL 뒤 별도 판정 처분 전개가 남아 있다. | 기각 | 행 2의 전개 지시는 최상위 판정 처분 전개 2.5를 요구한다. 렌즈 계약의 금지는 노드 전개와 검토전개에 적용한다. |
| C-03 | 2.3 중대. 소비 간선 주장과 이음새 연결 행이 다르다. | 수리 완료 | 2.5.13/U-02가 직접 자식 19개와 171쌍의 병행 자격 기록을 완성했다. |
| C-04 | 2.3 경미. 필드 방출의 연속 구간과 공간 구역 관계가 없다. | 수리 완료 | 2.9/M-04와 S-06이 `(z, y, x)` 순서, 반열림 연속 구간, N=1·2·4 시험을 정한다. |

2.5.3은 2.5.2의 수리 결과를 {경량} 1라운드로 검증했다. 2.5.4~2.5.7은 운전성, 충족성, 정합성, 승인 대조를 다시 적용했다. 2.5.11~2.5.13은 재검의 중대 지적을 수리·독립 검증했다. 2.5.14는 이 최종 결과와 현재 승인 대상을 반영한다.

선택지는 두 가지다.

1. 전면·단계 구현 DAG 승인(권고): 아래 스냅샷의 실행 DAG를 승인한다. 게이트 2 뒤에는 2.19 기준 실행을 먼저 수행한다. 기준 실행이 성공하면 2.6~2.15를 순서대로 실행한다.
2. 수정 후 재상신: 신규 제약 또는 스냅샷 문면을 지정해 반려한다. 행 2.19와 구현 노드는 실행하지 않고 결정 파일과 영향받은 행을 다시 수리한다.

권고는 1번이다. 행 1에서 승인한 「전면 구현 모두」를 유지한다. 네 렌즈가 제기한 결함은 새 구현 범위를 추가하지 않고 실행 순서, 검사 기준과 계약 연결을 수리한다.

## 신규 제약

없음

## 승인 대상 스냅샷

### 행 2.1: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md

````markdown
---
행: 2.1
유형: 파견
---

# 운전성 렌즈

- 목표: 백지 오케스트레이터가 파견표와 행 파일만으로 전체 서브트리를 운전할 수 있는지 판정한다.
- 완료 기준: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1-판정.md가 실재한다. frontmatter에 `VERDICT: PASS|FAIL`과 `계수:`가 있다. 판정은 근거 좌표, 닫힌 검사 범위, 무발견 영역을 기록한다.
- 렌즈: 운전성
- 판정 대상: C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1-판정.md
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md
- 모델 배정 근거: 배정표 codex-full(렌즈 gpt-5.6-sol med). 판정 자체가 산출이며 Codex 계열의 모델과 노력은 배정표가 직접 고정한다.
- 검토전개 모델: gpt-5.6-sol med. 배정표 codex-full 전개 값이며 FAIL 시 중대 지적의 자체 검토와 수리 설계를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md --model gpt-5.6-sol --writes 24000 --pending 70000 --root C:\cdda
  시각: 2026-08-24T13:53:48Z
  대상해시: sha1:113c74b92b2c
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .claude\skills\do-dag\계약\렌즈.md: ~3,095tok
  .claude\skills\do-dag\계약\판정.md: ~1,125tok
  .sdd\dag\parallel-turn-impl\결정\1-프레임체급.md: ~1,639tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~36,842tok (70,000바이트 — 측정 시점 미존재)
  읽기 합계: ~86,963tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 24,000바이트는 하한 미달)
  소요 견적: ~159,963tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1-판정.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.

## 임무

1. ready 판정, 파견문 착수 정보, 완료 신호, 동적 전개와 미정의 슬롯을 전수 시뮬레이션한다.
2. 판정 코퍼스 밖 근거의 지적은 근거 미확인으로 적고 판정 계수에 넣지 않는다.
3. 중대 지적이 하나 이상이면 검토전개 행을 판정 파일보다 먼저 등재한다.
4. 판정 대상 전건과 실행한 검사를 기록한다. 지적이 없으면 그 외 없음과 검사 범위를 적는다.

````

### 행 2.2: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md

````markdown
---
행: 2.2
유형: 파견
---

# 충족성 렌즈

- 목표: 행 2의 전건을 완주하면 사용자 승인 범위와 인계문 원자 요구가 빠짐없이 닫히는지 판정한다.
- 완료 기준: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2-판정.md가 실재한다. frontmatter에 `VERDICT: PASS|FAIL`과 `계수:`가 있다. 판정은 근거 좌표, 닫힌 검사 범위, 무발견 영역을 기록한다.
- 렌즈: 충족성
- 판정 대상: C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2-판정.md
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md
- 모델 배정 근거: 배정표 codex-full(렌즈 gpt-5.6-sol med). 판정 자체가 산출이며 Codex 계열의 모델과 노력은 배정표가 직접 고정한다.
- 검토전개 모델: gpt-5.6-sol med. 배정표 codex-full 전개 값이며 FAIL 시 중대 지적의 자체 검토와 수리 설계를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md --model gpt-5.6-sol --writes 24000 --pending 70000 --root C:\cdda
  시각: 2026-08-24T13:53:48Z
  대상해시: sha1:113c74b92b2c
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .claude\skills\do-dag\계약\렌즈.md: ~3,095tok
  .claude\skills\do-dag\계약\판정.md: ~1,125tok
  .sdd\dag\parallel-turn-impl\결정\1-프레임체급.md: ~1,639tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~36,842tok (70,000바이트 — 측정 시점 미존재)
  읽기 합계: ~86,963tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 24,000바이트는 하한 미달)
  소요 견적: ~159,963tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2-판정.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.

## 임무

1. 요구→행 추적표를 독립 재도출하고 각 원자 요구를 검사 가능한 완료 기준에 지목한다.
2. 판정 코퍼스 밖 근거의 지적은 근거 미확인으로 적고 판정 계수에 넣지 않는다.
3. 중대 지적이 하나 이상이면 검토전개 행을 판정 파일보다 먼저 등재한다.
4. 판정 대상 전건과 실행한 검사를 기록한다. 지적이 없으면 그 외 없음과 검사 범위를 적는다.

````

### 행 2.3: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md

````markdown
---
행: 2.3
유형: 파견
---

# 정합성 렌즈

- 목표: 행 2의 주장·좌표·계수·병행 판정이 결정, 기준선, 인계문과 일치하는지 판정한다.
- 완료 기준: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3-판정.md가 실재한다. frontmatter에 `VERDICT: PASS|FAIL`과 `계수:`가 있다. 판정은 근거 좌표, 닫힌 검사 범위, 무발견 영역을 기록한다.
- 렌즈: 정합성
- 판정 대상: C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3-판정.md
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md
- 모델 배정 근거: 배정표 codex-full(렌즈 gpt-5.6-sol med). 판정 자체가 산출이며 Codex 계열의 모델과 노력은 배정표가 직접 고정한다.
- 검토전개 모델: gpt-5.6-sol med. 배정표 codex-full 전개 값이며 FAIL 시 중대 지적의 자체 검토와 수리 설계를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md --model gpt-5.6-sol --writes 24000 --pending 70000 --root C:\cdda
  시각: 2026-08-24T13:53:48Z
  대상해시: sha1:113c74b92b2c
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .claude\skills\do-dag\계약\렌즈.md: ~3,095tok
  .claude\skills\do-dag\계약\판정.md: ~1,125tok
  .sdd\dag\parallel-turn-impl\결정\1-프레임체급.md: ~1,639tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~36,842tok (70,000바이트 — 측정 시점 미존재)
  읽기 합계: ~86,963tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 24,000바이트는 하한 미달)
  소요 견적: ~159,963tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3-판정.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.

## 임무

1. 행→정본 방향으로 문언, 좌표, 모델 배정, 소비 간선, 병행 자격을 대조한다.
2. 판정 코퍼스 밖 근거의 지적은 근거 미확인으로 적고 판정 계수에 넣지 않는다.
3. 중대 지적이 하나 이상이면 검토전개 행을 판정 파일보다 먼저 등재한다.
4. 판정 대상 전건과 실행한 검사를 기록한다. 지적이 없으면 그 외 없음과 검사 범위를 적는다.

````

### 행 2.4: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md

````markdown
---
행: 2.4
유형: 파견
---

# 승인 대조 렌즈

- 목표: 사용자 확정 문면이 행 2의 구조와 후행 소비 계약에 변형 없이 반영됐는지 판정한다.
- 완료 기준: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4-판정.md가 실재한다. frontmatter에 `VERDICT: PASS|FAIL`과 `계수:`가 있다. 판정은 근거 좌표, 닫힌 검사 범위, 무발견 영역을 기록한다.
- 렌즈: 승인 대조
- 판정 대상: C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4-판정.md
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md
- 모델 배정 근거: 배정표 codex-full(렌즈 gpt-5.6-sol med). 판정 자체가 산출이며 Codex 계열의 모델과 노력은 배정표가 직접 고정한다.
- 검토전개 모델: gpt-5.6-sol med. 배정표 codex-full 전개 값이며 FAIL 시 중대 지적의 자체 검토와 수리 설계를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md --model gpt-5.6-sol --writes 24000 --pending 70000 --root C:\cdda
  시각: 2026-08-24T13:53:48Z
  대상해시: sha1:113c74b92b2c
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .claude\skills\do-dag\계약\렌즈.md: ~3,095tok
  .claude\skills\do-dag\계약\판정.md: ~1,125tok
  .sdd\dag\parallel-turn-impl\결정\1-프레임체급.md: ~1,639tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~36,842tok (70,000바이트 — 측정 시점 미존재)
  읽기 합계: ~86,963tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 24,000바이트는 하한 미달)
  소요 견적: ~159,963tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4-판정.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.

## 임무

1. 결정 파일의 사용자 축자와 실행 노드 범위, 순서, 금지·한정, 재검증 지시를 대조한다.
2. 판정 코퍼스 밖 근거의 지적은 근거 미확인으로 적고 판정 계수에 넣지 않는다.
3. 중대 지적이 하나 이상이면 검토전개 행을 판정 파일보다 먼저 등재한다.
4. 판정 대상 전건과 실행한 검사를 기록한다. 지적이 없으면 그 외 없음과 검사 범위를 적는다.

````

### 행 2.5: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md

````markdown
---
행: 2.5
유형: 전개
---

# 네 렌즈 판정 처분 전개

- 목표: 네 렌즈의 판정을 근거에 따라 처분하고 사용자에게 승인 가능한 작업 DAG만 게이트 2에 올린다.
- 완료 기준: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5-보고.md가 최상위 전개 행 2의 네 렌즈 판정 전건을 소비한 기각·수리·재검·상신 처분과 등재 행을 기록한다. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md가 결정 서식으로 실재한다. 승인 대상 스냅샷은 행 2가 등재한 행 파일 전건과 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.md를 포함한다. 자기 서브트리의 마지막 브리핑 행은 수리·재검 결과를 같은 결정 파일에 반영한다. 검산은 exit 0이다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 네 렌즈의 근거 대조와 수리 DAG 설계를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 30000 --pending 100000 --root C:\cdda
  시각: 2026-08-24T13:54:07Z
  대상해시: sha1:01831a6781fa
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\결정\1-프레임체급.md: ~1,639tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  미존재 정본: ~52,632tok (100,000바이트 — 측정 시점 미존재)
  읽기 합계: ~110,499tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 30,000바이트는 하한 미달)
  소요 견적: ~183,499tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-12의 게이트 전 설계 검증 책임. 새 수리 이음새가 생기면 S행을 추가한다.
- 이월 사슬: 자기 서브트리의 마지막 브리핑 행이 결정/2-작업DAG.md를 쓰고, 2.5.z가 게이트 2로 넘긴다.
- 안전 속성·계약: 코퍼스 상한, 결정 축자 불가침, 근거 없는 지적 불산입, 수리 뒤 독립 재검.

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.d\불변식.md를 자식 행보다 먼저 쓴다.
2. 자기 층의 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.5.z는 이 렌즈를 선행으로 받는다.
3. 네 판정의 지적 전건을 실물과 코퍼스로 다시 대조한다. 각 지적을 기각, 수리, 재검, 상신 필요 중 하나 이상으로 닫는다.
4. 수리는 자기 층의 작업자 또는 전개 형제로 둔다. 지식자산을 고치는 작업자 바로 뒤에는 {경량} 검증런을 둔다.
5. 수리 뒤 판정 축의 재검이 필요하면 해당 렌즈를 자기 층의 형제로 다시 둔다.
6. 사용자 판단이 필요한 항목은 최종 브리핑의 신규 제약에 닫힌 목록으로 모은다.
7. 최상위 전개 행 2의 네 렌즈 판정 전건을 소비한 판정 처분과 수리 계획을 담은 C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md를 결정 서식으로 쓴다. 승인 대상 스냅샷에는 행 2가 등재한 행 파일 전건과 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.md를 축자로 넣는다.
8. 마지막 브리핑 작업자 행은 수리·재검 결과를 같은 결정 파일에 반영한다. 2.g2는 2.5.z 뒤에 선다.
9. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
10. 자식 행을 먼저 쓰고 파견표를 고친다. 작성 중 검산에는 `--mode partial --writer 2.5`를 붙인다.
11. 검산 명령이 exit 0이면 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5-보고.md를 마지막에 쓴다.
````

### 행 2.6: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md

````markdown
---
행: 2.6
유형: 전개
격리: worktree
base:
---

# 병렬 프로파일 표면 실행 노드

- 목표: 작업자 평가 CPU, 직렬 병합 CPU, 주 스레드 CPU, 변경·충돌 계수를 재현 가능한 프로파일로 분리한다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.6.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.6.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, cataclysm-dda/src/turn_profiler.h, cataclysm-dda/src/turn_profiler.cpp, cataclysm-dda/tests/turn_profiler_test.cpp, cataclysm-dda/tools/profile-turns.ps1, cataclysm-dda/src/do_turn.cpp, cataclysm-dda/src/monmove.cpp, cataclysm-dda/src/character.cpp, cataclysm-dda/src/character_body.cpp, cataclysm-dda/src/sounds.cpp, cataclysm-dda/src/map.cpp, cataclysm-dda/src/map_field.cpp
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 5절, 13절, 16.1절, 16.2절, 18절 9~10항
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-01 노출
- 이월 사슬: schema와 계측 API를 2.7, 2.8, 2.13, 2.14가 소비한다.
- 안전 속성·계약: 프로파일 schema, 작업자 전용 누적 배열, `background.other` 차감, JSON·HTML·PowerShell 동문성

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| P-01 | schema_version을 올리고 `primary_thread_cycles`를 JSON·HTML·시험에 연결한다. | 2.6 | CK-1: 작업자 시험·보고와 2.6.z 결산이 이 요구의 실결합 증거를 지목한다. |
| P-02 | `worker.<측정 요소>`와 `reduce.<측정 요소>`를 작업자별 누적 뒤 주 스레드 합산으로 기록한다. | 2.6 | CK-2: 작업자 시험·보고와 2.6.z 결산이 이 요구의 실결합 증거를 지목한다. |
| P-03 | 생물·플레이어·체온·음향·방출·아이템 하위 측정 구간을 인계문 16.2절 3~8항대로 분리한다. | 2.6 | CK-3: 작업자 시험·보고와 2.6.z 결산이 이 요구의 실결합 증거를 지목한다. |
| P-04 | `turn_workers`, 턴당 변경 레코드 수, 같은 대상 충돌 수를 기록하고 시험한다. | 2.6 | CK-4: 작업자 시험·보고와 2.6.z 결산이 이 요구의 실결합 증거를 지목한다. |
| P-05 | `-TurnWorkers N` 전달값과 JSON 값을 PowerShell이 대조해 불일치에서 실패한다. | 2.6 | CK-5: 작업자 시험·보고와 2.6.z 결산이 이 요구의 실결합 증거를 지목한다. |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.6 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.6.z는 충족성 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.6.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.6.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.6`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6-보고.md를 마지막에 쓴다.
````

### 행 2.7: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md

````markdown
---
행: 2.7
유형: 전개
격리: worktree
base:
---

# 공통 직렬 구조 실행 노드

- 목표: 고정 입력, 값 기반 변경, 대상별 병합, 결정론 난수, 단일 작업자 실행, 측정 요소 감사의 공통 계약을 닫는다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.7.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.7.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, cataclysm-dda/src/turn_input_state.h, cataclysm-dda/src/turn_input_state.cpp, cataclysm-dda/src/turn_change.h, cataclysm-dda/src/turn_change.cpp, cataclysm-dda/src/turn_random_stream.h, cataclysm-dda/src/turn_random_stream.cpp, cataclysm-dda/src/turn_executor.h, cataclysm-dda/src/turn_executor.cpp, cataclysm-dda/tests/turn_parallel_test.cpp, cataclysm-dda/CMakeLists.txt
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 3~4절, 9절, 11절 1~8항, 13절, 16.3절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-01 연결, S-02·S-03·S-04·S-14 노출
- 이월 사슬: 공통 공개 계약과 상태 검증값 계약을 2.8·2.10·2.12·2.13·2.14가 소비한다.
- 안전 속성·계약: 입력 불변성, 변경 원자성, 대상별 버킷, 순서 키 전체 순서, 난수 다섯 입력과 상수, 소유 결과 단일 작성자, 감사 fail-closed, 변경 버퍼 재사용, 깊은 복사 금지, 상태 검증값의 값 기반 직렬화

## 측정 요소 감사 공통 계약

2.7은 아래 등록부의 이름, 소유 행, 감사표 형식을 공통 계약으로 구현하고 검사한다. 각 후행 행은 자기 이름마다 한 표를 작업자 보고와 시험에 남긴다. 표의 다섯 필드는 `입력 목록`, `모든 쓰기`, `도달 가능한 전역 접근`, `난수 호출`, `결과의 적용 대상`이다. 다섯 필드 중 하나라도 닫히지 않으면 해당 측정 요소를 기존 직렬 경로에 유지한다. 표가 열린 측정 요소를 병렬 결선하거나 기본값 후보 근거로 쓰지 않는다.

| 측정 요소 | 소유 행 | 감사표 필드 |
|---|---|---|
| `map.items` | 2.9 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `map.visibility` | 2.9 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `scent` | 2.9 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `map.emissions` | 2.9 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `map.fields` | 2.9 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `player.temperature` | 2.10 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `player.replenish` | 2.10 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `player.body` | 2.10 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `map.creature_fields` | 2.10 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `sounds.effects` | 2.11 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `creatures` | 2.12 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `sounds.markers` | 2.12 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |
| `sounds.ai` | 2.12 | 입력 목록, 모든 쓰기, 도달 가능한 전역 접근, 난수 호출, 결과의 적용 대상 |

## 요구→행 추적

## 상태 검증값 정의 등록부

이 절의 C-09가 상태 검증값 정의의 유일한 공통 생산 계약이다. 후행 행은 C-09를 소비하고 상태 필드 목록을 다시 정의하지 않는다.

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| C-01 | `turn_input_state`가 인계문 9.1절 입력 전건을 값 또는 불변 `const` 보기로 제공하고 가변 포인터를 막는다. | 2.7 | CK-1: 작업자 시험·보고와 2.7.z 결산이 이 요구의 실결합 증거를 지목한다. |
| C-02 | 확인된 변경 종류 전건과 확장 통로, 직렬화 가능한 값, 원자 쓰기 대상, `turn_change_order`를 구현한다. | 2.7 | CK-2: 작업자 시험·보고와 2.7.z 결산이 이 요구의 실결합 증거를 지목한다. |
| C-03 | 변경 레코드를 쓰기 대상별 정렬 배열·버킷으로 분할한다. 각 대상별 버킷의 머리 중 최소 `turn_change_order`를 고르는 k-way 병합으로 모든 원자 변경을 `turn_change_order` 전체 순서로 적용한다. 전역 변경 배열을 추가로 정렬하지 않는다. 시험은 서로 다른 대상의 변경이 섞인 입력에서 전체 적용 순서와 대상별 버킷 생산·소비 결선을 검사하고, 전역 추가 정렬 호출 부재를 검사한다. | 2.7 | CK-3: 작업자 시험·보고와 2.7.z 결산이 이 요구의 실결합 증거를 지목한다. |
| C-04 | FNV-1a 상수와 `mix` 축자를 사용한 `turn_random_stream`을 구현하고 seed·1·2·4·제출 순서 시험을 둔다. | 2.7 | CK-4: 작업자 시험·보고와 2.7.z 결산이 이 요구의 실결합 증거를 지목한다. |
| C-05 | 작업자 하나의 `turn_executor`, 소유 결과 작성자 단언, 공통 구조 빌드 결선을 구현한다. | 2.7 | CK-5: 작업자 시험·보고와 2.7.z 결산이 이 요구의 실결합 증거를 지목한다. |
| C-06 | 작업자별 변경 레코드 버퍼를 평가 전 `reserve`하고, 턴 종료 뒤 `clear`만 하여 다음 턴에 같은 버퍼와 `capacity`를 재사용한다. 2턴 이상 검사에서 주소와 `capacity` 보존, 턴 중 재할당 횟수 0을 기록한다. | 2.7 | CK-6: 버퍼 재사용 시험과 2.7-보고의 `capacity`·할당 계수 증거를 2.7.z 결산이 판정한다. |
| C-07 | 변경 레코드를 쓰기 대상별 정렬 배열·버킷으로 분할한다. 각 대상별 버킷의 머리 중 최소 `turn_change_order`를 고르는 k-way 병합으로 모든 원자 변경을 `turn_change_order` 전체 순서로 적용한다. 전역 변경 배열을 추가로 정렬하지 않는다. 시험은 서로 다른 대상의 변경이 섞인 입력에서 전체 적용 순서와 대상별 버킷 생산·소비 결선을 검사하고, 전역 추가 정렬 호출 부재를 검사한다. | 2.7 | CK-7: 버킷 구조·전역 정렬 금지 검사·서로 다른 대상의 전체 순서·대상별 버킷 생산·소비 결선 시험을 2.7.z 결산이 판정한다. |
| C-08 | `turn_input_state`는 필요한 값과 수명 동안 불변인 보기만 구축한다. 전체 게임 객체 깊은 복사 생성자·복사 경로를 금지하고, 입력 구축 시험은 복사 계수 0과 허용된 필드별 복사만 기록한다. | 2.7 | CK-8: 입력 구축 계측·깊은 복사 금지 검사·소비자 시험을 2.7.z 결산이 판정한다. |
| C-09 | 상태 검증값의 공통 생산 계약을 구현한다. 구현자는 행 안에서 다음을 확정한다. (1) 다음 턴의 의미를 바꾸는 상태 필드의 닫힌 목록, (2) 각 필드의 값 기반 정규화 규칙, (3) 필드 이름과 정규화한 바이트의 축자 직렬화 순서, (4) 각 필드 길이와 전체 고정 길이 계산식이다. 상태 검증값의 등록부는 `turn_input_state`·소유 결과·변경 적용 뒤 상태·난수 상태·후속 턴에 영향을 주는 전역 상태를 대조해 필드를 확정한다. 포인터 주소와 메모리 할당 주소는 직렬화하지 않는다. 시험은 등록부의 각 필드를 하나씩 의미 있게 바꿀 때 검증값이 바뀌는지, 의미 값이 같고 포인터 주소만 다를 때 검증값이 같은지, 의미 값이 같고 메모리 할당 배치만 다를 때 검증값이 같은지 검사한다. 주소 문자열 검색은 주소 제외 시험을 대신하지 않는다. | 2.7 | CK-9: 닫힌 필드 등록부, 정규화 표, 축자 직렬화 순서, 고정 길이 계산, 필드별 변이 시험, 포인터 주소 불변성 시험, 메모리 할당 배치 불변성 시험을 2.7 작업자 보고와 2.7.z 결산이 지목한다. 하나라도 실패하면 결정성 게이트를 닫고 병렬 실행 모드를 기본값으로 설정하지 않는다. |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.7 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.7.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.7.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.7.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.7`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7-보고.md를 마지막에 쓴다.
````

### 행 2.8: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md

````markdown
---
행: 2.8
유형: 전개
격리: worktree
base:
---

# 지속 작업자 실행기 실행 노드

- 목표: 턴마다 생성하지 않는 작업자와 명령줄 작업자 수 계약을 예외·종료 안전성과 함께 구현한다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.8.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.8.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, cataclysm-dda/src/turn_executor.h, cataclysm-dda/src/turn_executor.cpp, cataclysm-dda/src/main.cpp, cataclysm-dda/tools/profile-turns.ps1, cataclysm-dda/tests/turn_parallel_test.cpp
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 4.3절, 11절 9~10항, 16.4절, 17.1절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-01·S-02·S-03·S-04 연결, S-05 노출
- 이월 사슬: 작업 제출·대기·종료 API를 계산 그룹과 턴 결선이 소비한다.
- 안전 속성·계약: 0·1·2·4 의미, 주 스레드 참여, 예외 전달, 지속 작업자 수명, 종료 합류

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| E-01 | 게임 시작 시 `N-1` 작업자를 만들고 주 스레드가 남은 작업을 실행한다. | 2.8 | CK-1: 작업자 시험·보고와 2.8.z 결산이 이 요구의 실결합 증거를 지목한다. |
| E-02 | N=0은 하드웨어 동시성 또는 1, N=1은 새 작업자 없음, N=2·4는 전체 평가 스레드 수로 동작한다. | 2.8 | CK-2: 작업자 시험·보고와 2.8.z 결산이 이 요구의 실결합 증거를 지목한다. |
| E-03 | 작업자 예외를 주 스레드에 전달하고 게임 종료에서 모든 작업자를 합류시킨다. | 2.8 | CK-3: 작업자 시험·보고와 2.8.z 결산이 이 요구의 실결합 증거를 지목한다. |
| E-04 | `--turn-workers N`과 PowerShell `-TurnWorkers`를 실행기와 프로파일 메타데이터에 연결한다. | 2.8 | CK-4: 작업자 시험·보고와 2.8.z 결산이 이 요구의 실결합 증거를 지목한다. |
| E-05 | 2.7/C-09의 상태 검증값 생산 계약과 세 양방향 시험을 전건 소비한다. 1·2·4 작업자 상태 검증값과 종료 뒤 잔존 작업자 없음 시험을 둔다. 닫힌 필드 목록의 각 필드 변이, 포인터 주소만 다른 동등 상태, 메모리 할당 배치만 다른 동등 상태를 1·2·4 작업자 실행에서 검사한다. C-09 또는 기능 조건 17.1절이 실패하면 결정성 게이트를 닫고 병렬 실행 모드를 기본값으로 설정하지 않는다. | 2.8 | CK-5: C-09 등록부·정규화·직렬화 순서·고정 길이 계산과 필드별 변이·포인터 주소 불변성·할당 배치 불변성 시험, 작업자 1·2·4·종료 시험을 2.8 작업자 보고와 2.8.z 결산이 지목한다. |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.8 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.8.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.8.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.8.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.8`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8-보고.md를 마지막에 쓴다.

````

### 행 2.9: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md

````markdown
---
행: 2.9
유형: 전개
격리: worktree
base:
---

# 지도 계산 이관 실행 노드

- 목표: 냄새·가시성·필드·아이템·방출을 고정 입력 평가와 순서 적용으로 이관한다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.9.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.9.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, cataclysm-dda/src/scent_map.cpp, cataclysm-dda/src/map.cpp, cataclysm-dda/src/map_field.cpp, cataclysm-dda/tests/turn_parallel_test.cpp
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 6.4절, 9.5절, 10.4절, 11절, 16.5절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-02·S-03·S-04·S-05 연결, S-06 노출
- 이월 사슬: 지도 소유 출력과 변경 레코드 적용점을 2.13이 소비한다.
- 안전 속성·계약: 조밀 배열 이중 버퍼, 가시성 패스 장벽, 희소 활성 목록, 경계 밖 변경, 지도 난수 경계

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| M-01 | 냄새 현재·다음 배열과 네 동반 값을 한 묶음으로 공개하고 행 구역 비교 시험을 둔다. | 2.9 | CK-1: 작업자 시험·보고와 2.9.z 결산이 이 요구의 실결합 증거를 지목한다. |
| M-02 | 가시성 패스 순서와 패스 장벽을 유지하며 각 작업이 자기 출력 구역만 쓰게 한다. | 2.9 | CK-2: 작업자 시험·보고와 2.9.z 결산이 이 요구의 실결합 증거를 지목한다. |
| M-03 | 필드·지상 활성 아이템·차량 아이템을 활성 서브맵 단위로 평가하고 경계 밖 변경을 기록한다. | 2.9 | CK-3: 작업자 시험·보고와 2.9.z 결산이 이 요구의 실결합 증거를 지목한다. |
| M-04 | 가구 방출 위치 목록과 지형 방출 위치 목록을 좌표 `(z, y, x)` 오름차순의 안정된 공간 순서로 각각 정렬한다. 작업자 수 `N`마다 각 목록 길이 `L`의 반열림 구간 `[floor(iL/N), floor((i+1)L/N))`을 작업자 `i`에 배정한다. 작업자는 배정 구간의 위치만 평가한다. 시험은 `N=1, 2, 4`에서 두 목록의 정렬, 구간의 무중복·전범위 합집합, 각 작업자 구간의 원 목록 연속성, 구역 밖 위치 부재를 검사한다. `mon_info_update()`는 지도 방출에서 분리한다. | 2.9 | CK-4: 작업자 시험·보고와 2.9.z 결산이 두 안정 순서, 작업자별 연속 구간, 구역 보존 시험과 분리된 `mon_info_update()`를 지목한다. |
| M-05 | 필드·활성 아이템·방출이 없는 타일에 작업을 만들지 않고 전역 접근·쓰기·난수 표를 닫는다. | 2.9 | CK-5: 작업자 시험·보고와 2.9.z 결산이 이 요구의 실결합 증거를 지목한다. |
| M-06 | `map.items`, `map.visibility`, `scent`, `map.emissions`, `map.fields`마다 공통 계약의 다섯 필드 감사표를 완성한다. 열린 필드가 있으면 그 측정 요소를 기존 직렬 경로에 유지한다. 변경 레코드는 2.7의 사전 할당 작업자 버퍼에만 기록하고 대상별 버킷으로 소비한다. `turn_input_state`는 전체 게임 객체 깊은 복사를 하지 않는다. | 2.9 | CK-6: 다섯 감사표, 직렬 유지 처분, 버퍼 `capacity` 재사용, 대상별 버킷 소비, 입력 구축 복사 계측을 2.9.z 결산이 판정한다. |

## 지도 측정 요소 감사표

작업자는 아래 각 행의 다섯 필드를 소스 좌표와 함께 닫는다. `열림` 또는 `미확인`은 결과란에 `기존 직렬 경로 유지`만 쓸 수 있다.

| 측정 요소 | 입력 목록 | 모든 쓰기 | 도달 가능한 전역 접근 | 난수 호출 | 결과의 적용 대상 | 결과 |
|---|---|---|---|---|---|---|
| `map.items` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `map.visibility` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `scent` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `map.emissions` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `map.fields` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.9 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.9.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.9.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.9.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.9`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9-보고.md를 마지막에 쓴다.
````

### 행 2.10: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md

````markdown
---
행: 2.10
유형: 전개
격리: worktree
base:
---

# 플레이어 상태 이관 실행 노드

- 목표: 플레이어 다섯 평가 작업의 소유권을 분리하고 제출 순서 독립인 병합을 구현한다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.10.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.10.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, cataclysm-dda/src/character_body.cpp, cataclysm-dda/src/character.cpp, cataclysm-dda/src/game.cpp, cataclysm-dda/src/map_field.cpp, cataclysm-dda/tests/turn_parallel_test.cpp
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 6.2절, 9.1~9.5절, 10.2절, 16.6절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-02·S-03·S-04·S-05 연결, S-07 노출
- 이월 사슬: 플레이어 결과 병합과 가시성 결과를 2.13이 소비한다.
- 안전 속성·계약: 다섯 고정 결과 구조체, 필드별 유일 작성자, 외부 변경 전환, `turn_system` 병합 순서

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| U-01 | 플레이어 시작 상태를 입력에 넣고 body·replenish·temperature·field·visibility 작업을 만든다. | 2.10 | CK-1: 작업자 시험·보고와 2.10.z 결산이 이 요구의 실결합 증거를 지목한다. |
| U-02 | 다섯 고정 결과 구조체의 직접 작성 범위가 겹치지 않는 소유 표와 단언을 둔다. | 2.10 | CK-2: 작업자 시험·보고와 2.10.z 결산이 이 요구의 실결합 증거를 지목한다. |
| U-03 | 효과·사기·인벤토리·지도 아이템·메시지의 복수 작성 가능 값을 변경 레코드로 전환한다. | 2.10 | CK-3: 작업자 시험·보고와 2.10.z 결산이 이 요구의 실결합 증거를 지목한다. |
| U-04 | 가시성 기억, 적대 목록, 안전 모드, 활동 중단, 메시지 결과를 명시한 순서로 적용한다. | 2.10 | CK-4: 작업자 시험·보고와 2.10.z 결산이 이 요구의 실결합 증거를 지목한다. |
| U-05 | 2.7/C-09의 상태 검증값 생산 계약과 세 양방향 시험을 전건 소비한다. 평가 제출 순서 전건에서 같은 플레이어 상태가 나오는 시험을 둔다. 닫힌 필드 목록의 각 필드 변이, 포인터 주소만 다른 동등 상태, 메모리 할당 배치만 다른 동등 상태를 제출 순서 전건에서 검사한다. C-09 또는 기능 조건 17.1절이 실패하면 결정성 게이트를 닫고 병렬 실행 모드를 기본값으로 설정하지 않는다. | 2.10 | CK-5: C-09 등록부·정규화·직렬화 순서·고정 길이 계산과 필드별 변이·포인터 주소 불변성·할당 배치 불변성 시험, 제출 순서 전건 시험을 2.10 작업자 보고와 2.10.z 결산이 지목한다. |
| U-06 | `player.temperature`, `player.replenish`, `player.body`, `map.creature_fields`마다 공통 계약의 다섯 필드 감사표를 완성한다. 열린 필드가 있으면 그 측정 요소를 기존 직렬 경로에 유지한다. 변경 레코드는 2.7의 사전 할당 작업자 버퍼에만 기록하고 대상별 버킷으로 소비한다. `turn_input_state`는 전체 게임 객체 깊은 복사를 하지 않는다. | 2.10 | CK-6: 네 감사표, 직렬 유지 처분, 버퍼 `capacity` 재사용, 대상별 버킷 소비, 입력 구축 복사 계측을 2.10.z 결산이 판정한다. |

## 플레이어 측정 요소 감사표

작업자는 아래 각 행의 다섯 필드를 소스 좌표와 함께 닫는다. `열림` 또는 `미확인`은 결과란에 `기존 직렬 경로 유지`만 쓸 수 있다.

| 측정 요소 | 입력 목록 | 모든 쓰기 | 도달 가능한 전역 접근 | 난수 호출 | 결과의 적용 대상 | 결과 |
|---|---|---|---|---|---|---|
| `player.temperature` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `player.replenish` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `player.body` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `map.creature_fields` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.10 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.10.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.10.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.10.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.10`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10-보고.md를 마지막에 쓴다.
````

### 행 2.11: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md

````markdown
---
행: 2.11
유형: 전개
격리: worktree
base:
---

# 음향 계산 이관 실행 노드

- 목표: 음향 계산과 오디오 부수효과를 분리하고 오디오 단일 소유와 종료 합류를 구현한다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.11.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.11.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, cataclysm-dda/src/sounds.cpp, cataclysm-dda/src/sounds.h, cataclysm-dda/src/sound_backend.h, cataclysm-dda/src/sound_backend_sdl3.cpp, cataclysm-dda/src/sdlsound.cpp, cataclysm-dda/src/sdlsound.h, cataclysm-dda/tests/turn_parallel_test.cpp
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 6.3절, 9.3~9.5절, 10.3절, 16.7절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-02·S-03·S-04·S-05 연결, S-08 노출
- 이월 사슬: 음향 변경과 종료 API를 2.13이 소비한다.
- 안전 속성·계약: 값 기반 `audio_command`, 오디오 호출 전수, 단일 소유 대기열, 음소거 순서, 종료 합류

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| A-01 | 음향 입력을 고정 상태에 넣고 평가 작업이 오디오 라이브러리 대신 값 기반 명령만 만든다. | 2.11 | CK-1: 작업자 시험·보고와 2.11.z 결산이 이 요구의 실결합 증거를 지목한다. |
| A-02 | 듣기·효과·메시지·활동 취소·생물 기억 결과를 `audio_command`와 분리한 변경으로 보낸다. | 2.11 | CK-2: 작업자 시험·보고와 2.11.z 결산이 이 요구의 실결합 증거를 지목한다. |
| A-03 | 오디오 호출 전건을 한 소유 스레드 대기열로 연결하고 detach 경로를 제거하거나 대체한다. | 2.11 | CK-3: 작업자 시험·보고와 2.11.z 결산이 이 요구의 실결합 증거를 지목한다. |
| A-04 | 음소거 전환과 명령 순서를 시험한다. | 2.11 | CK-4: 작업자 시험·보고와 2.11.z 결산이 이 요구의 실결합 증거를 지목한다. |
| A-05 | 새 명령 중지, 기본 대기열 폐기, 게임 상태 파괴 전 합류, 잔존 스레드 없음 시험을 둔다. | 2.11 | CK-5: 작업자 시험·보고와 2.11.z 결산이 이 요구의 실결합 증거를 지목한다. |
| A-06 | `sounds.effects`의 공통 계약 다섯 필드 감사표를 완성한다. 열린 필드가 있으면 `sounds.effects`를 기존 직렬 경로에 유지한다. 변경 레코드는 2.7의 사전 할당 작업자 버퍼에만 기록하고 대상별 버킷으로 소비한다. `turn_input_state`는 전체 게임 객체 깊은 복사를 하지 않는다. | 2.11 | CK-6: 감사표, 직렬 유지 처분, 버퍼 `capacity` 재사용, 대상별 버킷 소비, 입력 구축 복사 계측을 2.11.z 결산이 판정한다. |

## 음향 측정 요소 감사표

작업자는 아래 행의 다섯 필드를 소스 좌표와 함께 닫는다. `열림` 또는 `미확인`은 결과란에 `기존 직렬 경로 유지`만 쓸 수 있다.

| 측정 요소 | 입력 목록 | 모든 쓰기 | 도달 가능한 전역 접근 | 난수 호출 | 결과의 적용 대상 | 결과 |
|---|---|---|---|---|---|---|
| `sounds.effects` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.11 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.11.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.11.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.11.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.11`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11-보고.md를 마지막에 쓴다.
````

### 행 2.12: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md

````markdown
---
행: 2.12
유형: 전개
격리: worktree
base:
---

# 생물 계산 이관 실행 노드

- 목표: 생물별 평가와 이동·공격 변경을 안정 순회 번호와 결정적 충돌 병합으로 구현한다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.12.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.12.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, cataclysm-dda/src/creature_tracker.h, cataclysm-dda/src/monmove.cpp, cataclysm-dda/tests/turn_parallel_test.cpp
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 6.1절, 9.1~9.5절, 10.1절, 16.8절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-02·S-03·S-04·S-05 연결, S-09 노출
- 이월 사슬: 생물 결과와 충돌 병합을 2.13이 소비한다.
- 안전 속성·계약: 몬스터 뒤 NPC 안정 번호, 생물별 소유 결과, 시작 점유 읽기, 이동 원자성, 패배자 시작 위치

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| B-01 | 몬스터가 NPC보다 앞서는 시작 순회 번호와 생물별 전용 결과 위치를 만든다. | 2.12 | CK-1: 작업자 시험·보고와 2.12.z 결산이 이 요구의 실결합 증거를 지목한다. |
| B-02 | 상태 효과·이동력·계획·소리 인지·필드 적용을 고정 입력 평가로 옮긴다. | 2.12 | CK-2: 작업자 시험·보고와 2.12.z 결산이 이 요구의 실결합 증거를 지목한다. |
| B-03 | 이동·공격·소환·사망·타 생물 효과를 원자 변경 레코드로 만든다. | 2.12 | CK-3: 작업자 시험·보고와 2.12.z 결산이 이 요구의 실결합 증거를 지목한다. |
| B-04 | 목적지 충돌을 작은 source_order부터 적용하고 패배자를 시작 위치에 남긴다. | 2.12 | CK-4: 작업자 시험·보고와 2.12.z 결산이 이 요구의 실결합 증거를 지목한다. |
| B-05 | 2.7/C-09의 상태 검증값 생산 계약과 세 양방향 시험을 전건 소비한다. 1·2·4 작업자와 제출 순서에서 생물 상태 검증값이 같고 재계획하지 않는 시험을 둔다. 닫힌 필드 목록의 각 필드 변이, 포인터 주소만 다른 동등 상태, 메모리 할당 배치만 다른 동등 상태를 생물 실행에서 검사한다. C-09 또는 기능 조건 17.1절이 실패하면 결정성 게이트를 닫고 병렬 실행 모드를 기본값으로 설정하지 않는다. | 2.12 | CK-5: C-09 등록부·정규화·직렬화 순서·고정 길이 계산과 필드별 변이·포인터 주소 불변성·할당 배치 불변성 시험, 생물 작업자·제출 순서·재계획 시험을 2.12 작업자 보고와 2.12.z 결산이 지목한다. |
| B-06 | `creatures`, `sounds.markers`, `sounds.ai`마다 공통 계약의 다섯 필드 감사표를 완성한다. 열린 필드가 있으면 그 측정 요소를 기존 직렬 경로에 유지한다. 변경 레코드는 2.7의 사전 할당 작업자 버퍼에만 기록하고 대상별 버킷으로 소비한다. `turn_input_state`는 전체 게임 객체 깊은 복사를 하지 않는다. | 2.12 | CK-6: 세 감사표, 직렬 유지 처분, 버퍼 `capacity` 재사용, 대상별 버킷 소비, 입력 구축 복사 계측을 2.12.z 결산이 판정한다. |

## 생물 측정 요소 감사표

작업자는 아래 각 행의 다섯 필드를 소스 좌표와 함께 닫는다. `열림` 또는 `미확인`은 결과란에 `기존 직렬 경로 유지`만 쓸 수 있다.

| 측정 요소 | 입력 목록 | 모든 쓰기 | 도달 가능한 전역 접근 | 난수 호출 | 결과의 적용 대상 | 결과 |
|---|---|---|---|---|---|---|
| `creatures` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `sounds.markers` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |
| `sounds.ai` | 소스 좌표 전건 | 소스 좌표 전건 | 소스 좌표 전건 | 호출별 처분 | 적용 좌표 전건 | 병렬 또는 기존 직렬 경로 유지 |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.12 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.12.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.12.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.12.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.12`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12-보고.md를 마지막에 쓴다.
````

### 행 2.13: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md

````markdown
---
행: 2.13
유형: 전개
격리: worktree
base:
---

# 새 턴 순서 결선 실행 노드

- 목표: 13개 평가와 직렬 유지 범위를 7단계 턴 상태 전이에 실제로 연결한다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.13.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.13.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, cataclysm-dda/src/do_turn.cpp, cataclysm-dda/src/game.cpp, cataclysm-dda/src/main.cpp, cataclysm-dda/tests/turn_parallel_test.cpp, cataclysm-dda/CMakeLists.txt
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 7~8절, 13절, 16.9절, 19절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-01~S-09·S-14 연결, S-10 노출
- 이월 사슬: 완전 조립 기능, 상태 검증값 결정성 게이트, 기본값 상태를 2.14가 소비한다.
- 안전 속성·계약: S_t 고정 위치, 13개 중복 호출 제거, 순서 적용, 새 게임·로드 초기화, 실행기·오디오 종료, 상태 검증값 결정성 게이트

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| I-01 | 인계문 8절의 7단계를 `game::do_turn()`에 연결하고 S_t 고정 위치를 시험한다. | 2.13 | CK-1: 작업자 시험·보고와 2.13.z 결산이 이 요구의 실결합 증거를 지목한다. |
| I-02 | 13개 측정 요소의 기존 중복 호출을 제거하고 직렬 유지 항목을 바꾸지 않는다. | 2.13 | CK-2: 작업자 시험·보고와 2.13.z 결산이 이 요구의 실결합 증거를 지목한다. |
| I-03 | 작업자 1을 직렬 비교 모드로 유지하고 작업자 0은 기능 게이트가 GREEN일 때만 기본값 후보로 둔다. | 2.13 | CK-3: 작업자 시험·보고와 2.13.z 결산이 이 요구의 실결합 증거를 지목한다. |
| I-04 | 새 게임·저장 불러오기에서 실행기를 초기화하고 종료에서 실행기와 오디오 소유 스레드를 합류시킨다. | 2.13 | CK-4: 작업자 시험·보고와 2.13.z 결산이 이 요구의 실결합 증거를 지목한다. |
| I-05 | 2.7/C-09의 상태 검증값 생산 계약과 세 양방향 시험을 전건 소비한다. GPU 없이 완전 조립 상태 검증값, 제출 순서, 순서 키, 불변 입력, 오디오 소유 시험을 통과한다. 닫힌 필드 목록의 각 필드 변이, 포인터 주소만 다른 동등 상태, 메모리 할당 배치만 다른 동등 상태를 완전 조립 경로에서 검사한다. C-09 또는 기능 조건 17.1절이 실패하면 결정성 게이트를 닫고 병렬 실행 모드를 기본값으로 설정하지 않는다. | 2.13 | CK-5: C-09 등록부·정규화·직렬화 순서·고정 길이 계산과 필드별 변이·포인터 주소 불변성·할당 배치 불변성 시험, 완전 조립 기능 시험을 2.13 작업자 보고와 2.13.z 결산이 지목한다. |
| I-06 | 2.9~2.12의 13개 감사표를 전건 소비한다. 등록부의 이름이 정확히 한 번씩 나타나고, 각 표의 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상이 닫혔거나 기존 직렬 경로 유지로 처분됐는지 검사한다. 누락·중복·열린 필드가 있으면 병렬 결선과 작업자 0 기본값 후보를 금지한다. | 2.13 | CK-6: 13행 수렴표, 이름 수·중복 검사, 필드별 처분, 직렬 유지 결선 시험을 2.13.z 결산이 판정한다. |
| I-07 | 2.7의 S-03을 소비한다. S-03의 사전 할당·턴 간 재사용 버퍼, 대상별 정렬 배열·버킷, 전역 변경 배열의 추가 정렬 금지, 전체 게임 객체 깊은 복사 금지 증거를 전건 소비한다. 2.9~2.12의 생산·소비 경로가 같은 대상별 버킷을 실제로 생산하고 소비하는지 결선 시험으로 확인한다. 시험은 서로 다른 대상의 변경이 섞인 입력에서 모든 원자 변경의 `turn_change_order` 전체 적용 순서를 확인한다. | 2.13 | CK-7: `capacity`·할당 계수, 대상별 버킷 생산·소비 경로, 서로 다른 대상의 변경이 섞인 입력의 전체 순서, 전역 추가 정렬 호출 부재, 입력 구축 복사 계측, 생산자·소비자 결선 시험을 2.13.z 결산이 판정한다. |

## 13개 감사표 수렴 검사

2.13은 아래 13행을 정확히 한 번씩 소비한다. 결과가 `병렬`이면 다섯 필드가 모두 닫힌 증거 좌표를 기록한다. 결과가 `기존 직렬 경로 유지`이면 열린 필드와 직렬 호출 좌표를 기록한다. 그 밖의 결과, 행 누락, 이름 중복은 fail-closed다.

| 측정 요소 | 생산 행 | 소비할 감사표 | 허용 결과 | 병렬 결선 조건 |
|---|---|---|---|---|
| `map.items` | 2.9 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `map.visibility` | 2.9 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `scent` | 2.9 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `map.emissions` | 2.9 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `map.fields` | 2.9 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `player.temperature` | 2.10 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `player.replenish` | 2.10 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `player.body` | 2.10 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `map.creature_fields` | 2.10 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `sounds.effects` | 2.11 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `creatures` | 2.12 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `sounds.markers` | 2.12 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |
| `sounds.ai` | 2.12 | 입력 목록·모든 쓰기·도달 가능한 전역 접근·난수 호출·결과의 적용 대상 | 병렬 또는 기존 직렬 경로 유지 | 다섯 필드 닫힘 |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.13 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.13.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.13.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.13.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.13`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13-보고.md를 마지막에 쓴다.
````

### 행 2.14: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md

````markdown
---
행: 2.14
유형: 전개
격리: worktree
base:
---

# 기능·성능 인수 실행 노드

- 목표: 전체 기능과 성능 게이트를 재현 가능한 실물로 판정하고 병렬 기본값의 허용 여부를 닫는다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.14.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.14.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다. CK-6. 같은 계열의 첫 프로파일 산출 뒤 내용 게이트를 두고, 브리핑에 실물 좌표와 내용 요건 충족 표를 넣는다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, build/turn-parallel-performance.md, cataclysm-dda/turn-profile-results/turn-parallel-final-serial-1/, cataclysm-dda/turn-profile-results/turn-parallel-final-serial-2/, cataclysm-dda/turn-profile-results/turn-parallel-final-serial-3/, cataclysm-dda/turn-profile-results/turn-parallel-final-parallel-1/, cataclysm-dda/turn-profile-results/turn-parallel-final-parallel-2/, cataclysm-dda/turn-profile-results/turn-parallel-final-parallel-3/
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 14절, 16.9절 7~8항, 17~18절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-10·S-14 연결, S-11 노출
- 이월 사슬: 인수 실물, 상태 검증값 결정성 게이트, 남은 완료 조건을 2.15가 소비한다.
- 안전 속성·계약: 기존 변경 보존, 전체 시험, 1·2·4·제출 순서 검증값, 상태 검증값 양방향 시험, 여섯 최종 출력 경로 충돌 방지, 중앙 실행 통계

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| V-02 | 2.7/C-09의 상태 검증값 생산 계약과 세 양방향 시험을 전건 소비한다. 전체 단위 테스트와 기능 검증 7조건을 실제 완전 조립에서 통과시킨다. 닫힌 필드 목록의 각 필드 변이, 포인터 주소만 다른 동등 상태, 메모리 할당 배치만 다른 동등 상태를 인수 실행에서 검사한다. C-09 또는 기능 조건 17.1절이 실패하면 결정성 게이트를 닫고 병렬 실행 모드를 기본값으로 설정하지 않는다. | 2.14 | CK-2: C-09 등록부·정규화·직렬화 순서·고정 길이 계산과 필드별 변이·포인터 주소 불변성·할당 배치 불변성 시험, 전체 단위·기능 검증 7조건을 2.14 작업자 보고와 2.14.z 결산이 지목한다. |
| V-03 | 최종 직렬·병렬 10,000턴을 같은 seed로 각각 세 번 실행한다. 최종 출력 경로가 있으면 해당 최종 실행을 실패 처리한다. | 2.14 | CK-3: 작업자 시험·보고와 2.14.z 결산이 여섯 최종 실행의 실결합 증거를 지목한다. |
| V-04 | 최종 여섯 실행의 각 모드 중앙 실행에서 평균·중앙값·P99·프로세스·주 스레드·작업자·병합 CPU와 변경·충돌 수를 보고한다. | 2.14 | CK-4: 작업자 시험·보고와 2.14.z 결산이 이 요구의 실결합 증거를 지목한다. |
| V-05 | 최종 여섯 실행의 병렬 평균과 P99가 모두 작을 때만 병렬 기본값을 허용하고 18절 12조건을 전건 판정한다. | 2.14 | CK-5: 작업자 시험·보고와 2.14.z 결산이 이 요구의 실결합 증거를 지목한다. |
| V-06 | 같은 계열 첫 프로파일 산출 뒤 내용 게이트를 두고 실물 좌표와 내용 요건 충족 표를 브리핑에 넣는다. | 2.14 | CK-6: 작업자 시험·보고와 2.14.z 결산이 이 요구의 실결합 증거를 지목한다. |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.14 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.14.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.14.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.14.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.14`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14-보고.md를 마지막에 쓴다.
13. 같은 계열의 첫 프로파일 산출 뒤 내용 게이트를 둔다. 브리핑에는 실물 좌표와 내용 요건 충족 표를 넣는다.
````

### 행 2.15: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md

````markdown
---
행: 2.15
유형: 전개
격리: worktree
base:
---

# 국면 말미 표준 검증 실행 노드

- 목표: 국면 개시 기준 대비 누적 구현과 인수 근거 전건을 독립 검증해 잔여와 발견을 닫는다.
- 완료 기준: CK-1. 요구→행 추적 전건을 자식 완료 기준에 배정한다. CK-2. 자기 첫 자식은 충족성 렌즈다. CK-3. 지식자산 작업자마다 바로 뒤에 {경량} 검증런을 둔다. CK-4. 검증런을 제외한 파견 행이 세 개 이상이면 2.15.z 바로 앞에 {경량} 검증런을 둔다. CK-5. 2.15.z가 작업자 보고, 검증런 종료보고, 귀속, 이음새, 테스트 실물을 판정한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, 국면 개시 기준 대비 master 누적 변경 전건, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.d\
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 결정/2-작업DAG.md, 인계문 3~19절, 검증_체제.md 「검증런 배치」
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 요구 추적, 쓰기 집합, 이음새, 검증 배치를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 45000 --pending 30000 --root C:\cdda
  시각: 2026-08-24T13:53:53Z
  대상해시: sha1:2fe60f5bf75b
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\기준선.md: ~5,056tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~15,789tok (30,000바이트 — 측정 시점 미존재)
  읽기 합계: ~102,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~42,750tok (저작 예상 45,000바이트 × 사고 1.9배)
  소요 견적: ~183,610tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15-보고.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.
- 이음새: S-11 연결, S-12 노출
- 이월 사슬: 표준 검증 종료보고와 노드 결산을 2.z와 행 3이 소비한다.
- 안전 속성·계약: 정본 밖 공백, 결정성·원자성·소유권·생명주기, 기능·성능 증거, 잔여 회수

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| F-01 | 자기 첫 자식 충족성 렌즈 뒤에 {표준} 검증런 1행과 자기 싱크만 둔다. | 2.15 | CK-1: 작업자 시험·보고와 2.15.z 결산이 이 요구의 실결합 증거를 지목한다. |
| F-02 | 산출물은 국면 개시 기준 대비 master 누적 변경 전건으로 실측한다. | 2.15 | CK-2: 작업자 시험·보고와 2.15.z 결산이 이 요구의 실결합 증거를 지목한다. |
| F-03 | 목적·불변식·기준 원문 재료에 사용자 결정, 13개 범위, 안전 계약, 기능·성능 실물을 싣는다. | 2.15 | CK-3: 작업자 시험·보고와 2.15.z 결산이 이 요구의 실결합 증거를 지목한다. |
| F-04 | 발견은 검토전개로, 잔여는 결산 이월로 보내며 미처분 상신을 DONE으로 닫지 않는다. | 2.15 | CK-4: 작업자 시험·보고와 2.15.z 결산이 이 요구의 실결합 증거를 지목한다. |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 자식 단위마다 쓰기 파일 집합을 닫는다. 단위 쌍마다 쓰기 교집합, 소비 간선, 배타 점유를 판정한다.
4. 판정 결과가 자식 노드를 요구하면 frontmatter를 `격리: 그룹`으로 고치고 자식 전개마다 worktree를 둔다. 아니면 base를 고정하고 마커 명령으로 2.15 worktree를 연다.
5. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.15.z는 이 렌즈를 선행으로 받는다.
6. 위 요구 ID 전건을 작업자 행의 검사 가능한 완료 기준에 배정한다. 별도 정의 문서를 만들지 않는다.
7. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 작업자 대신 검증런을 선행으로 받는다.
8. 검증런을 제외한 파견 행이 세 개 이상이면 2.15.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
9. 자기 싱크 2.15.z를 둔다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
10. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
11. 이음새 광고는 C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md의 해당 S행을 사용한다. 새 이음새에는 S행을 추가한다.
12. 작성 중 검산에는 `--mode partial --writer 2.15`을 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15-보고.md를 마지막에 쓴다.

13. 이 노드는 자식 작업자를 추가하지 않는다. 충족성 렌즈 뒤에 {표준} 검증런 1행과 실행 싱크만 둔다.
````

### 행 2.16: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\16.md

````markdown
---
행: 2.16
유형: 전개
---

# 충족성 렌즈 중대 지적 검토전개

- 목표: 렌즈 2.2의 중대 지적 전건을 자체 검토하고, 타당한 것의 수리를 설계해 깐다.
- 완료 기준: 발견마다 판정(타당·기각·상신)과 근거가 보고에 있고, 타당 판정마다 수리 행이 등재돼 있으며, 검산 exit 0이다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\16.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\16-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2-판정.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md, C:\cdda\.claude\skills\do-dag\검토전개.md
- 모델 배정 근거: gpt-5.6-sol med. 행 2.2의 `검토전개 모델:` 슬롯이 배정표 codex-full 전개 값을 직접 고정한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2-판정.md,C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md,C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 40000 --root C:\cdda
  시각: 2026-08-24T14:10:33Z
  대상해시: sha1:8a3ae6f4b05c
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\이음새.md: ~2,065tok
  .sdd\dag\parallel-turn-impl\파견표.md: ~861tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2-보고.md: ~16,760tok
  .sdd\dag\parallel-turn-impl\행\2.d\1.md: ~2,144tok
  .sdd\dag\parallel-turn-impl\행\2.d\10.md: ~3,416tok
  .sdd\dag\parallel-turn-impl\행\2.d\11.md: ~3,410tok
  .sdd\dag\parallel-turn-impl\행\2.d\12.md: ~3,383tok
  .sdd\dag\parallel-turn-impl\행\2.d\13.md: ~3,429tok
  .sdd\dag\parallel-turn-impl\행\2.d\14.md: ~3,753tok
  .sdd\dag\parallel-turn-impl\행\2.d\15.md: ~3,406tok
  .sdd\dag\parallel-turn-impl\행\2.d\2-판정.md: ~7,206tok
  .sdd\dag\parallel-turn-impl\행\2.d\2.md: ~2,143tok
  .sdd\dag\parallel-turn-impl\행\2.d\3.md: ~2,121tok
  .sdd\dag\parallel-turn-impl\행\2.d\4.md: ~2,139tok
  .sdd\dag\parallel-turn-impl\행\2.d\5.md: ~2,640tok
  .sdd\dag\parallel-turn-impl\행\2.d\6.md: ~3,379tok
  .sdd\dag\parallel-turn-impl\행\2.d\7.md: ~3,491tok
  .sdd\dag\parallel-turn-impl\행\2.d\8.md: ~3,395tok
  .sdd\dag\parallel-turn-impl\행\2.d\9.md: ~3,445tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  읽기 합계: ~123,758tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~38,000tok (저작 예상 40,000바이트 × 사고 1.9배)
  소요 견적: ~199,758tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\16-보고.md
- 반환: 완료 첫 줄 `DONE`. 둘째 줄 `보고: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\16-보고.md`. 셋째 줄 `등재 행: <수>`.

## 임무

C:\cdda\.claude\skills\do-dag\검토전개.md 전문을 읽고 그대로 따른다.
````

### 행 2.17: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\17.md

````markdown
---
행: 2.17
유형: 전개
---

# 운전성 렌즈 지적 검토전개

- 목표: 렌즈 2.1의 중대 지적 전건을 자체 검토하고, 타당한 것의 수리를 설계해 깐다.
- 완료 기준: 발견마다 판정(타당·기각·상신)과 근거가 보고에 있고, 타당 판정마다 수리 행이 등재돼 있으며, 검산 exit 0.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1-판정.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md, C:\cdda\.claude\skills\do-dag\검토전개.md
- 모델 배정 근거: 행 2.1의 검토전개 모델 슬롯은 gpt-5.6-sol med다. 배정표 codex-full 전개 값이며 FAIL 시 중대 지적의 자체 검토와 수리 설계를 한 컨텍스트에서 저작한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md,C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\1.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\2.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\4.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\7.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\8.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\9.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\10.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\11.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\12.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\13.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\15.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\판정.md,C:\cdda\.sdd\dag\parallel-turn-impl\역사\계약\렌즈.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md --model gpt-5.6-sol --writes 40000 --root C:\cdda
  시각: 2026-08-24T14:07:33Z
  대상해시: sha1:c5540546c68d
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .claude\skills\do-dag\계약\렌즈.md: ~3,095tok
  .claude\skills\do-dag\계약\판정.md: ~1,125tok
  .sdd\dag\parallel-turn-impl\이음새.md: ~2,065tok
  .sdd\dag\parallel-turn-impl\파견표.md: ~760tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2-보고.md: ~16,760tok
  .sdd\dag\parallel-turn-impl\행\2.d\1.md: ~2,144tok
  .sdd\dag\parallel-turn-impl\행\2.d\10.md: ~3,416tok
  .sdd\dag\parallel-turn-impl\행\2.d\11.md: ~3,410tok
  .sdd\dag\parallel-turn-impl\행\2.d\12.md: ~3,383tok
  .sdd\dag\parallel-turn-impl\행\2.d\13.md: ~3,429tok
  .sdd\dag\parallel-turn-impl\행\2.d\14.md: ~3,753tok
  .sdd\dag\parallel-turn-impl\행\2.d\15.md: ~3,406tok
  .sdd\dag\parallel-turn-impl\행\2.d\2.md: ~2,143tok
  .sdd\dag\parallel-turn-impl\행\2.d\3.md: ~2,121tok
  .sdd\dag\parallel-turn-impl\행\2.d\4.md: ~2,139tok
  .sdd\dag\parallel-turn-impl\행\2.d\5.md: ~2,640tok
  .sdd\dag\parallel-turn-impl\행\2.d\6.md: ~3,379tok
  .sdd\dag\parallel-turn-impl\행\2.d\7.md: ~3,491tok
  .sdd\dag\parallel-turn-impl\행\2.d\8.md: ~3,395tok
  .sdd\dag\parallel-turn-impl\행\2.d\9.md: ~3,445tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  읽기 합계: ~120,671tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~38,000tok (저작 예상 40,000바이트 × 사고 1.9배)
  소요 견적: ~196,671tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\17-보고.md
- 반환: 완료 첫 줄 `DONE`. 둘째 줄 `보고: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\17-보고.md`. 셋째 줄 `등재 행: <수>`.

## 임무

C:\cdda\.claude\skills\do-dag\검토전개.md 전문을 읽고 그대로 따른다.
````

### 행 2.18: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\18.md

````markdown
---
행: 2.18
유형: 전개
---

# 정합성 렌즈 중대 지적 검토전개

- 목표: 렌즈 2.3의 중대 지적 전건을 자체 검토하고, 타당한 지적의 수리를 설계해 깐다.
- 완료 기준: 발견마다 판정(타당·기각·상신)과 근거가 보고에 있고, 타당 판정마다 수리 행이 등재돼 있으며, 검산 exit 0이다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\18.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\18-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3-판정.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\3-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md, C:\cdda\.claude\skills\do-dag\검토전개.md
- 모델 배정 근거: gpt-5.6-sol med. 행 2.3의 `검토전개 모델:` 슬롯이 배정표 codex-full 전개 값을 직접 고정한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md,C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2-보고.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\5.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\14.md,C:\cdda\.sdd\dag\parallel-turn-impl\결정\1-프레임체급.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\references\분해_원리.md,C:\cdda\.claude\skills\do-dag\references\검증_체제.md,C:\cdda\.claude\skills\do-dag\references\서식.md,C:\cdda\.claude\skills\do-dag\references\배정.md,C:\cdda\.claude\skills\do-dag\검토전개.md --model gpt-5.6-sol --writes 24000 --pending 14000 --root C:\cdda
  시각: 2026-08-24T14:07:16Z
  대상해시: sha1:c277a0c2feb3
  .claude\skills\do-dag\references\검증_체제.md: ~8,912tok
  .claude\skills\do-dag\references\배정.md: ~4,639tok
  .claude\skills\do-dag\references\분해_원리.md: ~15,178tok
  .claude\skills\do-dag\references\서식.md: ~14,080tok
  .claude\skills\do-dag\검토전개.md: ~2,860tok
  .claude\skills\do-dag\계약\공통.md: ~4,059tok
  .sdd\dag\parallel-turn-impl\결정\1-프레임체급.md: ~1,639tok
  .sdd\dag\parallel-turn-impl\이음새.md: ~2,065tok
  .sdd\dag\parallel-turn-impl\파견표.md: ~760tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2-보고.md: ~16,760tok
  .sdd\dag\parallel-turn-impl\행\2.d\14.md: ~3,753tok
  .sdd\dag\parallel-turn-impl\행\2.d\5.md: ~2,640tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md: ~30,843tok
  미존재 정본: ~7,368tok (14,000바이트 — 측정 시점 미존재)
  읽기 합계: ~119,860tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 24,000바이트는 하한 미달)
  소요 견적: ~192,860tok
  판정: gpt-5.6-sol 200,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\18-보고.md
- 반환: 완료 첫 줄 `DONE`. 둘째 줄 `보고: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\18-보고.md`. 셋째 줄 `등재 행: <수>`.

## 임무

C:\cdda\.claude\skills\do-dag\검토전개.md 전문을 읽고 그대로 따른다.
````

### 행 2.19: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.md

````markdown
---
행: 2.19
유형: 전개
격리: worktree
base:
---

# 구현 전 기준 실행 노드

- 목표: 구현 편집 전에 인계문 14절과 16.1절의 루트·서브모듈 상태와 시작 커밋, 전체 테스트, 기준 10,000턴 프로파일, 실행 파일 해시와 두 실패 처분을 실행 가능한 증거로 닫는다.
- 완료 기준: CK-1. 구현 편집 전에 `git status --short --branch`와 `git rev-parse HEAD`를 순서대로 실행한다. `build/turn-parallel-root-status.txt`에 각 명령과 각 stdout을 구분해 기록한다. 루트 시작 커밋 기록이 `git rev-parse HEAD` stdout과 같고 비어 있지 않은 40자리 소문자 16진 커밋 객체 ID인지 검사한다. CK-2. 구현 편집 전에 `git -C cataclysm-dda status --short --branch`와 `git -C cataclysm-dda rev-parse HEAD`를 순서대로 실행한다. `build/turn-parallel-submodule-status.txt`에 각 명령과 각 stdout을 구분해 기록한다. 서브모듈 시작 커밋 기록이 `git -C cataclysm-dda rev-parse HEAD` stdout과 같고 비어 있지 않은 40자리 소문자 16진 커밋 객체 ID인지 검사한다. CK-3. `test-game.ps1` 전체 테스트를 실행한다. 전체 테스트가 성공하면 명령과 출력을 기록한다. CK-4. `turn-parallel-baseline` 출력 경로가 없고 전체 테스트가 성공한 경우에만 같은 seed의 10,000턴 기준 프로파일을 그 경로에 실행한다. CK-5. 성공한 기준 프로파일 JSON에서 실행 파일 해시를 기록한다. CK-6. 기준 출력 경로가 이미 있으면 프로파일을 시작하지 않는다. 작업자 보고 frontmatter `상태`를 `예외`로 쓰고, 실행 명령, 출력, 존재 경로인 실패 증거 좌표를 기록한다. 작업자는 첫 줄 `예외`, 둘째 줄 `코드: 기준출력선재`, 셋째 줄 `사유: 기준 출력 경로가 이미 있다`로 반환한다. CK-7. 기존 전체 테스트가 실패하면 제품 파일을 편집하지 않는다. 작업자 보고 frontmatter `상태`를 `예외`로 쓰고, 실행 명령, 출력, 테스트 실패 증거 좌표를 기록한다. 작업자는 첫 줄 `예외`, 둘째 줄 `코드: 기존테스트실패`, 셋째 줄 `사유: 기존 전체 테스트가 실패했다`로 반환한다. CK-8. 성공한 기준 실행만 `DONE`으로 닫는다. `2.19.z`는 성공한 작업자 상태 기록, 두 상태 출력, 두 시작 커밋 기록, 두 형식·동일성 검사, 성공한 전체 테스트, 기준 프로파일, 실행 파일 해시를 모두 판정한 경우에만 완결한다. CK-6 또는 CK-7의 `예외`가 있으면 `2.19.z`와 행 `2.6`은 미완결로 남는다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\작업.md, C:\cdda\.claude\skills\do-dag\계약\보고.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md, build/turn-parallel-root-status.txt, build/turn-parallel-submodule-status.txt, cataclysm-dda/turn-profile-results/turn-parallel-baseline/
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md 16.1절, 17.3절
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md, C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md, C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\작업.md, C:\cdda\.claude\skills\do-dag\계약\보고.md, C:\cdda\.claude\skills\do-dag\references\분해_원리.md, C:\cdda\.claude\skills\do-dag\references\검증_체제.md, C:\cdda\.claude\skills\do-dag\references\서식.md, C:\cdda\.claude\skills\do-dag\references\배정.md
- 모델 배정 근거: 배정표 codex-full(전개 gpt-5.6-sol med). 기준 실행의 실패 처분, 산출 경로와 후행 차단을 한 컨텍스트에서 정의한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md,C:\cdda\.sdd\dag\parallel-turn-impl\기준선.md,C:\cdda\임시\cdda-parallel-turn-implementation-handoff_검증_2026-08-24\cdda-parallel-turn-implementation-handoff.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\계약\작업.md,C:\cdda\.claude\skills\do-dag\계약\보고.md --model gpt-5.6-sol --writes 30000 --pending 30000 --root C:\cdda
  시각: 2026-08-25T00:00:00Z
  대상해시: sha1:미측정
  판정: 전개 전 재측정한다.
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19-보고.md
- 반환: 성공한 기준 실행만 완료 첫 줄 `DONE`으로 반환한다. 기준 출력 경로 선재는 첫 줄 `예외`, 둘째 줄 `코드: 기준출력선재`, 셋째 줄 `사유: 기준 출력 경로가 이미 있다`로 반환한다. 기존 전체 테스트 실패는 첫 줄 `예외`, 둘째 줄 `코드: 기존테스트실패`, 셋째 줄 `사유: 기존 전체 테스트가 실패했다`로 반환한다.
- 이음새: 없음. 기준 실행은 새 원장, 새 필드, 새 공개 함수, 새 JSON 키, 새 노드 주입 인터페이스를 만들지 않는다.
- 이월 사슬: `2.19.z`는 성공한 기준 실행 증거를 판정한 경우에만 완결한다. 성공한 `2.19.z`만 행 `2.6`을 연다. 기준 실행 작업자의 `예외`는 `2.19.z`와 행 `2.6`을 미완결로 남긴다.
- 안전 속성·계약: 성공한 기준 실행만 `DONE`으로 수확한다. 기준 출력 경로 선재는 프로파일 시작 전에 `기준출력선재` 예외로 닫는다. 기존 전체 테스트 실패는 제품 파일 편집 전에 `기존테스트실패` 예외로 닫는다. 두 예외 보고는 명령, 출력, 실패 증거 좌표와 frontmatter `상태: 예외`를 기록한다. 기준 실행은 새 원장, 새 필드, 새 공개 함수, 새 JSON 키, 새 노드 주입 인터페이스를 만들지 않으며 이음새는 `없음`으로 유지한다. 기준 프로파일과 최종 인수 프로파일을 분리한다.

## 요구→행 추적

| 요구 ID | 내용 완료 기준 | 소유 행 | 증거 형태 |
|---|---|---|---|
| V-01 | 구현 편집 전에 루트·서브모듈 상태와 시작 커밋을 기록한다. 두 증거 파일은 네 Git 명령과 각 stdout을 구분해 보존한다. 각 시작 커밋 기록은 해당 `rev-parse HEAD` stdout과 같고 비어 있지 않은 40자리 소문자 16진 커밋 객체 ID여야 한다. 성공한 전체 테스트, 기준 10,000턴 프로파일, JSON 실행 파일 해시를 기록한다. 기준 출력 경로 선재는 프로파일을 시작하지 않고 `기준출력선재` 예외 보고로 처분한다. 기존 전체 테스트 실패는 제품 파일을 편집하지 않고 `기존테스트실패` 예외 보고로 처분한다. 두 예외 보고는 명령, 출력, 실패 증거 좌표와 frontmatter `상태: 예외`를 가진다. | 2.19 | 성공한 작업자 보고와 2.19.z 결산만 두 상태 파일의 네 Git 명령·stdout, 두 시작 커밋 기록과 형식·동일성 검사, 성공한 테스트 출력, 기준 프로파일, JSON 해시를 지목한다. CK-6 또는 CK-7 예외 보고는 2.19.z와 행 2.6을 미완결로 남긴다. |

## 전개 지시

1. C:\cdda\.sdd\dag\parallel-turn-impl\결정\2-작업DAG.md의 결정 절 축자를 읽는다. 결정에 따라 기존 행과 요구 추적을 재검증한다. 어긋난 행에는 폐기·승계 표기를 남기고 재저작한다.
2. C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md를 자식 행보다 먼저 쓴다.
3. 첫 자식으로 충족성 렌즈를 둔다. 나머지 자식과 2.19.z는 이 렌즈를 선행으로 받는다.
4. 구현 편집 전에 아래 네 Git 명령을 이 순서로 실행한다.
   ```powershell
   git status --short --branch
   git rev-parse HEAD
   git -C cataclysm-dda status --short --branch
   git -C cataclysm-dda rev-parse HEAD
   ```
5. `build/turn-parallel-root-status.txt`에는 루트 상태 명령과 루트 시작 커밋 명령을, 각 명령의 stdout과 구분해 기록한다. `build/turn-parallel-submodule-status.txt`에는 서브모듈 상태 명령과 서브모듈 시작 커밋 명령을, 각 명령의 stdout과 구분해 기록한다.
6. 루트와 서브모듈 시작 커밋 기록을 각각 검사한다. 각 기록은 해당 `rev-parse HEAD` stdout과 같고 비어 있지 않은 40자리 소문자 16진 커밋 객체 ID여야 한다.
7. V-01의 두 상태 출력, 두 시작 커밋 기록, 두 형식·동일성 검사, 성공한 전체 테스트, 기준 프로파일, JSON 실행 파일 해시를 성공한 작업자 행의 검사 가능한 완료 기준으로 배정한다.
8. 기준 출력 경로가 이미 있으면 프로파일을 시작하지 않는다. 작업자 보고 frontmatter `상태`를 `예외`로 쓰고, 실행 명령, 출력, 존재 경로인 실패 증거 좌표를 기록한다. 작업자는 첫 줄 `예외`, 둘째 줄 `코드: 기준출력선재`, 셋째 줄 `사유: 기준 출력 경로가 이미 있다`로 반환한다.
9. 기존 전체 테스트가 실패하면 제품 파일을 편집하지 않는다. 작업자 보고 frontmatter `상태`를 `예외`로 쓰고, 실행 명령, 출력, 테스트 실패 증거 좌표를 기록한다. 작업자는 첫 줄 `예외`, 둘째 줄 `코드: 기존테스트실패`, 셋째 줄 `사유: 기존 전체 테스트가 실패했다`로 반환한다.
10. 상태 출력만 있거나 두 시작 커밋 기록 중 하나가 없으면 2.19 작업자와 2.19.z가 완료하지 못하게 한다. 기준 실행 작업자의 CK-6 또는 CK-7 `예외`는 2.19.z와 행 2.6을 미완결로 남긴다.
11. 2.19.z는 성공한 작업자 상태 기록, 두 상태 출력, 두 시작 커밋 기록, 두 형식·동일성 검사, 성공한 전체 테스트, 기준 프로파일, 실행 파일 해시를 모두 판정한 경우에만 완결하게 한다.
12. 지식자산을 쓰는 작업자 바로 뒤에 {경량} 검증런을 둔다. 후행은 성공한 작업자와 성공한 검증런 뒤에만 열린다.
13. 검증런을 제외한 파견 행이 세 개 이상이면 2.19.z 바로 앞에 worktree 전체 변경집합 {경량} 검증런을 둔다.
14. 자기 싱크 2.19.z를 둔다. 2.19.z는 성공한 기준 실행의 CK-8 증거만 판정해 완결한다. 실행 노드면 역할 계약 C:\cdda\.claude\skills\do-dag\계약\싱크.md를 적재한 실행 싱크로 쓴다.
15. 자식 파견문마다 이 행의 명령, 마커 명령, 스킬 루트, 두 모델 프리셋, 역할 계약, 불변식 전건, 반환 확장, 실측기 budget 블록을 전사한다.
16. 새 원장, 새 필드, 새 공개 함수, 새 JSON 키, 새 노드 주입 인터페이스를 만들지 않는다. 이음새 광고에는 `없음`을 기록한다.
17. 작성 중 검산에는 `--mode partial --writer 2.19`를 붙인다. 검산 exit 0 뒤 C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19-보고.md를 마지막에 쓴다.
````

## 결정 (메인 기입 — 사용자 발화 축자)

사용자 발화 축자: 「전면 구현 모두」

선택된 라벨: 1. **전면·단계 구현 DAG 승인 (권고)**

선택지에 표시된 설명문 전문: 전면·단계 구현 DAG 승인(권고): 아래 스냅샷의 실행 DAG를 승인한다. 게이트 2 뒤에는 2.19 기준 실행을 먼저 수행한다. 기준 실행이 성공하면 2.6~2.15를 순서대로 실행한다.

## 메인 결정 (사용자 축자 아님)


## 전파 (메인 기입 — 실행 중 결정만)

- 2026-08-27 사용자 지시 「../general의 최신 커밋 내용을 확인하고 그 수정사항 전체를 이 디렉토리의 절차 자산 등에 동형으로 적용. @.sdd/dag/parallel-turn-impl\ 에 대한 소급적용 포함」을 적용한다.
- `결정/사용자확정-전개검증런-소급적용.md`가 미착수 행의 검증 구조를 덮는다. 이 파일의 렌즈 문면은 완결 행의 역사 기록으로만 읽는다.
