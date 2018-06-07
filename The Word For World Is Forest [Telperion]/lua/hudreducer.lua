-------------------------------------------------------------------------------
--
--		HUD Reducer module for SM5 modifier files 
--		
--		Author: 	Telperion
--		Date: 		2016-12-11
--
-------------------------------------------------------------------------------

local HUDReducer = Def.ActorFrame {
	InitCommand = function(self)
	end,
	OnCommand = function(self)
		self:sleep(1573);
	end
};

-------------------------------------------------------------------------------
--
--		Everybody wants to hide the Lay's.
--
local playerExpected = {false, false};		-- Who's playing?
for pn = 1,2 do
	if GAMESTATE:IsHumanPlayer("PlayerNumber_P"..pn) then
		playerExpected[pn] = true;
	end
end

HUDReducer[#HUDReducer+1] = Def.Quad {
	InitCommand = function(self)
		self:SetHeight(6)
			:SetWidth(6)
			:xy(-12,-12)
			:visible(false);
	end,
	OnCommand = function(self)
		SCREENMAN:GetTopScreen():SetDrawByZPosition(true)

		local hamburger = SCREENMAN:GetTopScreen();
		
		-- Hide the overlay and the underlay.
		if hamburger:GetScreenType() == "ScreenType_Gameplay" then
			hamburger:GetChild("Overlay" ):decelerate(1.0 / GAMESTATE:GetSongBPS()):diffusealpha(0.0);
			hamburger:GetChild("Underlay"):decelerate(1.0 / GAMESTATE:GetSongBPS()):diffusealpha(0.0);
		end
				
		-- Try to set the noteskin to "cyber" for each player.		
		local hadToSetNoteskin = false;
		local hadToEraseTurnMods = false;
		for pn,_ in ipairs(playerExpected) do		
			pops = GAMESTATE:GetPlayerState("PlayerNumber_P"..pn):GetPlayerOptions("ModsLevel_Preferred");
			if pops then 
				-- Changing the fail setting works well here.
				-- pops:FailSetting('FailType_Off');
				prevTN1, didItWork = pops:Mirror(false);
				prevTN2, didItWork = pops:Left(false);
				prevTN3, didItWork = pops:Right(false);
				prevTN4, didItWork = pops:Shuffle(false);
				prevTN5, didItWork = pops:SoftShuffle(false);
				prevTN6, didItWork = pops:SuperShuffle(false);
		
				prevNS1, didItWork = pops:NoteSkin("Cyber");
				prevNS2, didItWork = pops:NoteSkin("cyber");
				prevNS3, didItWork = pops:NoteSkin();
				if prevNS3:lower() ~= "cyber" then
					-- We couldn't do anything about the noteskin.
					hadToSetNoteskin = false;
				elseif prevNS1:lower() ~= "cyber" or
					   prevNS2:lower() ~= "cyber" then
					-- We changed the noteskin! 
					-- But the song needs to be restarted or it won't take.
					hadToSetNoteskin = true;
				end
				
				if prevTN1 or prevTN2 or prevTN3 or prevTN4 or prevTN5 or prevTN6 then
					-- No turn mods! C'mon!!
					hadToEraseTurnMods = true;
				end					
			end
			
			-- Force the combo to disappear.
			pv = hamburger:GetChild("PlayerP"..pn);
			if pv then
				pv:GetChild("Combo"):visible(false):hibernate(1573);
	
				--
				-- Uncomment this section if not hiding the whole underlay.
				--
--				hamburger:GetChild("ScoreP"..pn):visible(false);
--				-- SL-specific underlay usage!
--				hamburger:GetChild("Underlay"):GetChild("P"..pn.."Score"):visible(false);
--				hamburger:GetChild("Underlay"):GetChild("DangerP" ..  pn):visible(false):hibernate(1573);				
				
				-- We've done everything we needed to for this player.
				playerExpected[pn] = false;
			end
		end
				
		if hadToSetNoteskin or hadToEraseTurnMods then
			-- We changed the noteskin! 
			-- But the song needs to be restarted or it won't take.
			SCREENMAN:SetNewScreen("ScreenGameplay");
		end
		
		Trace("HUD Reducer: Done!")
		self:hibernate(1573);
	end
}

return HUDReducer;
