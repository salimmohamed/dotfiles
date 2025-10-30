local wezterm = require('wezterm')
local colors = require('colors.catppuccin')

-- Seed random numbers
math.randomseed(os.time())
math.random()
math.random()
math.random()

local GLOB_PATTERN = '*.{jpg,jpeg,png,gif,bmp,ico,tiff,pnm,dds,tga}'

---@class BackDrops
---@field current_idx number index of current image
---@field images string[] background images
---@field images_dir string directory of background images
---@field focus_color string background color when in focus mode
---@field focus_on boolean focus mode on or off
local BackDrops = {}
BackDrops.__index = BackDrops

--- Initialize backdrop controller
---@private
function BackDrops:init()
   local initial = {
      current_idx = 1,
      images = {},
      images_dir = wezterm.config_dir .. '/backdrops/',
      focus_color = colors.background,
      focus_on = false,
   }
   local backdrops = setmetatable(initial, self)
   return backdrops
end

--- Set the images directory
---@param path string directory of background images
function BackDrops:set_images_dir(path)
   self.images_dir = path
   if not path:match('/$') then
      self.images_dir = path .. '/'
   end
   return self
end

--- Load images from the images directory
function BackDrops:set_images()
   self.images = wezterm.glob(self.images_dir .. GLOB_PATTERN)
   return self
end

--- Set focus color
---@param focus_color string background color when in focus mode
function BackDrops:set_focus(focus_color)
   self.focus_color = focus_color
   return self
end

--- Create background options with current image
---@private
---@return table
function BackDrops:_create_opts()
   return {
      {
         source = { File = self.images[self.current_idx] },
         horizontal_align = 'Center',
      },
      {
         source = { Color = colors.background },
         height = '120%',
         width = '120%',
         vertical_offset = '-10%',
         horizontal_offset = '-10%',
         opacity = 0.96,
      },
   }
end

--- Create background options for focus mode
---@private
---@return table
function BackDrops:_create_focus_opts()
   return {
      {
         source = { Color = self.focus_color },
         height = '120%',
         width = '120%',
         vertical_offset = '-10%',
         horizontal_offset = '-10%',
         opacity = 1,
      },
   }
end

--- Set initial background options
---@param focus_on boolean? focus mode on or off
function BackDrops:initial_options(focus_on)
   focus_on = focus_on or false
   self.focus_on = focus_on

   if focus_on or #self.images == 0 then
      return self:_create_focus_opts()
   end

   return self:_create_opts()
end

--- Override window background options
---@private
---@param window any WezTerm Window
---@param background_opts table background option
function BackDrops:_set_opt(window, background_opts)
   window:set_config_overrides({
      background = background_opts,
   })
end

--- Get choices for InputSelector
function BackDrops:choices()
   local choices = {}
   for idx, file in ipairs(self.images) do
      table.insert(choices, {
         id = tostring(idx),
         label = file:match('([^/]+)$'),
      })
   end
   return choices
end

--- Select random background
---@param window any? WezTerm Window
function BackDrops:random(window)
   if #self.images == 0 then
      return
   end

   self.current_idx = math.random(#self.images)

   if window ~= nil then
      self:_set_opt(window, self:_create_opts())
   end
end

--- Cycle to next background
---@param window any WezTerm Window
function BackDrops:cycle_forward(window)
   if #self.images == 0 then
      return
   end

   if self.current_idx == #self.images then
      self.current_idx = 1
   else
      self.current_idx = self.current_idx + 1
   end
   self:_set_opt(window, self:_create_opts())
end

--- Cycle to previous background
---@param window any WezTerm Window
function BackDrops:cycle_back(window)
   if #self.images == 0 then
      return
   end

   if self.current_idx == 1 then
      self.current_idx = #self.images
   else
      self.current_idx = self.current_idx - 1
   end
   self:_set_opt(window, self:_create_opts())
end

--- Set specific background by index
---@param window any WezTerm Window
---@param idx number index of the images array
function BackDrops:set_img(window, idx)
   if #self.images == 0 or idx > #self.images or idx < 1 then
      return
   end

   self.current_idx = idx
   self:_set_opt(window, self:_create_opts())
end

--- Toggle focus mode
---@param window any WezTerm Window
function BackDrops:toggle_focus(window)
   local background_opts

   if self.focus_on then
      background_opts = self:_create_opts()
      self.focus_on = false
   else
      background_opts = self:_create_focus_opts()
      self.focus_on = true
   end

   self:_set_opt(window, background_opts)
end

return BackDrops:init()
