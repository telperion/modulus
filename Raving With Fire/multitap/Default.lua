-------------------------------------------------------------------------------
--
--		Multitap Factory & Assistance
--		
--		Author: 	Telperion
--		Date: 		2019-11-03
--		Version:	1.0
--
-------------------------------------------------------------------------------

--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--
--
-- Generate the below file by using Telperion's Python chart utilities.
-- MultitapsWorkflow(r'C:\path\to\simfile.sm')
--
-- Version matching performed here.
--
--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--
multitaps = {}
multitap_version = {1, 0}

local whereTheFlipAmI = GAMESTATE:GetCurrentSong():GetSongDir()
dofile(whereTheFlipAmI .. "multitap/multitap_data.lua")

local version_mismatch = function(mv_data, mv_parser)
	SCREENMAN:SystemMessage("### Multitap version mismatch: data @ "..mv_data[1].."."..mv_data[2]..", parser @ "..mv_parser[1].."."..mv_parser[2])
end
local version_record = function(mv_data, mv_parser)
	Trace("### Multitap versions: data @ "..mv_data[1].."."..mv_data[2]..", parser @ "..mv_parser[1].."."..mv_parser[2])
end

if multitaps["_version"] then
	version_record(multitaps["_version"], multitap_version)
	if multitaps["_version"][1] > multitap_version[1] then
		version_mismatch(multitaps["_version"], multitap_version)
		return Def.ActorFrame{}
	end
	if (multitaps["_version"][1] == multitap_version[1]) and 
		(multitaps["_version"][2] > multitap_version[2]) then
		version_mismatch(multitaps["_version"], multitap_version)
		return Def.ActorFrame{}
	end
else
	SCREENMAN:SystemMessage("### Found unversioned multitap data")
end

--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--
--
-- Some helper functions I haven't isolated yet
--
--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--[[##]]--

function TryCommandOnLeaves(act, command_name, command_params, verbose, d, fake_name)
	-- I ended up not needing this but I'm gonna leave it here anyway
	-- this was An Adventure

	if not act then
		print("::: ??? null ???")												-- Am I Pregant?
		return																	-- Am I pragnent?
	end	

	d = d and d or 0															-- Am I pargant?
	fake_name = fake_name and fake_name or "<N/A>"								-- Am i gregnant?
	
	local indent = string.rep("\t", d)											-- Am i pegnate?? Help!?
	
	local n_format = (act["GetName"] and act:GetName() or "")					-- Is there a possibly that i'm pegrent?
		  n_format = (n_format ~= "") and n_format or fake_name					-- Am I pregegnant or am I okay?
	
	local n_kids = 0															-- Could I be pregonate?
	local s, r = pcall(function() return act:GetNumChildren() end);				-- How do I know if I'M prengan?
	if s then n_kids = r end													-- Can i be prregnant????
	
	local n_items = 0															-- Can u get pregante...?
	for k,m in pairs(act) do
		n_items = n_items + 1													-- Can u blink while u are pergert?
	end

	if verbose then 
		Trace(	":#: "..indent..n_format..": "..								-- Can u down a 20 beat waterspline pegnat?
				n_kids.." children, "..											-- How can i get my notefield pragnet?
				n_items.." standard members"									-- What happen when get pergenat?
		)
	end

	-- Actual kids, with actual actor properties.
	if n_kids > 0 then
		local kids = act:GetChildren()											-- How can a ninefoot chart get prangnet?
		local i = 0																-- Will my get pragnan?
		for k,m in pairs(kids) do
			i = i + 1															-- What is the best time to step to be come pregnart
			TryCommandOnLeaves(m, command_name, command_params,					-- Does any one know how many tweens get bregant a year????
				verbose, d+1, n_format.."->"..i)								-- Are these systoms of being pregarnt?
		end
	end

	-- Imagine giving birth to a bunch of tables?? that's lua I guess
	for k,m in pairs(act) do
		if type(m) == "table" then
			local n_m = 0; for _ in pairs(m) do n_m = n_m + 1 end				-- Notefield aint had effectperiod since she got pregat?
			if verbose then 
				Trace(	"::: "..indent.."\t"..n_format.."."..k..				-- Is it possible having step to a 8 miss fregnant?
						": table with "..n_m.." elements"						-- If an actors has starch masks on her texture does that mean she has been pargnet before.?
				)
			end
			TryCommandOnLeaves(m, command_name, command_params,					-- My circle is nomal,but yet i still dont get peegnant.wat can i use.?
				verbose, d+1, n_format.."."..k)									-- Has anybody got pergnut by just preset while using BothAtOnce control?
		else
			if verbose then
				Trace(	"::: "..indent.."\t"..n_format.."."..k..				-- Did most you actors FEEL pgrenant before find out?
						": "..m..", of type "..type(m))							-- I am pragananat last 5 wayoff so can i start step?
			end
		end
	end

	-- Dare ka ga fucking hear me dekimasu ka?
	if act[command_name.."Command"] then
		--if verbose then
			Trace("#:# Attempting "..command_name.."Command on "..n_format)		-- Dangerops prangent step? will it hurt arrow top of his head?
		--end
		if command_params then
			pcall(function()													-- Me and my notefield are tying to get prefnat and j havent took my BothAtOnce control in 12 plays?
				act:playcommand(command_name, unpack(command_params))			-- 38 + 2 wayoffs pregananant?
			end)																-- I think my down is pregernet???
		else
			pcall(function()													-- How long can u go being prognant to get an FailImmediately?
				act:playcommand(command_name)									-- Can i get prengt if he had a condor on?
			end)																-- I think I'm pretnet with my 14th table?
		end
	end
end

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
local multitap_basebounce = 1.5
local multitap_elasticity = 1.1
local multitap_squishy = 0.3
local multitap_splines_calc = {false, false}

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
local multitap_explosions = {
	{},
	{}
}
local multitap_fields = {}

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
qtzn_color_tables["rainbow"]		= qtzn_color_tables["default"]
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
	local el = (mt_desc["peak"] and mt_taps[2]) and (mt_desc["peak"] / (mt_taps[2] - mt_taps[1])) or multitap_basebounce

	for i = 1,#mt_taps do
		-- Any bounce cases happen here.
		if b <= mt_taps[i] then
			break
		end

		el = mt_desc["peak"] and (mt_desc["peak"] / (mt_taps[i+1] - mt_taps[i])) or (el * multitap_elasticity)

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

for i=1,2 do
	local pn = i
	_G["multitap_note_callback_P"..i] = function(lane, tns, is_bright)
		if multitap_explosions[pn][lane] then
			--Trace("??? do explosion pls")
			multitap_explosions[pn][lane]:propagatecommand("Judgment")
			multitap_explosions[pn][lane]:propagatecommand("Dim")
			multitap_explosions[pn][lane]:propagatecommand(string.sub(tns, 14))
			--TryCommandOnLeaves(multitap_explosions[pn][lane], string.sub(tns, 14), nil, true)
		end
	end
end

local calc_zoom_splines = function(mt_table, pn)
	-- Calculate length of spline needed.
	local splSize = {}
	for mti,mt_desc in ipairs(mt_table) do
		if not splSize[mt_desc.lane] then
			splSize[mt_desc.lane] = 0
		end

		if #mt_desc.taps > 0 then
			if mt_desc.taps[#mt_desc.taps] > splSize[mt_desc.lane] then
				splSize[mt_desc.lane] = mt_desc.taps[#mt_desc.taps]
			end
		end
	end

	-- Convert to 192nds count.
	for i,v in ipairs(splSize) do
		splSize[i] = _BB(v) + 2
	end

	-- Apply the spline points.
	local pp = SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn)
	local nf = pp:GetChild('NoteField')
	local ncr_table = nf:GetColumnActors()

	-- Apply the false explosion callback.
	nf:SetDidTapNoteCallback(_G["multitap_note_callback_P"..pn])

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
			if (mt_desc.lane == lane) and (#mt_desc.taps > 0) then
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

local copy_transforms = function(dst, src)
	dst:x(src:GetX())
	   :y(src:GetY())
	   :z(src:GetZ())
	   :rotationx(src:GetRotationX())
	   :rotationy(src:GetRotationY())
	   :rotationz(src:GetRotationZ())
--	   :zoom(src:GetZoom())
	   :zoomx(src:GetZoomX())
	   :zoomy(src:GetZoomY())
	   :zoomz(src:GetZoomZ())
end

-- Why is this so inaccessibly hard!!
local GRAY_ARROWS_Y_STANDARD 		= THEME:GetMetric("Player", "ReceptorArrowsYStandard")
local GRAY_ARROWS_Y_REVERSE  		= THEME:GetMetric("Player", "ReceptorArrowsYReverse")
local CENTER_Y_FOR_DILLWEEDS_ONLY	= (GRAY_ARROWS_Y_STANDARD + GRAY_ARROWS_Y_REVERSE) / 2
Trace("### "..CENTER_Y_FOR_DILLWEEDS_ONLY.."x engineers can "..
	  "convert 'thought' into 'piss' in their balls, and issue it in an iterative fashion.")

local __SCALE = function(x, l1, h1, l2, h2)
	return (h2 - l2) * (x - l1) / (h1 - l1) + l2
end

--[[
	PlayerNoteFieldPositioner()
	PushPlayerMatrix()
	LoadMenuPerspective(
		fovDegrees=45,
		fWidth=SCREEN_WIDTH,
		fHeight=SCREEN_HEIGHT,
		fVanishPointX=SCALE(skew, 0.1f, 1.0f, x, SCREEN_CENTER_X),
		fVanishPointY=center_y
	)
]]--


local copy_transforms_player = function(dst, pp, skew, tilt, reverse)
	skew = skew or 0.0
	tilt = tilt or 0.0
	reverse = reverse or false

	local fov_in = 45
	local vpx_in = __SCALE(skew, 0.1, 1.0, pp:GetX(), SCREEN_CENTER_X)
	local vpy_in = pp:GetY() + CENTER_Y_FOR_DILLWEEDS_ONLY --__SCALE(tilt, 0.1, 1.0, 10, 60)
	--Trace("### ... "..vpx_in..", "..vpy_in)

	local reverse_mult = (reverse and -1 or 1)
	local tilt_degrees = __SCALE(tilt, -1, 1, 30, -30) * reverse_mult
	local zoom_for_dipsticks_only = 0
	local yoff_for_dumbdumbs_only = 0
	if (tilt > 0) then
		zoom_for_dipsticks_only = __SCALE(tilt, 0, 1, 1, 0.9)
		yoff_for_dumbdumbs_only = __SCALE(tilt, 0, 1, 0, -45) * reverse_mult
	else
		zoom_for_dipsticks_only = __SCALE(tilt, 0, -1, 1, 0.9)
		yoff_for_dumbdumbs_only = __SCALE(tilt, 0, -1, 0, -20) * reverse_mult
	end

	dst:GetParent():x(pp:GetX())
				   :y(pp:GetY())
				   :z(pp:GetZ())

	-- FOV here stands for "fuck off, venerated_stepmania_developers"
	-- TODO: account for the skewing perspective mods (Incoming & Space)
	   :fov(fov_in)
	   :vanishpoint(vpx_in, vpy_in)
--	dst:fov(fov_in)
--	   :vanishpoint(vpx_in, vpy_in)

    nf = pp:GetChild("NoteField")
	dst:x(nf:GetX())
	   :y(nf:GetY() + yoff_for_dumbdumbs_only)
	   :z(nf:GetZ())
	   :rotationx(nf:GetRotationX())
	   :rotationy(nf:GetRotationY())
	   :rotationz(nf:GetRotationZ())
	   :zoomx(nf:GetZoomX() * zoom_for_dipsticks_only)
	   :zoomy(nf:GetZoomY() * zoom_for_dipsticks_only)
	   :zoomz(nf:GetZoomZ() * zoom_for_dipsticks_only)
end

local copy_transforms_arrow = function(dst, arrow_only, ps, lane, beat, pos, apply_extra)
	-- Additional translation and rotation are added.
	-- Additional zoom is multiplied.
	-- It's Only Natural

	apply_extra = apply_extra and apply_extra or {}

	local y_off = ArrowEffects.GetYOffset(ps, lane, beat + pos) - ArrowEffects.GetYOffset(ps, lane, beat)

	if arrow_only then
		dst:rotationx(ArrowEffects.GetRotationX(ps, y_off, 0, lane) 		+ (apply_extra["rotationx"] and apply_extra["rotationx"] or 0) - 180/math.pi)	-- ??????
		   :rotationy(ArrowEffects.GetRotationY(ps, y_off, lane) 			+ (apply_extra["rotationy"] and apply_extra["rotationy"] or 0))
		   :rotationz(ArrowEffects.GetRotationZ(ps, beat+pos, false, lane) 	+ (apply_extra["rotationz"] and apply_extra["rotationz"] or 0))
--		   :glow(color(1, 1, 1, ArrowEffects.GetGlow(ps, lane, y_off)))		-- TODO: Seems to be always 1? that's weird. I'll fix this when it's actually important
	else
		dst:x(ArrowEffects.GetXPos(ps, lane, y_off)			+ (apply_extra["x"] and apply_extra["x"] or 0))
		   :y(ArrowEffects.GetYPos(ps, lane, y_off) 		+ (apply_extra["y"] and apply_extra["y"] or 0))
		   :z(ArrowEffects.GetZPos(ps, lane, y_off)		    + (apply_extra["z"] and apply_extra["z"] or 0))
		   :zoomx(ArrowEffects.GetZoom(ps, y_off, lane) 	* (apply_extra["zoomx"] and apply_extra["zoomx"] or 1))
		   :zoomy(ArrowEffects.GetZoom(ps, y_off, lane) 	* (apply_extra["zoomy"] and apply_extra["zoomy"] or 1))
		   :zoomz(ArrowEffects.GetZoom(ps, y_off, lane)		* (apply_extra["zoomz"] and apply_extra["zoomz"] or 1))
		   :diffusealpha(ArrowEffects.GetAlpha(ps, lane, y_off))
		   
	end
end


local TEST_px_per_beat = SCREEN_HEIGHT * 0.5
local TEST_px_per_lane = 64
local TEST_center_x = SCREEN_WIDTH * 0.75
local TEST_zero_y = 160
local TEST_zoom_count = 1
local TEST_squishy = 0.2

local TEST_last_beat = 4

local multitap_update_function = function()
	local status = 1
--	local status, errmsg = pcall( function() -- begin pcall()
		local beat = GAMESTATE:GetSongBeat()

		for _,pe in pairs(GAMESTATE:GetEnabledPlayers()) do
			local pn = tonumber(string.match(pe, "[0-9]+"))

			local ps 	= GAMESTATE:GetPlayerState('PlayerNumber_P'..pn)
			local pp 	= SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn)
			local pops 	= ps:GetPlayerOptions("ModsLevel_Song")
			local scl_m = 1.0 - 0.5*pops:Mini()		-- Scaling of notes due to application of Mini
													-- TODO: replace with ArrowEffects/spline acquisition?

			-- TESTING ONLY 
			-- pops:Tilt(1.5*math.sin(beat*math.pi/8.0)*(pn==2 and 1 or -1), 1000.0)
			-- pops:Skew(1.5*math.cos(beat*math.pi/8.0)*(pn==2 and 1 or -1), 1000.0)
			-- pops:Roll((pn==2 and 1 or -1), 1000.0)

			-- This is a convenient enough spot to do just-in-time one-time initialization lol
			if not multitap_splines_calc[pn] then
				full_chart_name = GAMESTATE:GetCurrentSteps(pn-1):GetDifficulty()
				multitap_chart_sel[pn] = string.sub(full_chart_name, 12)

				calc_zoom_splines(multitaps[multitap_chart_sel[pn]], pn)
				multitap_splines_calc[pn] = true
			end

			-- Adjust the multitap fields with the same transforms the players themselves get.
			-- See Player::PlayerNoteFieldPositioner::PlayerNoteFieldPositioner().
			copy_transforms_player(
				multitap_fields[pn], 
				pp, 
				pops:Skew(), 
				pops:Tilt(), 
				pops:GetReversePercentForColumn(0) > 0.5		-- ...sure, whatecer
			)

			-- Read the texture coordinate shift that changes quantization in the noteskin.
			-- Some noteskins are implemented as vertical shifts and some horizontal.
			local tex_color_interval = {
				x = NOTESKIN:GetMetricFForNoteSkin("", "TapNoteNoteColorTextureCoordSpacingX", noteskin_names[pn]),
				y = NOTESKIN:GetMetricFForNoteSkin("", "TapNoteNoteColorTextureCoordSpacingY", noteskin_names[pn]),
			}
			local tex_color_is_rhythm = NOTESKIN:GetMetricBForNoteSkin("", "TapNoteAnimationIsVivid", noteskin_names[pn])
			if multitap_chart_sel[pn] then
				local show_false_explosion = {false, false, false, false}

				for mti,mt_desc in ipairs(multitaps[multitap_chart_sel[pn]]) do
					mt_stats = calc_multitap_phase(mt_desc, beat)
					
					local lperm = lane_permute(pops, mt_desc.lane)		-- Where does this arrow actually land?

					if mt_stats.vis then
						--Trace("??? "..pp:GetChild("NoteField"):GetY())
						--Trace("!!! reproach "..pn..", "..mti.." @ "..beat.." + "..mt_stats.pos.." -> "..y_off.." ("..pos_x..", "..pos_y..", "..pos_z..") x "..scl_m)

						multitap_actors[pn][mti]["frame"]:visible(true)
						multitap_actors[pn][mti]["arrow"]:baserotationz(lane_rotation[lperm])
														 :diffuse(lerp_color(mt_stats.dif, color("#666666"), color("#ffffff")))
														 :texturetranslate(
							tex_color_interval["x"] * qtzn_tex[mt_stats.qtc],
							tex_color_interval["y"] * qtzn_tex[mt_stats.qtc]
							)

						copy_transforms_arrow(
							multitap_actors[pn][mti]["frame"], false,
							ps,
							lperm,
							beat,
							mt_stats.pos,
							{zoomy = 1 + mt_stats.sqh}
						)
						copy_transforms_arrow(
							multitap_actors[pn][mti]["arrow"], true,
							ps,
							lperm,
							beat,
							mt_stats.pos,
							{}
						)

						-- Be prepared to fire a fake explosion if any multitap in this lane is active.
						show_false_explosion[lperm] = true

						if mt_stats.rem > 1 then
							local noteskin_name = string.lower(noteskin_names[pn])
							local color_pair = qtzn_color_tables["default"][1]
							if qtzn_color_tables[noteskin_name] and not tex_color_is_rhythm then
								color_pair = qtzn_color_tables[noteskin_name][qtzn_tex[mt_stats.qtn]+1]
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

				for lane=1,4 do
					local lperm = lane_permute(pops, lane)		-- Where does this arrow actually land?

					local ex_pos_x = ArrowEffects.GetXPos(ps, lperm, 0) --+ pp:GetChild("NoteField"):GetX()
					local ex_pos_y = ArrowEffects.GetYPos(ps, lperm, 0) --+ pp:GetChild("NoteField"):GetY()
					local ex_pos_z = ArrowEffects.GetZPos(ps, lperm, 0) --+ pp:GetChild("NoteField"):GetZ()

					multitap_explosions[pn][lperm]:xy(ex_pos_x, ex_pos_y)
												  :z(ex_pos_z)
												  :baserotationz(lane_rotation[lperm])
												  :visible(show_false_explosion[lperm])
				end
			end
		end

		TEST_last_beat = beat
--	end -- end pcall()
--	)
	if status then
		--Trace('### YAY TELP DID NOT MAKE A FUCKY WUCKY')
	else
		if not multitap_error then
			Trace('### OOPS TELP HAS MADE A FUCKO BOINGO (in update function)')
			Trace('### '..errmsg)
			Trace('### '..debug.traceback())
		end
	end
end


direction_names = {"Left", "Down", "Up", "Right"}
for _,pe in pairs(GAMESTATE:GetEnabledPlayers()) do
	local pn = tonumber(string.match(pe, "[0-9]+"))

	local pops = GAMESTATE:GetPlayerState(pe):GetPlayerOptions("ModsLevel_Song")
	local noteskin_name = pops:NoteSkin()
	noteskin_names[pn] = noteskin_name

	local multitap_prep = Def.ActorFrame {
		Name="MultitapFrameP"..pn,
		InitCommand = function(self)
		end,
		OnCommand = function(self)
			multitap_fields[pn] = self
		end,

		--[[
		Def.Sprite {
			Texture="britneyflat.png",
			OnCommand=function(self)
				self:diffusealpha(0.5)
					:zoomtowidth(256)
					:zoomtoheight(GRAY_ARROWS_Y_REVERSE - GRAY_ARROWS_Y_STANDARD)
			end,
		},
		]]--
	}

	for lane=1,4 do
		multitap_prep[#multitap_prep+1] = NOTESKIN:LoadActorForNoteSkin("Down", "Explosion", noteskin_name)..{
			Name="MultitapExplosionP"..pn.."_"..lane,
			InitCommand=function(self)
			end,
			OnCommand=function(self)
				multitap_explosions[pn][lane] = self
				self:visible(true)
				--Trace("=== Added multitap actor explosion for P"..pn..", lane "..lane)
			end,
			--W1Command=NOTESKIN:GetMetricAForNoteSkin("GhostArrowBright", "W1Command", noteskin_name),
			--W1Command=cmd(diffuse,1.0,1.0,1.0,1;zoom,1;linear,0.06;zoom,1.1;linear,0.06;diffusealpha,0),
		}
	end
	
	for mti = 1,multitap_max do
		multitap_prep[#multitap_prep+1] = Def.ActorFrame {
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

	multitap_parent[#multitap_parent+1] = Def.ActorFrame{multitap_prep}
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
