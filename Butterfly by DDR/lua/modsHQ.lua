-------------------------------------------------------------------------------
--
--		Standard Playfield Modifier Headquarters
--		
--		Author: 	Telperion
--		Date: 		2018-11-25
--
--
--		Pass arguments when loading this actor:
--
--		local modsTable = {
--			-- [1]: beat start
--			-- [2]: mod type
--			-- [3]: mod strength (out of unity),
--			-- [4]: mod approach (in beats to complete),
--			-- [5]: player application (1 = P1, 2 = P2, 3 = both, 0 = neither)
--		};
--		local modsLeadBy = 0.009;
--
-------------------------------------------------------------------------------

-- Parse arguments.
local modsTable, modsLeadBy, clearMods = unpack(...)
modsTable 	= modsTable 	or {}
modsLeadBy 	= modsLeadBy 	or 0
clearMods 	= clearMods 	or false

local modsLaunched = 0;

local mods = {
	["Alternate"] 					= "float",
--	["AttackMines"] 				= "bool",
	["AttenuateX"] 					= "float",
	["AttenuateY"] 					= "float",
	["AttenuateZ"] 					= "float",
--	["Backwards"] 					= "bool",
--	["BatteryLives"] 				= "int",
	["Beat"] 						= "float",
	["BeatMult"] 					= "float",
	["BeatOffset"] 					= "float",
	["BeatPeriod"] 					= "float",
	["BeatY"] 						= "float",
	["BeatYMult"] 					= "float",
	["BeatYOffset"] 				= "float",
	["BeatYPeriod"] 				= "float",
	["BeatZ"] 						= "float",
	["BeatZMult"] 					= "float",
	["BeatZOffset"] 				= "float",
	["BeatZPeriod"] 				= "float",
	["Big"] 						= "bool",
	["Blind"]	 					= "float",
	["Blink"] 						= "float",
--	["BMRize"] 						= "bool",
	["Boomerang"] 					= "float",
	["Boost"] 						= "float",
	["Bounce"] 						= "float",
	["BounceOffset"] 				= "float",
	["BouncePeriod"] 				= "float",
	["BounceZ"] 					= "float",
	["BounceZOffset"] 				= "float",
	["BounceZPeriod"] 				= "float",
	["Brake"] 						= "float",
	["Bumpy"] 						= "float",
	["Bumpyn"] 						= "float",
	["BumpyOffset"] 				= "float",
	["BumpyPeriod"] 				= "float",
	["BumpyX"] 						= "float",
	["BumpyXOffset"] 				= "float",
	["BumpyXPeriod"] 				= "float",
	["Centered"] 					= "float",
	["CMod"] 						= "float",
	["Confusion"] 					= "float",
	["ConfusionOffset"] 			= "float",
	["ConfusionOffsetn"] 			= "float",
	["ConfusionX"] 					= "float",
	["ConfusionXOffset"] 			= "float",
	["ConfusionXOffsetn"] 			= "float",
	["ConfusionY"] 					= "float",
	["ConfusionYOffset"] 			= "float",
	["ConfusionYOffsetn"] 			= "float",
	["Cosecant"] 					= "bool",
	["Cover"] 						= "float",
	["Cross"] 						= "float",
	["Dark"] 						= "float",
	["Darkn"] 						= "float",
	["Digital"] 					= "float",
	["DigitalOffset"] 				= "float",
	["DigitalPeriod"] 				= "float",
	["DigitalSteps"] 				= "float",
	["DigitalZ"] 					= "float",
	["DigitalZOffset"] 				= "float",
	["DigitalZPeriod"] 				= "float",
	["DigitalZSteps"] 				= "float",
	["Distant"] 					= "float",
	["Dizzy"] 						= "float",
	["DizzyHolds"] 					= "bool",
--	["DrainSetting"] 				= "DrainType",
	["DrawSize"] 					= "float",
	["DrawSizeBack"] 				= "float",
	["Drunk"] 						= "float",
	["DrunkOffset"] 				= "float",
	["DrunkPeriod"] 				= "float",
	["DrunkSpeed"] 					= "float",
	["DrunkZ"] 						= "float",
	["DrunkZOffset"] 				= "float",
	["DrunkZPeriod"] 				= "float",
	["DrunkZSpeed"] 				= "float",
	["Echo"] 						= "bool",
	["Expand"] 						= "float",
	["ExpandPeriod"] 				= "float",
--	["FailSetting"] 				= "FailType",
	["Flip"] 						= "float",
	["Floored"] 					= "bool",
	["Hallway"] 					= "float",
	["Hidden"] 						= "float",
	["HiddenOffset"] 				= "float",
	["HoldRolls"] 					= "bool",
	["Incoming"] 					= "float",
	["Invert"] 						= "float",
--	["IsEasierForCourseAndTrail"] 	= "Course",
--	["IsEasierForSongAndSteps"] 	= "Song",
	["Left"] 						= "bool",
--	["LifeSetting"] 				= "LifeType",
	["Little"] 						= "bool",
	["MaxScrollBPM"] 				= "float",
	["Mines"] 						= "bool",
	["Mini"] 						= "float",
	["MinTNSToHideNotes"] 			= "TapNoteScore",
	["Mirror"] 						= "bool",
	["MMod"] 						= "float",
	["ModTimerMult"] 				= "float",
	["ModTimerOffset"] 				= "float",
--	["ModTimerSetting"] 			= "ModTimerType",
	["MoveXn"] 						= "float",
	["MoveYn"] 						= "float",
	["MoveZn"] 						= "float",
--	["MuteOnError"] 				= "bool",
	["NoAttack"] 					= "float",
	["NoFakes"] 					= "bool",
	["NoHands"] 					= "bool",
	["NoHolds"] 					= "bool",
	["NoJumps"] 					= "bool",
	["NoLifts"] 					= "bool",
	["NoMines"] 					= "bool",
	["NoQuads"] 					= "bool",
	["NoRolls"] 					= "bool",
	["NoStretch"] 					= "bool",
	["NoteSkin"] 					= "string",
	["Overhead"] 					= "bool",
	["ParabolaX"] 					= "float",
	["ParabolaY"] 					= "float",
	["ParabolaZ"] 					= "float",
--	["Passmark"] 					= "float",
	["Planted"] 					= "bool",
--	["PlayerAutoPlay"] 				= "float",
	["PulseInner"] 					= "float",
	["PulseOffset"] 				= "float",
	["PulseOuter"] 					= "float",
	["PulsePeriod"] 				= "float",
	["Quick"] 						= "bool",
	["RandAttack"] 					= "float",
	["RandomSpeed"] 				= "float",
	["RandomVanish"] 				= "float",
	["Reverse"] 					= "float",
	["Reversen"] 					= "float",
	["Right"] 						= "bool",
	["Roll"] 						= "float",
	["Sawtooth"] 					= "float",
	["SawtoothPeriod"] 				= "float",
	["SawtoothZ"] 					= "float",
	["SawtoothZPeriod"] 			= "float",
	["ScrollBPM"] 					= "float",
	["ScrollSpeed"] 				= "float",
	["ShrinkLinear"] 				= "float",
	["ShrinkMult"] 					= "float",
	["Shuffle"] 					= "bool",
	["Skew"] 						= "float",
	["Skippy"] 						= "bool",
	["SoftShuffle"] 				= "bool",
	["Space"] 						= "float",
	["Split"] 						= "float",
	["Square"] 						= "float",
	["SquareOffset"] 				= "float",
	["SquarePeriod"] 				= "float",
	["SquareZ"] 					= "float",
	["SquareZOffset"] 				= "float",
	["SquareZPeriod"] 				= "float",
	["Stealth"] 					= "float",
	["Stealthn"] 					= "float",
	["StealthPastReceptors"] 		= "bool",
	["StealthType"] 				= "bool",
	["Stomp"] 						= "bool",
	["Sudden"] 						= "float",
	["SuddenOffset"] 				= "float",
	["SuperShuffle"] 				= "bool",
	["Tilt"] 						= "float",
	["TimeSpacing"] 				= "float",
	["Tiny"] 						= "float",
	["Tinyn"] 						= "float",
	["Tipsy"] 						= "float",
	["TipsyOffset"] 				= "float",
	["TipsySpeed"] 					= "float",
	["Tornado"] 					= "float",
	["TornadoOffset"] 				= "float",
	["TornadoPeriod"] 				= "float",
	["TornadoZ"] 					= "float",
	["TornadoZOffset"] 				= "float",
	["TornadoZPeriod"] 				= "float",
	["TurnNone"] 					= "bool",
	["Twirl"] 						= "float",
	["Twister"] 					= "bool",
	["Wave"] 						= "float",
	["WavePeriod"] 					= "float",
	["Wide"] 						= "bool",
	["XMod"] 						= "float",
	["Xmode"] 						= "float",
	["ZBuffer"] 					= "bool",
	["Zigzag"] 						= "float",
	["ZigzagOffset"] 				= "float",
	["ZigzagPeriod"] 				= "float",
	["ZigzagZ"] 					= "float",
	["ZigzagZOffset"] 				= "float",
	["ZigzagZPeriod"] 				= "float",
}
local ClearAllMods = function(playerNum, justTrace)
	local currValue;
	local currApproach;
	
	playerNum = playerNum or 1
	justTrace = justTrace or false
	
	if playerNum < 1 or playerNum > 2 then do Trace("In clearAllMods: Player number "..playerNum.." is invalid!"); return end end
	pops = GAMESTATE:GetPlayerState("PlayerNumber_P"..playerNum):GetPlayerOptions("ModsLevel_Song");
	if pops then
		for modName,modType in pairs(mods) do
			currValue,currApproach = pops[modName](pops);
			-- Trace("In clearAllMods: P"..playerNum.." has mod "..modName.." set to "..tostring(currValue));
			
			if not justTrace then
				if modType == "float" then
					if modName == "ScrollBPM" then
						pops[modName](pops, 200);
					elseif modName == "ScrollSpeed" then
						pops[modName](pops, 1);
					else
						pops[modName](pops, 0);
					end
				elseif modType == "bool" then
					pops[modName](pops, false);
				elseif modType == "int" then
					if modName == "BatteryLives" then
						pops[modName](pops, 4);
					else
						pops[modName](pops, 0);
					end
				else -- if modType == "ENUM" then
				end
			end
		end
	else
		Trace("In clearAllMods: Player options for "..playerNum.." are not initialized!");
	end
end

local UpdateMods = function(self)
	-- Most things are determined by beat, believe it or not.		
	local overtime = GAMESTATE:GetSongBeat();
	
	-- TODO: this assumes the effect applies over a constant BPM section!!
	BPS = GAMESTATE:GetSongBPS()
	
	-- Safely initialize the mods table and leading beat count.
	modsTable 	= modsTable or {};
	modsLeadBy 	= modsLeadBy or 0;
	
	if modsLaunched >= #modsTable then
		Trace('>>> modsHQ: Hibernated!!');
		self:hibernate(1573);
		do return end
	else
		while modsLaunched < #modsTable do
			-- Trace('>>> modsHQ: ' .. modsLaunched);
			-- Check the next line of the mods table.
			nextMod = modsTable[modsLaunched + 1];
			
			if overtime + modsLeadBy >= nextMod[1] then
				-- TODO: this assumes the effect applies over a constant BPM section!!
				Trace('>>> modsHQ: ' .. modsLaunched .. ' @ time = ' .. overtime);
				
				for _,pe in pairs(GAMESTATE:GetEnabledPlayers()) do
					pn = tonumber(string.match(pe, "[0-9]+"));
					if (nextMod[5] == pn or nextMod[5] == 3) then
						pops = GAMESTATE:GetPlayerState(pe):GetPlayerOptions("ModsLevel_Song");
						
						-- Calculate approach (in units of the value per second):
						-- a = (value final - value initial) * (beats per second) / (beats for transition + ``machine epsilon``)
						-- Has to be done individually for each player, just in case they're coming from different initial values :(
						opVal, opApproach = pops[ nextMod[2] ]( pops );
						if opApproach == 0 then -- SOMEONE FUCKED UP AND IT WASN'T ME.
							newApproach = BPS;
						else
							newApproach = math.abs(nextMod[3] - opVal) * BPS / (nextMod[4] + 0.001);
						end
											pops[ nextMod[2] ]( pops, nextMod[3], newApproach );
						Trace('>>> modsHQ: ' .. opVal      .. ' @ rate = ' .. opApproach  .. ' for ' .. pe);
						Trace('>>> modsHQ: ' .. nextMod[3] .. ' @ rate = ' .. newApproach .. ' for ' .. pe .. ' [New!]');
					end
				end
				
				modsLaunched = modsLaunched + 1
			else
				-- Trace('>>> modsHQ: ' .. overtime .. ' < ' .. nextMod[1])
				break;
			end
		end
	end		
end

return Def.ActorFrame {
	Name = "ModsHQ",
	OnCommand = function(self)
		if clearMods then
			clearAllMods(1)
			clearAllMods(2)
		end
		self:SetUpdateFunction(UpdateMods)
	end
}