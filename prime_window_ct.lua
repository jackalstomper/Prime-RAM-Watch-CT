package.loaded.utils = nil
package.loaded.dolphin = nil
package.loaded.prime_core = nil

local utils = require "utils"
local dolphin = require "dolphin"
local core = require "prime_core_ct"


local layout = {
    
  init = function(window)
    window:setSize(201, 270)
  
    label = utils.initLabel(window, 5, 5, "")
  end,
  
  update = function()
  
    text = ""
    --text = text .. utils.intToHexStr(core.getObject().player) .. "\n"
    --text = text .. utils.intToHexStr(core.getPos().address)
    --text = text .. utils.intToHexStr(getAddress("Dolphin.exe")+ dolphin.getRAMPointer)
    --text = text .. utils.intToHexStr(core.getObject().player)
    
   
   if getGameID() == "prime" then 
    
  text = text .. "IGT: " 
  text = text .. core.getIGT().hour .. ":" .. string.format("%02.0f", core.getIGT().min) .. ":" .. string.format("%06.3f", core.getIGT().sec)
  text = text .. "   Room# " .. core.getRoom().ID
  text = text .. "\nHealth:  " .. string.format("%05.3f", core.getHealth().hp) .. "     " .. core.getHealth().etankcur .. " / " .. core.getHealth().etankmax 
  text = text .. "\n"
  text = text .. "\nPosition: "
	text = text .. "\n" .. string.format("%8.2f", core.getPos().X) .. " " .. string.format("%8.2f", core.getPos().Y) .. " " .. string.format("%7.2f", core.getPos().Z)
  text = text .. "\nSpeed: " .. string.format("%6.3f", core.getSpd().XY) .. " | " .. string.format("%7.3f", core.getSpd().Z)
  text = text .. "\nDispl: " .. string.format("%6.3f", core.getSpd().Dxy)
  text = text .. "\n" 
  text = text .. "\nCharge: " .. string.format("%05.3f", core.getCharge().timer) .. " | " .. core.getCharge().state
  text = text .. "\nBoost:  " .. string.format("%05.3f", core.getBoost().timer)
  text = text .. "\nBombs:  " .. core.getBomb().count .. " | " .. string.format("%05.3f", core.getBomb().timer)
  text = text .. "\nJump:   " .. core.getJump().state .. " | " .. string.format("%05.3f", core.getJump().timer)
  
  elseif getGameID() == "menumod" then
  
  text = "Menu Mod is not supported" 
  
	elseif getGameID() == "echoes" then
	
	text = text .. "IGT: " 
  text = text .. core.getIGT().hour .. ":" .. string.format("%02.0f", core.getIGT().min) .. ":" .. string.format("%06.3f", core.getIGT().sec) 
  text = text .. "   Room# " .. core.getRoom().ID
  text = text .. "\nHealth:  " .. string.format("%05.3f", core.getHealth().hp) .. "     " .. core.getHealth().etankcur .. " / " .. core.getHealth().etankmax 
  text = text .. "\n"
	text = text .. "\nPosition: "
	text = text .. "\n" .. string.format("%8.2f", core.getPos().X) .. " " .. string.format("%8.2f", core.getPos().Y) .. " " .. string.format("%7.2f", core.getPos().Z)
  text = text .. "\nSpeed: " .. string.format("%6.3f", core.getSpd().XY) .. " | " .. string.format("%7.3f", core.getSpd().Z)
  if core.getSpd().Dxy > ((core.getSpd().XY)*2.5) then
		text = text .. "\nDispl:  0.000 "
	else
		text = text .. "\nDispl: " .. string.format("%6.3f", core.getSpd().Dxy)
	end
  text = text .. "\n" 
	text = text .. "\nCharge: " .. string.format("%05.3f", core.getCharge().timer)
	text = text .. "\nBoost:  " .. string.format("%05.3f", core.getBoost().timer) .. " | " .. string.format("%05.3f", core.getBoost().cooldown)
	text = text .. "\nBombs:  " .. core.getBomb().count .. " | " .. string.format("%05.3f", core.getBomb().timer)
	text = text .. "\nJump:   " .. core.getJump().state .. " | " .. string.format("%05.3f", core.getJump().timer)
	
	elseif getGameID() == "corruption" then
	
	text = text .. "IGT: " 
  text = text .. core.getIGT().hour .. ":" .. string.format("%02.0f", core.getIGT().min) .. ":" .. string.format("%06.3f", core.getIGT().sec) 
  text = text .. "   Room# " .. core.getRoom().ID
  text = text .. "\nHealth:  " .. string.format("%05.3f", core.getHealth().hp) .. "     " .. core.getHealth().etankcur .. " / " .. core.getHealth().etankmax 
  text = text .. "\n"
	text = text .. "\nPosition: "
	text = text .. "\n" .. string.format("%8.2f", core.getPos().X) .. " " .. string.format("%8.2f", core.getPos().Y) .. " " .. string.format("%7.2f", core.getPos().Z)
  text = text .. "\nSpeed: " .. string.format("%6.3f", core.getSpd().XY) .. " | " .. string.format("%7.3f", core.getSpd().Z)
  if core.getSpd().Dxy > ((core.getSpd().XY)*2.5) then
		text = text .. "\nDispl:  0.000 "
	else
		text = text .. "\nDispl: " .. string.format("%6.3f", core.getSpd().Dxy)
	end
  text = text .. "\n" 
	text = text .. "\nCharge: " .. string.format("%05.3f", core.getCharge().timer)
	text = text .. "\nBoost:  " .. string.format("%05.3f", core.getBoost().timer) .. " | " .. string.format("%05.3f", core.getBoost().cooldown)
	text = text .. "\nBombs:  " .. core.getBomb().count 
	text = text .. "\nJump:   " .. core.getJump().state .. " | " .. string.format("%05.3f", core.getJump().timer)
	text = text .. "\nSA:     " .. core.getSA().count
	
  else 
  text = text .. "Not a supported game"
  text = text .. core.getGameID()
  text = text .. "\n"
	end
	
	label:setCaption(text)
	
  end,
}



-- Initializing and customizing the GUI window.

local window = createForm(true)



-- Put it in the center of the screen.
-- Alternatively you can use something like: window:setPosition(100, 300) 
window:setPosition(157, 195)
-- Set the window title.
window:setCaption("Prime Watch")
-- Customize the font.
local font = window:getFont()
font:setName("Lucida Console")
font:setSize(9)

layout.init(window)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Set up update timer
update_timer = createTimer(nil,true)
timer_setInterval(update_timer,16) -- 16 roughly equals 1 frame in real time

function update_watch()
	if pcall(layout.update) then
		-- Nothing
	else
		update_timer = nil -- Stop the timer
	end
end

timer_onTimer(update_timer,update_watch)
