# VLC JNJ

버그 수정과 기능 추가를 위한 VLC 데스크톱 플레이어 포크입니다. `main`은 VideoLAN의 `3.0.x` 유지보수 브랜치에서 시작합니다. VLC의 프로젝트 개요와 플랫폼별 빌드 안내는 [원본 README](README)와 [INSTALL](INSTALL)에 있습니다.

## 개발 시작

새 작업 환경에서는 포크를 복제하고 VideoLAN 공식 저장소를 `upstream`으로 등록합니다.

```sh
git clone -c core.autocrlf=false https://github.com/chowhi123/vlc-jnj.git
cd vlc-jnj
git remote add upstream https://code.videolan.org/videolan/vlc.git
git fetch upstream
```

버그 수정이나 기능 작업은 최신 `main`에서 분기합니다. 아래는 자막 수정 작업의 예입니다. 작업 브랜치를 푸시한 뒤 이 포크의 `main`을 대상으로 PR을 엽니다.

```sh
git switch main
git pull --ff-only origin main
git switch -c fix/subtitle-timing
# 수정 및 커밋 후
git push -u origin HEAD
```

업스트림 변경도 별도 브랜치에서 병합합니다. 충돌을 해결하고 빌드와 재생을 확인한 뒤 `main`에 반영하면 기존 포크 커밋의 이력을 보존할 수 있습니다.

```sh
git switch main
git pull --ff-only origin main
git fetch upstream
git switch -c sync/vlc-3.0.x
git merge upstream/3.0.x
git push -u origin HEAD
```

## Windows x64 빌드

Docker Desktop의 Linux 컨테이너 엔진을 실행한 상태에서 저장소 루트의 PowerShell에서 실행합니다.

```powershell
.\jnj\build-win64.ps1
```

스크립트는 [업스트림 CI 설정](extras/ci/gitlab-ci.yml)에서 빌드 이미지 버전을 읽습니다. 현재 브랜치의 커밋, 커밋 전 수정, Git에서 무시하지 않은 새 파일을 임시 Linux 작업 폴더에 복사한 뒤 [VLC 빌드 스크립트](extras/package/win32/build.sh)를 실행합니다. 해당 리비전의 사전 빌드 라이브러리가 있으면 내려받고, 의존성 입력을 수정했거나 라이브러리가 없으면 소스에서 빌드합니다.

성공하면 `build-win64/vlc-*-win64-debug.zip`이 생성됩니다. ZIP을 풀고 그 안의 `vlc.exe`를 실행하면 수정한 플레이어를 설치 없이 시험할 수 있습니다.
