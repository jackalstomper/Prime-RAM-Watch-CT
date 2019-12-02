package.loaded.utils = nil
package.loaded.dolphin = nil
package.loaded.version = nil
package.loaded.prime = nil
package.loaded.echoes = nil
package.loaded.corruption = nil

local utils = require "utils"
local dolphin = require "dolphin"
  
local layout = {
    
  init = function(window)
    window:setSize(265, 275)
    window:setPosition(157, 195) -- Set window position
    window:setCaption("Prime Watch") -- Set the window title.
    local font = window:getFont()
    font:setName("Lucida Console") -- Customize the font.
    font:setSize(9)
    label = createLabel(window)
  end,
  
  update = function()
  
  text = ""
    
  if dolphin.get_GameID() == "prime" then 
    _G.core = require "prime"
    text = core.layout()
    
  elseif dolphin.get_GameID() == "menumod" then
    text = "Menu Mod is not supported" 
  
	elseif dolphin.get_GameID() == "echoes" then
    _G.core = require "echoes"
    text = core.layout()
	
	elseif dolphin.get_GameID() == "corruption" then
    _G.core = require "corruption"
    text = core.layout()
	
  else 
    text = text .. "Not a supported game "
    .. "\nGame ID "
    .. dolphin.get_GameID()
    .. "\n"
	end
	
	label:setCaption(text)
	
  end,
}

-- Initializing the GUI window.
local window = createForm(true)
layout.init(window)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Create update timer
update_timer = createTimer(nil,true)
timer_setInterval(update_timer,16) -- 16 ms approx. 1 frame RTA (1/60)

function update_watch()
	if pcall(layout.update) then --calls layout to update
		-- Nothing
	else
		update_timer = nil -- Stop the timer
	end
end

timer_onTimer(update_timer,update_watch) -- On tick, update the timer and update the function
