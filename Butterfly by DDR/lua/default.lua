-------------------------------------------------------------------------------
--
--		NAOKI feat. PAULA TERRY - "BUTT***** -CHUNITHM ver.-"
--		Special Content
--		
--		Author: 	Telperion
--		Date: 		2018-11-25
--
--
--		A fresh take on a classic song.
--		Happy Thanksgiving, Konami.
--		Now give me Night of Knights Challenge
--
-------------------------------------------------------------------------------

local G = {}
G.W = SCREEN_WIDTH
G.H = SCREEN_HEIGHT
G.BPS = 145.0 / 60.0		-- GAMESTATE:GetSongBPS()
G.T = 0
G.T_offset = 0
G.msg = 0
G.exe = 0
G.per = 0
G.P = {}

G.Zmax =  5
G.Zmin = -5

telp = nil

-- Load helpful support functions and constants.
local whereTheFlipAmI = GAMESTATE:GetCurrentSong():GetSongDir()
dofile(whereTheFlipAmI .. 'lua/telpers.lua')

-- Keep-alive and super global initializations happen here.
local _FG_ = Def.ActorFrame {
	BeginCommand = function(self)
		self:SetDrawByZPosition(true)
			:SetFOV(45)

		G.P[1] = SCREENMAN:GetTopScreen():GetChild('PlayerP1')
		G.P[2] = SCREENMAN:GetTopScreen():GetChild('PlayerP2')

		for pn = 1,2 do
			if G.P[pn] then
				G.P[pn]:visible(false)
				G.P[pn]:GetChild("Judgment"):visible(false)
			end
		end
	end,
	Def.Actor { 
		Name = "slep",
		OnCommand = function(self)
			self:sleep(1573)
		end
	}	
}

-- Set up proxies!
local prox = {
	{},					-- Multiples allowed!
	{},					-- For both players.
}
local proxJud = {}		-- There'll only be two of these.


for pn = 1,2 do
	local pnLoc = pn
	_FG_[#_FG_ + 1] = Def.ActorProxy {
		Name = "ProxyP"..pnLoc,
		InitCommand = function(self)				
			prox[pnLoc][1] = self
			self:AddWrapperState()
			self:AddWrapperState()
		end,
		BeginCommand = function(self)
			if G.P[pnLoc] then
				self:SetTarget(G.P[pnLoc])
				Trace("### Player proxy for P"..pnLoc.." target set!")
			else
				--self:hibernate(1573)
				Trace("### Player proxy for P"..pnLoc.." not needed!")
			end
		end,
		OnCommand = function(self)
			if G.P[pnLoc] then
				self:z(4)
				self:GetWrapperState(1)					-- Encase in a wrapper state that cancels out the original position.
					:xy(-self:GetTarget():GetX(), -self:GetTarget():GetY())
				self:GetWrapperState(2)					-- Then encase in a wrapper state that can be individually moved as desired.
					:xy(G.W*(0.5*pnLoc - 0.25), G.H*0.5)
				Trace("### Player proxy for P"..pnLoc.." location set! (X = "..self:GetTarget():GetX()..", Y = "..self:GetTarget():GetY()..")")
			else
				Trace("### Player proxy for P"..pnLoc.." location update not needed!")
			end
		end,
		RecenterProxyMessageCommand = function(self)
			if G.P[pnLoc] then
				self:GetWrapperState(1)
					:xy(-self:GetTarget():GetX(), -self:GetTarget():GetY())			
				Trace("### Player proxy for P"..pnLoc.." location recentered! (X = "..self:GetTarget():GetX()..", Y = "..self:GetTarget():GetY()..")")		
			else
				Trace("### Player proxy for P"..pnLoc.." location update not needed!")
			end
		end,
	}

	_FG_[#_FG_ + 1] = Def.ActorProxy {
		Name = "JudgeProxyP"..pnLoc,
		InitCommand = function(self)				
			proxJud[pnLoc] = self
			self:AddWrapperState()
			self:AddWrapperState()
		end,
		BeginCommand = function(self)
			if G.P[pnLoc] then
				self:SetTarget(G.P[pnLoc]:GetChild("Judgment"))
				Trace("### Judgment proxy for P"..pnLoc.." target set!")
			else
				--self:hibernate(1573)
				Trace("### Judgment proxy for P"..pnLoc.." not needed!")
			end
		end,
		OnCommand = function(self)
			if G.P[pnLoc] then
				self:z(5)
				self:GetWrapperState(1)					-- Encase in a wrapper state that cancels out the original position.
					:xy(-self:GetTarget():GetX(), -self:GetTarget():GetY())
				self:GetWrapperState(2)					-- Then encase in a wrapper state that can be individually moved as desired.
					:xy(G.W*(0.6*pnLoc - 0.4), G.H*0.5)
					:zoom(0.7)							-- Judgment doesn't need to be that big lol
				Trace("### Judgment proxy for P"..pnLoc.." location set!")
			else
				Trace("### Judgment proxy for P"..pnLoc.." location update not needed!")
			end
		end,
	}
end


-- _FG_[#_FG_ + 1] = LoadActor('./diagnostic.lua')
-- _FG_[#_FG_]["OnCommand"] = function(self)
-- 	self:xy(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5)
-- 		:z(10)
-- 		:SetDrawByZPosition(true)
-- 		:SetFOV(45)
-- 		:linear(60)
-- 		:rotationx(1080)
-- end



--[[
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
-- tree nodes
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
--]]

trees = {}
treeMeta = {
	nTrees = 24,
	maxTreeSize = 120,
	maxTreeGen = 6,
	fullScale = math.min(G.W, G.H) * 1.1,
	zScale = 1.00,
}
treeMeta.leafSize = treeMeta.fullScale*0.05
treeMeta.trunkThk = treeMeta.fullScale*0.01
treeActors = {}
treeCoords = {}
treesInit = {}


_PTBN_ = {
	spreadin = 0,	-- 0: perturbance of phi, degrees
	rotation = 0,	-- 1: perturbance of theta, degrees
	lengthen = 0,	-- 2: perturbance of length, proportion of full-scale
	coloring = 0,	-- 3: perturbance of leaf color
	unfurled = 0,	-- 4: perturbance to fold phi, proportion of full-scale

	new = function(self, o)
		local ptbn = {}
		setmetatable(ptbn, self)
		self.__index = self

	    ptbn.spreadin = o and o.spreadin or 0
	    ptbn.rotation = o and o.rotation or 0
	    ptbn.lengthen = o and o.lengthen or 0
	    ptbn.coloring = o and o.coloring or 0
	    ptbn.unfurled = o and o.unfurled or 0

	    return ptbn
	end,
}

perturbances = {}
for i = 1,treeMeta.nTrees do
	perturbances[i] = _PTBN_:new()
end



_TN_ = {
	whom = -1,		-- which tree this node belongs to (ick!)
	from = -1,		-- which node index in the tree node list *this* node grew from
	ph = 0,			-- phi, elevation/spreading parameter
	th = 0,			-- theta, azimuthal/rotation parameter
	ll = 0,			-- length of branch to this node
	leaf = true,	-- am I a leaf?? who the henk know

	new = function(self, o)
		local tn = {}
		setmetatable(tn, self)
		self.__index = self

	    tn.whom = o and o.whom 	or -1
	    tn.from = o and o.from 	or -1
	    tn.ph 	= o and o.ph 	or 0
	    tn.th 	= o and o.th 	or 0
	    tn.ll 	= o and o.ll 	or 0
	    tn.leaf = o and o.leaf 	or true

	    return tn
	end,

	Perturb = function(self)
		local ret = _TN_:new()
		local ptbn = (self.whom > 0) and perturbances[self.whom] or _PTBN_:new()

	    ret.ph = (self.ph + ptbn.spreadin*DEG_TO_RAD) * (1.0 - ptbn.unfurled)
	    ret.th =  self.th + ptbn.rotation*DEG_TO_RAD
	    ret.ll =  self.ll * (1.0 + ptbn.lengthen)
	    return ret
	end,
  
	FullCoord = function(self)
		if self.from <= 0 then
			return _TN_:new()
		else
			local ref = trees[self.whom][self.from]:FullCoord()
			local psf = self --self:Perturb()

      		local rcp = math.cos(ref.ph)
      		local rsp = math.sin(ref.ph)
      		local rct = math.cos(ref.th)
      		local rst = math.sin(ref.th)
      		local bcp = math.cos(ref.ph + psf.ph)
      		local bsp = math.sin(ref.ph + psf.ph)
     		local bct = math.cos(ref.th + psf.th)
      		local bst = math.sin(ref.th + psf.th)
      		local rll = ref.ll
      		local bll = psf.ll
      
  			-- Recall that phi is measured from apex downward to horizon.
      		local x = rll*rsp*rct + bll*bsp*bct
      		local y = rll*rcp     + bll*bcp
      		local z = rll*rsp*rst + bll*bsp*bst
      
		    ref.th = math.atan2(z, x)
		    ref.ph = math.atan2(math.sqrt(x*x + z*z), y)
		    ref.ll = math.sqrt(x*x + y*y + z*z)
--		    Trace("@@@ FullCoord calc: len = "..ref.ll.." up to "..self.from)
		    return ref
		end
	end,

	ToCartesian = function(self)	
	    return {
	    	self.ll*math.sin(self.ph)*math.cos(self.th),
	    	self.ll*math.cos(self.ph),
	    	self.ll*math.sin(self.ph)*math.sin(self.th) * treeMeta.zScale
	    }
	end,

	FullDist = function(self, nodeList)
		if self.from <= 0 then
			return 0
		else
			return self:FullCoord().ll
		end
	end,
}




for i = 1,treeMeta.nTrees do
	trees[i] = {_TN_:new()}
	trees[i][1].whom = i
	treeActors[i] = {}			-- leaves, branches
	treeCoords[i] = {{}, {}}	-- leaves, branches
	treesInit[i] = false
end


--[[
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
-- replicator functions
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
--]]

treePDF = {
	bud = function(params)
		local zo = params.zo or 0
		local gp = params.gp or 0

		zo = zo * gp

			if zo < 0.15 then return 1
		elseif zo < 0.30 then return 3
		elseif zo < 0.70 then return 5
		else                  return 0
		end
	end,

	the = function(params)
		local zo       = params.zo       or 0
		local buds     = params.buds     or 0
		local budIndex = params.budIndex or 0

		return (zo + budIndex) * 2 * math.pi / buds
	end,

	phi = function(params)
		local zo = params.zo or 0

		return math.pi / 12 + (zo*zo) * math.pi / 12
		-- return math.pi / 6
	end,

	len = function(params)
		local zo   = params.zo   or 0
		local dist = params.dist or 0

		return 0.3 * (0.5 + 3.0*zo*zo - 2.0*zo*zo*zo) * (treeMeta.fullScale - dist)
		-- return 0.5 * (fullScale - fullDist)
	end,
}


treeMeta.Growth = function(treeIndex, gen)
	local tt = trees[treeIndex]
	local xHold = #trees[treeIndex]
	local x = xHold

	for i = 1,xHold do
		parBud = math.random()
		parThe = math.random()
		parPhi = math.random()
		parLen = math.random()

		if trees[treeIndex][i].leaf then
			local buds = treePDF.bud({zo = parBud, gp = (gen-1)/(treeMeta.maxTreeGen-1)})
			for j = 1,buds do
				x = x + 1
				trees[treeIndex][x] = _TN_:new({
					whom = treeIndex,
					from = i,
					ph = treePDF.phi({zo = parPhi}),
					th = treePDF.the({zo = parThe, buds = buds, budIndex = j}),
					ll = treePDF.len({zo = parLen, dist = tt[i]:FullDist()})
					})
				Trace(
					x ..
					": origin = "		.. i ..
					", bud = "			.. j ..
					", phi = "			.. tt[x].ph * 180/math.pi ..
					"deg, theta = "		.. tt[x].th * 180/math.pi ..
					"deg, len = "		.. tt[x].ll ..
					", total len = "	.. tt[x]:FullDist()
					)

				if x > treeMeta.maxTreeSize then
					Trace(i .. ": early stop!")
					break
				end
			end
			if buds > 0 then
				trees[treeIndex][i].leaf = false
				Trace(i .. ": no longer a leaf")
			else
				Trace(i .. ": still a leaf")
			end
		end


		if x > treeMeta.maxTreeSize then
			Trace(i .. ": early stop!")
			break
		end
	end
end


treeMeta.Plant = function(treeIndex)
	trees[treeIndex] = {_TN_:new()}
	for i = 1,treeMeta.maxTreeGen do
		Trace("Tree "..treeIndex..", Growth Period "..i..": Begin")
		treeMeta.Growth(treeIndex, i)
		Trace("Tree "..treeIndex..", Growth Period "..i..": End")
	end
end



--[[
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
-- start drawing stuff
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
--]]

for i = 1,treeMeta.nTrees do
	treeMeta.Plant(i)
end

local _SQRT3DIV6 = math.sqrt(3)/6
local _SQRT3DIV3 = math.sqrt(3)/3

function CalculateTreePositions(setupOnce)
	setupOnce = setupOnce or false	-- ONLY CALL WITH THIS PARAMETER ONCE!

	for i = 1,treeMeta.nTrees do		
		local TCart = {}			-- All cartesian coordinates
		for j = 1,#trees[i] do
			TCart[j] = trees[i][j]:FullCoord():Perturb():ToCartesian()
		end

		local leafIndex = 0
		for j = 2,#trees[i] do 		-- We don't need to draw the root; start from index 2
			local nodeCoord = TCart[j]

			-- Draw leaves as leaves.
			if trees[i][j].leaf then
				treeCoords[i][1][3*leafIndex + 1] =	{
					{nodeCoord[1]+treeMeta.leafSize*0.5, -nodeCoord[2]-treeMeta.leafSize*_SQRT3DIV6, nodeCoord[3]+0.001},
					{1.0, 1.0, 0.7, 1.0},
					{0.0, 0.0}
				}
				treeCoords[i][1][3*leafIndex + 2] =	{
					{nodeCoord[1]-treeMeta.leafSize*0.5, -nodeCoord[2]-treeMeta.leafSize*_SQRT3DIV6, nodeCoord[3]+0.001},
					{0.7, 1.0, 1.0, 1.0},
					{0.0, 1.0}
				}
				treeCoords[i][1][3*leafIndex + 3] =	{
					{nodeCoord[1], -nodeCoord[2]+treeMeta.leafSize*_SQRT3DIV3, nodeCoord[3]+0.001},
					{0.7, 1.0, 0.7, 0.8},
					{1.0, 1.0}
				}
				leafIndex = leafIndex + 1
			end
		end

		for j = 2,#trees[i] do 		-- We don't need to draw the root; start from index 2
			-- Draw connecting branch.
			local nodeCoord = TCart[j]
			local fromCoord = TCart[trees[i][j].from]
			local branchTaper = trees[i][j].leaf and 1 or 1		-- and 0 or 1 for actual taper effect...
			treeCoords[i][2][j*4 - 7] =	{
				{nodeCoord[1]-treeMeta.trunkThk*0.5*branchTaper, -nodeCoord[2], nodeCoord[3]},
				{1.0, 1.0, 1.0, 1.0},
				{0.0, 0.0}
			}
			treeCoords[i][2][j*4 - 6] =	{
				{nodeCoord[1]+treeMeta.trunkThk*0.5*branchTaper, -nodeCoord[2], nodeCoord[3]},
				{1.0, 1.0, 1.0, 1.0},
				{0.0, 1.0}
			}
			treeCoords[i][2][j*4 - 5] =	{
				{fromCoord[1]+treeMeta.trunkThk*0.5, -fromCoord[2], fromCoord[3]},
				{1.0, 1.0, 1.0, 0.8},
				{1.0, 1.0}
			}
			treeCoords[i][2][j*4 - 4] =	{
				{fromCoord[1]-treeMeta.trunkThk*0.5, -fromCoord[2], fromCoord[3]},
				{1.0, 1.0, 1.0, 0.8},
				{1.0, 0.0}
			}
		end


		if setupOnce then
			local treeRow = (i-1)%4
			local treeCol = math.floor((i-1)/4)
			_FG_[#_FG_ + 1] = Def.ActorMultiVertex {
				InitCommand = function(self)
					treeActors[i][2] = self
					self:xy(G.W*0.5, G.H*1.0)
						:z(0)
						:SetVertices(treeCoords[i][2])
						:SetDrawState({
							Mode = "DrawMode_Quads",
							First = 1,
							Num = -1
							})
						:diffuse({0.2, 0.1, 0.0, 0.7})
				end
			}
			_FG_[#_FG_ + 1] = Def.ActorMultiVertex {
				InitCommand = function(self)
					treeActors[i][1] = self
					self:xy(G.W*0.5, G.H*1.0)
						:z(0)
						:SetVertices(treeCoords[i][1])
						:SetDrawState({
							Mode = "DrawMode_Triangles",
							First = 1,
							Num = -1
							})
						:diffuse({0.0, 0.5, 0.0, 0.9})
				end
			}
		end
	end
end

function CalculateTreePositions_Cheap()
	for i = 1,treeMeta.nTrees do
		local treeRGB = telp.HSV2RGB({0.3-perturbances[i].coloring*0.3, 1.0, 0.5 + perturbances[i].coloring*0.5})
		for j = 1,2 do 	-- leaves, branches
			if treeActors[i][j] then
				treeActors[i][j]:zoomx((1 + perturbances[i].spreadin * 0.05) * perturbances[i].unfurled)
								:zoomy(1 - perturbances[i].spreadin * 0.05)
								:zoomz(1 + perturbances[i].spreadin * 0.05)
								:rotationy(perturbances[i].rotation)

				if j == 1 then
					treeActors[i][j]:diffuse({treeRGB[1], treeRGB[2], treeRGB[3], 0.9})
				end
			end
		end
	end
end

CalculateTreePositions(true)	-- ONLY CALL WITH THIS PARAMETER ONCE!!


for i = 0,20 do
	local QCoords = {
		{
			{-0.6*G.W, -0.6*G.H, 0},
			{0.0, 0.5, 0.3, i*0.01},
			{0.0, 0.0}
		},
		{
			{ 0.6*G.W, -0.6*G.H, 0},
			{0.0, 0.5, 0.3, i*0.01},
			{1.0, 0.0}
		},
		{
			{ 0.6*G.W,  0.6*G.H, 0},
			{0.0, 0.1, 0.0, i*0.04},
			{1.0, 1.0}
		},
		{
			{-0.6*G.W,  0.6*G.H, 0},
			{0.0, 0.1, 0.0, i*0.04},
			{0.0, 1.0}
		},
	}
	_FG_[#_FG_ + 1] = Def.ActorMultiVertex {
		InitCommand = function(self)
			self:xy(G.W*0.5, G.H*0.5)
				:z(-0.5*i + 5)
				:SetVertices(QCoords)
				:SetDrawState({
					Mode = "DrawMode_Quads",
					First = 1,
					Num = -1
					})
		end
	}
end



butts = {
	nButts = 30,
	buttActors = {},
	buttDest = {},
	buttSpeed = {},
}
for i = 1,butts.nButts do
	butts.buttDest[i] = 'C'
	butts.buttSpeed[i] = (math.random() * 6 + 12)
end

for iButty = 1,butts.nButts do
	local iTempy = LoadActor('./butt.lua', {iButty, 1 / G.BPS})
	iTempy["OnCommand"] = function(self)
		self:zoom(0.25)
			:rotationx(-60)
	end

	_FG_[#_FG_ + 1] = Def.ActorFrame {
		iTempy,
		InitCommand = function(self)
			butts.buttActors[iButty] = self
		end,
		OnCommand = function(self)
			self:visible(false)
		end,
		FlyAwayCommand = function(self)
			self:visible(true)
				:accelerate(butts.buttSpeed[iButty] / G.BPS)
				:xy(butts.buttDest[iButty][1], butts.buttDest[iButty][2])
				:zoom(0.2)
				:z(G.Zmin)
				:queuecommand("HideAway")
		end,
		HideAwayCommand = function(self)
			self:visible(false)
		end,
	}
end


-- ehehe
_FG_[#_FG_ + 1] = Def.Sprite {
	Name = "gull",
	Texture = "butts/gull",
	InitCommand = function(self)
		self:SetAllStateDelays(1 / (G.BPS * 13))
			:xy(G.W*(math.random()*0.3+0.7), G.H*1.2)
			:z(G.Zmax)
			:zoom(1.5)
	end,
	OnCommand = function(self)
		self:visible(false)
	end,
	ButtergullMessageCommand = function(self)
		self:visible(true)
			:accelerate(12 / G.BPS)
			:xy(G.W*(math.random()*0.3), G.H*-0.2)
			:zoom(0.2)
			:z(G.Zmin)
			:queuecommand("HideAway")
	end,
	HideAwayCommand = function(self)
		self:visible(false)
	end,
}
	

--[[
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
-- this is where the shit will be happening
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
--]]

perframes = {
	PerturbTrees = function(t)		
		for i = 1,treeMeta.nTrees do
			perturbances[i].spreadin = 0.2 * math.cos(2*PI*G.T / 1)
			perturbances[i].rotation = 12 * math.sin(2*PI*G.T / 16)
			perturbances[i].coloring = 0.5 * math.sin(2*PI*(G.T / 27 + i * 7 / treeMeta.nTrees)) + 0.5
			perturbances[i].lengthen = 0
			perturbances[i].unfurled = 1
		end		
	end,
	ColorTrees = function(t, p)
		ind = p.ind or -1
		rev = p.rev or false

		if ind > 0 then
			perturbances[ind].coloring = rev and t or 1-t
		else
			for i=1,treeMeta.nTrees do
				perturbances[i].coloring = rev and t or 1-t
			end
		end
	end,
	MoveTrees = function(t, p)
		for i = 1,treeMeta.nTrees do
			local tCol = 			(i-1) % 3
			local tRow = math.floor((i-1) / 3)
			local tSweep = G.T + math.sin(2*PI*G.T)/(8*PI)
			local tNear = ((tSweep - tRow) % 8) * 0.25
			local tPose = (math.floor((tSweep - tRow) / 8) + tCol) % 3
			local tZ = tNear * (G.Zmax-G.Zmin) + G.Zmin
			Trace("### i = "..i..", tZ = "..tZ)

			for j = 1,2 do
				if treeActors[i][j] then
					treeActors[i][j]
						:xy(
							G.W*(0.5 + (tPose-1)*0.4 + 0.1*math.sin(2*PI*(tSweep - tRow) / 7)),
							G.H*1.0
						)
						:z(tZ)
						:zoom(telp.clamp(tNear*0.5, 0, 1)*1.5+0.5)
						:visible(tZ > G.Zmin)
				end
			end
		end
	end,
	FadeTrees = function(t, p)
	end,
}
executes = {
	CastButts = function(p)
		local corn = p[1] or 'C'
		local selMin = p[2] or 1
		local selMax = p[3] or butts.nButts
		local delayRange = p[4] or 0
		local maxTransit = p[5] or 6
		local delays = telp.randlist(selMax-selMin+1)

		for i = selMin,selMax do			
			if butts.buttActors[i] then
--				butts.buttActors[i]:GetChild():z()
--				butts.buttActors[i]:GetChild():z()
				local xOrigin = G.W * (0.5 + (math.random()-0.5)*0.6*(corn == 'D' and 2 or 1))
				local yOrigin = G.H * 1.2

				butts.buttDest[i] = {G.W * (0.5 + (math.random()-0.5)*0.6*(corn == 'D' and 2 or 1)), G.H * -0.2}
				if corn == 'L' then
					xOrigin = G.W * -0.2
					if math.random() < 0.5 then
						butts.buttDest[i] = {
							G.W * (1.2),
							G.H * (-0.2 + math.random()*0.6),
						}
					else
						butts.buttDest[i] = {
							G.W * (1.2 - math.random()*0.6),
							G.H * (-0.2),
						}
					end
				end
				if corn == 'R' then
					xOrigin = G.W *  1.2
					if math.random() < 0.5 then
						butts.buttDest[i] = {
							G.W * (-0.2),
							G.H * (-0.2 + math.random()*0.6),
						}
					else
						butts.buttDest[i] = {
							G.W * (-0.2 + math.random()*0.6),
							G.H * (-0.2),
						}
					end
				end

				local iDelayProp = delays[i-selMin+1]/#delays
				local iSleep = math.sqrt(iDelayProp) * delayRange
				butts.buttSpeed[i] = math.sqrt(1 - iDelayProp*0.5) * maxTransit
				local iDir = math.atan2(butts.buttDest[i][1]-xOrigin, butts.buttDest[i][2]-yOrigin)		-- backwards on purpose!!
				
				butts.buttActors[i] :xy(xOrigin, yOrigin)
									:z(G.Zmax)
									:rotationy(iDir / DEG_TO_RAD)
									:zoom(2)
									:sleep(iSleep / G.BPS)
									:queuecommand("FlyAway")
			end
		end
	end,
}


local messageList = {
	-- [1]: beat number to issue message on
	-- [2]: message title
	-- [3]: optional table of arguments passed to message

--	{  0.00, "RecenterProxy"},
	{240.00 + math.random(0,3) * 4, "Buttergull"},
}

local executeList = {
	-- [1]: beat number execute occurs on
	-- [2]: function to execute on this beat or as nearly after as possible
	-- [3]: further parameters to the execute function

	{  0.00, executes.CastButts, {'L',  1, 10, 16, 12} },
	{  8.00, executes.CastButts, {'R', 11, 20, 16, 12} },
	{ 16.00, executes.CastButts, {'C', 21, 30, 16, 12} },

	{ 32.00, executes.CastButts, {'L',  1, 10,  4, 4} },
	{ 36.00, executes.CastButts, {'R', 11, 20,  4, 4} },
	{ 40.00, executes.CastButts, {'C', 21, 30,  4, 4} },

	{ 96.00, executes.CastButts, {'L',  1, 10, 16, 12} },
	{104.00, executes.CastButts, {'R', 11, 20, 16, 12} },
	{112.00, executes.CastButts, {'C', 21, 30, 16, 12} },

	{239.00, executes.CastButts, {'D',  1, 15,  3, 6} },
	{243.00, executes.CastButts, {'D', 16, 30,  3, 6} },
	{247.00, executes.CastButts, {'D',  1, 15,  3, 6} },
	{251.00, executes.CastButts, {'D', 16, 30,  3, 6} },
}

local perframeList = {
	-- [1]: beat number perframe begins on
	-- [2]: beat number perframe ends on
	-- [3]: function to execute that accepts progress through this perframe scaled from 0 to 1
	--		(beat time is still accessible ofc)
	-- [4]: further parameters to the perframe function

	{  0.00, 512.00, perframes.PerturbTrees },

	{  0.00, 512.00, perframes.MoveTrees },
}

-- Time-based effects.
function ButtUpdate(self)
	-- Most things are determined by beat, believe it or not.		
	G.T = GAMESTATE:GetSongBeat() + G.T_offset
	
	-- TODO: this assumes the effect applies over a constant BPM section!!
	G.BPS = GAMESTATE:GetSongBPS()

	-- I`ve binch
	CalculateTreePositions_Cheap()
			
	-- Broadcast messages on their own terms.
	while true do
		if G.msg < #messageList then
			local messageBeat, messageName, messageArgs = unpack(messageList[G.msg+1])
			if G.T >= messageBeat then			
				if messageArgs then
					MESSAGEMAN:Broadcast( messageName, messageArgs )
				else
					MESSAGEMAN:Broadcast( messageName )
				end
				
				G.msg = G.msg + 1
			else
				break;
			end
		else
			break;
		end
	end

	-- Executes as they appear.
	while true do
		if G.exe < #executeList then
			local executeBeat, executeFunc, executeArgs = unpack(executeList[G.exe+1])
			if G.T >= executeBeat then			
				if executeArgs then
					executeFunc(executeArgs)
				else
					executeFunc()
				end
				
				G.exe = G.exe + 1
			else
				break;
			end
		else
			break;
		end
	end

	-- Perframes, any or all, all the time.
	for pfi = 1,#perframeList do
		pfParams = perframeList[pfi]
		if pfParams[1] < G.T and G.T < pfParams[2] then		
			local pft = telp.clamp(G.T, pfParams[1], pfParams[2])
			if pfParams[4] then
				pfParams[3](pft, pfParams[4])
			else
				pfParams[3](pft)
			end
		end
	end

end
_FG_[#_FG_ + 1] = Def.ActorFrame {
	Name = "Timekeeper",
	InitCommand = function(self)
		self:SetUpdateFunction(ButtUpdate)
	end,
}


-- Load the HUD reducer into this script.
_FG_[#_FG_ + 1] = LoadActor("./hudreducer.lua")

-- Load the mods table parser into this script.
niceSpeed = (420 + 69) / 145			-- This song is 145 BPM.
modsTable = {
	-- [1]: beat start
	-- [2]: mod type
	-- [3]: mod strength (out of unity),
	-- [4]: mod approach (in beats to complete)
	-- [5]: player application (1 = P1, 2 = P2, 3 = both, 0 = neither)
		
--		{   0.0,	"ScrollSpeed",	niceSpeed,    8.0,	3}, 
		{   0.0,	"Dark",				  0.5,    8.0,	3}, 
}
_FG_[#_FG_ + 1] = LoadActor("./modsHQ.lua", {modsTable, 0.009, false})

return _FG_