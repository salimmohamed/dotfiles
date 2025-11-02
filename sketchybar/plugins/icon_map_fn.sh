#!/bin/bash

# Icon mapping function - converts app names to nerd font icons
# Based on the sketchybar-app-font

get_icon_for_app() {
  local app_name="$1"

  case "$app_name" in
    "Live") echo ":ableton:" ;;
    "Adobe Bridge") echo ":adobe_bridge:" ;;
    "Affinity Designer"|"Affinity Designer 2") echo ":affinity_designer:" ;;
    "Affinity Photo"|"Affinity Photo 2") echo ":affinity_photo:" ;;
    "Airmail") echo ":airmail:" ;;
    "Alacritty") echo ":alacritty:" ;;
    "Alfred") echo ":alfred:" ;;
    "Android Messages") echo ":android_messages:" ;;
    "Android Studio") echo ":android_studio:" ;;
    "App Store") echo ":app_store:" ;;
    "Arc") echo ":arc:" ;;
    "Bear") echo ":bear:" ;;
    "Battle.net") echo ":battle_net:" ;;
    "Bitwarden") echo ":bit_warden:" ;;
    "Blender") echo ":blender:" ;;
    "Brave Browser") echo ":brave_browser:" ;;
    "Calculator"|"Calculette") echo ":calculator:" ;;
    "Calendar"|"日历"|"Fantastical"|"Cron"|"Amie"|"Calendrier"|"Notion Calendar") echo ":calendar:" ;;
    "Claude") echo ":claude:" ;;
    "Code"|"Code - Insiders") echo ":code:" ;;
    "Copilot") echo ":copilot:" ;;
    "Cursor") echo ":cursor:" ;;
    "DataGrip") echo ":datagrip:" ;;
    "Discord"|"Discord Canary"|"Discord PTB") echo ":discord:" ;;
    "Docker"|"Docker Desktop") echo ":docker:" ;;
    "Figma") echo ":figma:" ;;
    "Finder"|"访达") echo ":finder:" ;;
    "Firefox"|"Firefox Developer Edition"|"Firefox Nightly") echo ":firefox:" ;;
    "System Preferences"|"System Settings"|"系统设置"|"Réglages Système") echo ":gear:" ;;
    "GitHub Desktop") echo ":git_hub:" ;;
    "GoLand") echo ":goland:" ;;
    "Google Chrome"|"Chromium"|"Google Chrome Canary") echo ":google_chrome:" ;;
    "Hyper") echo ":hyper:" ;;
    "IntelliJ IDEA") echo ":idea:" ;;
    "IINA") echo ":iina:" ;;
    "Adobe Illustrator"|"Illustrator") echo ":illustrator:" ;;
    "Insomnia") echo ":insomnia:" ;;
    "iTerm"|"iTerm2") echo ":iterm:" ;;
    "Keynote"|"Keynote 讲演") echo ":keynote:" ;;
    "kitty") echo ":kitty:" ;;
    "Logseq") echo ":logseq:" ;;
    "Mail"|"HEY"|"Canary Mail"|"Mailspring"|"MailMate"|"Superhuman"|"Spark"|"邮件") echo ":mail:" ;;
    "Maps"|"Google Maps") echo ":maps:" ;;
    "Messages"|"信息"|"Nachrichten") echo ":messages:" ;;
    "Messenger") echo ":messenger:" ;;
    "Microsoft Edge") echo ":microsoft_edge:" ;;
    "Microsoft Excel") echo ":microsoft_excel:" ;;
    "Microsoft Outlook") echo ":microsoft_outlook:" ;;
    "Microsoft PowerPoint") echo ":microsoft_power_point:" ;;
    "Microsoft Teams"|"Microsoft Teams (work or school)") echo ":microsoft_teams:" ;;
    "Microsoft Word") echo ":microsoft_word:" ;;
    "Music"|"音乐"|"Musique") echo ":music:" ;;
    "Neovide"|"neovide"|"Neovim"|"neovim"|"nvim") echo ":neovim:" ;;
    "Notion") echo ":notion:" ;;
    "Notes"|"备忘录") echo ":notes:" ;;
    "Obsidian") echo ":obsidian:" ;;
    "OBS") echo ":obsstudio:" ;;
    "1Password") echo ":one_password:" ;;
    "ChatGPT") echo ":openai:" ;;
    "Opera") echo ":opera:" ;;
    "Orion"|"Orion RC") echo ":orion:" ;;
    "Pages"|"Pages 文稿") echo ":pages:" ;;
    "Preview"|"预览"|"Aperçu") echo ":pdf:" ;;
    "Adobe Photoshop") echo ":photoshop:" ;;
    "PhpStorm") echo ":php_storm:" ;;
    "Plex") echo ":plex:" ;;
    "Plexamp") echo ":plexamp:" ;;
    "Podcasts"|"播客") echo ":podcasts:" ;;
    "Postman") echo ":postman:" ;;
    "PyCharm") echo ":pycharm:" ;;
    "Reminders"|"提醒事项"|"Rappels") echo ":reminders:" ;;
    "Rider"|"JetBrains Rider") echo ":rider:" ;;
    "Rio") echo ":rio:" ;;
    "Safari"|"Safari浏览器"|"Safari Technology Preview") echo ":safari:" ;;
    "Signal") echo ":signal:" ;;
    "Sketch") echo ":sketch:" ;;
    "Skype") echo ":skype:" ;;
    "Slack") echo ":slack:" ;;
    "Spark Desktop") echo ":spark:" ;;
    "Spotify") echo ":spotify:" ;;
    "Sublime Text") echo ":sublime_text:" ;;
    "Telegram") echo ":telegram:" ;;
    "Terminal"|"终端") echo ":terminal:" ;;
    "Things"|"Microsoft To Do") echo ":things:" ;;
    "Thunderbird") echo ":thunderbird:" ;;
    "Todoist") echo ":todoist:" ;;
    "Tower") echo ":tower:" ;;
    "Twitter"|"Tweetbot") echo ":twitter:" ;;
    "Vim"|"MacVim"|"VimR") echo ":vim:" ;;
    "Vivaldi") echo ":vivaldi:" ;;
    "VLC") echo ":vlc:" ;;
    "VSCodium") echo ":vscodium:" ;;
    "Warp") echo ":warp:" ;;
    "WebStorm") echo ":web_storm:" ;;
    "WeChat"|"微信") echo ":wechat:" ;;
    "WezTerm") echo ":wezterm:" ;;
    "WhatsApp"|"‎WhatsApp") echo ":whats_app:" ;;
    "Xcode") echo ":xcode:" ;;
    "Zed") echo ":zed:" ;;
    "Zen Browser") echo ":zen_browser:" ;;
    "zoom.us") echo ":zoom:" ;;
    "Zotero") echo ":zotero:" ;;
    *) echo ":default:" ;;  # Default icon for unknown apps
  esac
}

# If called directly with an argument, output the icon
if [ -n "$1" ]; then
  get_icon_for_app "$1"
fi
