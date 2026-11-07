-- Right side widgets (loaded right-to-left, renders left-to-right on screen)
require("items.widgets.calendar")
require("items.widgets.battery")
-- require("items.widgets.wifi") -- hidden while trying the bar without it
require("items.widgets.volume")
require("items.widgets.music")
require("items.widgets.codexbar")
-- require("items.widgets.ram") -- disabled temporarily, looks clean without it
require("items.widgets.cpu")
require("items.widgets.zen")

-- No pill backgrounds on the right; the left side (workspaces, menus) keeps them.
-- Delete this line to bring the right-side pills back.
sbar.set("/widgets\\..*\\.bracket/", { background = { drawing = false } })
