# Interactive shell configuration
# This file is sourced for interactive shells

# cmux: ensure wrapper binaries (claude, etc.) take priority inside cmux
if [[ -n "$CMUX_SURFACE_ID" ]]; then
  export PATH="/Applications/cmux.app/Contents/Resources/bin:$PATH"
fi

# Source modular configuration files
[[ -f "$ZDOTDIR/config/prompt.zsh" ]] && source "$ZDOTDIR/config/prompt.zsh"
[[ -f "$ZDOTDIR/config/zoxide.zsh" ]] && source "$ZDOTDIR/config/zoxide.zsh"
[[ -f "$ZDOTDIR/config/completion.zsh" ]] && source "$ZDOTDIR/config/completion.zsh"

# Aliases (migrated from old ~/.zshrc)
alias spyder-uninstall='rm -rf ~/.spyder-py3'

# Tmux workflow
alias tb='tmux-boot'
alias rh='rehoboam'
alias c='claude'
restart-bars() {
  pkill -f '/Users/sm/.config/aerospace/follow-floats.sh' 2>/dev/null || true
  pkill -f 'sketchybar --trigger aerospace_workspace_change' 2>/dev/null || true

  osascript -e 'tell application "AeroSpace" to quit' >/dev/null 2>&1 || true
  sleep 1
  pgrep -x AeroSpace >/dev/null && pkill -x AeroSpace 2>/dev/null || true

  brew services restart sketchybar >/dev/null 2>&1
  open -a AeroSpace >/dev/null 2>&1

  printf 'Restarted AeroSpace and SketchyBar.\n'
}
alias rbars='restart-bars'
tka() {
  tmux kill-server 2>/dev/null || true
  while tmux has-session 2>/dev/null; do sleep 0.1; done
  rm -rf ~/.local/share/tmux/resurrect 2>/dev/null || true
  killall Ghostty 2>/dev/null || true
}

# Add additional configuration files here
# Example:
# [[ -f "$ZDOTDIR/config/aliases.zsh" ]] && source "$ZDOTDIR/config/aliases.zsh"
# [[ -f "$ZDOTDIR/config/functions.zsh" ]] && source "$ZDOTDIR/config/functions.zsh"

export PATH=$PATH:$HOME/.spicetify

# Obsidian CLI
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Hugging Face (for Kokoro TTS model downloads)
[[ -f "$ZDOTDIR/config/secrets.zsh" ]] && source "$ZDOTDIR/config/secrets.zsh"

# Calibre + lue ebook reader
book() {
  local library="$HOME/Calibre"
  local db="$library/metadata.db"
  local progress_dir="$HOME/Library/Application Support/lue"
  local selection

  selection=$(sqlite3 "$db" "
    SELECT b.title, '$library/' || b.path || '/' || d.name || '.' || LOWER(d.format)
    FROM books b
    JOIN data d ON b.id = d.book
    WHERE LOWER(d.format) IN ('epub','pdf','txt','docx','doc','html','rtf','md')
      AND b.id NOT IN (
        SELECT btl.book FROM books_tags_link btl
        JOIN tags t ON t.id = btl.tag WHERE LOWER(t.name) = 'hidden'
      )
    ORDER BY b.title COLLATE NOCASE
  " | python3 -c "
import sys, os, glob

progress_dir = '$progress_dir'
mtimes = {}
for f in glob.glob(os.path.join(progress_dir, '*.progress.json')):
    mtimes[os.path.basename(f).replace('.progress.json', '').lower()] = os.path.getmtime(f)

import re
recent, rest = [], []
for line in sys.stdin:
    line = line.rstrip('\n')
    title, path = line.split('|', 1)
    filename = os.path.splitext(os.path.basename(path))[0]
    key = re.sub(r'[^A-Za-z0-9]+', '', filename).lower()
    if key in mtimes:
        recent.append((mtimes[key], title, path))
    else:
        rest.append((title, path))

recent.sort(key=lambda x: -x[0])
for _, title, path in recent:
    print(f'{title}\t{path}')
for title, path in rest:
    print(f'{title}\t{path}')
" | fzf --reverse --with-nth=1 --delimiter='\t' --no-sort --prompt='  ' \
    | cut -f2)

  [[ -n "$selection" ]] && lue "$selection"
}

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


