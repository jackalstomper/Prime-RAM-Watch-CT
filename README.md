# Supported Dolphin Versions

#### Dolphin Emulator 

-- 3.0 Builds -- 

3.5-2302-x64

-- 4.0 Builds --

4.0-2826, 3599, 4191, 4222, 4233, 4565, 4577, 4654

-- 5.0 Builds --

5.0-9413, 10638, 10833


#### Games Supported 

Metroid Prime 1 		NTSC (0-00), 
Metroid Prime 2: Echoes 	NTSC (0-00), 
Metroid Prime 3: Corruption 	NTSC (0A-0)

*support for the Prime Trilogy Disc, Wii de Asobu, Prime 1 JP, Prime 1 Korean (0-30),
Prime 1 PAL, Echoes PAL, and Dark Echoes, and PAL Corruption is planned in that order.

*Practice mod is not supported (though partially works) and Menu mod is not supported at all. 
You probably shouldn't be TAS'ing on these anyways. 

# ram-watch-cheat-engine

RAM watch display examples, using Lua scripts in Cheat Engine.

Basic use of Cheat Engine lets you display RAM values in real time while a game is running,
but with scripting you can get a much more customized display.


# What you'll need

	* The Lua scripts in this repository. Download the ZIP, and extract it somewhere on your computer.

	* Cheat Engine https://www.cheatengine.org/downloads.php
	  These scripts have mainly been tested with Cheat Engine 6.8.3 (64-bit version). 

	* A code editor that supports Lua syntax highlighting. I personally use ZeroBrane Studio.
	  You can find ZeroBrane Studio here https://studio.zerobrane.com/
	  More simple text editors like Notepad or Notepad++ also work.


# How to use

Run Cheat Engine. In the Cheat Engine window, click File -> Open Process, then scroll to your dolphin window and select it and click open. 
Alternatively you can click the computer shaped icon in the top left and select dolphin from there. Next, in the Cheat Engine window, 
click File ->  Load and select PrimeList.CT and select yes when prompted. Make sure that Cheat Engine is both hooked, and that dolphin is 
running a game before attempting to load PrimeList. 

# Performance note

Running one of these scripts alongside your game may cause the game to run slower. Generally, it seems to get worse if you've clicked
Execute Script many times while testing, and in this case closing and re-opening Cheat Engine may make it better. (But I could be wrong.)

Closing the window causes an "Error:Access violation" which has yet to be resolved. If you close the window by mistake you will likely
need to close and re-open Cheat Engine to fix the issue. 


# Acknowledgments

Masterjun, for writing the RAM watch script (2013/08/26) that this project was based on: http://pastebin.com/vUCmhwMQ

Tales, for helping answer some questions I had. Some of Tale's other Sonic scripts are what the prime scripts is heavily based off of.
