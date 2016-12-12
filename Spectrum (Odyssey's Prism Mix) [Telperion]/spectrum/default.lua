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

local DEG_TO_RAD = math.pi / 180.0

--
-- 		some funktion !
--
local SideSign = function(i) return (i == 2) and 1 or -1 end

local RangeScale = function(t, inLower, inUpper, outLower, outUpper)
	local ti = (t - inLower) / (inUpper - inLower)
	return outLower + ti * (outUpper - outLower)
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
			self:z(1)
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
			local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..self:getaux()):GetChild('Judgment')
			if McCoy then 
				self:SetTarget(McCoy)
				McCoy:visible(false)
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
--		Some ghosting!
--
nGhosts = 1


--
--		Instead of projecting the ghost to a rectangular Sprite, we're gonna
--		try slapping it on a distorted ActorMultiVertex instead.
--		Setting up the vertex coordinates for that takes a little bit of work.
--
local PI    = math.pi;
local LOG2  = math.log(2.0);
local spectralRows = 36;			-- assuming 16:9
local spectralCols = 64;			-- assuming 16:9
local spectralDX = sw/spectralCols;
local spectralDY = sh/spectralRows;

local tw = math.exp(math.ceil(math.log(sw)/LOG2) * LOG2);
local th = math.exp(math.ceil(math.log(sh)/LOG2) * LOG2);

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

local CalculateShiftingTextures = function(verts, gradient)
	-- Coordinate the texture all at once.
	for vertIndex = 1,#verts do
		local x = verts[vertIndex][1][1] / sw - 0.5
		local y = verts[vertIndex][1][2] / sh - 0.5
		
		-- The gradient function operates on [-1, 1] × [-1, 1].
		-- The magnitude of the gradient is expected to be scaled to that same space.
		xn, yn = gradient(2*x, 2*y)
		
		-- Apply the gradient onto the vertices after scaling to texture space.
		verts[vertIndex][3][1] = (verts[vertIndex][1][1] + xn * sw)/tw
		verts[vertIndex][3][2] = (verts[vertIndex][1][2] + yn * sh)/th
	end

	return verts	
end


local Gradient_NullShift = function(x, y)
	return 0, 0
end

local Gradient_HorizontalSpread = function(x, y)
	local T = 1.8				-- Side crest distance from center
	local M = 0.3				-- Scaling factor for X direction
	local N = 0.8				-- Scaling factor for Y direction
	local A = 0.01				-- Maximum mplitude of shift
	
	local Trad = 2*PI/T
	local B = 1 + M*x*x + N*y*y
	local BB = B*B
		
	local xn = math.cos(Trad * x) * 2*A*M*x/BB - Trad * math.sin(Trad * x) * A/B
	local yn = math.cos(Trad * x) * 2*A*N*y/BB
	
	return xn, yn
end



local spectralAMV = 
	Def.ActorFrame {
		Name = "SpectralAMV"
	}

for rowIndex = 1,spectralRows do
	spectralAMV[#spectralAMV + 1] =
		Def.ActorMultiVertex {
			Name = "SpectralAMVStrip_"..rowIndex,
			InitCommand = function(self)
				local verts = CalculateRowBaseVertices(rowIndex)
				-- verts = CalculateBaseTextures(verts)
				-- verts = CalculateShiftingTextures(verts, Gradient_NullShift)
				verts = CalculateShiftingTextures(verts, Gradient_NullShift)
				self:xy(0, 0)
					:SetVertices(verts)
					:SetDrawState{First = 1,
								  Num = spectralCols * 2,
								  Mode = "DrawMode_QuadStrip"}
			end,
		}
end


for ghostIndex = 1,nGhosts do
	local aftMemoryName = "Memory_"..ghostIndex
	local aftOutputName = "Output_"..ghostIndex
	local ghostBoyName  = "Ghost_" ..ghostIndex
	local aftOutSprName = "Sprite_"..ghostIndex
	
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
						:GetChild("SpectralAMVStrip_"..rowIndex)
						:SetTexture( self:GetTexture() )
				end
			end,
			Def.Sprite{	
				Name = aftOutSprName,
				Texture = aftMemoryName,
				InitCommand=function(self)
				end,
				BeginCommand=function(self)
--					local myColorIndex = tonumber(string.match(self:GetName(), "Sprite_([0-9]+)"))
					self:Center()
						:diffuse({1,1,1,0.99})
						:visible(true)
				end,
				StopTrailMessageCommand=function(self)
					self:diffuse({1,1,1,0.0})
				end,
				StartTrailMessageCommand=function(self)
					self:diffuse({1,1,1,0.99})
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
				end
			}
	end
		
	local ghostBoy = 
		Def.Sprite{
			Name = ghostBoyName,
			Texture = aftOutputName,
			InitCommand=cmd(Center),
			OnCommand=function(self)
				local myIndex = tonumber(string.match(self:GetName(), "Ghost_([0-9]+)"))
				Trace("myIndex: "..myIndex)
				self:z(3)
					:blend("BlendMode_Add")
					:diffuse({1,1,1,0.7})
					:visible(true)
			end,			
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
			for i,v in ipairs(plr) do
				if v then
					v:visible(false);
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
niceSpeed = 420 / 155			-- This song is 155 BPM.
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




