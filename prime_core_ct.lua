package.loaded.shared = nil
package.loaded.utils = nil
package.loaded.dolphin = nil

local shared = require "shared"
local utils = require "utils"
local dolphin = require "dolphin"
local intToDouble = utils.intToDouble
local readFloatBE = utils.readFloatBE
local readIntBE = utils.readIntBE
local ram = dolphin.get_RAM_Start()

local core = {}

function getGameID()
	local gameID = readIntBE(ram, 6)
	-- Check whether the ID is GM8E01 (Prime 0-00 NTSC) or G2ME01 (Prime 2 Echoes NTSC) or RM3E01 (Prime 3 Corruption NTSC)
	if gameID == 0x474D38453031 then
		return "prime"
	elseif gameID == 0x47324D453031 then
		menuMod = readIntBE(ram + 0x17FFFE8, 6)
    if menuMod == 0x47324D453031 then
      return "menumod"
    else 
      return "echoes"
    end
	elseif gameID == 0x524D33453031 then
		return "corruption"
  else
    return "\nERROR" .. gameID
	end
end
core.getGameID = getGameID

local function getObject()

	local CPlayer 
	local CPlayerMorph
	local CPlayerGun
	local CPlayerBomb
	local CGameState 
	local Room

	if getGameID() == "prime" then
		CPlayer = readIntBE(ram + 0x458350, 4) - 0x80000000 + ram
		CPlayerMorph = readIntBE(CPlayer + 0x768, 4) - 0x80000000 + ram
		CPlayerGun = readIntBE(CPlayer + 0x490, 4) - 0x80000000 + ram
		CPlayerBomb = CPlayerGun
		CGameState = readIntBE(ram + 0x4578CC, 4) - 0x80000000 + ram
		Room = ram + 0x45AA74
	elseif getGameID() == "echoes" then
		CPlayer = readIntBE(ram + 0x3CA740, 4) - 0x80000000 + ram
		CPlayerMorph = readIntBE(CPlayer + 0x1174, 4) - 0x80000000 + ram
		CPlayerGun = readIntBE(CPlayer + 0x1314, 4) - 0x80000000 + ram
		CPlayerBomb = readIntBE(CPlayer + 0xEBC, 4) - 0x80000000 + ram
		CGameState = readIntBE(ram + 0x3C5C9C, 4) - 0x80000000 + ram
		Room = ram + 0x3DCD80 
	elseif getGameID() == "corruption" then
		Base = readIntBE(ram + 0x5C4F98, 4) - 0x80000000 + ram
    CPlayer = readIntBE(Base + 0x2184, 4) - 0x80000000 + ram -- 0x0 80592C78 --
		CPlayerMorph = readIntBE(CPlayer + 0x2AC4, 4) - 0x80000000 + ram
		CPlayerGun = ram + 0x9934B4 -- start of gun/ inventory object + 0x0, 80993E80 -- 
		CPlayerBomb = readIntBE(CPlayer + 0x3ADC, 4) - 0x80000000 + ram
		CGameState = readIntBE(ram + 0x5C7D80, 4) - 0x80000000 + ram
    Room = Base
		
	end
	
	return {player = CPlayer, morph = CPlayerMorph, gun = CPlayerGun, bomb = CPlayerBomb, gamestate = CGameState, room = Room}
end
core.getObject = getObject

local function getSpd()
	
	
	local pointer = getObject().player
	local offset1 -- translational velocity --		---------------------------------------------------------
	local offset2 -- rotational velocity --			--- Velocity and Displacement are not the same thing, ---
	local offset3 -- displacement --				--- displacement will measure 0 while velocity will   ---
	local offset4 -- horizontal displacement --		--- be increasing during infinite boost for example.  ---
													---------------------------------------------------------																					
	if getGameID() == "prime" then
		offset1 = 0x138 
		offset2 = 0x144
		offset3 = 0x4F8
		offset4 = 0x4FC 
	elseif getGameID() == "echoes" then
		offset1 = 0x1A8
		offset2 = 0x1B4
		offset3 = 0xF7C
		offset4 = 0xFCC 
	elseif getGameID() == "corruption" then
		offset1 = 0x178
		offset2 = 0x184
		offset3 = 0x2930
		offset4 = 0x2934
	end
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
	
	if getGameID() == "prime" then
		offset = 0x40
		offset2 = 0x10
	elseif getGameID() == "echoes" then
		offset = 0x54
		offset2 = 0x4
	elseif getGameID() == "corruption" then
		offset = 0x6C
		offset2 = 0x4
	end
	local address = pointer + offset 
	
	return {address = address, X = readFloatBE(address, 4), Y = readFloatBE(address + offset2, 4), Z = readFloatBE(address + offset2 + offset2, 4)}
end
core.getPos = getPos

local function getJump()

	local pointer = getObject().player
	local offset1 -- jump state --
	local offset2 -- space jump timer -- 
	local offset3 -- jump presses in air --
	
	if getGameID() == "prime" then
		offset1 = 0x258
		offset2 = 0x28C
		offset3 = 0x298
	elseif getGameID() == "echoes" then
		offset1 = 0x2D0
		offset2 = 0x304
		offset3 = 0x304 -- not correct --
	elseif getGameID() == "corruption" then
		offset1 = 0x29C
		offset2 = 0x2C8
		offset3 = 0x2D4
	end
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
	
	if getGameID() == "prime" then
		offset1 = 0x340
		offset2 = 0x32C
	elseif getGameID() == "echoes" then
		offset1 = 0x48
		offset2 = 0x0  -- not correct --
	elseif getGameID() == "corruption" then
		offset1 = 0x50
		offset2 = 0x0  -- not correct --
	end
	local address1 = pointer + offset1
	local address2 = pointer + offset2
	
	return {timer = readFloatBE(address1, 4), state = readIntBE(address2, 4)}
end
core.getCharge = getCharge

local function getBoost()

	local pointer = getObject().morph
	local offset1 -- charge timer -- 
	local offset2 -- cooldown timer -- 
	
	if getGameID() == "prime" then
		offset1 = 0x1DE8
		offset2 = 0x1DF4 -- boost drain time ? --
	elseif getGameID() == "echoes" then
		offset1 = 0x1020
		offset2 = 0x1850
	elseif getGameID() == "corruption" then
		offset1 = 0xFD0
		offset2 = 0x2FFC
	end
	local address1 = pointer + offset1
	local address2 = pointer + offset2
	
	return {timer = readFloatBE(address1, 4), cooldown = readFloatBE(address2, 4)}
end
core.getBoost = getBoost

local function getBomb()

	local pointer = getObject().bomb
	local offset1 -- bomb count --
	local offset2 -- refill or cooldown timer --
	
	if getGameID() == "prime" then
		offset1 = 0x308
		offset2 = 0x35C
	elseif getGameID() == "echoes" then
		offset1 = 0x788
		offset2 = 0x668
	elseif getGameID() == "corruption" then
		offset1 = 0x44
		offset2 = 0x44 -- there is no timer for corruption bombs --
	end
	local address1 = pointer + offset1
	local address2 = pointer + offset2
	
	return {count = readIntBE(address1, 4), timer = readFloatBE(address2, 4)}
end
core.getBomb = getBomb

local function getSA()

	local pointer = getObject().morph
	local offset -- count --
	
	if getGameID() == "corruption" then 
		offset = 0x34AC
	end
	local address = pointer + offset 
	
	return {count = readIntBE(address, 4)}
end
core.getSA = getSA

local function getFluid() -- only valid in prime1 right now will need to look at how echoes floaty works later --

	local pointer = getObject().player
	local offset1 -- number of water boxes -- 
	local offset2 -- distance underwater -- 
	
	if getGameID() == "prime" then
		offset1 = 0xE6
		offset2 = 0x828
	end
	local address1 = pointer + offset1
	local address2 = pointer + offset2
	
	return {count = readBytes(address1, 1), depth = readFloatBE(address2, 4)}
end
core.getFluid = getFluid

local function getIGT()

	local pointer = getObject().gamestate
	local offset -- IGT in frames -- 
	
	if getGameID() == "prime" then
		offset = 0xA0
	elseif getGameID() == "echoes" then 
		offset = 0x48
	elseif getGameID() == "corruption" then
		offset = 0x38
	end
	local address = pointer + offset
	local timerFloat = (intToDouble(readIntBE(address, 8) + 0x8000000000000000) * -1)
	local timerSec = timerFloat % 60
	local timerMin = math.floor((timerFloat / 60) % 60)
	local timerHour = math.floor(timerFloat / 3600)	
	
	return {sec = timerSec, min = timerMin, hour = timerHour}
end
core.getIGT = getIGT

local function getRoom()

	local pointer = getObject().room
	local offset 
	
	if getGameID() == "prime" then	
		offset = 0x0
	elseif getGameID() == "echoes" then
		offset = 0x0
	elseif getGameID() == "corruption" then
		offset = 0x2150
	end
	local address = pointer + offset
		
	return {ID = readIntBE(address, 4)}
end
core.getRoom = getRoom

local function getHealth()
  
  local pointer 
  local offset1 -- player hp -- 
  local offset2 -- # of etanks -- 
  
  if getGameID() == "prime" then
    pointer = getObject().gamestate
    offset1 = 0x2AC
    offset2 = 0x38C
  elseif getGameID() == "echoes" then
    pointer = getObject().gun
    offset1 = 0x14
    offset2 = 0x258
  elseif getGameID() == "corruption" then
    pointer = getObject().gun
    offset1 = 0x18
    offset2 = 0x154
  end
  
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



return core