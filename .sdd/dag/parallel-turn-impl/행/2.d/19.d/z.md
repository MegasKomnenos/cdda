---
행: 2.19.z
유형: 싱크
---

# 구현 전 기준 실행 싱크

- 목표: 성공한 기준 실행 증거 전건을 판정하고, 예상 실패가 없을 때만 행 2.19를 종결한다.
- 완료 기준: S-01. 행 2.19.2 보고의 frontmatter가 `상태: DONE`이다. S-02. 행 2.19.1 판정이 성공하고 중대 미처분을 남기지 않는다. S-03. 두 상태 파일, 두 시작 커밋, 두 형식·동일성 검사, 기준 프로파일 JSON, 10,000 완료 턴, seed, 실행 파일 SHA-256을 실물로 다시 판정한다. 전체 테스트 exit 0은 직접 실행하지 않고 `C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\6-보고.md`의 증거 좌표로 판정한다(`C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-전체실행일원화.md`). S-04. 행 2.19.2 보고의 루트·서브모듈 시작·종료 측정값과 비교 결과를 다시 판정한다. 시작 시점의 기존 tracked 변경은 HEAD, unstaged binary diff, staged binary diff SHA-256이 종료 측정과 각각 같아야 한다. 시작 시점의 기존 untracked 파일은 상대 경로, 파일 유형, 내용 SHA-256이 종료 측정과 각각 같아야 한다. S-05. `기준출력선재` 예외가 있으면 결산을 완결하지 않고 첫 줄 `예외`로 반환한다. S-06. 성공 증거 전건이 있으면 결산 `단계: 종결`과 `상태: DONE`을 기록한다. S-07. 기준 실행 산출은 새 원장, 새 필드, 새 공개 함수, 새 JSON 키, 새 노드 주입 인터페이스를 만들지 않는다. 이음새 전기는 `없음`이다. S-08. 폐지 — 사용자확정 결정이 기각 보관 재판정 행(2.19.8)을 제거했다. 기각 보관 항목은 판정 없이 보존한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\z-결산.md, C:\cdda\build\turn-parallel-root-status.txt, C:\cdda\build\turn-parallel-submodule-status.txt, C:\cdda\cataclysm-dda\turn-profile-results\turn-parallel-baseline\
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-전체실행일원화.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\1-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\6-보고.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-전체실행일원화.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\1-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\6-보고.md, C:\cdda\build\turn-parallel-root-status.txt, C:\cdda\build\turn-parallel-submodule-status.txt, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md
- 모델 배정 근거: 배정표 codex-full(싱크 gpt-5.6-terra low). 단계 원장과 CK-8이 판정 절차를 닫는다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\기각보관\2.19.4.3-라운드1-소급.md,C:\cdda\build\turn-parallel-root-status.txt,C:\cdda\build\turn-parallel-submodule-status.txt,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\계약\싱크.md --model gpt-5.6-terra --writes 18000 --pending 50000 --root C:\cdda
  시각: 2026-08-25T15:16:59Z
  대상해시: sha1:6262ce27e201
  .claude\skills\do-dag\계약\공통.md: ~4,077tok
  .claude\skills\do-dag\계약\싱크.md: ~10,040tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\19.d\기각보관\2.19.4.3-라운드1-소급.md: ~865tok
  .sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md: ~1,380tok
  .sdd\dag\parallel-turn-impl\행\2.d\19.md: ~5,534tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  build\turn-parallel-root-status.txt: ~3,741tok
  build\turn-parallel-submodule-status.txt: ~45tok
  미존재 정본: ~26,316tok (50,000바이트 — 측정 시점 미존재)
  읽기 합계: ~56,302tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 18,000바이트는 하한 미달)
  소요 견적: ~129,302tok
  판정: gpt-5.6-terra 250,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\z-결산.md
- 반환: 완료 첫 줄 `DONE`. 둘째 줄 `결산: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\z-결산.md`. 비완결은 첫 줄 `예외`, 둘째 줄 `코드: 싱크비완결`, 셋째 줄 `사유: <한 줄>`, 넷째 줄 `결산: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\z-결산.md`.

## 임무

1. 첫 비가역 행위 전에 결산 파일과 `단계: 판정완료`를 쓴다.
2. S-01~S-07을 실제 보고, 판정, 상태 파일, 프로파일 JSON, 행 2.19.6 보고로 판정한다. 완결 행 2.19의 CK-8 문면 중 전체 테스트 직접 판정, 행 2.19.3 종료보고, 기각 보관 판정은 사용자확정 결정 `C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-전체실행일원화.md`가 대체한다.
3. 프로파일 JSON은 구조화 도구로 세 필드만 출력한다. 실행 파일 SHA-256은 보고 값과 대조한다.
4. 2.19.2 보고의 시작·종료 측정값과 비교 결과를 재판정한다. 기존 항목의 삭제, 되돌림, 덮어쓰기가 있으면 `상태: 완료미충족`으로 기록하고 `싱크비완결` 예외로 반환한다.
5. 예상 실패 반환이나 미충족 항목이 하나라도 있으면 `상태: 완료미충족`으로 기록하고 `싱크비완결` 예외로 반환한다.
6. 성공한 경우에만 빈 격리 worktree와 브랜치를 회수한다. 커밋할 추적 변경이 없으면 빈 커밋을 만들지 않는다.
7. 이음새 전기와 잔여·처분을 채운다. 새 이음새가 없으면 `없음`을 적는다.
8. 마커 grant와 lease를 사용했다면 해제한 뒤 마지막 편집으로 `단계: 종결`을 쓴다.
