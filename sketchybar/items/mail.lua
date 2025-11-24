local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local mail = sbar.add("item", "widgets.mail", {
    position = "right",
    icon = {
        padding_left = 8,
        padding_right = 8,
        font = {
            style = settings.font.style_map["Regular"],
            size = 14.0,
        }
    },
    label = {
        width = 0,
        font = { family = settings.font.numbers }
    },
    update_freq = 20,
    popup = { align = "center" }
})

mail:subscribe({ "forced", "routine", "system_woke" }, function()
    -- Just show the mail icon without count
    mail:set({
        icon = {
            string = icons.mail.empty
        },
        label = { string = "" },
    })
end)

sbar.add("bracket", "widgets.mail.bracket", { mail.name }, {
    background = { color = colors.bg1 }
})

mail:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Microsoft Outlook'")
end)
