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

local whereTheFlipAmI = GAMESTATE:GetCurrentSong():GetSongDir()
dofile(whereTheFlipAmI .. 'lua/telpers.lua')

_FG_ = Def.ActorFrame {
	OnCommand = function(self)
		self:SetDrawByZPosition(true)
			:SetFOV(45)
	end,
	Def.Actor { 
		Name = "slep",
		OnCommand = function(self)
			self:sleep(1573)
		end
	}	
}

-- _FG_[#_FG_ + 1] = LoadActor('./diagnostic.lua')
-- _FG_[#_FG_]["OnCommand"] = function(self)
-- 	self:xy(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5)
-- 		:z(10)
-- 		:SetDrawByZPosition(true)
-- 		:SetFOV(45)
-- 		:linear(60)
-- 		:rotationx(1080)
-- end

-- _FG_[#_FG_ + 1] = LoadActor('./tree.lua')
-- _FG_[#_FG_]["OnCommand"] = function(self)
-- 	self:xy(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5)
-- 		:z(10)
-- 		:rotationx(-60)
-- 		:SetDrawByZPosition(true)
-- 		:SetFOV(45)
-- end



--[[
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
-- tree nodes
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
--]]


perturbances = {
	spreadin = 0,	-- 0: perturbance of phi, degrees
	rotation = 0,	-- 1: perturbance of theta, degrees
	lengthen = 0,	-- 2: perturbance of length, proportion of full-scale
	coloring = 0,	-- 3: perturbance of leaf color
	unfurled = 0,	-- 4: perturbance to fold phi, proportion of full-scale
}



_TN_ = {
	from = -1,
	ph = 0,
	th = 0,
	ll = 0,
	leaf = true,

	new = function(self, o)
		local tn = {}
		setmetatable(tn, self)
		self.__index = self

	    tn.from = o and o.from 	or -1
	    tn.ph 	= o and o.ph 	or 0
	    tn.th 	= o and o.th 	or 0
	    tn.ll 	= o and o.ll 	or 0
	    tn.leaf = o and o.leaf 	or true

	    return tn
	end,

	Perturb = function(self)
		local ret = _TN_:new()

	    ret.ph = (self.ph + perturbances.spreadin*math.pi/180) * (1.0 - perturbances.unfurled)
	    ret.th =  self.th + perturbances.rotation*math.pi/180
	    ret.ll =  self.ll * (1.0 + perturbances.lengthen)
	    return ret
	end,
  
	FullCoord = function(self, nodeList)
		if self.from <= 0 then
			return _TN_:new()
		else
			local ref = nodeList[self.from]:FullCoord(nodeList)
			local psf = self:Perturb()

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
	    	self.ll*math.sin(self.ph)*math.sin(self.th)
	    }
	end,

	FullDist = function(self, nodeList)
		if self.from <= 0 then
			return 0
		else
			return self:FullCoord(nodeList).ll
		end
	end,
}



trees = {}
treeMeta = {
	nTrees = 12,
	maxTreeSize = 300,
	maxTreeGen = 6,
	fullScale = math.min(G.W, G.H) * 0.6,
}
treeMeta.leafSize = treeMeta.fullScale*0.05
treeMeta.trunkThk = treeMeta.fullScale*0.01

for i = 1,treeMeta.nTrees do
	trees[i] = {_TN_:new()}
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

			if zo < 0.02 then return 1
		elseif zo < 0.20 then return 3
		elseif zo < 0.60 then return 5
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
					from = i,
					ph = treePDF.phi({zo = parPhi}),
					th = treePDF.the({zo = parThe, buds = buds, budIndex = j}),
					ll = treePDF.len({zo = parLen, dist = tt[i]:FullDist(tt)})
					})
				Trace(
					x ..
					": origin = "		.. i ..
					", bud = "			.. j ..
					", phi = "			.. tt[x].ph * 180/math.pi ..
					"deg, theta = "		.. tt[x].th * 180/math.pi ..
					"deg, len = "		.. tt[x].ll ..
					", total len = "	.. tt[x]:FullDist(tt)
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

for i = 1,1 do
	treeMeta.Plant(i)
end




for i = 0,20 do
	local QCoords = {
		{
			{-0.8*G.W, -0.8*G.H, 0},
			{0.0, 0.0, 1.0, 0.3},
			{0.0, 0.0}
		},
		{
			{ 0.8*G.W, -0.8*G.H, 0},
			{0.0, 1.0, 0.0, 0.2},
			{1.0, 0.0}
		},
		{
			{ 0.8*G.W,  0.8*G.H, 0},
			{1.0, 0.0, 0.0, 0.1},
			{1.0, 1.0}
		},
		{
			{-0.8*G.W,  0.8*G.H, 0},
			{0.5, 0.5, 0.5, 0.0},
			{0.0, 1.0}
		},
	}
	_FG_[#_FG_ + 1] = Def.ActorMultiVertex {
		InitCommand = function(self)
			self:xy(G.W*0.5, G.H*0.5)
				:z(i*50 - 500)
				:SetVertices(QCoords)
				:SetDrawState({
					Mode = "DrawMode_Quads",
					First = 1,
					Num = -1
					})
		end
	}
end

for i = 1,20 do
	local iDelay = i * 3
	local iSpeed = math.random() * 6 + 12
	local iDir = (math.random() * 90 - 45) * math.pi / 180
	local iButty = math.random(8)

	local iTempy = LoadActor('./butt.lua', iButty)
	iTempy["OnCommand"] = function(self)
		self:zoom(0.25)
			:rotationx(-60)
	end

	_FG_[#_FG_ + 1] = Def.ActorFrame {
		iTempy,
		OnCommand = function(self)
			self:SetDrawByZPosition(true)
				:SetFOV(45)
				:rotationy(iDir * 180 / math.pi)
				:z(500)
				:xy(G.W * (0.5 - 0.7*math.tan(iDir)), G.H * (1.0 + 0.2*math.random()))

			self:sleep(iDelay)
				:queuecommand("FlyAway")		
		end,
		FlyAwayCommand = function(self)
			self:accelerate(iSpeed)
				:xy(G.W * (0.5 + 0.7*math.tan(iDir)), G.H * (0.0 - 0.5*math.random()))
				:z(-500)
		end
	}
end


-- Load the HUD reducer into this script.
_FG_[#_FG_ + 1] = LoadActor("./hudreducer.lua")

return _FG_