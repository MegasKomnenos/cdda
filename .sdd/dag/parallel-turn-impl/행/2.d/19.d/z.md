---
행: 2.19.z
유형: 싱크
---

# 구현 전 기준 실행 싱크

- 목표: 표적 테스트와 기준 프로파일의 증거를 판정하고 행 2.19를 종결한다.
- 완료 기준: S-01. 행 2.19.1 판정이 성공한다. S-02. 행 2.19.6과 2.19.2 보고의 frontmatter가 `상태: DONE`이다. S-03. 빌드 기록, 명세, `result.json`의 해시와 테스트 이름 집합이 일치한다. S-04. 세 표적 테스트의 실행 상태와 결과가 각각 `completed`와 `passed`다. S-05. 기준 프로파일의 완료 턴은 10000이고 seed는 `cdda-turn-profile-v1`이다. S-06. 기준 프로파일의 실행 파일 SHA-256이 비어 있지 않다. S-07. 행 2.19.2의 시작·종료 상태가 기존 사용자 변경을 보존한다. S-08. 같은 테스트나 데이터 consistency를 다시 실행하지 않는다. S-09. 성공하면 결산 `상태: DONE`과 `단계: 종결`을 기록한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식-2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\z-결산.md, C:\cdda\build\turn-parallel-root-status.txt, C:\cdda\build\turn-parallel-submodule-status.txt, C:\cdda\cataclysm-dda\turn-profile-results\turn-parallel-baseline\
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-테스트하네스연결.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\1-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\6-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\2-보고.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-테스트하네스연결.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\1-판정.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\6-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\2-보고.md, C:\cdda\build\turn-parallel-root-status.txt, C:\cdda\build\turn-parallel-submodule-status.txt, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식-2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md
- 모델 배정 근거: 배정표 codex-full(싱크 gpt-5.6-terra low). 단계 원장과 완료 기준이 판정 절차를 닫는다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-테스트하네스연결.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\1-판정.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\6-보고.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\2-보고.md,C:\cdda\build\turn-parallel-root-status.txt,C:\cdda\build\turn-parallel-submodule-status.txt,C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식-2.md,C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\계약\싱크.md --model gpt-5.6-terra --writes 18000 --pending 50000 --root C:\cdda
  시각: 2026-08-28T02:46:30Z
  대상해시: sha1:ff8ef51a7685
  미해석: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\6-보고.md
  .claude\skills\do-dag\계약\공통.md: ~4,077tok
  .claude\skills\do-dag\계약\싱크.md: ~10,034tok
  .sdd\dag\parallel-turn-impl\결정\사용자확정-테스트하네스연결.md: ~2,201tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\19.d\1-판정.md: ~5,488tok
  .sdd\dag\parallel-turn-impl\행\2.d\19.d\2-보고.md: ~1,076tok
  .sdd\dag\parallel-turn-impl\행\2.d\19.d\불변식.md: ~1,380tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식-2.md: ~2,337tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  build\turn-parallel-root-status.txt: ~3,741tok
  build\turn-parallel-submodule-status.txt: ~45tok
  미존재 정본: ~26,316tok (50,000바이트 — 측정 시점 미존재)
  읽기 합계: ~60,999tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 18,000바이트는 하한 미달)
  소요 견적: ~133,999tok
  판정: gpt-5.6-terra 250,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\z-결산.md
- 반환: 완료 첫 줄 `DONE`. 둘째 줄 `결산: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\z-결산.md`. 비완결은 첫 줄 `예외`, 둘째 줄 `코드: 싱크비완결`, 셋째 줄 `사유: <한 줄>`, 넷째 줄 `결산: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\19.d\z-결산.md`.

## 임무

1. 첫 비가역 행위 전에 결산 파일과 `단계: 판정완료`를 쓴다.
2. S-01부터 S-08까지를 보고와 실제 JSON 파일로 판정한다.
3. 빌드 기록 SHA-256과 `result.json`의 `build_record_sha256`을 대조한다.
4. 명세 SHA-256과 `result.json`의 `manifest_sha256`을 대조한다.
5. 명세와 결과의 테스트 이름 집합을 대조한다.
6. 조각별 `execution_status`, `outcome`, 시도 증거를 판정한다.
7. 기준 프로파일 JSON과 시작·종료 상태 증거를 판정한다.
8. 증거가 없거나 어긋나면 `상태: 완료미충족`으로 기록한다. `싱크비완결`로 반환한다.
9. 성공한 경우에만 빈 격리 worktree와 브랜치를 회수한다. 빈 커밋은 만들지 않는다.
10. grant와 lease를 해제한 뒤 마지막 편집으로 `단계: 종결`을 쓴다.
