package.loaded.utils = nil

local utils = require "utils"

-- Specify your Dolphin version here.

-- If you use a version of Dolphin listed here (recommended if you want to
-- set up this script as easily as possible), uncomment the line for that
-- version, and comment out the rest of the version lines. Then you're good
-- to go; you can ignore the rest of the steps!

-- If you use a different version of Dolphin, add a line for your Dolphin
-- version here, and uncomment the rest of the version lines.
-- Then, below, follow the instructions to get gameRAMStartPointerAddress
-- and add an elseif clause for your Dolphin version.

-- A line is "commented out" if it has two dashes at the start. This means
-- the Lua engine will ignore the line. If you are looking at this script
-- in Cheat Engine, make sure you have View -> Syntax Highlighting checked,
-- and the comments should show with a gray color and italics.
-- To "uncomment" a commented-out line, just remove the two dashes from the
-- start of the line.

local dolphin = {}

-- Start by commenting out which Major Dolphin verison you are using 

--local dolphinMajor = "3.0"
local dolphinMajor = "4.0"
--local dolphinMajor = "5.0" 

--Next comment out which specific version of dolphin you are using

-- 3.0 Builds --
--local dolphinVersion = "3.5-2302-x64"

-- 4.0 Builds --
--local dolphinVersion = "4.0-2826"
--local dolphinVersion = "4.0-3599"
--local dolphinVersion = "4.0-4191"
local dolphinVersion = "4.0-4222"
--local dolphinVersion = "4.0-4233"
--local dolphinVersion = "4.0-4565"
--local dolphinVersion = "4.0-4577"
--local dolphinVersion = "4.0-4654"

-- 5.0 Builds --
--local dolphinVersion = "5.0-9413"
--local dolphinVersion = "5.0-10638"
--local dolphinVersion = "5.0-10833"

-- We need to specify if we are using 5.0 dolphin or higher
-- this is because for 5.0 and higher versions, the starting memory
-- address is 8 Bytes while 4.0 and lower versions are 4 Bytes
local majorBytes = nil
if dolphinMajor == "3.0" then
  majorBytes = 4
elseif dolphinMajor == "4.0" then
  majorBytes = 4
elseif dolphinMajor == "5.0" then 
  majorBytes = 8
end

-- The following variables are memory addresses that depend on the Dolphin
-- version. Since addresses are written in hex, make sure you have the "0x"
-- before the actual number.

-- Follow this: http://tasvideos.org/forum/t/13462 tutorial to get a
-- "pointerscan result". Doubleclick on the Address column and enter the address
-- after the ' "Dolphin.exe"+ ' (don't forget the 0x).
--
-- If this address doesn't work consistently, follow the tutorial again
-- and try picking a different address. 


local gameRAMStartPointerAddress = nil
if dolphinVersion == "3.5-2302-x64" then
  gameRAMStartPointerAddress = 0x04961818
elseif dolphinVersion == "4.0-2826" then
  gameRAMStartPointerAddress = 0x00D1EBC8
elseif dolphinVersion == "4.0-3599" then
  gameRAMStartPointerAddress = 0x00F35D38
elseif dolphinVersion == "4.0-4191" then
  gameRAMStartPointerAddress = 0x00BD6710
elseif dolphinVersion == "4.0-4222" then
  gameRAMStartPointerAddress = 0x00BD97B8
elseif dolphinVersion == "4.0-4233" then
  gameRAMStartPointerAddress = 0x00BD97B8
elseif dolphinVersion == "4.0-4565" then
  gameRAMStartPointerAddress = 0x00BE67D8
elseif dolphinVersion == "4.0-4577" then
  gameRAMStartPointerAddress = 0x00BE67D8
elseif dolphinVersion == "4.0-4654" then
  gameRAMStartPointerAddress = 0x00BEC7E0 -- or BEC7E0 or D8
elseif dolphinVersion == "5.0-9413" then
  gameRAMStartPointerAddress = 0x00EB0BF8
elseif dolphinVersion == "5.0-10638" then
  gameRAMStartPointerAddress = 0x00F82528
elseif dolphinVersion == "5.0-10833" then
  gameRAMStartPointerAddress = 0x00F8C118
end
dolphin.getMajor = dolphinMajor
dolphin.getVersion = dolphinVersion
dolphin.getRAMPointer = gameRAMStartPointerAddress

-- Now we need to get the game's start address. We'll use this as a base for all
-- other addresses.
--
-- Example value: In Dolphin 3.5-2302 x64 and many 4.0 versions,
-- this is usually 0x7FFF0000, and is always 4 Bytes long. 
-- In Dolphin 5.0 versions this is usually dynamic and is usually 
-- 6 Bytes long. This is why we specified which major version we 
-- are using previously. 

local function get_RAM_Start()
	return utils.readIntLE(getAddress("Dolphin.exe") + gameRAMStartPointerAddress, majorBytes)
end
dolphin.get_RAM_Start = get_RAM_Start

return dolphin