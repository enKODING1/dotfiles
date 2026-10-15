# dotfiles

macOS 터미널 설정 (zsh + Oh My Zsh + Powerlevel10k, vim)

## 설치

```sh
git clone https://github.com/enKODING1/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

- Homebrew, Oh My Zsh, Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting 을 설치
- [pokemon-colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts) 를 `~/.local` 에 설치 (터미널 시작 시 랜덤 포켓몬 출력)
- `Brewfile` 의 패키지 설치 (건너뛰려면 `SKIP_BREW=1 ./install.sh`)
- 기존 파일은 `~/.dotfiles_backup/<날짜>/` 로 백업 후 심볼릭 링크 생성

## 구조

| 파일 | 링크 위치 |
| --- | --- |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zprofile` | `~/.zprofile` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |
| `vim/.vimrc` | `~/.vimrc` |

## 사용법

- 설정은 `~/.zshrc` 등을 그대로 수정하면 됨 (실제로는 이 레포 파일을 수정하는 것)
- 변경 후 `cd ~/dotfiles && git commit -am "..." && git push`
- API 키 등 머신별/비밀 설정은 `~/.zshrc.local` 에 (git에 안 올라감)
- 패키지 목록 갱신: `brew bundle dump --file=~/dotfiles/Brewfile --force`
