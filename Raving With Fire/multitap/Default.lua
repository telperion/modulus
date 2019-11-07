-------------------------------------------------------------------------------
--
--		Multitap Factory & Assistance
--		
--		Author: 	Telperion
--		Date: 		2019-11-03
--		Version:	0.1
--
-------------------------------------------------------------------------------

--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--
--
-- Replace the contents of this table by using the Python chart utilities.
-- MultitapsWorkflow(r'C:\path\to\simfile.sm')
--
--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--
local multi_taps = {
	{lane = 1, taps = {
		  12.500,
		  13.500,
		  14.500,
	},
	{lane = 1, taps = {
		  16.500,
		  17.500,
		  18.500,
	},
	{lane = 0, taps = {
		  20.000,
		  21.000,
		  22.000,
		  23.000,
	},
	{lane = 2, taps = {
		  20.500,
		  21.500,
		  22.500,
	},
	{lane = 1, taps = {
		  24.500,
		  25.500,
		  26.500,
	},
	{lane = 2, taps = {
		  25.000,
		  27.000,
	},
	{lane = 3, taps = {
		  24.000,
		  26.000,
	},
	{lane = 0, taps = {
		  28.000,
		  28.750,
		  29.500,
	},
	{lane = 3, taps = {
		  30.000,
		  30.750,
		  31.500,
	},
	{lane = 0, taps = {
		  32.750,
		  33.500,
	},
	{lane = 2, taps = {
		  32.500,
		  33.250,
	},
	{lane = 2, taps = {
		  34.500,
		  35.250,
	},
	{lane = 3, taps = {
		  34.750,
		  35.500,
	},
	{lane = 0, taps = {
		  36.000,
		  38.000,
	},
	{lane = 1, taps = {
		  37.000,
		  38.000,
	},
	{lane = 3, taps = {
		  39.000,
		  40.500,
	},
	{lane = 0, taps = {
		  39.500,
		  42.000,
	},
	{lane = 2, taps = {
		  41.000,
		  42.000,
	},
	{lane = 0, taps = {
		  43.000,
		  46.000,
	},
	{lane = 2, taps = {
		  44.500,
		  46.000,
	},
	{lane = 3, taps = {
		  43.500,
		  45.000,
	},
	{lane = 0, taps = {
		  48.250,
		  48.750,
	},
	{lane = 1, taps = {
		  47.250,
		  47.750,
		  50.000,
	},
	{lane = 2, taps = {
		  49.250,
		  49.750,
	},
	{lane = 3, taps = {
		  47.000,
		  47.500,
		  48.000,
		  48.500,
		  49.000,
		  49.500,
	},
	{lane = 0, taps = {
		  51.000,
		  51.500,
		  52.000,
	},
	{lane = 1, taps = {
		  54.000,
		  58.500,
	},
	{lane = 2, taps = {
		  56.000,
		  59.500,
	},
	{lane = 3, taps = {
		  53.000,
		  55.000,
		  57.000,
	},
	{lane = 0, taps = {
		  58.000,
		  59.000,
		  60.000,
	},
	{lane = 1, taps = {
		  62.500,
		  64.000,
	},
	{lane = 2, taps = {
		  62.000,
		  63.500,
	},
	{lane = 0, taps = {
		  65.000,
		  65.500,
	},
	{lane = 1, taps = {
		  65.250,
		  65.750,
	},
	{lane = 2, taps = {
		  66.000,
		  67.500,
	},
	{lane = 1, taps = {
		  66.750,
		  67.250,
	},
	{lane = 3, taps = {
		  66.500,
		  67.000,
	},
}

--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--
--
-- Multitap generation code begins here
--
--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--

local BPS = GAMESTATE:GetSongBPS();

local multitap_parent = Def.ActorFrame {
	OnCommand = function(self)
		self:sleep(1000);
	end
};

local multitap_actors = {
	{},
	{}
}

local multitap_error = false
local multitap_previsible = 4
local multitap_elasticity = 1



local qtzn_lookup = {}
for _,qtzn in ipairs({48, 24, 16, 12, 8, 6, 4, 3, 2, 1}) do
	for i = 0,48,(48/qtzn) do
		qtzn_lookup[i] = qtzn
	end
end

local calc_qtzn = function(b)
	-- What quantization is this beat number?
	-- e.g., quarter = 1, 16th = 4, 24th = 6, etc.

	-- Graceful fallback for no-tap case.
	if not b then
		return 0
	end

	-- Each quarter can be divided into 48 steps.
	-- Get the nearest proper step.
	local d48 = math.floor(b*48 + 0.5) - math.floor(b)*48

	-- Decide where it falls.
	return qtzn_lookup[d48]
end

local parabolator = function(b, t, elastic)
	-- b = beat length of this multitap iteration
	-- t = time in beats since the start of this multitap iteration
	-- elastic = scaling of arrowpath position (1 = perfect bounce from approach speed, 0 = dead stop)
	-- returns distance back up the arrow path to travel
	--
	-- f(t) = v/b * t * (b - t), where v = approach speed
	-- we can get around needing to know the pixelar speed of the arrow by calculating distance
	-- in terms of beats traveled @ whatever the reading speed is.
	-- therefore the approach is always 1 beat/beat >:)
	if not elastic then
		elastic = 1
	end
	return elastic * t * (b-t) / b
end

local calc_multitap_phase = function(mt_desc, b)
	-- mt_table = multitap descriptor with the follwoing elements:
	--		lane: which lane the tap is in (unimportant here)
	--		taps: tap beat times included in this multitap
	-- b = current beat
	-- returns a table with the following elements:
	--		rem: # of hits left (the multitap should show a number if it's more than 1)
	--		pos: position in beats before receptors
	--		qtc: quantization of currently approaching note
	--		qtn: quantization of next note in the multitap (used to color the number)
	--		vis: currently visible (true/false)
	local ret = {
		rem = 0,
		pos = 0,
		qtc = 0,
		qtn = 0,
		vis = false
	}

	if not mt_desc then
		Trace("No multitap descriptor??")
		multitap_error = true
		return ret
	end
	local mt_taps = mt_desc["taps"]
	if not mt_taps then
		Trace("No tap description in multitap??")
		multitap_error = true
		return ret
	end

	if #mt_taps == 0 then
		Trace("An empty multitap is fine I guess")
		return ret
	end		

	if b > mt_taps[#mt_taps] then
		-- Already past the last tap! But don't yell about it. Loudmouth
		return ret
	end

	-- Basic case for when we're earlier than the first tap.
	ret.rem = #mt_taps
	ret.pos = mt_taps[1] - b
	ret.qtc = calc_qtzn(mt_taps[1])
	ret.qtn = calc_qtzn(mt_taps[2])
	ret.vis = (ret.pos < multitap_previsible)
	local el = 1

	for i = 1,#mt_taps do
		-- Any bounce cases happen here.
		if b <= mt_taps[i] then
			break
		end

		el = el * multitap_elasticity

		-- We're assured to have an i+1 element here because
		-- we've already jumped out when b > mt_taps[#mt_taps].
		ret.rem = #mt_taps - i + 1
		ret.pos = parabolator(mt_taps[i+1] - mt_taps[i], b - mt_taps[i], el)
		ret.qtc = calc_qtzn(mt_taps[i])
		ret.qtn = calc_qtzn(mt_taps[i+1])
		ret.vis = true
	end

	return ret
end

local lane_permute = function(pops, l)
	-- Which lane is the desired arrow in?
	-- Account for Left, Right, and Mirror.
	-- Otherwise I honestly don't give heck. You are on your lonesome binch. Tohoku Evolved up in this jawn
	local lanes = {1, 2, 3, 4}

	if pops:Mirror() 	then lanes = {lanes[4], lanes[3], lanes[2], lanes[1]} end
	if pops:Left()		then lanes = {lanes[2], lanes[4], lanes[1], lanes[3]} end
	if pops:Right() 	then lanes = {lanes[3], lanes[1], lanes[4], lanes[2]} end

	return lanes[l]
end
local lane_rotation = {90, 0, 180, 270}

local calc_xmod = function(pops, BPS)
	-- Convert approach distance into (approximate) beats by using the scroll speed.
	-- Any boost-style mods will heckify this up
	local xmod 	= pops:XMod()
	local mmod 	= pops:MMod()
	local cmod	= pops:CMod()
	if mmod then
		return mmod / (BPS * 60)
	end
	if xmod then
		return xmod
	end
	if cmod then
		return cmod / (BPS * 60)
	end
end

local multitap_update_function = function()
	local status, errmsg = pcall( function() -- begin pcall()
		-- TODO: rewrite this ~shyttt~

		for idx,act in pairs(tehe_notes) do
			local ps 	= GAMESTATE:GetPlayerState('PlayerNumber_P'..idx)
			local pp 	= SCREENMAN:GetTopScreen():GetChild('PlayerP'..idx)
			local pops 	= ps:GetPlayerOptions("ModsLevel_Song")

			local sp 	= ps:GetSongPosition()
			local beat 	= sp:GetSongBeat()
			local BPS 	= sp:GetCurBPS()
			local mrate	= GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
			local scl_m = 1.0 - 0.5*pops:Mini()		-- Scaling of notes due to application of Mini
			local lperm = lane_permute(pops, 3)		-- Where does the "up arrow" land?

			local scl_w = 1.0
			-- local scl_w = ArrowEffects.GetZoom(ps, y_off, 3)
			-- why is the order of parameters different!!
			-- (currently don't care because no application of Tiny to account for)

			local scroll_speed = calc_xmod(pops, BPS)
			local tehe_distance = tehe_distance_px / (scroll_speed * mrate * 64 * scl_m)
			--Trace("$$$ P"..idx.."'s scroll_speed = "..scroll_speed)

			if (beat >= tehe_beat_start and beat < tehe_beat_cross) then
				-- Parabolic approach phase:
				--		Swing up to and past the receptors before making contact
				--		Start with high rotation and un-rotate as it goes 
				--		Fade in really quickly
				local tw 		= (beat - tehe_beat_start) / (tehe_beat_cross - tehe_beat_start)
				local fake_beat = offset_parabola(tw, tehe_past_receptor) * tehe_distance + tehe_beat_start
				local y_off = ArrowEffects.GetYOffset(ps, lperm, fake_beat) - ArrowEffects.GetYOffset(ps, lperm, tehe_beat_start)
				local pos_x = ArrowEffects.GetXPos(ps, lperm, y_off) * scl_w * scl_m + pp:GetX()
				local pos_y = ArrowEffects.GetYPos(ps, lperm, y_off) * scl_w * scl_m + pp:GetY()
				local pos_z = ArrowEffects.GetZPos(ps, lperm, y_off) * scl_w * scl_m + pp:GetZ()
				local rot_w = 360 * tehe_rotations * (1 - tw)*(1 - tw)

				--Trace("!!! approach "..idx.." @ "..fake_beat.." -> "..y_off.." ("..pos_x..", "..pos_y..", "..pos_z..") x "..scl_m)

				act:visible(true)
				act:diffusealpha(1 - math.pow(1 - tw, 6.0))
				act:xy(pos_x, pos_y)
				act:z(pos_z)
				act:baserotationz(lane_rotation[lperm])
				act:rotationx(rot_w * 0.7)
				act:rotationy(rot_w * 0.8)
				act:rotationz(rot_w)
				act:zoom(scl_w * scl_m)
			elseif (beat >= tehe_beat_cross and beat < tehe_beat_end) then
				-- Linear fadeout phase:
				--		Leave the receptor in reverse with the same speed as the end of the parabola
				--		Don't rotate
				--		Fade out slowly
				local tw 		= (beat - tehe_beat_cross) / (tehe_beat_cross - tehe_beat_start)
				local tw_alpha 	= (beat - tehe_beat_cross) / (tehe_beat_end - tehe_beat_cross)
				local fake_beat = offset_parabola_outline(tw, tehe_past_receptor) * tehe_distance + tehe_beat_cross
				local y_off = ArrowEffects.GetYOffset(ps, lperm, fake_beat) - ArrowEffects.GetYOffset(ps, lperm, tehe_beat_cross)
				local pos_x = ArrowEffects.GetXPos(ps, lperm, y_off) * scl_w * scl_m + pp:GetX()
				local pos_y = ArrowEffects.GetYPos(ps, lperm, y_off) * scl_w * scl_m + pp:GetY()
				local pos_z = ArrowEffects.GetZPos(ps, lperm, y_off) * scl_w * scl_m + pp:GetZ()

				--Trace("!!! reproach "..idx.." @ "..fake_beat.." -> "..y_off.." ("..pos_x..", "..pos_y..", "..pos_z..") x "..scl_m)

				act:visible(true)
				act:diffusealpha(1-tw_alpha*tw_alpha)
				act:xy(pos_x, pos_y)
				act:z(pos_z)
				act:baserotationz(lane_rotation[lperm])
				act:rotationx(0)
				act:rotationy(0)
				act:rotationz(0)
				act:zoom(scl_w * scl_m)
			else
				--Trace ("!!! haha bye")
				act:visible(false)
			end
		end
	end -- end pcall()
	)
	if status then
		--Trace('### YAY TELP DID NOT MAKE A FUCKY WUCKY')
	else
		if not multitap_error then
			Trace('### OOPS TELP HAS MADE A FUCKO BOINGO (in update function)')
			Trace('### '..errmsg)
		end
	end
end



for _,pe in pairs(GAMESTATE:GetEnabledPlayers()) do
	local pn = tonumber(string.match(pe, "[0-9]+"));
	
	local pops = GAMESTATE:GetPlayerState(pe):GetPlayerOptions("ModsLevel_Song");
	local noteskinName = pops:NoteSkin();
	
	for mti = 1,#multi_taps do
		multitap_parent[#multitap_parent+1] = NOTESKIN:LoadActorForNoteSkin("Down", "Tap Note", noteskinName)..{
			Name="TeheP"..pn,
			InitCommand=function(self)
			end,
			OnCommand=function(self)
				local i = tonumber(string.match(self:GetName(), "([0-9]+)"))

				-- Only create a tehe if the player is on SH or SX.
				local diff = GAMESTATE:GetCurrentSteps(i-1):GetDifficulty()
				local stype = GAMESTATE:GetCurrentSteps(i-1):GetStepsType()
				if stype == 'StepsType_Dance_Single' and (diff == 'Difficulty_Challenge' or diff == 'Difficulty_Hard') then
					multitap_actors[pn][i] = self
				else
					self:visible(false)
				end
			end,
		}
	end
end

multitap_parent[#multitap_parent+1] = Def.ActorFrame {
	Name="Update",
	InitCommand=function(self)	
		Trace("### im alive")
		self:SetUpdateFunction(multitap_update_function)
	end,

	Def.ActorFrame {
		InitCommand = function(self)
			self:sleep(69420)
		end
	}
}

return multitap_parent
