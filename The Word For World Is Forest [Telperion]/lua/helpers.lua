-------------------------------------------------------------------------------
--
--		Helper functions for SM5 modifier files
--		
--		Author: 	Telperion
--		Date: 		2018-06-06
--		Target:		SM5.0.12+
--
-------------------------------------------------------------------------------

local PI = math.pi
local LOG2 = math.log(2.0)
local SQRT2 = math.sqrt(2.0)
local DEG_TO_RAD = math.pi / 180.0


-- Lua with that stealth shallow copy. fuck thou and the referential horse thee rode in on
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function ArrayMax(a)
	if #a == 0 then return nil end
	if #a == 1 then return a[1] end
	local m = a[1]
	for _,v in pairs(a) do
		if v > m then m = v end
	end
	return m
end

function ArrayMin(a)
	if #a == 0 then return nil end
	if #a == 1 then return a[1] end
	local m = a[1]
	for _,v in pairs(a) do
		if v < m then m = v end
	end
	return m
end


function SideSign(i) return (i ~= 1) and 1 or -1 end

function RangeScale(t, inLower, inUpper, outLower, outUpper)
	local ti = (t - inLower) / (inUpper - inLower)
	return outLower + ti * (outUpper - outLower)
end

function RangeClamp(t, outLower, outUpper)
	local ti = t
	ti = (ti < outLower) and outLower or ti
	ti = (ti > outUpper) and outUpper or ti
	return ti
end

function Whomst(act)
	return tonumber(string.match(act:GetName(), "P([0-9]+)"))
end

function Whichst(act)
	return tonumber(string.match(act:GetName(), "_([0-9]+)"))
end


function GentleFunction(t, p)
	-- Quintic tweening function for smooth behavior
	-- p = control parameter determining slope in center
	-- p el [  0, 15/8] for monotonic movement
	-- p el [5/4,  3/2] for non-inflective movement
    local tt = 2*t - 1
    local z = (  p - 1.5) * tt^5
    		+ (2.5 - 2*p) * tt^3
    		+ 		   p  * tt
    return 0.5*z + 0.5
end

function CuteFunction(t)
	-- Smoothest way to get from point A to B on a quintic
	-- Specific case of GentleFunction with minimal inflection (p = 5/4)
    local tt = 2*t - 1
    local z = -0.25 * tt^5
    		+  1.25 * tt
    return 0.5*z + 0.5
end

function StrongFunction(t, p)
	-- Cubic tweening function for smooth behavior
	-- p = control parameter determining slope at ends
	-- p el [0, 3] for monotonic movement
    local tt = 2*t - 1
    local z = (p - 2) * tt^3 
    		+ (3 - p) * tt
    return 0.5*z + 0.5
end

function BiasFunction(t, p, q)
	-- Cubic tweening function for smooth behavior with off-center middle
	-- p = control parameter determining slope at middle
	-- q = control parameter determining y-intercept (and interest point)
    local tt = 2*t - 1
    local z = (((1 - p)  * tt
    		+   (0 - q)) * tt
    		+        p ) * tt
    		+        q
    return 0.5*z + 0.5
end


function RGB2HSV(rgbColor)
	-- RGB: [0, 1]
	-- HSV: [0, 360) (hue), 
	--		[0, 1] (saturation, value)
	local r, g, b, alpha = unpack(rgbColor)

	local cmin = ArrayMin({r, g, b})
	local cmax = ArrayMax({r, g, b})
	local rr = RangeScale(r, cmin, cmax, 0.0, 1.0)
	local gg = RangeScale(g, cmin, cmax, 0.0, 1.0)
	local bb = RangeScale(b, cmin, cmax, 0.0, 1.0)

	local h = 0
	if rr >= 1 then h = RangeScale(gg - bb, -1, 1, -60.0,  60.0) end
	if gg >= 1 then h = RangeScale(bb - rr, -1, 1,  60.0, 180.0) end
	if bb >= 1 then h = RangeScale(rr - gg, -1, 1, 180.0, 300.0) end
	if  h <  0 then h = h + 360 end

	local s = cmax - cmin
	local v = (cmax + cmin) / 2.0

	local hsvColor = {h, s, v, alpha}
	-- Trace("("..r..", "..g..", "..b..") RGB -> HSV ("..h..", "..s..", "..v..")")
	-- Trace("^^ min/max ("..cmin..", "..cmax..") ^^ ("..rr..", "..gg..", "..bb..") Scaled RGB ^^")
	return hsvColor
end

function LightnessOf(rgbColor)
	return 0.11 * rgbColor[1] + 0.59 * rgbColor[2] + 0.30 * rgbColor[3]
end

function HSV2RGB(hsvColor)
	-- HSV: [0, 360) (hue), 
	--		[0, 1] (saturation, value)
	-- RGB: [0, 1]
	local h, s, v, alpha = unpack(hsvColor)

	h = h % 360

	local r, g, b
	if     h <  60 then
		r = 1.0
		g = RangeScale(h,   0,  60, 0.0, 1.0)
		b = 0.0
	elseif h < 120 then
		r = RangeScale(h,  60, 120, 1.0, 0.0)
		g = 1.0
		b = 0.0
	elseif h < 180 then
		r = 0.0
		g = 1.0
		b = RangeScale(h, 120, 180, 0.0, 1.0)
	elseif h < 240 then
		r = 0.0
		g = RangeScale(h, 180, 240, 1.0, 0.0)
		b = 1.0
	elseif h < 300 then
		r = RangeScale(h, 240, 300, 0.0, 1.0)
		g = 0.0
		b = 1.0
	else --h < 360
		r = 1.0
		g = 0.0
		b = RangeScale(h, 300, 360, 1.0, 0.0)
	end

	if v > 0.5 then
		r = 1.0 - (1.0 - v) * (1.0 - r) * 2
		g = 1.0 - (1.0 - v) * (1.0 - g) * 2
		b = 1.0 - (1.0 - v) * (1.0 - b) * 2
	else
		r = 2 * v * r
		g = 2 * v * g
		b = 2 * v * b
	end

	local cmin = ArrayMin({r, g, b})
	local cmax = ArrayMax({r, g, b})
	local ss = 1.0 - s
	local cminSat = (cmin + ss*cmax) / (1.0 + ss)
	local cmaxSat = (cmax + ss*cmin) / (1.0 + ss)
	r = RangeScale(r, cmin, cmax, cminSat, cmaxSat)
	g = RangeScale(g, cmin, cmax, cminSat, cmaxSat)
	b = RangeScale(b, cmin, cmax, cminSat, cmaxSat)

	local rgbColor = {r, g, b, alpha}
	-- Trace("("..h..", "..s..", "..v..") HSV -> RGB ("..r..", "..g..", "..b..")")
	return rgbColor
end

function PalettePicker(paletteStyle, paletteSeed)
	-- Palette styles:
	-- 0	Corresponding Triad
	--		[1]
	--		[2], or [1] +/- 30~90 deg
	--		[1] - ([2] - [1])
	-- 1	Complementary Triad (not implemented)
	--		[1]
	--		[2], or [1] +/- 30~90 deg
	--		([1] + [2])/2 + 180 deg
	-- 2	Four Corner Quad
	--		[1]
	--		[2], or [1] +/- 30~90 deg
	--		[1] + 180 deg
	--		[2] + 180 deg
	-- 3	Correspomplementary Quad
	--		[1]
	--		[2], or [1] +/- 30~90 deg
	--		[1] - ([2] - [1])
	--		[1] + 180 deg
	-- Accepts {r, g, b} or {r, g, b, alpha} color as the seed.
	-- Returns {r, g, b, alpha} colors as the palette.
	if #paletteSeed < 4 then
		paletteSeed[4] = 1.0
	end

	if paletteStyle == 0 then
		shift = 15 + 30 * math.random()
		baseHSV = RGB2HSV(paletteSeed)
		return {
			HSV2RGB({baseHSV[1]        , baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] + shift, baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] - shift, baseHSV[2], baseHSV[3], baseHSV[4]}),
			}
	elseif paletteStyle == 1 then
		-- Mirror corresponding triad for now.
		shift = 15 + 30 * math.random()
		baseHSV = RGB2HSV(paletteSeed)
		return {
			HSV2RGB({baseHSV[1]        , baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] + shift, baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] - shift, baseHSV[2], baseHSV[3], baseHSV[4]}),
			}
	elseif paletteStyle == 2 then
		shift = 30 + 60 * math.random()
		baseHSV = RGB2HSV(paletteSeed)
		return {
			HSV2RGB({baseHSV[1]              , baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] + shift      , baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] +  180       , baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] + shift + 180, baseHSV[2], baseHSV[3], baseHSV[4]}),
			}
	elseif paletteStyle == 3 then
		shift = 15 + 30 * math.random()
		baseHSV = RGB2HSV(paletteSeed)
		return {
			HSV2RGB({baseHSV[1]        , baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] + shift, baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] - shift, baseHSV[2], baseHSV[3], baseHSV[4]}),
			HSV2RGB({baseHSV[1] +  180 , baseHSV[2], baseHSV[3], baseHSV[4]}),
			}
	elseif paletteStyle == -1 then
		return {paletteSeed}
	else
		-- passthrough
		return paletteSeed
	end
end


--s/o to BrotherMojo
function mindf_reverseRotation(angleX, angleY, angleZ)
	local sinX = math.sin(angleX);
	local cosX = math.cos(angleX);
	local sinY = math.sin(angleY);
	local cosY = math.cos(angleY);
	local sinZ = math.sin(angleZ);
	local cosZ = math.cos(angleZ);
	return { math.atan2(-cosX*sinY*sinZ-sinX*cosZ,cosX*cosY),
			 math.asin(-cosX*sinY*cosZ+sinX*sinZ),
			 math.atan2(-sinX*sinY*cosZ-cosX*sinZ,cosY*cosZ) }
end



function SortModsTable(mt)
	-- Insertion sort into the butt
	-- because wow I'm mostly lazy
	-- and can assume it's mostly sorted

	mtNew = {}

	for _,mr in pairs(mt) do
		local insertLocation = 1
		for i = #mtNew,1,-1 do
--			Trace("### SortModsTable: "..mtNew[i][1].." vs. "..mr[1])
			if mtNew[i][1] <= mr[1] then
				insertLocation = i+1
				break
			end
		end
--		Trace("### SortModsTable: "..mr[1].." ("..mr[2]..") -> "..insertLocation)
		table.insert(mtNew, insertLocation, mr)
	end

	return mtNew
end

return Def.ActorFrame {}
