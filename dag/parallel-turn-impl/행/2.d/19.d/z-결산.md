---
유형: 결산
행: 2.19.z
상태: DONE
단계: 종결
---

# 구현 전 기준 실행 결산

## 판정

| 완료 기준 | 판정 | 직접 확인한 증거 |
|---|---|---|
| S-01 | 충족 | `1-판정.md`의 발견 두 건은 행 2.19.4의 수리와 후속 `VERDICT: PASS` 판정으로 닫혔다. |
| S-02 | 충족 | `6-보고.md`와 `2-보고.md`의 frontmatter가 각각 `상태: DONE`이다. |
| S-03 | 충족 | `build.json` SHA-256 `3E445493E3CF33AB13A0214476B328BBF5E265DF20B81525886C633FA554CB88`과 `result.json`의 `build_record_sha256`이 같다. `manifest.json` SHA-256 `D57D5A711DF11BAEC5B9E13590DA19D7A1D70966F7F42BF0D25B827AF2681876`과 `result.json`의 `manifest_sha256`이 같다. 명세와 결과의 테스트 집합은 `proficiency_gain_short_crafts`, `crafting_skill_gain`, `monster_speed_description`이다. |
| S-04 | 충족 | `crafting`과 `monster` 조각은 각각 `execution_status: completed`, `outcome: passed`다. 두 조각의 세 테스트는 모두 `passed`다. 각 조각의 `attempt-0001.json`과 공용 batch `attempt.json`이 존재하고 완료·exit code 0을 기록한다. |
| S-05 | 충족 | `turn-profile.json`의 `metadata.seed`는 `cdda-turn-profile-v1`이다. `completed_turns`와 `turns` 배열 길이는 각각 10000이다. |
| S-06 | 충족 | `turn-profile.json`의 `metadata.executable_sha256`은 `665F50FB58B0D808F9340E6DCC9BB1C14A58437AAC71A59A8FFC474686EB9307`이다. |
| S-07 | 충족 | 루트와 서브모듈 상태 파일에서 시작·종료 명령 출력의 바이트열이 각각 같다. 루트 비교 SHA-256은 `79D0DAF51976205F69EF01B64BD88DD6462F4E85CA96178C32A20C40824F5CB3`이다. 서브모듈 비교 SHA-256은 `C7CE0B40CBEB4AD8FACC3D932CE7467002CE35EF7B70540B36FE0AA46C02B33D`이다. |
| S-08 | 충족 | 기존 `run`에는 조각별 시도 하나와 batch 시도 하나만 있다. 이 싱크는 테스트와 data consistency를 실행하지 않았다. |

`dag_check.py --table C:\cdda\.sdd\dag\parallel-turn-impl\파견표.md`는 `무발견`으로 종료했다.

## 병합·회수

커밋은 만들지 않았다. `C:\Users\wogud\AppData\Local\dag-wt\parallel-turn-impl+2.19`는 staged·unstaged·untracked 파일이 없는 상태로 확인했다. Git이 서브모듈 때문에 일반 회수를 거부한 뒤, 같은 빈 worktree만 `git worktree remove --force`로 회수했다. 브랜치 `dag/parallel-turn-impl/2.19`도 삭제했다.

마커는 유효한 grant 없음과 빈 lease를 보고했다. 해제할 grant와 lease는 없다.

## 잔여·처분

없음.
