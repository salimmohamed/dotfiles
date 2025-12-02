local Config = require('config')

-- Load background images and set initial backdrop
-- require('utils.backdrops'):set_images():random()

-- Setup event handlers
require('events.gui-startup').setup()
require('events.right-status').setup()
require('events.tab-title').setup()
require('events.new-tab-button').setup()

-- Build and return configuration
return Config:init()
   :append(require('config.general'))
   :append(require('config.fonts'))
   :append(require('config.appearance'))
   :append(require('config.domains'))
   :append(require('config.bindings'))
   :append(require('config.launch')).options
