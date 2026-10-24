---
행: 2.6.z
유형: 싱크
---

# 병렬 프로파일 표면 실행 싱크

- 목표: 2.6 worktree의 프로파일 변경을 귀속·시험·이음새 증거와 함께 저장소에 결합한다.
- 완료 기준: Z-01. 2.6.2, 2.6.4, 2.6.6 보고가 `DONE`이고 완료 기준 표, 편집 귀속, 이음새 광고, 반증 의무를 채웠다. Z-02. 2.6.1, 2.6.3, 2.6.5, 2.6.7, 2.6.8 종료보고와 2.6.9 보고가 실재한다. 검증런의 승인 수리와 잔여 처분이 모두 귀속된다. Z-03. worktree와 중첩 `cataclysm-dda` worktree의 실제 변경 전건이 세 작업자 보고의 편집 귀속 합집합과 같다. Z-04. 세 작업자의 빌드 기록, 명세, `result.json`, 각 SHA-256, 조각별 `execution_status`, 조각별 `outcome`, 모든 시도 증거가 일치한다. 같은 테스트를 다시 실행하지 않는다. Z-05. P-01부터 P-05까지의 제품 코드, JSON·HTML·PowerShell 결선, Catch2 실물, PowerShell 일치·불일치 프로브를 직접 판정한다. Z-06. S-01의 명세 전건과 시험 증거가 있으면 이음새를 `노출됨`으로 전기한다. 하나라도 없으면 `미착수`를 유지하고 완료미충족으로 반환한다. Z-07. 중첩 `cataclysm-dda` 변경 커밋은 `C:\cdda\cataclysm-dda`의 객체 저장소에서 도달 가능하다. 루트 worktree 커밋은 그 커밋의 gitlink를 가리킨다. Z-08. 계약/싱크.md의 귀속 대조, 완료 기준 판정, 단계 원장, 병합, 커밋, 회수 순서를 완료한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식-2.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\불변식.md
- 겨냥: C:\Users\wogud\AppData\Local\dag-wt\parallel-turn-impl+2.6\, C:\Users\wogud\AppData\Local\dag-wt\parallel-turn-impl+2.6\cataclysm-dda\, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\z-결산.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md S-01
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\4-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\6-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\1.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\3.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\5.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\7.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\8.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\9-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md S-01
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\4-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\6-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\1.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\3.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\5.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\7.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\8.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\9-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식-2.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-테스트하네스연결.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md, C:\cdda\.claude\skills\commit-harness\SKILL.md
- 모델 배정 근거: 배정표 codex-full(싱크 gpt-5.6-terra low). 단계 원장과 닫힌 완료 기준에 따라 귀속·병합·커밋을 집행한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files "C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\2-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\4-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\6-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\1.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\3.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\5.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\7.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\8.d\종료보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\9-보고.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\불변식-2.md, C:\cdda\.sdd\dag\parallel-turn-impl\결정\사용자확정-테스트하네스연결.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md, C:\cdda\.claude\skills\commit-harness\SKILL.md" --model gpt-5.6-terra --writes 25000 --pending 120000 --root C:\cdda
  시각: 2026-08-28T10:43:38Z
  대상해시: sha1:1bcc5d016d5b
  미해석: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\2-보고.md · C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\4-보고.md · C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\6-보고.md · C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\1.d\종료보고.md · C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\3.d\종료보고.md · C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\5.d\종료보고.md · C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\7.d\종료보고.md · C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\8.d\종료보고.md · C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\9-보고.md
  .claude\skills\commit-harness\SKILL.md: ~3,581tok
  .claude\skills\do-dag\계약\공통.md: ~4,077tok
  .claude\skills\do-dag\계약\싱크.md: ~10,034tok
  .sdd\dag\parallel-turn-impl\결정\사용자확정-테스트하네스연결.md: ~2,201tok
  .sdd\dag\parallel-turn-impl\이음새.md: ~4,362tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  .sdd\dag\parallel-turn-impl\행\2.d\6.d\불변식.md: ~1,737tok
  .sdd\dag\parallel-turn-impl\행\2.d\6.md: ~4,307tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식-2.md: ~2,512tok
  .sdd\dag\parallel-turn-impl\행\2.d\불변식.md: ~3,374tok
  미존재 정본: ~63,158tok (120,000바이트 — 측정 시점 미존재)
  읽기 합계: ~100,273tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 25,000바이트는 하한 미달)
  소요 견적: ~173,273tok
  판정: gpt-5.6-terra 250,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\z-결산.md
- 반환: 완료 첫 줄 `DONE`. 공통 필드 뒤에 `결산: C:\cdda\.sdd\dag\parallel-turn-impl\행\2.d\6.d\z-결산.md`를 쓴다.

## 임무

1. 계약/싱크.md의 노드 싱크 절차를 따른다.
2. 루트 worktree와 중첩 `cataclysm-dda` worktree를 각각 실측한다.
3. 중첩 worktree 변경은 별도 커밋으로 만든다. 커밋 객체를 `C:\cdda\cataclysm-dda`의 객체 저장소로 전송하고 도달성을 확인한다.
4. 루트 worktree가 중첩 커밋의 gitlink를 가리키게 한 뒤 루트 worktree 커밋을 만든다.
5. 2.6.2, 2.6.4, 2.6.6의 테스트 증거를 판정한다. 테스트를 다시 실행하지 않는다.
6. Z-01부터 Z-08까지 판정한 뒤 S-01을 전기한다.
