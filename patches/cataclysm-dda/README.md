# cataclysm-dda 로컬 패치

서브모듈 `cataclysm-dda`의 원격은 업스트림 `cleverraven/cataclysm-dda` 하나다. 이 저장소가 그 위에 쌓은 커밋은 업스트림에 올릴 수 없으므로, 여기 패치 파일로 공개한다. 상위 저장소의 서브모듈 포인터는 항상 업스트림에 있는 기반 커밋을 가리킨다. 포인터가 로컬 커밋을 가리키면 다른 곳의 `git submodule update`가 그 커밋을 찾지 못한다.

- 기반 커밋: `f84af651df313f1d06667f3fefc781d0e979bb41` (상위 저장소의 서브모듈 포인터와 같다)
- 패치: `0001`~`0003`. 기반 커밋에 번호 순으로 적용하면 로컬 `master`의 `3092abfcfcb`와 같은 트리(`fa8b4f1`)가 된다.

## 적용

클론 뒤 한 번 실행한다. 빌드·테스트 스크립트(`build-game.ps1`, `build-tests.ps1`, `run-tests.ps1`, `test-harness/`)는 패치가 적용된 트리를 전제한다.

```
git submodule update --init cataclysm-dda
git -C cataclysm-dda switch -c master
git -C cataclysm-dda am ../patches/cataclysm-dda/*.patch
```

## 갱신

서브모듈 `master`에 커밋을 더했으면 패치를 다시 뽑는다. 서브모듈 포인터는 바꾸지 않는다.

```
git -C cataclysm-dda format-patch -o ../patches/cataclysm-dda <기반 커밋>..master
```

`format-patch`는 한글 커밋 제목을 파일 이름에서 지운다. 파일 이름은 영문으로 고쳐 단다. 업스트림을 따라 기반 커밋을 옮길 때는 로컬 커밋을 새 기반 위로 rebase하고, 포인터와 이 문서의 기반 커밋, 패치를 함께 바꾼다.
