-------------------------------------------------------------------------------
--
--		Zedd feat. Matthew Koma - "Spectrum (Odyssey's Prism Mix)"
--		Special Content
--		
--		Author: 	Telperion
--		Date: 		2016-12-11
--
--
--		We'll run where lights won't chase us
--		Hide where love can save us
--		I will never let you go
--
-------------------------------------------------------------------------------

local sw = SCREEN_WIDTH
local sh = SCREEN_HEIGHT
local BPS = GAMESTATE:GetSongBPS()
local overtime = 0
local overtimeOffset = 0
local fgmsg = 0
local fgcmd = 0
local plr = {nil, nil}

local PI = math.pi
local LOG2 = math.log(2.0)
local DEG_TO_RAD = math.pi / 180.0

--
-- 		some funktion !
--
local SideSign = function(i) return (i == 2) and 1 or -1 end

local RangeScale = function(t, inLower, inUpper, outLower, outUpper)
	local ti = (t - inLower) / (inUpper - inLower)
	return outLower + ti * (outUpper - outLower)
end

local RangeClamp = function(t, outLower, outUpper)
	local ti = t
	ti = (ti < outLower) and outLower or ti
	ti = (ti > outUpper) and outUpper or ti
	return ti
end

-------------------------------------------------------------------------------
--
--		Actors begin below this line
--


local Spectrum = Def.ActorFrame {
	InitCommand = function(self)
	end,
	OnCommand = function(self)
		plr[1] = SCREENMAN:GetTopScreen():GetChild('PlayerP1')
		plr[2] = SCREENMAN:GetTopScreen():GetChild('PlayerP2')
		self:sleep(1573)
	end
}



-------------------------------------------------------------------------------
--
-- 		Playfield proxies
--

for pn = 1,2 do
	Spectrum[#Spectrum + 1] = Def.ActorFrame {	
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
	Spectrum[#Spectrum + 1] = Def.ActorProxy {
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


-------------------------------------------------------------------------------
--
--		Extra nuts 'n' bolts
--

local texArrows = {
	0.000,		-- 4th
	0.375,		-- 16th
	0.125,		-- 8th
	0.250,		-- 12th
	0.625,		-- 32nd
	0.875,		-- 64th
--	0.500,		-- 24th
--	0.750,		-- 48th
	}			-- Texture coordinate shifts

	
for quantIndex,quantTexCoord in ipairs(texArrows) do
	Spectrum[#Spectrum + 1] = 
		NOTESKIN:LoadActorForNoteSkin("Down", "Tap Note", "cyber") .. {
			Name = "SpectrumNote"..quantIndex,
			InitCommand = function(self)
				self:visible(false)
					:xy(0, 0)
					:texturetranslate(quantTexCoord, 0)
--				Trace("Created the source note "..quantIndex.."!")
			end,
		}
end


local SpectralAdditions =
	Def.ActorFrameTexture {
		Name = "SpectralAdditions",
		InitCommand = function(self)
			self:SetTextureName( self:GetName() )
				:SetWidth(sw)
				:SetHeight(sh)
				:EnableAlphaBuffer( true )
				:Create()
		end,
--		BeginCommand = function(self)
--			local spa = self:GetParent()
--							:GetChild("Output_1")
--							:GetChild("SpectralAdditionsSprite")
--			spa:SetTexture( self:GetTexture() )
--			Trace("Set texture! woo!")
--		end,
	}


-- The Wheel of Fate is Turning.. . .. . .
for i,_ in ipairs(texArrows) do
	local WheelOfFate = 
		Def.ActorFrame {
			Name = "WheelOfFate"..i,
			InitCommand = function(self)
				self:aux( 1/math.sqrt(i) )
					:fov(90)
			end,
			OnCommand = function(self)
				self:xy(sw/2, sh/2)
					:queuecommand("Rotater")
			end,
			RotaterCommand = function(self)
				self:aux( self:getaux() * -1 )
				self:smooth((7.0 + math.random() * 4.0) / BPS)
					:rotationz(180 * math.random() * self:getaux())
					:queuecommand("Rotater")
			end,
		}
	
	local spokesCount = 2 + 4 * i
	local bestRadius = 64 * 1.5 * (spokesCount - 3) / (2*PI) * (sw/sh * 9/16)
	for j = 1,spokesCount do
		WheelOfFate[#WheelOfFate + 1] = 
			Def.ActorProxy {
				Name = "NoteProxy"..j,	
				InitCommand = function(self)
					self:aux( i )
				end,	
				BeginCommand=function(self)
					local McCoy = self:GetParent()
									  :GetParent()
									  :GetParent()
									  :GetChild("SpectrumNote"..self:getaux())
					if McCoy then 
						self:SetTarget(McCoy)
							:zoom(1 - self:getaux()*0.05)
							:visible(true)						
					else 
						self:hibernate(1573)
						Trace("You unhooked the tap note parents again, god damn it!!")
					end
				end,
				OnCommand=function(self)
					local myIndex = tonumber(string.match(self:GetName(), "[0-9]+"))
					self:xy(bestRadius * math.cos(2*PI * j/spokesCount), bestRadius * math.sin(2*PI * j/spokesCount))
						:rotationz(360 * j/spokesCount - 90)
						:bob()
						:effectclock('beat')
						:effectmagnitude(0, 0, 30)
						:effectperiod(2)
						:effectoffset(j)
				end,
			}
	end
		
	SpectralAdditions[#SpectralAdditions + 1] = WheelOfFate
end

Spectrum[#Spectrum + 1] = SpectralAdditions
	
--
-- 		Extra nuts 'n' bolts
--
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--
--		Some ghosting!
--
nGhosts = 3
colorGhosts = {
	{1, 1, 0, 1},
	{0, 1, 1, 1},
	{1, 0, 1, 1},
	}


--
--		Instead of projecting the ghost to a rectangular Sprite, we're gonna
--		try slapping it on a distorted ActorMultiVertex instead.
--		Setting up the vertex coordinates for that takes a little bit of work.
--
local spectralRows = 35				-- assuming 16:9
local spectralCols = 63				-- assuming 16:9
local spectralDX = sw/spectralCols
local spectralDY = sh/spectralRows

local tw = math.exp(math.ceil(math.log(sw)/LOG2) * LOG2)
local th = math.exp(math.ceil(math.log(sh)/LOG2) * LOG2)

local CalculateRowBaseVertices = function(rowIndex)
	verts = {}
	
	--
	-- 1--3--5--7-...
	-- |  |  |  |
	-- 2--4--6--8-...
	--
	for tateIndex = 0, spectralCols do
		verts[#verts+1] = {
			{tateIndex * spectralDX, (rowIndex-1) * spectralDY, 0},
			Color.White,
			{0, 0}
		}
		verts[#verts+1] = {
			{tateIndex * spectralDX,  rowIndex    * spectralDY, 0},
			Color.White,
			{0, 0}
		}
	end
	
	return verts
end

local CalculateBaseTextures = function(verts)
	-- Coordinate the texture all at once.
	for vertIndex = 1,#verts do
		verts[vertIndex][3][1] = verts[vertIndex][1][1] / tw
		verts[vertIndex][3][2] = verts[vertIndex][1][2] / th
		Trace(">>> vx = "..verts[vertIndex][1][1]..", vy = "..verts[vertIndex][1][2].." <<<")
	end

	return verts	
end

local Gradient_NullShift = function(x, y, z)
	return 0, 0
end

local CalculateShiftingTextures = function(verts, gradient, soul)
	gradient = gradient or Gradient_NullShift
	soul = soul or 0
	
	-- Coordinate the texture all at once.
	for vertIndex = 1,#verts do
		local x = verts[vertIndex][1][1] / sw - 0.5
		local y = verts[vertIndex][1][2] / sh - 0.5
		
		-- The gradient function operates on [-1, 1] × [-1, 1].
		-- The magnitude of the gradient is expected to be scaled to that same space.
		-- The third parameter is used to differentiate between multiple AMV ghosts.
		xn, yn = gradient(2*x, 2*y, soul)
		
		-- Apply the gradient onto the vertices after scaling to texture space.
		verts[vertIndex][3][1] = RangeClamp(verts[vertIndex][1][1] + xn * sw, 0, sw-1)/tw
		verts[vertIndex][3][2] = RangeClamp(verts[vertIndex][1][2] + yn * sh, 0, sh-1)/th
	end

	return verts	
end


local Gradient_Expand = function(x, y, z)
	return x * (-0.02 - 0.02*z), (y+0.8) * (-0.02 - 0.02*z)
end

local Gradient_HorizontalSpread = function(x, y, z)
	local T = 1.8				-- Side crest distance from center
	local M = 0.7 + z			-- Scaling factor for X direction
	local N = 0.8 + z			-- Scaling factor for Y direction
	local A = 0.002				-- Maximum amplitude of shift
	
	local Trad = 2*PI/T
	local B = 1 + M*x*x + N*y*y
	local BB = B*B
		
	local xn = math.cos(Trad * x) * 2*A*M*x/BB - Trad * math.sin(Trad * x) * A/B
	local yn = math.cos(Trad * x) * 2*A*N*y/BB
	
	return xn, yn
end

local Gradient_Sinkholes = function(x, y, z)
	local ph0 =  -PI/2			-- Angle of first sinkhole
	local phi = 2*PI/7			-- Additional angle per sinkhole
	local R = 1.1				-- Radial distance of sinkholes from center
	local M = 2.0 + z			-- Scaling factor for X direction
	local N = 2.0 - z			-- Scaling factor for Y direction
	local A = 0.002				-- Maximum amplitude of shift
	
	local xn = 0
	local yn = 0
	
	-- The function is additive, so calculate each sinkhole's contribution individually.
	for sinkhole = 1,7 do
		local theta = ph0 + sinkhole * phi
		local xshift = x - R*math.cos(theta)
		local yshift = y - R*math.sin(theta)
		
		local B = 1 + M*xshift*xshift + N*yshift*yshift
		local BB = B*B
			
		xn = xn + 2*A*M*xshift/BB
		yn = yn + 2*A*N*yshift/BB
	end
	
	-- Unsinkhole the center.	
	local B = 1 + M*x*x + N*y*y
	local BB = B*B
		
	xn = xn - 2*A*M*x/BB
	yn = yn - 2*A*N*y/BB
	
	return xn, yn
end


local Gradient_Drip = function(x, y, z)
	local T = 0.4				-- Period of drip wave
	local M = 0.3 + 0.1 * z	-- Scaling factor for X direction
	local N = 1.0 + z			-- Scaling factor for Y direction
	local A = 0.002				-- Maximum amplitude of shift
	
	local Trad = 2*PI/T
		
	local xn = math.sin(Trad * y) * A*M*Trad
	local yn = -A*N*(y+1)
	
	return xn, yn
end

local Gradient_DripRev = function(x, y, z)
	local T = 0.4				-- Period of drip wave
	local M = 0.3 + 0.1 * z	-- Scaling factor for X direction
	local N = 1.0 + z			-- Scaling factor for Y direction
	local A = 0.002				-- Maximum amplitude of shift
	
	local Trad = 2*PI/T
		
	local xn = -math.sin(Trad * y) * A*M*Trad
	local yn = -A*N*(y+1)
	
	return xn, yn
end


local Gradient_Whirlpool = function(x, y, z)
	local T = 7					-- Periods in one revolution
	local M = 0.3 + 0.1 * z		-- Scaling factor for wave distortion
	local N = 0.3 + 0.1 * z		-- Scaling factor on distance to amplitude
	local A = 0.002				-- Maximum amplitude of shift
	
	local Trad = 2*PI/T
	local Bmag = math.sqrt(x*x + y*y)
	local Barg = math.atan(y, x)
		
	local xn = -y * A*(N + 1 / Bmag)
	local yn =  x * A*(N + 1 / Bmag)
	
	return xn, yn
end

local Gradient_Gack = function(x, y, z)
	local T = 7					-- Periods in one revolution
	local phi = PI/2			-- Phase shift of gacks
	local M = 1.0				-- Scaling factor on distance to amplitude
	local N = 0.5				-- Scaling factor for wave distortion
	local A = 0.005				-- Maximum amplitude of shift
	
	
	y = y + z*4/3				-- Shift y.
	local Trad = T
	local Bmag = math.sqrt(x*x + y*y)
	local Barg = math.acos(x/(Bmag+0.000001)) * (y >= 0 and 1 or -1)
	local Bsin = math.sin(Trad * Barg - phi)
	local Bsin2 = math.sin(2 * (Trad * Barg - phi))
	local BigDenom = 1 + Bmag*Bmag*(M + N*Bsin*Bsin)
	local BigDenomSq = BigDenom * BigDenom
	
	local thn = -2*A*Bmag*(M + N*Bsin*Bsin) / BigDenomSq
	local rn = Trad*A*N*Bmag*Bsin2 / ((Bmag+0.000001)*BigDenomSq)
		
	local xn = rn * math.cos(Barg) - thn * math.sin(Barg)
	local yn = rn * math.sin(Barg) + thn * math.cos(Barg)
	
	return xn, yn
end


local nullVerts = {}
local horzVerts = {}
local dripVerts = {}
local gackVerts = {}

for ghostIndex = 1,nGhosts do
	local aftMemoryName = "Memory_"..ghostIndex
	local aftOutputName = "Output_"..ghostIndex
	local ghostBoyName  = "Ghost_" ..ghostIndex
	local aftOutSprName = "Sprite_"..ghostIndex



	local spectralAMV = 
		Def.ActorFrame {
			Name = "SpectralAMV"
		}

	for rowIndex = 1,spectralRows do
		spectralAMV[#spectralAMV + 1] =
			Def.ActorMultiVertex {
				Name = "SpectralAMVStrip_"..ghostIndex.."_"..rowIndex,
				InitCommand = function(self)
					local verts = CalculateRowBaseVertices(rowIndex)
					-- verts = CalculateBaseTextures(verts)
					-- verts = CalculateShiftingTextures(verts, Gradient_NullShift)
					verts = CalculateShiftingTextures(verts, Gradient_Gack, (ghostIndex-2)*0.5)
					self:xy(0, 0)
						:SetVertices(verts)
						:SetDrawState{First = 1,
									  Num = (spectralCols + 1) * 2,
									  Mode = "DrawMode_QuadStrip"}
				end,
				GradientChangeMessageCommand = function(self, args)
					ghostIndex, rowIndex = string.match(self:GetName(), "_([0-9]+)_([0-9]+)")
					local verts = CalculateRowBaseVertices(rowIndex)
					if args[1] then
						verts = CalculateShiftingTextures(verts, args[1], (ghostIndex-2)*0.5)
					end
					
					if args[2] then
						self:finishtweening()
							:decelerate(args[2] / BPS)
							:SetVertices(verts)
					else		
						self:finishtweening()
							:SetVertices(verts)
					end
				end,
			}
	end
	
	local aftMemory = 
		Def.ActorFrameTexture{
			Name = aftMemoryName,
			InitCommand=function(self)
				self:SetTextureName( self:GetName() )
					:SetWidth( sw )
					:SetHeight( sh )
					:EnableAlphaBuffer( true )
					:Create()
			end,
		}
	aftMemory[#aftMemory + 1] = spectralAMV

	local aftOutput = 
		Def.ActorFrameTexture{
			Name = aftOutputName,
			InitCommand=function(self)
				self:SetTextureName( self:GetName() )
					:SetWidth( sw )
					:SetHeight( sh )
					:EnableAlphaBuffer( true )
					:Create()
					
				myMemoryName = "Memory"..string.match(self:GetName(), "Output(_[0-9]+)")
				Trace(myMemoryName)
				for rowIndex=1,spectralRows do
					self:GetParent()
						:GetChild(myMemoryName)
						:GetChild("SpectralAMV")
						:GetChild("SpectralAMVStrip_"..ghostIndex.."_"..rowIndex)
						:SetTexture( self:GetTexture() )
				end
			end,
			Def.Sprite{	
				Name = aftOutSprName,
				Texture = aftMemoryName,
				InitCommand=function(self)
					self:aux( tonumber(string.match(self:GetName(), "Sprite_([0-9]+)")) )
				end,
				BeginCommand=function(self)
					self:Center()
						:diffuse(colorGhosts[self:getaux()])
						:diffusealpha(0.0)
						:visible(true)
				end,
				StopTrailMessageCommand=function(self)
					self:diffusealpha(0.0)
				end,
				StartTrailMessageCommand=function(self)
					self:diffusealpha(0.998)
				end
			},
		}
	for pn = 1,2 do
		aftOutput[#aftOutput + 1] = 
			Def.ActorProxy {					
				Name = "ProxyP"..pn,
				BeginCommand=function(self)
					local pn = string.match(self:GetName(), "ProxyP([12])")
					local p = self:GetParent()
								  :GetParent()
								  :GetChild('ProxyP'..pn.."Outer")
--								  :GetChild('ProxyP'..pn.."Inner")
					self:SetTarget(p)
				end,
				OnCommand=function(self)
					self:xy(0, 0)
				end,
				GhostProxiesOffMessageCommand=function(self)
					self:visible(false)
				end,
				GhostProxiesOnMessageCommand=function(self)
					self:visible(true)
				end,
			}
	end
	
	for i=1,2 do
		aftOutput[#aftOutput + 1] = 
			Def.Sprite {					
				Name = "SpectralAdditionsSprite"..i,
				InitCommand=function(self)
					self:aux( tonumber(string.match(self:GetName(), "[0-9]+")) )
				end,
				BeginCommand=function(self)
					local spa = self:GetParent()
									:GetParent()
									:GetChild("SpectralAdditions")
					self:SetTexture( spa:GetTexture() )
					Trace("Set texture! woo!")
				end,
				OnCommand=function(self)
					self:xy(sw/2 + sw * SideSign(self:getaux()), sh/2)
--						:blend("BlendMode_WeightedMultiply")
						:diffusealpha(0.7)
				end,
				FateHelloMessageCommand=function(self)
					self:decelerate(1.0 / BPS)
						:xy(sw/2 + sw/2 * SideSign(self:getaux()), sh/2)
				end,
				FateGoodbyeMessageCommand=function(self)
					self:decelerate(32.0 / BPS)
						:xy(sw/2 + sw * SideSign(self:getaux()), sh/2)
				end,
			}
	end
	
	aftOutput[#aftOutput + 1] = 
		Def.Sprite {					
			Name = "BG",
			Texture = "./spectrum-bq.png",
			InitCommand=function(self)
			end,
			OnCommand=function(self)			
				self:SetWidth(sw)
					:SetHeight(sw * 9/16)
					:xy(sw/2, sh - sw*9/32)
					:diffusealpha(0.6)
					:z(-1)
			end,
			HideBGMessageCommand=function(self, args)
				if args[1] then
					self:finishtweening()
						:decelerate(args[1] / BPS)
						:diffusealpha(0.0)
				else
					self:finishtweening()
						:diffusealpha(0.0)
				end
			end,
			ShowBGMessageCommand=function(self, args)
				if args[1] then
					self:finishtweening()
						:decelerate(args[1] / BPS)
						:diffusealpha(0.6)
				else
					self:finishtweening()
						:diffusealpha(0.6)
				end
			end,
		}
		
	local ghostBoy = 
		Def.Sprite{
			Name = ghostBoyName,
			Texture = aftOutputName,
			InitCommand=cmd(Center),
			OnCommand=function(self)
				local myIndex = tonumber(string.match(self:GetName(), "Ghost_([0-9]+)"))
				Trace("myIndex: "..myIndex)
				self:z(0.5)
					:blend("BlendMode_Add")
					:diffuse({1,1,1,0.4})
					:visible(true)
			end,
			GhostDiffuseMessageCommand=function(self, args)
				if args[2] then
					self:finishtweening()
						:decelerate(args[2] / BPS)
						:diffusealpha(args[1])
				else
					self:finishtweening()
						:diffusealpha(args[1])
				end
			end
		}
		
	Spectrum[#Spectrum + 1] = aftMemory
	Spectrum[#Spectrum + 1] = aftOutput
	Spectrum[#Spectrum + 1] = ghostBoy
end

--
--		Some ghosting!
--
-------------------------------------------------------------------------------


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
	{242.00, "GhostProxiesOn"},
	{242.08, "GhostProxiesOff"},
	{246.00, "GhostProxiesOn"},
	{246.08, "GhostProxiesOff"},
	{250.00, "GhostProxiesOn"},
	{250.08, "GhostProxiesOff"},
	{254.00, "GhostProxiesOn"},
	{254.08, "GhostProxiesOff"},
	{258.00, "GhostProxiesOn"},
	{258.08, "GhostProxiesOff"},
	{262.00, "GhostProxiesOn"},
	{262.08, "GhostProxiesOff"},
	{266.00, "GhostProxiesOn"},
	{266.08, "GhostProxiesOff"},
	{270.00, "GhostProxiesOn"},
	{270.08, "GhostProxiesOff"},
	{274.00, "GhostProxiesOn"},
	{274.08, "GhostProxiesOff"},
	{278.00, "GhostProxiesOn"},
	{278.08, "GhostProxiesOff"},
	{282.00, "GhostProxiesOn"},
	{282.08, "GhostProxiesOff"},
	{286.00, "GhostProxiesOn"},
	{286.08, "GhostProxiesOff"},
	{290.00, "GhostProxiesOn"},
	{290.08, "GhostProxiesOff"},
	{294.00, "GhostProxiesOn"},
	{294.08, "GhostProxiesOff"},
	{298.00, "GhostProxiesOn"},
	{298.08, "GhostProxiesOff"},
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
	{332.00, "GradientChange", {Gradient_Expand, 4}},
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

Spectrum[#Spectrum + 1]= Def.Quad {
	InitCommand = function(self)
		self:SetHeight(6)
			:SetWidth(6)
			:xy(-sw,-sh)
			:visible(false)
	end,
	OnCommand = function(self)
		self:queuecommand("Update")
	end,
	UpdateCommand = function(self)
		-- Most things are determined by beat, believe it or not.		
		overtime = GAMESTATE:GetSongBeat() + overtimeOffset
		
		-- TODO: this assumes the effect applies over a constant BPM section!!
		BPS = GAMESTATE:GetSongBPS()
		
		-- Hide players and use proxies instead.
		-- (The FG command system has largely been replaced with the FG messaging system.)
		if overtime >=   0.0 and fgcmd ==  0 then
			for pn = 1,2 do
				local v = SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn)
				if v then
					v:visible(false);
					Trace('Hid real player '..pn)
				end
			end
			
			fgcmd = fgcmd + 1
		end
				
		-- Broadcast messages on their own terms.
		while true do
			if fgmsg < #messageList then
				messageBeat, messageName, messageArgs = unpack(messageList[fgmsg+1])
				if overtime >= messageBeat then			
					if messageArgs then
						MESSAGEMAN:Broadcast( messageName, messageArgs )
					else
						MESSAGEMAN:Broadcast( messageName )
					end
					
					fgmsg = fgmsg + 1
				else
					break;
				end
			else
				break;
			end
		end
				
		-- Wait a bit and then update again!
		self:queuecommand("WaitABit")
	end,
	WaitABitCommand = function(self)
		self:sleep(0.02)
		self:queuecommand("Update")
	end
}




-- Load the HUD reducer into this script.
Spectrum[#Spectrum + 1] = LoadActor("./hudreducer.lua")

-- Load the mods table parser into this script.
niceSpeed = (420 + 69) / 155			-- This song is 155 BPM.
modsTable = {
	-- [1]: beat start
	-- [2]: mod type
	-- [3]: mod strength (out of unity),
	-- [4]: mod approach (in beats to complete)
	-- [5]: player application (1 = P1, 2 = P2, 3 = both, 0 = neither)
		
		{   0.0,	"ScrollSpeed",	niceSpeed,    8.0,	3}, 
		{   0.0,	"Dark",				  0.8,    8.0,	3}, 
}
Spectrum[#Spectrum + 1] = LoadActor("./modsHQ.lua", {modsTable, 0})


return Spectrum




