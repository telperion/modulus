-------------------------------------------------------------------------------
--
--		Diagnostic AMV Test
--		
--		Author: 	Telperion
--		Date: 		2018-11-25
--
-------------------------------------------------------------------------------

local T = Def.ActorFrame {
	Def.Actor { 
		Name = "slep",
		OnCommand = function(self) self:sleep(1573) end
	},

	InitCommand = function(self)
	end,
	OnCommand = function(self)
	end,
}

local tAMVs = Def.ActorFrame {
	Name = "ElementsTest",

	InitCommand = function(self)
		self:SetDrawByZPosition(true)
	end,
	OnCommand = function(self)
	end,
}
local tCoords = {}

local NR = 8
local NC = 12
local fullW = 480
local fullH = 360
local eaSep = 20
local sizeW = (fullW-(NC-1)*eaSep)/NC
local sizeH = (fullH-(NR-1)*eaSep)/NR
local ptZ = 10

for i = 1,(NR*NC) do
	local i0 = i - 1
	local iR = math.floor(i0/NC)
	local iC = i0 % NC
	local iN = i0 / (NR*NC-1.0) * 0.5 + 0.5

	local cX = sizeW*(0.5+iC) + eaSep*iC - fullW*0.5
	local cY = sizeH*(0.5+iR) + eaSep*iR - fullH*0.5

	tCoords[i] = {
		{
			{0.0, 0.0, -ptZ},
			{1.0, 1.0, 1.0, 0.5},
			{0.5, 0.5}
		},
		{
			{-sizeW*0.5, -sizeH*0.5, ptZ},
			{1.0, 0.0, iN, 1.0},
			{0.5, 0.5}
		},
		{
			{ sizeW*0.5, -sizeH*0.5, ptZ},
			{1.0, 1.0, iN, 1.0},
			{0.5, 0.5}
		},

		{
			{0.0, 0.0, -ptZ},
			{1.0, 1.0, 1.0, 0.5},
			{0.5, 0.5}
		},
		{
			{ sizeW*0.5,  sizeH*0.5, ptZ},
			{iN, 0.0, 1.0, 1.0},
			{0.5, 0.5}
		},
		{
			{-sizeW*0.5,  sizeH*0.5, ptZ},
			{iN, 1.0, 1.0, 1.0},
			{0.5, 0.5}
		},


		{
			{0.0, 0.0, ptZ},
			{0.0, 0.0, 0.0, 0.5},
			{0.5, 0.5}
		},
		{
			{-sizeW*0.5, -sizeH*0.5, -ptZ},
			{0.0, 0.0, iN, 1.0},
			{0.5, 0.5}
		},
		{
			{-sizeW*0.5,  sizeH*0.5, -ptZ},
			{0.0, 1.0, iN, 1.0},
			{0.5, 0.5}
		},

		{
			{0.0, 0.0, ptZ},
			{0.0, 0.0, 0.0, 0.5},
			{0.5, 0.5}
		},
		{
			{ sizeW*0.5,  sizeH*0.5, -ptZ},
			{iN, 0.0, 0.0, 1.0},
			{0.5, 0.5}
		},
		{
			{ sizeW*0.5, -sizeH*0.5, -ptZ},
			{iN, 1.0, 0.0, 1.0},
			{0.5, 0.5}
		},
	}
	tAMVs[#tAMVs+1] = Def.ActorMultiVertex {		
		InitCommand = function(self)
			self:aux(i)
				:xy(cX, cY)
				:SetVertices(tCoords[i])
				:SetDrawState({
					Mode = "DrawMode_Triangles",
					First = 1,
					Num = -1
					})
			Trace("### hello to "..i.."!")
		end,
		OnCommand = function(self)
			self:rotationz(1080.0*(self:getaux() / (NR*NC-1.0) - 0.5))
				:decelerate(10.0)
				:rotationz(0.0)
			Trace("### hey from "..self:getaux().."!")
		end,
	}
end

for i = 1,#tAMVs do
	T[#T+1] = tAMVs[i]
end

return T