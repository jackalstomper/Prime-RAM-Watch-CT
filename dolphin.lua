package.loaded.utils = nil

local utils = require "utils"

local dolphin = {}

--[[
It is important that when scanning Dolphin's memory that we only look at Mapped memory. 
The mapped memory corresponds to dolphins emulated memory and from just simple observation,
the first Game ID address found in the mapped memory region is the start of our emulated ram.
This could be completely wrong however and it might break at some point as a result of this
assumption. 

What's is most important is that we have Cheat Engine scan settings only search emulated memory 
or else this will fail. You can do this in Settings > Scan settings > uncheck both MEM_PRIVATE 
and MEM_IMAGE at the bottom. Then finally, of the three make sure the only checked box is 
MEM_MAPPED and that should work.
]]--

local RAM_Start = nil
local GameID = nil

if utils.scanStr("GM8E01") ~= nil then
  RAM_Start = utils.scanStr("GM8E01")
  GameID = "prime"
elseif utils.scanStr("G2ME01") ~= nil then
  RAM_Start = utils.scanStr("G2ME01")
  GameID = "echoes"
elseif utils.scanStr("RM3E01") ~= nil then
  RAM_Start = utils.scanStr("RM3E01")
  GameID = "corruption"
end
  
local function get_RAM_Start()
  return utils.intToHexStr(RAM_Start) --scanStr returns an int and we convert to Hex address
end
dolphin.get_RAM_Start = get_RAM_Start

--[[ 
Here we have searched the mapped memory for the 3 game ID's of the prime versions supported at this moment.
]]--

local function get_GameID()
  if GameID ~= "echoes" then
    return GameID
  elseif utils.readIntBE(RAM_Start + 0x17FFFE8, 6) == 0x47324D453031 then 
    return "menumod" -- menu mod exclusive repeating Game ID at this address
  else
    return GameID
  end
end
dolphin.get_GameID = get_GameID

return dolphin