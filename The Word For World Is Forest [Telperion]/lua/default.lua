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

local niceSpeed = (420 + 69) / 150			-- This song is 150 BPM.
local slowSpeed = (420 - 69) / 150			-- This song is 150 BPM.
local sw = SCREEN_WIDTH
local sh = SCREEN_HEIGHT
local BPS = GAMESTATE:GetSongBPS()
local ofs = 0.009
local overtime = 0
local visualOffset = -0.01
local fgmsg = 0
local fgcmd = 0
local checked = false
local proxiesCentered = false
local plr = {nil, nil}

local PI = math.pi
local EPS = 0.001
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





local playerFullAF = {}

local PlayerProxyActors = {}
local PlayerFullFrames = {}
local PlayerTreeView = nil

-------------------------------------------------------------------------------
--
-- 		Playfield proxies
--

local playerValleyAF = Def.ActorFrame {
	InitCommand = function(self)
		PlayerTreeView = self
		self:xy(0.5 * sw, 1.0 * sh)
	end,
	OnCommand = function(self)
	end,
}

for pn = 1,2 do
	playerFullAF[pn] = Def.ActorFrame {	
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
--						self:xy(0, 0)	-- TODO: what Y value!!
						self:xy(-McCoy:GetX(), -McCoy:GetY())	-- TODO: what Y value!!
--						self:GetParent():xy(McCoy:GetX(), McCoy:GetY())
						Trace("Player "..self:getaux()..": x = "..McCoy:GetX()..", y = "..McCoy:GetY())
						Trace("Player "..self:getaux().." Proxy centered itself!")
					else
						Trace("Player "..self:getaux().." Proxy couldn't center itself!")
					end
				end,
				RecenterProxyMessageCommand=function(self)					
					local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..self:getaux())
					if McCoy then 
--						self:xy(0, 0)	-- TODO: what Y value!!
						self:xy(-McCoy:GetX(), -McCoy:GetY())	-- TODO: what Y value!!
--						self:GetParent():xy(McCoy:GetX(), McCoy:GetY())
						Trace("Player "..self:getaux()..": x = "..McCoy:GetX()..", y = "..McCoy:GetY())
						Trace("Player "..self:getaux().." Proxy recentered itself!")
						proxiesCentered = true
					end
				end,
			},
			InitCommand = function(self)
				PlayerProxyActors[pn] = self
				self:xy(0, 0)
--				self:aux( tonumber(string.match(self:GetName(), "_([0-9]+)")) )
			end,
			OnCommand = function(self)
			end,
			CenterProxiesMessageCommand = function(self)
--				self:decelerate(8.0 / BPS):xy(sw/2, sh/2)
			end,
		},
		InitCommand = function(self)
			PlayerFullFrames[pn] = self
--			self:aux( tonumber(string.match(self:GetName(), "_([0-9]+)")) )
			self:xy(0, 0)
		end,
		OnCommand = function(self)
			self:fov(90)
				:SetDrawByZPosition(true)
		end,
	}
	playerValleyAF[#playerValleyAF + 1] = playerFullAF[pn]
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
			self:xy(sw * (0.1 + 0.8 * (self:getaux() - 1)), sh/2)
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
--		Some arrow paths
--

local pathActors = {}
local splSize = 528
local splTilt = 0.03
local splActive = {
	-- Lead in by [3] beats before [1]
	-- Lead out by [4] beats before [2]
	flight = {},
	camper = {},
	ascend = {},
}
splActive.flight = {
	{112, 184, 8, 4},
--	{320, 384, 8, 2},
	{448, 512, 4, 8},
}
splActive.camper = {
	-- Lead in by [3] beats before [1]
	-- Lead out by [4] beats before [2]
	-- [5] determines if fire cube in effect or not
	{192, 256, 8, 2, true},
	{256, 288, 2, 2, false},
	{288, 320, 2, 2, true},	
}
local splValleyTrace = {0}	-- x coordinate only, [-1, 1]
for i = 2,splSize do
	-- Let's try to go the opposite direction from the previous point.
	-- In a contractive way (hahaha runaway boys)
	splValleyTrace[#splValleyTrace + 1] = (math.random() - 0.5) * 0.5 - splValleyTrace[i-1] * 0.5
end


function EngageForestscapeFlight(splHandle, lane, extentX, extentZ)
	splHandle:SetSplineMode('NoteColumnSplineMode_Offset')
			 :SetSubtractSongBeat(false)
			 :SetReceptorT(0.0)
			 :SetBeatsPerT(1.0)
	local splObject = splHandle:GetSpline()
	splObject:SetSize(splSize)
	for spli = 1,splSize do
		splObject:SetPoint(spli, {
			extentX * splValleyTrace[spli],
			0,
			extentZ * splValleyTrace[spli] * splTilt * (2.5 - lane)
		})
	end
	splObject:Solve()
end
function DisengageForestscapeFlight(splHandle, lane)
	splHandle:SetSplineMode('NoteColumnSplineMode_Disabled')
			 :SetSubtractSongBeat(false)
			 :SetReceptorT(0.0)
			 :SetBeatsPerT(1.0)
	local splObject = splHandle:GetSpline()
	splObject:SetSize(splSize)
	for spli = 1,splSize do
		splObject:SetPoint(spli, {
			0,
			0,
			0
		})
	end
	splObject:Solve()
end

for pn = 1,2 do
	pathActors[pn] = {}
	for lane = 1,4 do
		local pff = playerFullAF[pn]
		local pnL = pn
		local lnL = lane
		playerFullAF[pn][#pff + 1] = Def.ActorMultiVertex
		{
			Name = "PathLaneP"..pnL.."_"..lnL,
			InitCommand = function(self)
				pathActors[pn][lane] = {self, nil}
			end,
			OnCommand = function(self)
				if plr[pnL] then
					--self:xy(plr[pnL]:GetX(), plr[pnL]:GetY())

					local nf = plr[pnL]:GetChild('NoteField')
					local colActors = nf:GetColumnActors()
					local splHandle = colActors[lnL]:GetPosHandler()
					local splRotHdl = colActors[lnL]:GetRotHandler()
					local splZoomHdl = colActors[lnL]:GetZoomHandler()
					pathActors[pn][lane] = {self, splHandle, splRotHdl, splZoomHdl}
					nf:fov(90)

					self:SetLineWidth(3)					
						:SetDrawState{First = 1,
									  Num = 0,
									  Mode = "DrawMode_LineStrip"}

					DisengageForestscapeFlight(splHandle, lane)

					local splRotObj = splRotHdl:GetSpline()
					splRotHdl:SetSplineMode('NoteColumnSplineMode_Offset')
							 :SetBeatsPerT(1)
					splRotObj:SetSize(2)
							 :SetPoint(1, {0, 0, 0})
							 :SetPoint(2, {0, 0, 0})
							 :Solve()
				end
			end,
		}
	end
end

--
--		Some arrow paths
--
-------------------------------------------------------------------------------


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


local forestscapeAuxActor = nil
local treePlace = {0.5 * sw, 0.4 * sh, -30 * math.sqrt(sw, sh)}
local treeZExtend = 0.5
local treeSize = {60, 60, 1}
local treeColorVariation = 0.1
local nTrees = 500
local nHillSdv = 20
local nBPCorner = 6
local bpRadCurve = 0.1
local altitude = 1.5
local trees = {}
local hills = {}
local backplate = nil
local treesFrame = nil
local treesAF = Def.ActorFrame {
	InitCommand = function(self)
		self:xy(sw * 0.5, sh * 3.0)
			:rotationx(15)

		treesFrame = self
	end,
	BeginCommand = function(self)
	end,
	OnCommand = function(self)
		self:fov(90)
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
_FG_[#_FG_ + 1] = Def.ActorFrame {
	InitCommand = function(self)
		forestscapeAuxActor = self
		self:aux(0)
	end,

	ShowForestscapeMessageCommand = function(self, args)
		local tweenTime 	= (args and (#args >= 1) and args[1]) or 0

		if treesFrame then
			treesFrame:visible(1)
		end
		for pn=1,2 do
			for lane=1,4 do
				if pathActors[pn][lane] then					
					EngageForestscapeFlight(pathActors[pn][lane][2], lane, treePlace[1], treePlace[3])
				end
			end
		end
			
		if tweenTime > EPS then
			self:decelerate(tweenTime / BPS)
		end
		self:aux(1)
	end,
	HideForestscapeMessageCommand = function(self, args)
		local tweenTime 	= (args and (#args >= 1) and args[1]) or 0

		if tweenTime > EPS then
			self:accelerate(tweenTime / BPS)
		end
		self:aux(0)
			:queuecommand('HideForestscape2')
	end,
	HideForestscape2Command = function(self)	
		if treesFrame then
			treesFrame:visible(0)
		end
		for pn=1,2 do
			for lane=1,4 do
				if pathActors[pn][lane] then					
					DisengageForestscapeFlight(pathActors[pn][lane][2], lane)
				end
			end
		end
	end,
}

--
--		Some trees
--
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--
-- 		Climb a tree I guess
--

local trunkascentAuxActor = nil
local trunkOuterRadius = sw * 0.2
local trunkInnerRadius = sw * 0.15
local trunkPeriodY = sh * 0.3






function EngageTrunkAscentClimb_Pos(splHandle, pn, lane, extentR, periodY)
	splHandle:SetSplineMode('NoteColumnSplineMode_Position')
			 :SetSubtractSongBeat(false)
			 :SetReceptorT(0.0)
			 :SetBeatsPerT(1.0)
	local splObject = splHandle:GetSpline()
	splObject:SetSize(splSize)
	for spli = 1,splSize do
		local trunkArg = (math.fmod(spli * slowSpeed / periodY) - 0.25 + lane*0.25 + pn*0.625) * 2 * PI
		splObject:SetPoint(spli, {
			extentR * spli * math.cos(trunkArg),
			math.fmod(slowSpeed * spli, sh) - sh / 2,
			extentR * spli * math.sin(trunkArg)
		})
	end
	splObject:Solve()
end
function EngageTrunkAscentClimb_Rot(splHandle, pn, lane, extentR, periodY)
	splHandle:SetSplineMode('NoteColumnSplineMode_Position')
			 :SetSubtractSongBeat(false)
			 :SetReceptorT(0.0)
			 :SetBeatsPerT(1.0)
	local splObject = splHandle:GetSpline()
	splObject:SetSize(splSize)
	for spli = 1,splSize do
		local trunkArg = (math.fmod(spli * slowSpeed / periodY) - 0.25 + lane*0.125) * 2 * PI
		splObject:SetPoint(spli, {
			0,
			trunkArg,
			0
		})
	end
	splObject:Solve()
end
function EngageTrunkAscentClimb_Zoom(splHandle, pn, lane, extentR, periodY)
	splHandle:SetSplineMode('NoteColumnSplineMode_Position')
			 :SetSubtractSongBeat(false)
			 :SetReceptorT(0.0)
			 :SetBeatsPerT(1.0)
	local splObject = splHandle:GetSpline()
	splObject:SetSize(splSize)
	for spli = 1,splSize do
		local trunkArg = (math.fmod(spli * slowSpeed / periodY) - 0.25 + lane*0.125) * 2 * PI
		splObject:SetPoint(spli, {
			0.8 + 0.4 * (spli % 2),
			0.8 + 0.4 * (spli % 2),
			1  + 10.0 * (spli % 2)
		})
	end
	splObject:Solve()
end

function DisengageTrunkAscentClimb(splHandle, lane)
	splHandle:SetSplineMode('NoteColumnSplineMode_Disabled')
			 :SetSubtractSongBeat(false)
			 :SetReceptorT(0.0)
			 :SetBeatsPerT(1.0)
	local splObject = splHandle:GetSpline()
	splObject:SetSize(splSize)
	for spli = 1,splSize do
		splObject:SetPoint(spli, {
			0,
			0,
			0
		})
	end
	splObject:Solve()
end


_FG_[#_FG_ + 1] = Def.ActorFrame {
	InitCommand = function(self)
		trunkascentAuxActor = self
		self:aux(0)
	end,

	ShowTrunkAscentMessageCommand = function(self, args)
		local tweenTime 	= (args and (#args >= 1) and args[1]) or 0

		if treesFrame then
			treesFrame:visible(1)
		end
		for pn=1,2 do
			for lane=1,4 do
				if pathActors[pn][lane] then					
					EngageTrunkAscentClimb(pathActors[pn][lane][2], lane, treePlace[1], treePlace[3])
				end
			end
		end
			
		if tweenTime > EPS then
			self:decelerate(tweenTime / BPS)
		end
		self:aux(1)
	end,
	HideTrunkAscentMessageCommand = function(self, args)
		local tweenTime 	= (args and (#args >= 1) and args[1]) or 0

		if tweenTime > EPS then
			self:accelerate(tweenTime / BPS)
		end
		self:aux(0)
			:queuecommand('HideForestscape2')
	end,
	HideTrunkAscent2Command = function(self)	
		if treesFrame then
			treesFrame:visible(0)
		end
		for pn=1,2 do
			for lane=1,4 do
				if pathActors[pn][lane] then					
					DisengageTrunkAscentClimb(pathActors[pn][lane][2], lane, 0, 0)
				end
			end
		end
	end,
}
--
--		Climb a tree I guess
--
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--
-- 		Message listing
--

local messageList = {
	-- [1]: beat number to issue message on
	-- [2]: message title
	-- [3]: optional table of arguments passed to message

	{  0.10, "RecenterProxy"},	
	
	{  0.00, "HideForestscape"},	
	{300.00, "ShowForestscape", {8.0}},
	{316.00, "HideForestscape", {8.0}},
}

--
-- 		Message listing
--
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--
--		gfx update function
--

vt_last = nil
function gfxUpdateFunction()
	-------------------------------------------------------------------------------
	--
	--	Basic setup (don't touch this much!!)
	--

	-- Most things are determined by beat, believe it or not.		
	local vt = GAMESTATE:GetSongBeat() + visualOffset

	if not vt_last then
		vt_last = vt
	end
		
	-- TODO: this assumes the effect applies over a constant BPM section!!
	BPS = GAMESTATE:GetSongBPS()
	
	-- Initializations
	if vt >=   0.0 and not checked then
		for i,v in ipairs(plr) do
			if v then
				v:visible(false)
				 --:xy(sw/2, sh/2)					-- TODO: why this height??
				 :z(0)
			end
		end

		checked = true
	end
			
	-- Broadcast messages on their own terms.
	while true do
		if fgmsg < #messageList then
			messageBeat, messageName, messageArgs = unpack(messageList[fgmsg+1])
			if vt >= messageBeat then			
				if messageArgs then
					MESSAGEMAN:Broadcast( messageName, messageArgs )
				else
					MESSAGEMAN:Broadcast( messageName )
				end
				
				fgmsg = fgmsg + 1
			else
				break
			end
		else
			break
		end
	end

	--
	--	Basic setup (don't touch this much!!)
	--
	-------------------------------------------------------------------------------


	-------------------------------------------------------------------------------
	--
	--	Arrow path drawing portion (don't touch this much!!)
	--

	for pn = 1,2 do
		for lane = 1,4 do
			if pathActors[pn][lane] then
				local pact = pathActors[pn][lane][1]
				local psph = pathActors[pn][lane][2]
				local psta = GAMESTATE:GetPlayerState("PlayerNumber_P"..pn)
				local maxP = 640.0
				local stepP = 16.0
				local nSteps = math.floor(maxP / stepP) + 1

				-- Construct a list of vertices for the path.
				local verts = {}
				for ti = 1,nSteps do
					verts[ti] = {
						{0, 0, 0},
						HSV2RGB({90*(ti/nSteps) + 30*(lane - 1) + 15*pn + 210, 1.0, 0.5, (ti/nSteps)})
					}
				end

				-- Contribution from regular old arrow effects (mods).
				if psta and not (psph and psph:GetSplineMode() == 'NoteColumnSplineMode_Position') then 
					for ti = 1,nSteps do
						-- ArrowEffects offset functions' input is defined as pixels down the lane, essentially
						local t = ti * stepP
						local px = ArrowEffects.GetXPos(psta, lane, t)
						local py = ArrowEffects.GetYPos(psta, lane, t)
						local pz = ArrowEffects.GetZPos(psta, lane, t)

						verts[ti][1][1] = verts[ti][1][1] + px
						verts[ti][1][2] = verts[ti][1][2] + py
						verts[ti][1][3] = verts[ti][1][3] + pz
						--Trace('### arreff['..pn..']['..lane..']: t = '..t..', px = '..px..', py = '..py..', pz = '..pz)
					end
				end

				-- Contribution from user splines.
				if psph and psph:GetSplineMode() ~= 'NoteColumnSplineMode_Disabled' then
					local spl = psph:GetSpline()
					local bpt = psph:GetBeatsPerT()
					--Trace('### maxP = '..maxP..', spl = '..spl:GetDimension()..'D '..spl:GetSize()..'-pt')

					--local maxT = spl:GetMaxT()
					for ti = 1,nSteps do
						-- The note column spline evaluator's input is defined as "t"
						-- and a certain number of beats is allotted to each unit of t by handler:SetBeatsPerT()
						-- so ya gotta Relate all these Numeral's Togethe'r
						-- TODO: when the speed mod isn't constant, it has to be accounted for directly
						local pixY = ti * stepP
						local t = pixY / (niceSpeed * 64 * bpt) + vt / bpt
						local pp = spl:Evaluate(t)

						verts[ti][1][1] = verts[ti][1][1] + pp[1]
						verts[ti][1][2] = verts[ti][1][2] + pp[2]
						verts[ti][1][3] = verts[ti][1][3] + pp[3]
						--Trace('### spline['..pn..']['..lane..']: t = '..t..', px = '..pp[1]..', py = '..pp[2]..', pz = '..pp[3])
					end						
				end

				pact:SetLineWidth(6)
					:SetVertices(verts)
					:SetDrawState{First = 1,
								  Num = -1,
								  Mode = "DrawMode_LineStrip"}
					:x(PlayerProxyActors[pn]:GetX())
					:y(PlayerProxyActors[pn]:GetY())		-- TODO: how to set this Y offset?!
					:z(PlayerProxyActors[pn]:GetZ())
					:diffusealpha(1.0)
			end
		end
	end

	--
	--	Arrow path drawing portion (don't touch this much!!)
	--
	-------------------------------------------------------------------------------
	

--	for i,v in ipairs(plr) do
--		if v then
--			Trace('Player '..i..': x = '..v:GetX()..', y = '..v:GetY())
--		end
--	end

	-------------------------------------------------------------------------------	
	--
	--	Perframing: forest scape
	--

	local forestscapeParam = forestscapeAuxActor:getaux()

	local ppz = 1.0 + treeZExtend
	if treesFrame then
		-- Preserve base rotation for the landscape only.
		treesFrame:rotationy(forestscapeParam * (math.sin(vt * PI / 17.0) * 10.0) + 0.0)
				  :rotationx(forestscapeParam * (math.sin(vt * PI / 13.0) * 5.0) + 15.0)
				  :xy(sw * 0.5, sh * (3.0 - 1.8 * forestscapeParam))
				  
		for ti = 1,#trees do
			if trees[ti][1] then
				local vx = trees[ti][2]
				local vy = trees[ti][3]
				local vz = 1.0 - math.fmod(vt / 4.0 - trees[ti][4] - treeZExtend + ppz, ppz)
				trees[ti][1]:xy(vx * treePlace[1], vy * -treePlace[2])
							:z(vz * treePlace[3])
							:diffusealpha(forestscapeParam * math.sqrt(RangeScale(vz, -treeZExtend, 1.0, 1.0, 0.1)))
			end
		end
		for hi = 1,#hills do
			if hills[hi][1] then
				local vz = 1.0 - math.fmod(vt / 8.0 - hills[hi][2] - treeZExtend + ppz, ppz)
				hills[hi][1]:z(vz * treePlace[3])
							:diffusealpha(forestscapeParam)
			end
		end
	end

	if forestscapeParam > EPS then
		for pn = 1,2 do
			PlayerFullFrames[pn]:rotationx(-90 * forestscapeParam)
					  			:zoomx(1.0 + forestscapeParam * 0.5)
					  			:zoomy(1.0 + forestscapeParam * 1.0)
					  			:zoomz(1.0 + forestscapeParam * 0.5)
					  			:z(forestscapeParam * treePlace[3])
			--Trace('### plr '..pn..': RX = '..plr[pn]:GetRotationX()..', RY = '..plr[pn]:GetRotationY()..', RZ = '..plr[pn]:GetRotationZ())

			for lane = 1,4 do
				-- Dial in or out on the "confusionoffsetx".
				-- Separate from arrow pathing but uses some common objects.
				if pathActors[pn][lane] then
					local splRotHdl = pathActors[pn][lane][3]
					local splRotObj = splRotHdl:GetSpline()
					splRotHdl:SetSplineMode('NoteColumnSplineMode_Offset')
							 :SetBeatsPerT(1)
					splRotObj:SetSize(2)
							 :SetPoint(1, {forestscapeParam * PI/2, 0, 0})
							 :SetPoint(2, {forestscapeParam * PI/2, 0, 0})
							 :Solve()

					pathActors[pn][lane][1]:diffusealpha(forestscapeParam)
				end
			end
		end

		backplate:diffusealpha(forestscapeParam * 0.5)

		-- Don't preserve base rotation for the forestscape player container.
		PlayerTreeView:rotationy(forestscapeParam * (math.sin(vt * PI / 17.0) * 10.0 - 0.0))
			  		  :rotationx(forestscapeParam * (math.sin(vt * PI / 13.0) * 5.0 + 30.0))
	end

	--
	--	Perframing: forest scape
	--
	-------------------------------------------------------------------------------	



	-------------------------------------------------------------------------------	
	--
	--	Perframing: trunk ascent
	--

	local trunkascentParam = trunkascentAuxActor:getaux()

	local ppz = 1.0 + treeZExtend
	if treesFrame then
		-- Preserve base rotation for the landscape only.
		treesFrame:rotationy(forestscapeParam * (math.sin(vt * PI / 17.0) * 10.0) + 0.0)
				  :rotationx(forestscapeParam * (math.sin(vt * PI / 13.0) * 5.0) + 15.0)
				  :xy(sw * 0.5, sh * (3.0 - 1.8 * forestscapeParam))
				  
		for ti = 1,#trees do
			if trees[ti][1] then
				local vx = trees[ti][2]
				local vy = trees[ti][3]
				local vz = 1.0 - math.fmod(vt / 4.0 - trees[ti][4] - treeZExtend + ppz, ppz)
				trees[ti][1]:xy(vx * treePlace[1], vy * -treePlace[2])
							:z(vz * treePlace[3])
							:diffusealpha(forestscapeParam * math.sqrt(RangeScale(vz, -treeZExtend, 1.0, 1.0, 0.1)))
			end
		end
		for hi = 1,#hills do
			if hills[hi][1] then
				local vz = 1.0 - math.fmod(vt / 8.0 - hills[hi][2] - treeZExtend + ppz, ppz)
				hills[hi][1]:z(vz * treePlace[3])
							:diffusealpha(forestscapeParam)
			end
		end
	end

	if forestscapeParam > EPS then
		for pn = 1,2 do
			PlayerFullFrames[pn]:rotationx(-90 * forestscapeParam)
					  			:zoomx(1.0 + forestscapeParam * 0.5)
					  			:zoomy(1.0 + forestscapeParam * 1.0)
					  			:zoomz(1.0 + forestscapeParam * 0.5)
					  			:z(forestscapeParam * treePlace[3])
			--Trace('### plr '..pn..': RX = '..plr[pn]:GetRotationX()..', RY = '..plr[pn]:GetRotationY()..', RZ = '..plr[pn]:GetRotationZ())

			for lane = 1,4 do
				-- Dial in or out on the "confusionoffsetx".
				-- Separate from arrow pathing but uses some common objects.
				if pathActors[pn][lane] then
					local splRotHdl = pathActors[pn][lane][3]
					local splRotObj = splRotHdl:GetSpline()
					splRotHdl:SetSplineMode('NoteColumnSplineMode_Offset')
							 :SetBeatsPerT(1)
					splRotObj:SetSize(2)
							 :SetPoint(1, {forestscapeParam * PI/2, 0, 0})
							 :SetPoint(2, {forestscapeParam * PI/2, 0, 0})
							 :Solve()

					pathActors[pn][lane][1]:diffusealpha(forestscapeParam)
				end
			end
		end

		backplate:diffusealpha(forestscapeParam * 0.5)

		-- Don't preserve base rotation for the forestscape player container.
		PlayerTreeView:rotationy(forestscapeParam * (math.sin(vt * PI / 17.0) * 10.0 - 0.0))
			  		  :rotationx(forestscapeParam * (math.sin(vt * PI / 13.0) * 5.0 + 30.0))
	end

	--
	--	Perframing: trunk ascent
	--
	-------------------------------------------------------------------------------	
	

	for pn = 1,2 do
		if not proxiesCentered then
			plr[pn]:xy(0, 0)
		else
			--plr[pn]:xy(0, -135 * (1.0 - forestscapeParam))		-- TODO: why this height?
		end
		PlayerFullFrames[pn]:xy(0, -270 * (1.0 - forestscapeParam))	-- TODO: why this height?
	end

	-- Final step.
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
messageList = SortModsTable(messageList)

_FG_[#_FG_ + 1] = playerValleyAF

-- Load the HUD reducer into this script.
_FG_[#_FG_ + 1] = LoadActor("./hudreducer.lua")
Trace('### Forest: Loaded HUD Reducer')

-- Load the mods table parser into this script.
modsTable = {
	-- [1]: beat start
	-- [2]: mod type
	-- [3]: mod strength (out of unity),
	-- [4]: mod approach (in beats to complete)
	-- [5]: player application (1 = P1, 2 = P2, 3 = both, 0 = neither)
		
		{   0.0,	"ScrollSpeed",	niceSpeed,    8.0,	3}, 
		{   0.0,	"Dark",				  0.2,    8.0,	3}, 
--		{   0.0,	"Tipsy",			  1.0,    8.0,	3},  
--		{   0.0,	"Drunk",			  0.5,    8.0,	3},
		{   0.0,	"Beat",				  1.0,    8.0,	1}, 
		{   0.0,	"Beat",				 -1.0,    8.0,	2}, 
--		{   0.0,	"Tornado",			  1.0,    8.0,	3}, 
--		{   0.0,	"Flip",				 -0.1,    8.0,	3}, 
		{   0.0,	"Sudden",			  0.9,    8.0,	3}, 
		{   0.0,	"SuddenOffset",		  2.0,    8.0,	3}, 

		{ 191.0, 	"Reverse",			  1.0,	  1.0,  1},
		{ 253.0, 	"Reverse", 			  0.0,	  2.5,	1},
		{ 382.0, 	"Reverse", 			  1.0,	  2.0,	2},
		{ 444.0, 	"Reverse", 			  0.0,	  3.0,	2},
}
modsTable = SortModsTable(modsTable)
_FG_[#_FG_ + 1] = LoadActor("./modsHQ.lua", {modsTable, 0})
Trace('### Forest: Loaded mods HQ')


return _FG_

--##  END  UPSTREAM ###########################################################
--#############################################################################



