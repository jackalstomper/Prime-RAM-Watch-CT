package.loaded.utils = nil
package.loaded.dolphin = nil

local utils = require "utils"
local dolphin = require "dolphin"
local intToDouble = utils.intToDouble
local readFloatBE = utils.readFloatBE
local readIntBE = utils.readIntBE
local ram = dolphin.get_RAM_Start()

local core = {}

local function getObject()

	local CPlayer 
	local CPlayerMorph
	local CPlayerGun
	local CPlayerBomb
	local CGameState 

  CPlayer = readIntBE(ram + 0x458350, 4) - 0x80000000 + ram
  CPlayerMorph = readIntBE(CPlayer + 0x768, 4) - 0x80000000 + ram
  CPlayerGun = readIntBE(CPlayer + 0x490, 4) - 0x80000000 + ram
  CPlayerBomb = CPlayerGun
  CGameState = readIntBE(ram + 0x4578CC, 4) - 0x80000000 + ram
  
	return {player = CPlayer, morph = CPlayerMorph, gun = CPlayerGun, bomb = CPlayerBomb, gamestate = CGameState}
end
core.getObject = getObject

local function getSpd()
	
	
	local pointer = getObject().player
	local offset1 -- translational velocity --		---------------------------------------------------------
	local offset2 -- rotational velocity --			--- Velocity and Displacement are not the same thing, ---
	local offset3 -- displacement --				      --- displacement will measure 0 while velocity will   ---
	local offset4 -- horizontal displacement --	--- be increasing during infinite boost for example.  ---

  offset1 = 0x138 
  offset2 = 0x144
  offset3 = 0x4F8
  offset4 = 0x4FC 

	local address1 = pointer + offset1 
	local address2 = pointer + offset2 
	local address3 = pointer + offset3 
	local address4 = pointer + offset4 
	local xy_vel = math.sqrt((readFloatBE(address1, 4))^2 + (readFloatBE(address1 + 0x4, 4))^2)
	
	return {X = readFloatBE(address1, 4), Y = readFloatBE(address1 + 0x4, 4), Z = readFloatBE(address1 + 0x8, 4), XY = xy_vel,
			Xr = readFloatBE(address2, 4), Yr = readFloatBE(address2 + 0x4, 4), Zr = readFloatBE(address2 + 0x8, 4), 
			D = readFloatBE(address3, 4), Dxy = readFloatBE(address4, 4)}
end 
core.getSpd = getSpd

local function getPos()

	local pointer = getObject().player
	local offset -- position --
	local offset2 -- vector offset -- 
	
  offset = 0x40
  offset2 = 0x10
    
	local address = pointer + offset 
	
	return {address = address, X = readFloatBE(address, 4), Y = readFloatBE(address + offset2, 4), Z = readFloatBE(address + offset2 + offset2, 4)}
end
core.getPos = getPos

local function getJump()

	local pointer = getObject().player
	local offset1 -- jump state --
	local offset2 -- space jump timer -- 
	local offset3 -- jump presses in air --
	
  offset1 = 0x258
  offset2 = 0x28C
  offset3 = 0x298
	
	local address1 = pointer + offset1 
	local address2 = pointer + offset2 
	local address3 = pointer + offset3
	
	return {state = readIntBE(address1, 4), timer = readFloatBE(address2, 4), press = readIntBE(address3, 4)}
end
core.getJump = getJump

local function getCharge()
	
	local pointer = getObject().gun 
	local offset1 -- charge timer -- 
	local offset2 -- charge state --
	
  offset1 = 0x340
  offset2 = 0x32C
	
	local address1 = pointer + offset1
	local address2 = pointer + offset2
	
	return {timer = readFloatBE(address1, 4), state = readIntBE(address2, 4)}
end
core.getCharge = getCharge

local function getBoost()

	local pointer = getObject().morph
	local offset1 -- charge timer -- 
	local offset2 -- cooldown timer -- 
	
  offset1 = 0x1DE8
  offset2 = 0x1DF4 -- boost drain time ? --
    
	local address1 = pointer + offset1
	local address2 = pointer + offset2
	
	return {timer = readFloatBE(address1, 4), cooldown = readFloatBE(address2, 4)}
end
core.getBoost = getBoost

local function getBomb()

	local pointer = getObject().bomb
	local offset1 -- bomb count --
	local offset2 -- refill or cooldown timer --
	
  offset1 = 0x308
  offset2 = 0x35C
	
	local address1 = pointer + offset1
	local address2 = pointer + offset2
	
	return {count = readIntBE(address1, 4), timer = readFloatBE(address2, 4)}
end
core.getBomb = getBomb


local function getFluid() 

	local pointer = getObject().player
	local offset1 -- number of water boxes -- 
	local offset2 -- distance underwater -- 
	
	
  offset1 = 0xE6
  offset2 = 0x828
	
	local address1 = pointer + offset1
	local address2 = pointer + offset2
	
	return {count = readBytes(address1, 1), depth = readFloatBE(address2, 4)}
end
core.getFluid = getFluid

local function getIGT()

	local pointer = getObject().gamestate
	local offset -- IGT in frames -- 
	
  offset = 0xA0
	
	local address = pointer + offset
	local timerFloat = (intToDouble(readIntBE(address, 8) + 0x8000000000000000) * -1)
	local timerSec = timerFloat % 60
	local timerMin = math.floor((timerFloat / 60) % 60)
	local timerHour = math.floor(timerFloat / 3600)	
	
	return {sec = timerSec, min = timerMin, hour = timerHour}
end
core.getIGT = getIGT

local function getRoom()

	Room = ram + 0x45AA74
  
	return {ID = readIntBE(Room, 4)}
end
core.getRoom = getRoom

local function getHealth()
  
  local pointer 
  local offset1 -- player hp -- 
  local offset2 -- # of etanks -- 
  
  pointer = getObject().gamestate
  offset1 = 0x2AC
  offset2 = 0x38C
  
  local address1 = pointer + offset1
  local address2 = pointer + offset2
  local maxHP = readIntBE(address2, 4) * 100 + 99
  local currentHP = readFloatBE(address1, 4)
  local difHP = maxHP - currentHP
  local currentEtanks = math.floor((maxHP - difHP)/100) 
  local hp = currentHP - (currentEtanks * 100)
  
  return{current = currentHP, max = maxHP, hp = hp, etankcur = currentEtanks, etankmax = readIntBE(address2, 4)}
end
core.getHealth = getHealth

local function layout()
  
  local text = "IGT: " 
   .. core.getIGT().hour .. ":" .. string.format("%02.0f", core.getIGT().min) .. ":" .. string.format("%06.3f", core.getIGT().sec)
   .. "   Room# " .. core.getRoom().ID
   .. "\nHealth:  " .. string.format("%05.3f", core.getHealth().hp) .. "     " .. core.getHealth().etankcur .. " / " .. core.getHealth().etankmax 
   .. "\n"
   .. "\nPosition: "
	 .. "\n" .. string.format("%8.2f", core.getPos().X) .. " " .. string.format("%8.2f", core.getPos().Y) .. " " .. string.format("%7.2f", core.getPos().Z)
   .. "\nSpeed: " .. string.format("%6.3f", core.getSpd().XY) .. " | " .. string.format("%7.3f", core.getSpd().Z)
   .. "\nDispl: " .. string.format("%6.3f", core.getSpd().Dxy)
   .. "\n" 
   .. "\nCharge: " .. string.format("%05.3f", core.getCharge().timer) .. " | " .. core.getCharge().state
   .. "\nBoost:  " .. string.format("%05.3f", core.getBoost().timer)
   .. "\nBombs:  " .. core.getBomb().count .. " | " .. string.format("%05.3f", core.getBomb().timer)
   .. "\nJump:   " .. core.getJump().state .. " | " .. string.format("%05.3f", core.getJump().timer)
  
  return text
end
core.layout = layout

return core