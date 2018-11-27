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