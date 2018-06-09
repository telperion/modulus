-------------------------------------------------------------------------------
--
--		Edelritter (Nhato vs. Taishi) - "The Word For World Is Forest"
--		Stepcharts Made Horribly 4
--		
--		Author: 	Telperion
--		Date: 		2018-06-11
--		Target:		SM5.0.12+
--
-------------------------------------------------------------------------------
--
--		We'll run where lights won't chase us
--		Hide where love can save us
--		I will never let you go
--
-------------------------------------------------------------------------------

local circumvention = false
if circumvention then
	return Def.ActorFrame {}
end

local sw = SCREEN_WIDTH
local sh = SCREEN_HEIGHT
local BPS = GAMESTATE:GetSongBPS()
local ofs = 0.009
local overtime = 0
local visualOffset = -0.01
local fgmsg = 0
local fgcmd = 0
local checked = false
local plr = {nil, nil}

local PI = math.pi
local LOG2 = math.log(2.0)
local SQRT2 = math.sqrt(2.0)
local DEG_TO_RAD = math.pi / 180.0

--
--	Texture constants
--
local ttw = math.pow(2, math.ceil(math.log(sw) / LOG2))
local tth = math.pow(2, math.ceil(math.log(sh) / LOG2))
local twscale = sw / ttw
local thscale = sh / tth

--#############################################################################
--## BEGIN   SETUP  ###########################################################

-------------------------------------------------------------------------------
--
--		Actors begin below this line
--


local _DZ_ = Def.ActorFrame {}
local _FG_ = Def.ActorFrame {
	InitCommand = function(self)
	end,
	OnCommand = function(self)
		plr[1] = SCREENMAN:GetTopScreen():GetChild('PlayerP1')
		plr[2] = SCREENMAN:GetTopScreen():GetChild('PlayerP2')
		Trace('### Forest: Started')
		self:sleep(1573)
	end
};

_FG_[#_FG_ + 1] = LoadActor("./helpers.lua")
Trace('### Forest: Loaded Helpers')



-------------------------------------------------------------------------------
--
-- 		Playfield proxies
--

for pn = 1,2 do
	_FG_[#_FG_ + 1] = Def.ActorFrame {	
		Name = "ProxyP"..pn.."Outer",
		Def.ActorFrame {	
			Name = "ProxyP"..pn.."Inner",
			Def.ActorProxy {					
				Name = "ProxyP"..pn,
				InitCommand = function(self)
					self:aux( tonumber(string.match(self:GetName(), "[0-9]")) )
				end,
				BeginCommand=function(self)
					local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..self:getaux())
					if McCoy then 
						self:SetTarget(McCoy)
					else 
						self:hibernate(1573)
					end
				end,
				OnCommand=function(self)
					local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..self:getaux())
					if McCoy then 
						self:xy(-McCoy:GetX(), -McCoy:GetY())
						self:GetParent():xy(McCoy:GetX(), McCoy:GetY())
						Trace("Player "..self:getaux().." Proxy centered itself!")
					else
						Trace("Player "..self:getaux().." Proxy couldn't center itself!")
					end
				end,
				RecenterProxyMessageCommand=function(self)					
					local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..self:getaux())
					if McCoy then 
						self:xy(-McCoy:GetX(), -McCoy:GetY())
						self:GetParent():xy(McCoy:GetX(), McCoy:GetY())
					end
				end,
			},
			InitCommand = function(self)
--				self:aux( tonumber(string.match(self:GetName(), "_([0-9]+)")) )
			end,
			CenterProxiesMessageCommand = function(self)
				self:decelerate(8.0 / BPS):xy(sw/2, sh/2-60)
			end,
		},
		InitCommand = function(self)
--			self:aux( tonumber(string.match(self:GetName(), "_([0-9]+)")) )
		end,
		OnCommand = function(self)
			self:z(2)
		end,
	}
end

--
-- Judgment proxies
--
for pn = 1,2 do
	_FG_[#_FG_ + 1] = Def.ActorProxy {
		Name = "JudgeP"..pn.."Proxy",
		InitCommand = function(self)
			self:aux( tonumber(string.match(self:GetName(), "[0-9]")) )
		end,
		BeginCommand = function(self)
			local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..self:getaux())
			if McCoy then 
				local McJudge = McCoy:GetChild('Judgment')
				self:SetTarget(McJudge)
				McJudge:visible(false)
			else 
				self:hibernate(1573)
			end
		end,
		OnCommand = function(self)
			local p = self:GetParent()
						  :GetChild('ProxyP'..self:getaux().."Outer")
						  :GetChild('ProxyP'..self:getaux().."Inner")
			
			self:xy(p:GetX(), sh/2)
				:zoom(0.8)
		end,
	}
end

--
-- 		Playfield proxies
--
-------------------------------------------------------------------------------

--##  END    SETUP  ###########################################################
--#############################################################################


-------------------------------------------------------------------------------
--
--		Extra nuts 'n' bolts
--

--
-- 		Extra nuts 'n' bolts
--
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--
--		Some trees
--

function CalculateBaseVertices_Tree()
	-- use disjoint triangles for simplicity

	verts = {
		{{-0.25, 0.25, 0}, {0,   1,   0,   1.0}},
		{{ 0.25, 0.25, 0}, {0.2, 1,   0,   1.0}},
		{{ 0,    1,    0}, {0,   1,   0.2, 1.0}},
		{{-0.10, 0,    0}, {0.3, 0.1, 0,   1.0}},
		{{ 0.10, 0,    0}, {0.3, 0.1, 0,   1.0}},
		{{ 0.10, 0.25, 0}, {0.3, 0.1, 0,   1.0}},
		{{ 0.10, 0.25, 0}, {0.3, 0.2, 0,   1.0}},
		{{-0.10, 0.25, 0}, {0.3, 0.2, 0,   1.0}},
		{{-0.10, 0,    0}, {0.3, 0.2, 0,   1.0}},
	}


	-- texcoords (in case we need them)
	for i = 1,3 do
		verts[i][3] = {(verts[i][1][1] + 0.25) / 0.50, (verts[i][1][2] - 0.25) / 0.75}
	end
	for i = 4,9 do
		verts[i][3] = {(verts[i][1][1] + 0.10) / 0.20, (verts[i][1][2] - 0)    / 0.25}
	end

	return verts
end


local coefValley = 5
function Hillside(vx)
	return math.log(math.abs((coefValley-1)*vx) + 1) / math.log(coefValley)
end


local treePlace = {0.5 * sw, 0.4 * sh, -30 * math.sqrt(sw, sh)}
local treeZExtend = 0.5
local treeSize = {60, 60, 1}
local treeColorVariation = 0.1
local nTrees = 1000
local nHillSdv = 20
local nBPCorner = 12
local bpRadCurve = 0.2
local altitude = 1.5
local trees = {}
local hills = {}
local backplate = nil
local treesFrame = nil
local treesAF = Def.ActorFrame {
	InitCommand = function(self)
		self:xy(sw * 0.5, sh * 1.2)
			:rotationx(15)

		treesFrame = self
	end,
	BeginCommand = function(self)
	end,
	OnCommand = function(self)
		self:fov(45)
			:SetDrawByZPosition(true)
	end,	
}
for i = 1,nTrees do
	local treeIndex = i
	treesAF[#treesAF + 1] = Def.ActorMultiVertex {
		InitCommand = function(self)
			local verts = CalculateBaseVertices_Tree()

			-- ln(abs([s-1]*t) + 1)/ln(s)
			local vx = math.random() *  2.0                - 1.0
			--	  vx = math.sin(vx * PI / 2.0)
			local vz = math.random() * (1.0 + treeZExtend) - treeZExtend
			local vy = Hillside(vx)
			local hh = RangeScale(math.random(), 0.0, 1.0, 0.5, 1.5)

			local treeColor = HSV2RGB({
					RangeScale(math.random(), 0.0, 1.0,  90.0, 150.0),
					1.0,
					RangeScale(math.random(), 0.0, 1.0,   0.3,   0.6),
					1.0
				})
			for vi = 1,3 do
				verts[vi][2] = treeColor
			end

			self:aux(treeIndex)
				:xy(vx * treePlace[1], vy * -treePlace[2])
				:z(vz * treePlace[3])
				:SetVertices(verts)
				:SetDrawState{First = 1,
							  Num = 9,
							  Mode = "DrawMode_Triangles"}
				:zoomx( treeSize[1] * hh)
				:zoomy(-treeSize[2] * hh)	-- THEY'RE ALL UPSID'E DOW'N LOL
				:zoomz( treeSize[3])
				:diffusealpha(math.sqrt(RangeScale(vz, -treeZExtend, 1.0, 1.0, 0.5)))

			trees[#trees + 1] = {self, vx, vy, vz}
		end,
	}
end
for i = 1,nHillSdv do
	local hillIndex = i
	
	local verts = {}
	--
	-- Assume valley floor is square res for now.
	--
	-- 1--3--5--7--
	-- |  |  |  |
	-- 2--4--6--8--
	--
	local vzA = (1.0 + treeZExtend) * (hillIndex-1)/nHillSdv - treeZExtend
	local vzB = (1.0 + treeZExtend) *  hillIndex   /nHillSdv - treeZExtend
	for vi = 0,nHillSdv do
		-- Specify pairs of vertices.
		local vx  = 2*        vi   /nHillSdv - 1
		local vy  = Hillside(vx)
		verts[#verts + 1] = {
			{
				vx  * treePlace[1],
				vy  * treePlace[2],
				0
			},
			HSV2RGB({
				RangeScale(math.random(), 0.0, 1.0, 330.0, 390.0),
				RangeScale(math.random(), 0.0, 1.0,   0.2,   0.6),
				RangeScale(math.random(), 0.0, 1.0,   0.1,   0.2),
				1.0
			}),
			{vx*0.5+0.5, vzA*0.5+0.5}		-- this could be arclength defined but I ain't about that life
			}
		verts[#verts + 1] = {
			{
				vx  * treePlace[1],
				vy  * treePlace[2],
				(vzA-vzB) * treePlace[3]
			},
			HSV2RGB({
				RangeScale(math.random(), 0.0, 1.0, 330.0, 390.0),
				RangeScale(math.random(), 0.0, 1.0,   0.2,   0.6),
				RangeScale(math.random(), 0.0, 1.0,   0.1,   0.2),
				1.0
			}),
			{vx*0.5+0.5, vzA*0.5+0.5}		-- this could be arclength defined but I ain't about that life
			}
	end

	treesAF[#treesAF + 1] = Def.ActorMultiVertex {
		InitCommand = function(self)

			self:aux(hillIndex)				
				:z(vzB * treePlace[3])		-- trying to force draw by Z order to cooperate
				:SetVertices(verts)
				:SetDrawState{First = 1,
							  Num = -1,
							  Mode = "DrawMode_QuadStrip"}
				:zoomy(-1)	-- THEY'RE ALL UPSID'E DOW'N LOL
				:diffusealpha(math.sqrt(RangeScale(hillIndex, 0.0, nHillSdv, 1.0, 0.8)))

			hills[#hills + 1] = {self, vzB}
		end,
	}
end

for i=1,1 do
	local verts = {}

	--
	--
	--	/¯¯¯\
	--	|   |
	--	|   |
	--
	verts[#verts + 1] = {{
		-treePlace[1], 
		treePlace[2] * Hillside(-1), 
		0
		}}
	for vi = 0,nBPCorner do
		local vth = RangeScale(vi, 0, nBPCorner, 0, PI/2)
		local vx = math.cos(vth)
		local vy = math.sin(vth)
		verts[#verts + 1] = {{
			-treePlace[1] + bpRadCurve * treePlace[1] * (1 - vx),
			treePlace[2]*(1+altitude)  - bpRadCurve * treePlace[1] * (1 - vy),
			0
			}}
	end
	for vi = 0,nBPCorner do
		local vth = RangeScale(vi, 0, nBPCorner, PI/2, 0)
		local vx = math.cos(vth)
		local vy = math.sin(vth)
		verts[#verts + 1] = {{
			treePlace[1] - bpRadCurve * treePlace[1] * (1 - vx),
			treePlace[2]*(1+altitude) - bpRadCurve * treePlace[1] * (1 - vy),
			0
			}}
	end
	verts[#verts + 1] = {{
		treePlace[1], 
		treePlace[2] * Hillside(1), 
		0
		}}


	for vi = 1,#verts do
		verts[vi][2] = HSV2RGB({RangeScale(vi, 1, #verts, 90, 150), 1.0, 0.5, 1.0})		
	end


	treesAF[#treesAF + 1] = Def.ActorMultiVertex {
		InitCommand = function(self)

			self:aux(0)				
				:z(treePlace[3])		-- trying to force draw by Z order to cooperate
				:SetLineWidth(12)
				:SetVertices(verts)
				:SetDrawState{First = 1,
							  Num = -1,
							  Mode = "DrawMode_LineStrip"}
				:zoomy(-1)	-- THEY'RE ALL UPSID'E DOW'N LOL
				:diffusealpha(0.5)

			backplate = self
		end,
	}
end

_FG_[#_FG_ + 1] = treesAF

--
--		Some trees
--
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--
--		gfx update function
--

vt_last = nil
function gfxUpdateFunction()
	-- Most things are determined by beat, believe it or not.		
	local vt = GAMESTATE:GetSongBeat() + visualOffset

	if not vt_last then
		vt_last = vt
	end
		
	-- TODO: this assumes the effect applies over a constant BPM section!!
	BPS = GAMESTATE:GetSongBPS()

	local ppz = 1.0 + treeZExtend
	if treesFrame then
		treesFrame:rotationx(math.sin(vt * PI / 13.0) * 5.0 + 15.0)
				  :rotationy(math.sin(vt * PI / 17.0) * 10.0 + 0.0)
		for ti = 1,#trees do
			if trees[ti][1] then
				local vx = trees[ti][2]
				local vy = trees[ti][3]
				local vz = 1.0 - math.fmod(vt / 8.0 - trees[ti][4] - treeZExtend + ppz, ppz)
				trees[ti][1]:xy(vx * treePlace[1], vy * -treePlace[2])
							:z(vz * treePlace[3])
			end
		end
		for hi = 1,#hills do
			if hills[hi][1] then
				local vz = 1.0 - math.fmod(vt / 8.0 - hills[hi][2] - treeZExtend + ppz, ppz)
				hills[hi][1]:z(vz * treePlace[3])
			end
		end
	end

	vt_last = vt
end

--
--		gfx update function
--
-------------------------------------------------------------------------------



--#############################################################################
--## BEGIN UPSTREAM ###########################################################

-------------------------------------------------------------------------------
--
-- 		This is where the shit will be happening.
--

local messageList = {
	-- [1]: beat number to issue message on
	-- [2]: message title
	-- [3]: optional table of arguments passed to message
	
	{  0.00, "CenterProxies"},	
	{  0.00, "GhostDiffuse", {0.1}},
	{  0.00, "GhostProxiesOff"},	
	{  8.00, "GradientChange", {Gradient_HorizontalSpread}},	
	{  8.00, "StartTrail"},
	
	{240.00, "HideBG", {16}},
	{240.00, "GhostDiffuse", {0.3, 64}},
	{242.00, "GhostProxiesPulse"},
	{246.00, "GhostProxiesPulse"},
	{250.00, "GhostProxiesPulse"},
	{254.00, "GhostProxiesPulse"},
	{258.00, "GhostProxiesPulse"},
	{262.00, "GhostProxiesPulse"},
	{266.00, "GhostProxiesPulse"},
	{270.00, "GhostProxiesPulse"},
	{274.00, "GhostProxiesPulse"},
	{278.00, "GhostProxiesPulse"},
	{282.00, "GhostProxiesPulse"},
	{286.00, "GhostProxiesPulse"},
	{290.00, "GhostProxiesPulse"},
	{294.00, "GhostProxiesPulse"},
	{298.00, "GhostProxiesPulse"},
	{303.00, "GhostProxiesOn"},
	
	{311.00, "GhostProxiesOff"},
	{312.00, "GhostProxiesOn"},
	{312.00, "GradientChange", {Gradient_Drip}},
	{312.50, "GradientChange", {Gradient_HorizontalSpread, 1.5}},
	{314.00, "GradientChange", {Gradient_DripRev}},
	{314.50, "GradientChange", {Gradient_HorizontalSpread, 1.5}},
	{327.00, "GhostProxiesOff"},
	{328.00, "GhostProxiesOn"},
	{328.00, "GradientChange", {Gradient_DripRev}},
	{328.50, "GradientChange", {Gradient_HorizontalSpread, 1.5}},
	{330.00, "GradientChange", {Gradient_Drip}},
	{330.50, "GradientChange", {Gradient_HorizontalSpread, 1.5}},
	{332.00, "GradientChange", {Gradient_Expand, 12}},
	{343.00, "GhostProxiesOff"},
	{344.00, "GhostProxiesOn"},
	{351.00, "GhostProxiesOff"},
	{351.00, "GradientChange", {Gradient_Expand, 1}},
	{352.00, "GhostProxiesOn"},
	{352.00, "GradientChange", {Gradient_Drip}},
	{353.00, "GradientChange", {Gradient_Expand, 1}},
	{354.00, "GradientChange", {Gradient_DripRev}},
	{355.00, "GradientChange", {Gradient_Expand, 1}},
	{356.00, "GradientChange", {Gradient_Drip}},
	{356.75, "GradientChange", {Gradient_Expand, 3.25}},
	{363.50, "GradientChange", {Gradient_DripRev}},
		
	{368.00, "GhostProxiesOff"},
	{368.00, "GhostDiffuse", {0.4, 7}},
	{368.00, "GradientChange", {Gradient_Gack, 7}},	
	{375.00, "FateHello"},	
	{376.00, "GhostProxiesOn"},
	
	{496.00, "FateGoodbye"},	
	{496.00, "GhostDiffuse", {0.0, 32}},	
	{496.00, "GhostProxiesOff"},	
	{524.00, "StopTrail"},	
	{526.00, "StartTrail"},	
	{528.00, "GhostDiffuse", {0.5}},
	{528.00, "GhostProxiesOn"},
	{528.00, "ShowBG", {4}},
	{536.00, "GhostDiffuse", {0.0, 4}},
}



-------------------------------------------------------------------------------
--
-- Messaging controller
--
_FG_[#_FG_ + 1] = Def.ActorFrame {
	-- Control the rotation splines
	RotateWholeFieldMessageCommand = function(self, args)
		local tweenTime 	= (#args >= 1) and args[1] or 4
		local pnOrBoth		= (#args >= 2) and args[2] or 1
		local endingAngle 	= (#args >= 3) and args[3] or 0

		for pn = 1,2 do
			if pnOrBoth == pn or pnOrBoth == 3 then
				local pp = SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn)
				local nf = pp:GetChild('NoteField')

				for i,cv in ipairs(nf:GetColumnActors()) do
					cv:smooth(tweenTime / BPS)
					cv:GetRotHandler():SetSplineMode('NoteColumnSplineMode_Offset')
					cv:GetRotHandler():SetBeatsPerT(1.3 - i * 0.2)
					local splr = cv:GetRotHandler():GetSpline()
					splr:SetSize(2)
					splr:SetPoint(1, {0, 0, -endingAngle * DEG_TO_RAD})
					splr:SetPoint(2, {0, 0, -endingAngle * DEG_TO_RAD})
					splr:Solve()
				end
			end

--		if PlayerProxyActors[pn] then
--			PlayerProxyActors[pn]:smooth(tweenTime/BPS)
--								 :rotationz(endingAngle)
--		end

		end

	end,
}


-- Perframe controller
_FG_[#_FG_ + 1] = Def.ActorFrame {
	InitCommand = function(self)
		self:SetUpdateFunction(gfxUpdateFunction)
	end,

	Def.ActorFrame {
		InitCommand = function(self)
			self:sleep(69420)
		end
	}
}



-------------------------------------------------------------------------------
--
-- Put it all together.
--

-- Load the HUD reducer into this script.
_FG_[#_FG_ + 1] = LoadActor("./hudreducer.lua")
Trace('### Forest: Loaded HUD Reducer')

-- Load the mods table parser into this script.
niceSpeed = (420 + 69) / 150			-- This song is 150 BPM.
modsTable = {
	-- [1]: beat start
	-- [2]: mod type
	-- [3]: mod strength (out of unity),
	-- [4]: mod approach (in beats to complete)
	-- [5]: player application (1 = P1, 2 = P2, 3 = both, 0 = neither)
		
		{   0.0,	"ScrollSpeed",	niceSpeed,    8.0,	3}, 
		{   0.0,	"Dark",				  0.8,    8.0,	3}, 
}
_FG_[#_FG_ + 1] = LoadActor("./modsHQ.lua", {modsTable, 0})
Trace('### Forest: Loaded mods HQ')


return _FG_

--##  END  UPSTREAM ###########################################################
--#############################################################################



