#!/bin/bash

# Icon mapping for applications using sketchybar-app-font
# Returns an appropriate icon for a given application name

case $1 in
# Browsers
"Safari" | "Safari Technology Preview")
	echo ":safari:"
	;;
"Google Chrome" | "Chrome")
	echo ":google_chrome:"
	;;
"Brave Browser" | "Brave")
	echo ":brave_browser:"
	;;
"Arc")
	echo ":arc:"
	;;
"Firefox" | "Firefox Developer Edition")
	echo ":firefox:"
	;;
"Microsoft Edge")
	echo ":microsoft_edge:"
	;;

# Terminals
"WezTerm" | "wezterm-gui")
	echo ":wezterm:"
	;;
"iTerm2" | "iTerm")
	echo ":iterm:"
	;;
"Terminal" | "Terminal.app")
	echo ":terminal:"
	;;
"Alacritty")
	echo ":alacritty:"
	;;
"kitty")
	echo ":kitty:"
	;;
"Ghostty")
	echo ":ghostty:"
	;;

# Editors & IDEs
"Visual Studio Code" | "Code" | "VSCode")
	echo ":visual_studio_code:"
	;;
"Cursor")
	echo ":cursor:"
	;;
"Neovim" | "nvim")
	echo ":vim:"
	;;
"IntelliJ IDEA" | "IntelliJ")
	echo ":intelli_j:"
	;;
"PyCharm")
	echo ":pycharm:"
	;;
"WebStorm")
	echo ":webstorm:"
	;;
"Xcode")
	echo ":xcode:"
	;;
"Sublime Text")
	echo ":sublime_text:"
	;;

# Communication
"Slack")
	echo ":slack:"
	;;
"Discord")
	echo ":discord:"
	;;
"Microsoft Teams" | "Teams")
	echo ":microsoft_teams:"
	;;
"Zoom" | "zoom.us")
	echo ":zoom:"
	;;
"Messages" | "信息")
	echo ":messages:"
	;;
"Telegram")
	echo ":telegram:"
	;;
"WhatsApp")
	echo ":whats_app:"
	;;
"Signal")
	echo ":signal:"
	;;

# Mail
"Mail" | "邮件")
	echo ":mail:"
	;;
"Spark")
	echo ":spark:"
	;;
"Outlook" | "Microsoft Outlook")
	echo ":microsoft_outlook:"
	;;

# Productivity
"Notion")
	echo ":notion:"
	;;
"Obsidian")
	echo ":obsidian:"
	;;
"Notes" | "备忘录")
	echo ":notes:"
	;;
"Reminders" | "提醒事项")
	echo ":reminders:"
	;;
"Todoist")
	echo ":todoist:"
	;;
"Trello")
	echo ":trello:"
	;;
"Asana")
	echo ":asana:"
	;;
"OneNote")
	echo ":onenote:"
	;;

# Design
"Figma")
	echo ":figma:"
	;;
"Sketch")
	echo ":sketch:"
	;;
"Adobe Photoshop" | "Photoshop")
	echo ":adobe_photoshop:"
	;;
"Adobe Illustrator" | "Illustrator")
	echo ":adobe_illustrator:"
	;;
"Adobe XD")
	echo ":adobe_xd:"
	;;
"Blender")
	echo ":blender:"
	;;

# Media
"Spotify")
	echo ":spotify:"
	;;
"Music" | "音乐")
	echo ":music:"
	;;
"TV" | "Apple TV")
	echo ":tv:"
	;;
"VLC")
	echo ":vlc:"
	;;
"IINA")
	echo ":iina:"
	;;

# System & Utilities
"Finder" | "访达")
	echo ":finder:"
	;;
"System Settings" | "System Preferences" | "系统设置")
	echo ":gear:"
	;;
"Activity Monitor")
	echo ":activity_monitor:"
	;;
"Calculator" | "计算器")
	echo ":calculator:"
	;;
"Calendar" | "日历")
	echo ":calendar:"
	;;
"Contacts" | "通讯录")
	echo ":contacts:"
	;;
"Photos" | "照片")
	echo ":photos:"
	;;
"Preview")
	echo ":default:"
	;;
"App Store")
	echo ":app_store:"
	;;

# DevOps & Cloud
"Docker" | "Docker Desktop")
	echo ":docker:"
	;;
"TablePlus")
	echo ":table_plus:"
	;;
"Postman")
	echo ":postman:"
	;;

# Office
"Microsoft Word" | "Word")
	echo ":microsoft_word:"
	;;
"Microsoft Excel" | "Excel")
	echo ":microsoft_excel:"
	;;
"Microsoft PowerPoint" | "PowerPoint")
	echo ":microsoft_power_point:"
	;;
"Pages")
	echo ":pages:"
	;;
"Numbers")
	echo ":numbers:"
	;;
"Keynote")
	echo ":keynote:"
	;;

# Reading & Reference
"Books" | "图书")
	echo ":books:"
	;;
"Kindle")
	echo ":kindle:"
	;;

# Gaming
"Steam")
	echo ":steam:"
	;;

# Security & VPN
"1Password")
	echo ":one_password:"
	;;
"Bitwarden")
	echo ":bit_warden:"
	;;

# Default fallback
*)
	echo ":default:"
	;;
esac
