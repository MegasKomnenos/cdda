---
행: z
유형: 싱크
---

# 병렬 턴 구현 국면 종결

- 목표: 병렬 턴 구현 국면의 증거·이음새·잔여를 최종 결산하고 활성 국면을 닫는다.
- 완료 기준: `행/z-결산.md`가 싱크 단계 원장을 끝까지 기록한다. 결산 상태와 반환 첫 줄이 싱크 반환 검산에 합치한다.
- 작업 디렉토리: C:\cdda
- 명령: python C:\cdda\.claude\skills\do-dag\scripts\dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md
  python C:\cdda\.claude\skills\do-dag\scripts\dag_marker.py
- 스킬 루트: C:\cdda\.claude\skills\do-dag
- 모델_프리셋: codex-full
- 검증런_모델_프리셋: codex-full
- 계약: C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md
- 불변식: C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md
- 겨냥: C:\cdda\.sdd\dag\parallel-turn-impl\행\z-결산.md, C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, parallel-turn-impl 마커
- 정본: C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\3.d\z-결산.md
- 읽기 목록: C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\3.d\z-결산.md, C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md, C:\cdda\.claude\skills\do-dag\계약\공통.md, C:\cdda\.claude\skills\do-dag\계약\싱크.md
- 모델 배정 근거: 배정표 codex-full(싱크 gpt-5.6-terra low). 단계 원장에 고정된 절차를 집행한다.
- 예산:
  [실측기 budget]
  명령: python dag_measure.py budget --files C:\cdda\.sdd\dag\parallel-turn-impl\행\0.d\불변식.md,C:\cdda\.claude\skills\do-dag\계약\공통.md,C:\cdda\.claude\skills\do-dag\계약\싱크.md --model gpt-5.6-terra --writes 16000 --pending 48000 --root C:\cdda
  시각: 2026-08-25T15:17:06Z
  대상해시: sha1:b29ed2c223f2
  .claude\skills\do-dag\계약\공통.md: ~4,077tok
  .claude\skills\do-dag\계약\싱크.md: ~10,040tok
  .sdd\dag\parallel-turn-impl\행\0.d\불변식.md: ~930tok
  미존재 정본: ~25,263tok (48,000바이트 — 측정 시점 미존재)
  읽기 합계: ~40,310tok (문자계열 단가 견적)
  하네스 기저: ~28,000tok (시스템 프롬프트·툴 스키마·스킬 목록 — 실측 상수)
  도구 왕복: ~10,000tok (셸·검색 결과, 편집 회신 — 실측 상수)
  출력 유보: ~35,000tok (하한 — 저작 예상 16,000바이트는 하한 미달)
  소요 견적: ~113,310tok
  판정: gpt-5.6-terra 250,000 대비 예산 안
  [/실측기]
- 산출: C:\cdda\.sdd\dag\parallel-turn-impl\행\z-결산.md
- 반환: 완료 첫 줄 `DONE`. 추가 필드 없음.

## 임무

- 국면명: parallel-turn-impl
- 이음새 원장: C:\cdda\.sdd\dag\parallel-turn-impl\이음새.md

