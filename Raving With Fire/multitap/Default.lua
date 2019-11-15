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
-- TODO: move this to its own (ideally autogenerateable) file!
--
--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--
local multitaps = {
	Hard = {
		{lane = 1, taps = {
			  12.500,
			  13.500,
			  14.500,
		}},
		{lane = 1, taps = {
			  16.500,
			  17.500,
			  18.500,
		}},
		{lane = 0, taps = {
			  20.000,
			  21.000,
			  22.000,
			  23.000,
		}},
		{lane = 2, taps = {
			  20.500,
			  21.500,
			  22.500,
		}},
		{lane = 1, taps = {
			  24.500,
			  25.500,
			  26.500,
		}},
		{lane = 2, taps = {
			  25.000,
			  27.000,
		}},
		{lane = 3, taps = {
			  24.000,
			  26.000,
		}},
		{lane = 0, taps = {
			  28.000,
			  28.750,
			  29.500,
		}},
		{lane = 3, taps = {
			  30.000,
			  30.750,
			  31.500,
		}},
		{lane = 0, taps = {
			  32.750,
			  33.500,
		}},
		{lane = 2, taps = {
			  32.500,
			  33.250,
		}},
		{lane = 2, taps = {
			  34.500,
			  35.250,
		}},
		{lane = 3, taps = {
			  34.750,
			  35.500,
		}},
		{lane = 0, taps = {
			  36.000,
			  38.000,
		}},
		{lane = 1, taps = {
			  37.000,
			  38.000,
		}},
		{lane = 3, taps = {
			  39.000,
			  40.500,
		}},
		{lane = 0, taps = {
			  39.500,
			  42.000,
		}},
		{lane = 2, taps = {
			  41.000,
			  42.000,
		}},
		{lane = 0, taps = {
			  43.000,
			  46.000,
		}},
		{lane = 2, taps = {
			  44.500,
			  46.000,
		}},
		{lane = 3, taps = {
			  43.500,
			  45.000,
		}},
		{lane = 0, taps = {
			  48.250,
			  48.750,
		}},
		{lane = 1, taps = {
			  47.250,
			  47.750,
			  50.000,
		}},
		{lane = 2, taps = {
			  49.250,
			  49.750,
		}},
		{lane = 3, taps = {
			  47.000,
			  47.500,
			  48.000,
			  48.500,
			  49.000,
			  49.500,
		}},
		{lane = 0, taps = {
			  51.000,
			  51.500,
			  52.000,
		}},
		{lane = 1, taps = {
			  54.000,
			  58.500,
		}},
		{lane = 2, taps = {
			  56.000,
			  59.500,
		}},
		{lane = 3, taps = {
			  53.000,
			  55.000,
			  57.000,
		}},
		{lane = 0, taps = {
			  58.000,
			  59.000,
			  60.000,
		}},
		{lane = 1, taps = {
			  62.500,
			  64.000,
		}},
		{lane = 2, taps = {
			  62.000,
			  63.500,
		}},
		{lane = 0, taps = {
			  65.000,
			  65.500,
		}},
		{lane = 1, taps = {
			  65.250,
			  65.750,
		}},
		{lane = 2, taps = {
			  66.000,
			  67.500,
		}},
		{lane = 1, taps = {
			  66.750,
			  67.250,
		}},
		{lane = 3, taps = {
			  66.500,
			  67.000,
		}},
	},
}

--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--
--
-- Multitap generation code begins here
--
--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--

local BPS = GAMESTATE:GetSongBPS()

local multitap_parent = Def.ActorFrame {
	OnCommand = function(self)
		self:sleep(1000);
	end
};

local multitap_error = false
local multitap_previsible = 8
local multitap_elasticity = 1
local multitap_squishy = 0.3
local multitap_splines_calc = false

local multitap_max = 0
for _,mt_list in pairs(multitaps) do
	if multitap_max < #mt_list then
		multitap_max = #mt_list
	end
end

-- Initialize the multitap actor list.
-- 
-- 	Player number (1 or 2)
--		Multitap index
--			{frame, arrow, count}
local multitap_actors = {
	{},
	{}
}
for pn = 1,2 do
	for i = 1,multitap_max do
		multitap_actors[pn][i] = {}
	end
end
local multitap_chart_sel = {
	"Hard",
	"Hard"
}

local noteskin_names = {
	"shadow",
	"shadow"
}


local qtzn_lookup = {}
for _,qtzn in ipairs({48, 24, 16, 12, 8, 6, 4, 3, 2, 1}) do
	for i = 0,48,(48/qtzn) do
		qtzn_lookup[i] = qtzn
	end
end

local qtzn_tex = {}
qtzn_tex[ 0] = 0
qtzn_tex[ 1] = 0
qtzn_tex[ 2] = 1
qtzn_tex[ 3] = 2
qtzn_tex[ 4] = 3
qtzn_tex[ 6] = 4
qtzn_tex[ 8] = 5
qtzn_tex[12] = 6
qtzn_tex[16] = 7
qtzn_tex[24] = 7
qtzn_tex[48] = 7


-- I don't think it's reasonable within the UPS5 submission timeframe to
-- dynamically pull/calculate the actual *color* of each quantization for
-- an arbitrary noteskin, so I'm precalculating some options based on the
-- Cabby noteskin pack.
local qtzn_color_tables = {
	default = {					-- whole texture I'm fucking busy only get few color
		{"ffffff", "cccccc"},	-- 4ths
		{"ffffff", "cccccc"},	-- 8ths
		{"ffffff", "cccccc"},	-- 12ths
		{"ffffff", "cccccc"},	-- 16ths
		{"ffffff", "cccccc"},	-- 24ths
		{"ffffff", "cccccc"},	-- 32nds
		{"ffffff", "cccccc"},	-- 64ths
		{"ffffff", "cccccc"},	-- 192nds
	},
	shadow = {					-- best colorblindness acuity in the noteskins sharing the ITG palette
		{"ff6100", "ff0000"},	-- 4ths
		{"00a2ff", "00f0ff"},	-- 8ths
		{"fa81d1", "7a15fe"},	-- 12ths
		{"e2f90f", "09a357"},	-- 16ths
		{"fa81d1", "7a15fe"},	-- 24ths
		{"f1db03", "e67b02"},	-- 32nds
		{"33fc7b", "04b8b6"},	-- 64ths
		{"33fc7b", "04b8b6"},	-- 192nds
	},
	color = {					-- the most like unto the true DDR Note noteskin
		{"ffc5c5", "ff0000"},	-- 4ths
		{"0000ff", "c5c5ff"},	-- 8ths
		{"00ff00", "c5ffc5"},	-- 12ths
		{"fff617", "646001"},	-- 16ths
		{"00ff00", "c5ffc5"},	-- 24ths
		{"00ff00", "c5ffc5"},	-- 32nds
		{"00ff00", "c5ffc5"},	-- 64ths
		{"00ff00", "c5ffc5"},	-- 192nds
	},
	note = {					-- this is what the DDR Note noteskin should have been
		{"ff7c7c", "ff2121"},	-- 4ths
		{"7e86f4", "2432ec"},	-- 8ths
		{"be77fb", "9018f8"},	-- 12ths
		{"faff73", "f7ff11"},	-- 16ths
		{"f383bf", "eb2c93"},	-- 24ths
		{"ff966d", "ff4d06"},	-- 32nds
		{"90e3ff", "43d0ff"},	-- 64ths
		{"85ff7c", "30ff20"},	-- 192nds
	},
	horseshoe = {				-- I think it's very unprofessional of the official Trot 100 News account to try and cancel an artist.
		{"dfa9db", "a96fba"},	-- 4ths
		{"faba61", "d49234"},	-- 8ths
		{"98d3f1", "2c78b6"},	-- 12ths
		{"fe96b9", "b7366e"},	-- 16ths
		{"b6b3d5", "6947bf"},	-- 24ths
		{"f0e56e", "eae6bf"},	-- 32nds
		{"8b7bff", "503497"},	-- 64ths
		{"ebe6ad", "edb032"},	-- 192nds
	},
}
qtzn_color_tables["cel"]			= qtzn_color_tables["shadow"]
--qtzn_color_tables["color"]
qtzn_color_tables["cyber"]			= qtzn_color_tables["shadow"]
qtzn_color_tables["ddr"]			= qtzn_color_tables["default"]
qtzn_color_tables["enchantment"]	= qtzn_color_tables["shadow"]
qtzn_color_tables["equality"]		= qtzn_color_tables["default"]
qtzn_color_tables["excel"]			= qtzn_color_tables["shadow"]
qtzn_color_tables["horsegroove"]	= qtzn_color_tables["shadow"]
qtzn_color_tables["horsenote"]		= qtzn_color_tables["note"]
--qtzn_color_tables["horseshoe"]
qtzn_color_tables["metal"]			= qtzn_color_tables["shadow"]
--qtzn_color_tables["note"]
qtzn_color_tables["onlyonecouples"]	= qtzn_color_tables["shadow"]
qtzn_color_tables["rainbow"]		= qtzn_color_tables["shadow"]
qtzn_color_tables["robot"]			= qtzn_color_tables["default"]
--qtzn_color_tables["shadow"]
qtzn_color_tables["solo"]			= qtzn_color_tables["shadow"]
qtzn_color_tables["toonprints"]		= qtzn_color_tables["horseshoe"]
qtzn_color_tables["trax"]			= qtzn_color_tables["note"]
qtzn_color_tables["vel"]			= qtzn_color_tables["shadow"]
qtzn_color_tables["vintage"]		= qtzn_color_tables["shadow"]
qtzn_color_tables["vivid"]			= qtzn_color_tables["default"]

local _BB = function(b)
	return math.floor(b*48 + 0.5)
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

local parabolator_dt = function(b, t, elastic)
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
	return elastic * (b - 2*t) / b
end

local calc_multitap_phase = function(mt_desc, b)
	-- mt_desc = multitap descriptor with the following elements:
	--		lane: which lane the tap is in (unimportant here)
	--		taps: tap beat times included in this multitap
	-- b = current beat
	-- returns a table with the following elements:
	--		rem: # of hits left (the multitap should show a number if it's more than 1)
	--		pos: position in beats before receptors
	--		qtc: quantization of currently approaching note
	--		qtn: quantization of next note in the multitap (used to color the number)
	--		dif: diffuse arrow from 0 (dark) to 1 (full brightness)
	--		vis: currently visible (true/false)
	local ret = {
		rem = 0,
		pos = 0,
		sqh = 0,
		qtc = 0,
		qtn = 0,
		dif = 0,
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
	ret.sqh = 0
	ret.qtc = calc_qtzn(mt_taps[1])
	ret.qtn = calc_qtzn(mt_taps[2])
	ret.dif = 0
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
		ret.rem = #mt_taps - i
		ret.pos = parabolator(mt_taps[i+1] - mt_taps[i], b - mt_taps[i], el)
		ret.sqh = multitap_squishy*(math.abs(parabolator_dt(mt_taps[i+1] - mt_taps[i], b - mt_taps[i], el)) - 0.5)
		ret.qtc = calc_qtzn(mt_taps[i+1])
		ret.qtn = calc_qtzn(mt_taps[i+2])
		ret.dif = i / (#mt_taps-1)
		ret.vis = true
	end

	return ret
end


local calc_zoom_splines = function(mt_table, pp)
	-- Calculate length of spline needed.
	local splSize = {}
	for mti,mt_desc in ipairs(mt_table) do
		if not splSize[mt_desc.lane + 1] then
			splSize[mt_desc.lane + 1] = 0
		end

		if #mt_desc.taps > 0 then
			if mt_desc.taps[#mt_desc.taps] > splSize[mt_desc.lane + 1] then
				splSize[mt_desc.lane + 1] = mt_desc.taps[#mt_desc.taps]
			end
		end
	end

	-- Convert to 192nds count.
	for i,v in ipairs(splSize) do
		splSize[i] = _BB(v) + 2
	end

	-- Apply the spline points.
	local nf = pp:GetChild('NoteField')
	local ncr_table = nf:GetColumnActors()

	for lane,ncr in ipairs(ncr_table) do
		splHandle = ncr:GetZoomHandler()
		splHandle:SetSplineMode('NoteColumnSplineMode_Offset')
				 :SetSubtractSongBeat(false)
				 :SetReceptorT(0.0)
				 :SetBeatsPerT(1/48)
		local splObject = splHandle:GetSpline()
		splObject:SetSize(splSize[lane])
		for spli = 1,splSize[lane] do
			splObject:SetPoint(spli, {0, 0, 0})
		end
		for mti,mt_desc in ipairs(mt_table) do
			if (mt_desc.lane + 1 == lane) and (#mt_desc.taps > 0) then
				for spli=_BB(mt_desc.taps[1]),_BB(mt_desc.taps[#mt_desc.taps]) do
					splObject:SetPoint(spli+1, {-1, -1, -1})
					--Trace("::: "..lane..".("..spli.." of "..splSize[lane]..") or ("..(spli/48)..")")
				end
			end
		end
		splObject:Solve()
	end
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


local TEST_px_per_beat = SCREEN_HEIGHT * 0.5
local TEST_px_per_lane = 64
local TEST_center_x = SCREEN_WIDTH * 0.75
local TEST_zero_y = 160
local TEST_zoom_count = 1
local TEST_squishy = 0.2

local multitap_update_function = function()
	local status, errmsg = pcall( function() -- begin pcall()
		local beat = GAMESTATE:GetSongBeat()

		for _,pe in pairs(GAMESTATE:GetEnabledPlayers()) do
			local pn = tonumber(string.match(pe, "[0-9]+"))

			local ps 	= GAMESTATE:GetPlayerState('PlayerNumber_P'..pn)
			local pp 	= SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn)
			local pops 	= ps:GetPlayerOptions("ModsLevel_Song")
			local scl_m = 1.0 - 0.5*pops:Mini()		-- Scaling of notes due to application of Mini
													-- TODO: replace with ArrowEffects/spline acquisition?
			scl_m = 1.0

			if not multitap_splines_calc then
				calc_zoom_splines(multitaps[multitap_chart_sel[pn]], pp)
				multitap_splines_calc = true
			end

			local tex_color_interval = {
				x = NOTESKIN:GetMetricFForNoteSkin("", "TapNoteNoteColorTextureCoordSpacingX", noteskin_names[pn]),
				y = NOTESKIN:GetMetricFForNoteSkin("", "TapNoteNoteColorTextureCoordSpacingY", noteskin_names[pn]),
			}
			local tex_color_is_rhythm = NOTESKIN:GetMetricBForNoteSkin("", "TapNoteAnimationIsVivid", noteskin_names[pn])
			if multitap_chart_sel[pn] then
				for mti,mt_desc in ipairs(multitaps[multitap_chart_sel[pn]]) do
					mt_stats = calc_multitap_phase(mt_desc, beat)

					if mt_stats.vis then
						local lperm = lane_permute(pops, mt_desc.lane+1)		-- Where does this arrow actually land?

						local y_off = ArrowEffects.GetYOffset(ps, lperm, beat + mt_stats.pos) - ArrowEffects.GetYOffset(ps, lperm, beat)
						local pos_x = ArrowEffects.GetXPos(ps, lperm, y_off) * scl_m + pp:GetX() + pp:GetChild("NoteField"):GetX()
						local pos_y = ArrowEffects.GetYPos(ps, lperm, y_off) * scl_m + pp:GetY() + pp:GetChild("NoteField"):GetY()
						local pos_z = ArrowEffects.GetZPos(ps, lperm, y_off) * scl_m + pp:GetZ() + pp:GetChild("NoteField"):GetZ()

						--Trace("??? "..pp:GetChild("NoteField"):GetY())
						--Trace("!!! reproach "..pn..", "..mti.." @ "..beat.." + "..mt_stats.pos.." -> "..y_off.." ("..pos_x..", "..pos_y..", "..pos_z..") x "..scl_m)

						multitap_actors[pn][mti]["frame"]:visible(true)
														 :xy(pos_x, pos_y)
														 :z(pos_z)
														 :zoomy(1 + mt_stats.sqh)
						--								 :xy(TEST_px_per_lane * (mt_desc.lane - 2.5) + TEST_center_x,
						--								 	 TEST_px_per_beat * mt_stats.pos + TEST_zero_y)
						multitap_actors[pn][mti]["arrow"]:baserotationz(lane_rotation[lperm])
														 :diffuse(lerp_color(mt_stats.dif, color("#666666"), color("#ffffff")))
														 :texturetranslate(
							tex_color_interval["x"] * qtzn_tex[mt_stats.qtc],
							tex_color_interval["y"] * qtzn_tex[mt_stats.qtc]
							)

						if mt_stats.rem > 1 then
							local noteskin_name = string.lower(noteskin_names[pn])
							local color_pair = qtzn_color_tables["default"][1]
							if qtzn_color_tables[noteskin_name] and not tex_color_is_rhythm then
								color_pair = qtzn_color_tables[noteskin_name][mt_stats.qtn]
							end
							multitap_actors[pn][mti]["count"]:visible(true)
															 :settext(mt_stats.rem)
															 :zoom(TEST_zoom_count)
															 :diffuseramp()
															 :effectclock("beat")
															 :effectcolor1(color("#"..color_pair[1]))
															 :effectcolor2(color("#"..color_pair[2]))
						else
							multitap_actors[pn][mti]["count"]:visible(false)
						end
					else
						multitap_actors[pn][mti]["frame"]:visible(false)
					end
				end
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
	local pn = tonumber(string.match(pe, "[0-9]+"))

	local pops = GAMESTATE:GetPlayerState(pe):GetPlayerOptions("ModsLevel_Song")
	local noteskin_name = pops:NoteSkin()
	noteskin_names[pn] = noteskin_name
	
	for mti = 1,multitap_max do
		multitap_parent[#multitap_parent+1] = Def.ActorFrame {
			Name="MultitapP"..pn.."_"..mti,
			InitCommand=function(self)
			end,
			OnCommand=function(self)
				local i = mti

				multitap_actors[pn][i]["frame"] = self
				self:visible(false)

				--Trace("=== Added multitap actor frame for P"..pn..", index "..i)
			end,
			NOTESKIN:LoadActorForNoteSkin("Down", "Tap Note", noteskin_name)..{
				Name="MultitapArrowP"..pn.."_"..mti,
				InitCommand=function(self)
				end,
				OnCommand=function(self)
					local i = mti

					multitap_actors[pn][i]["arrow"] = self
					self:visible(true)
					--Trace("=== Added multitap actor arrow for P"..pn..", index "..i)
				end,
			},
			Def.BitmapText {
				Name="MultitapTextP"..pn.."_"..mti,
				Font="_komika axis 36px.ini",
				Text="",
				InitCommand=function(self)
				end,
				OnCommand=function(self)
					local i = mti

					multitap_actors[pn][i]["count"] = self
					self:visible(false)
						:z(10.0)
						:strokecolor(color("#000000"))
					--Trace("=== Added multitap actor count for P"..pn..", index "..i)
				end,
			},
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


--[[

--
-- Backup
--


					-- Only create a tehe if the player is on SH or SX.
					-- local diff = GAMESTATE:GetCurrentSteps(i-1):GetDifficulty()
					-- local stype = GAMESTATE:GetCurrentSteps(i-1):GetStepsType()
					-- if stype == 'StepsType_Dance_Single' and (diff == 'Difficulty_Challenge' or diff == 'Difficulty_Hard') then



local tehe_update_function = function()
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


]]--