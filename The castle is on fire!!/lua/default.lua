-------------------------------------------------------------------------------
--
--		cranky feat. おもしろ三国志 [Records of the Three Kingdoms] -
--						"宛城、炎上！！" [The castle is on fire!!]
--		U.P.S. 3
--		
--		Author: 	Telperion
--		Date: 		2017-11-08
--		Target:		SM5.0.12+
--
-------------------------------------------------------------------------------
--
--		A delicious wine for the beautiful lady...
--		And this castle just fell into my hands.
--		I wish the whole country could fall to me so easily...
--
-------------------------------------------------------------------------------

local circumvention = false
if circumvention then
	return Def.ActorFrame {}
end

niceSpeed = (420) / 128			-- This song is 128 BPM.
local sw = SCREEN_WIDTH
local sh = SCREEN_HEIGHT
local BPS = 175/60 -- GAMESTATE:GetSongBPS()
local ofs = 0.009
local overtime = 0
local visualOffset = -0.01
local fgmsg = 0
local checked = false
local plr = {nil, nil}

local PI = math.pi
local LOG2 = math.log(2.0)
local SQRT2 = math.sqrt(2.0)
local DEG_TO_RAD = math.pi / 180.0

-------------------------------------------------------------------------------
-- TESTING AREA
local testSpeech = true
if testSpeech then
	-- using SpeechBubble.py
             sbPages = {  'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main',   'main'}
             sbIndex = {      33,        0,       68,       69,       76,       73,       67,       73,       79,       85,       83,        0,       87,       73,       78,       69,        0,       70,       79,       82,        0,       84,       72,       69,        0,       66,       69,       65,       85,       84,       73,       70,       85,       76,        0,       76,       65,       68,       89,       14,       14,       14,        0,       33,       78,       68,        0,       84,       72,       73,       83,        0,       67,       65,       83,       84,       76,       69,        0,       74,       85,       83,       84,        0,       70,       69,       76,       76,        0,       73,       78,       84,       79,        0,       77,       89,        0,       72,       65,       78,       68,       83,       14,        0,       41,        0,       87,       73,       83,       72,        0,       84,       72,       69,        0,       87,       72,       79,       76,       69,        0,       67,       79,       85,       78,       84,       82,       89,        0,       67,       79,       85,       76,       68,        0,       70,       65,       76,       76,        0,       84,       79,        0,       77,       69,        0,       83,       79,        0,       69,       65,       83,       73,       76,       89,       14,       14,       14,        0}
               sbCol = {       0,        1,        2,        3,        4,        5,        6,        7,        8,        9,       10,       11,       12,       13,       14,       15,       16,       17,       18,       19,       20,       21,       22,       23,       24,       25,       26,       27,       28,       29,       30,       31,       32,       33,       34,       35,       36,       37,       38,       39,       40,       41,       42,        0,        1,        2,        3,        4,        5,        6,        7,        8,        9,       10,       11,       12,       13,       14,       15,       16,       17,       18,       19,       20,       21,       22,       23,       24,       25,       26,       27,       28,       29,       30,       31,       32,       33,       34,       35,       36,       37,       38,       39,       40,        0,        1,        2,        3,        4,        5,        6,        7,        8,        9,       10,       11,       12,       13,       14,       15,       16,       17,       18,       19,       20,       21,       22,       23,       24,       25,       26,       27,       28,       29,       30,       31,       32,       33,       34,       35,       36,       37,       38,       39,       40,       41,       42,       43,       44,       45,       46,       47,       48,       49,       50,       51,       52,       53,       54}
               sbRow = {       0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        1,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2,        2}
                 sbX = {    -301,     -283,     -268,     -251,     -239,     -228,     -215,     -202,     -188,     -170,     -153,     -141,     -122,     -102,      -86,      -69,      -57,      -45,      -30,      -15,       -3,        8,       23,       39,       51,       64,       79,       95,      114,      130,      142,      155,      172,      187,      197,      207,      221,      240,      259,      274,      286,      298,      309,     -287,     -264,     -244,     -229,     -218,     -203,     -188,     -175,     -163,     -151,     -135,     -119,     -106,      -95,      -83,      -71,      -60,      -44,      -27,      -14,       -3,        9,       23,       35,       45,       55,       66,       82,       98,      112,      125,      145,      169,      183,      197,      215,      234,      254,      271,      284,      295,     -391,     -378,     -359,     -339,     -326,     -310,     -296,     -285,     -270,     -254,     -242,     -223,     -200,     -183,     -170,     -158,     -146,     -134,     -119,     -101,      -81,      -65,      -52,      -36,      -22,      -10,        5,       23,       38,       53,       68,       80,       96,      110,      120,      130,      141,      155,      168,      188,      210,      222,      234,      249,      262,      274,      290,      306,      319,      330,      344,      359,      371,      383,      394}
                 sbY = {      20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       20,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,       62,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102,      102}
                 sbT = {    17.0, 17.117647, 17.235294, 17.352941, 17.470588, 17.588235, 17.705882, 17.823529, 17.941176, 18.058824, 18.176471, 18.294118, 18.411765, 18.529412, 18.647059, 18.764706, 18.882353,     20.0, 20.115385, 20.230769, 20.346154, 20.461538, 20.576923, 20.692308, 20.807692, 20.923077, 21.038462, 21.153846, 21.269231, 21.384615,     21.5, 21.615385, 21.730769, 21.846154, 21.961538, 22.076923, 22.192308, 22.307692, 22.423077, 22.538462, 22.653846, 22.769231, 22.884615,     26.0,   26.125,    26.25,   26.375,     30.5, 30.783784, 31.067568, 31.351351, 31.635135, 31.918919, 32.202703, 32.486486, 32.77027, 33.054054, 33.337838, 33.621622, 33.905405, 34.189189, 34.472973, 34.756757, 35.040541, 35.324324, 35.608108, 35.891892, 36.175676, 36.459459, 36.743243, 37.027027, 37.310811, 37.594595, 37.878378, 38.162162, 38.445946, 38.72973, 39.013514, 39.297297, 39.581081, 39.864865, 40.148649, 40.432432, 40.716216,     51.0, 51.218182, 51.436364, 51.654545, 51.872727, 52.090909, 52.309091, 52.527273, 52.745455, 52.963636, 53.181818,     53.4, 53.618182, 53.836364, 54.054545, 54.272727, 54.490909, 54.709091, 54.927273, 55.145455, 55.363636, 55.581818,     55.8, 56.018182, 56.236364, 56.454545, 56.672727, 56.890909, 57.109091, 57.327273, 57.545455, 57.763636, 57.981818,     58.2, 58.418182, 58.636364, 58.854545, 59.072727, 59.290909, 59.509091, 59.727273, 59.945455, 60.163636, 60.381818,     60.6, 60.818182, 61.036364, 61.254545, 61.472727, 61.690909, 61.909091, 62.127273, 62.345455, 62.563636, 62.781818}
                 sbH = 123
                 sbW = 854
             sbMaxLL = 55
            sbTClose = 67.0


	_SB_ = Def.ActorFrame{
		InitCommand = function(self)
		end,
		OnCommand = function(self)
			SCREENMAN:GetTopScreen():SetDrawByZPosition(true)

			local hamburger = SCREENMAN:GetTopScreen()
			if hamburger:GetScreenType() == "ScreenType_Gameplay" then
				hamburger:GetChild("Overlay" ):decelerate(4.0 / BPS):diffusealpha(0.0)
				hamburger:GetChild("Underlay"):decelerate(4.0 / BPS):diffusealpha(0.0)
			end

			self:fov(75)
				:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
				:zoom(0.75)
				:SetDrawByZPosition(true)
				:sleep(1573)
		end
	}


	bevelSize  = 12
	outerGrow  = 4
	outerColor = {0.4, 0.0, 0.0, 0.5}
	innerColor = {0.3, 0.3, 0.3, 0.7}

	vertsOuterStart = {
		-- Diamond with "duplicated" corners
		{{0, 0, 0}, outerColor, {0, 0}},
		{{ bevelSize+outerGrow,  outerGrow/2, 0}, outerColor, {0, 0}},
		{{ outerGrow/2,  bevelSize+outerGrow, 0}, outerColor, {0, 0}},
		{{-outerGrow/2,  bevelSize+outerGrow, 0}, outerColor, {0, 0}},
		{{-bevelSize-outerGrow,  outerGrow/2, 0}, outerColor, {0, 0}},
		{{-bevelSize-outerGrow, -outerGrow/2, 0}, outerColor, {0, 0}},
		{{-outerGrow/2, -bevelSize-outerGrow, 0}, outerColor, {0, 0}},
		{{ outerGrow/2, -bevelSize-outerGrow, 0}, outerColor, {0, 0}},
		{{ bevelSize+outerGrow, -outerGrow/2, 0}, outerColor, {0, 0}} 
		}
	vertsOuterStart[#vertsOuterStart+1] = vertsOuterStart[2]

	vertsInnerStart = {
		-- Diamond with "duplicated" corners
		{{0, 0, 0}, innerColor, {0, 0}},
		{{ bevelSize,  0, 0}, innerColor, {0, 0}},
		{{ 0,  bevelSize, 0}, innerColor, {0, 0}},
		{{ 0,  bevelSize, 0}, innerColor, {0, 0}},
		{{-bevelSize,  0, 0}, innerColor, {0, 0}},
		{{-bevelSize,  0, 0}, innerColor, {0, 0}},
		{{ 0, -bevelSize, 0}, innerColor, {0, 0}},
		{{ 0, -bevelSize, 0}, innerColor, {0, 0}},
		{{ bevelSize,  0, 0}, innerColor, {0, 0}}
		}
	vertsInnerStart[#vertsInnerStart+1] = vertsInnerStart[2]


	signNS = {1, 1, 1, 1, -1, -1, -1, -1, 1}
	signEW = {1, 1, -1, -1, -1, -1, 1, 1, 1}
	vertsOuterExtNS = {}
	vertsOuterExtEW = {}
	vertsOuterFinal = {}
	for i = 1,#vertsOuterStart do
		vertsOuterExtNS[i] = {}
		vertsOuterExtEW[i] = {}
		vertsOuterFinal[i] = {}
		for j = 1,#vertsOuterStart[i] do
			-- stupid hack to get around pass-by-reference
			vertsOuterExtNS[i][j] = {}
			vertsOuterExtEW[i][j] = {}
			vertsOuterFinal[i][j] = {}
			for k = 1,#vertsOuterStart[i][j] do
				vertsOuterExtNS[i][j][k] = vertsOuterStart[i][j][k] + 0
				vertsOuterExtEW[i][j][k] = vertsOuterStart[i][j][k] + 0
				vertsOuterFinal[i][j][k] = vertsOuterStart[i][j][k] + 0
			end
		end
		if i > 1 then
			vertsOuterExtEW[i][1][1] = vertsOuterExtEW[i][1][1] + sbW*signEW[i-1]/2
			vertsOuterExtNS[i][1][2] = vertsOuterExtNS[i][1][2] + sbH*signNS[i-1]/2
			vertsOuterFinal[i][1][1] = vertsOuterExtEW[i][1][1]
			vertsOuterFinal[i][1][2] = vertsOuterExtNS[i][1][2]
		end
	end

	vertsInnerExtNS = {}
	vertsInnerExtEW = {}
	vertsInnerFinal = {}
	for i = 1,#vertsInnerStart do
		vertsInnerExtNS[i] = {}
		vertsInnerExtEW[i] = {}
		vertsInnerFinal[i] = {}
		for j = 1,#vertsInnerStart[i] do
			-- stupid hack to get around pass-by-reference
			vertsInnerExtNS[i][j] = {}
			vertsInnerExtEW[i][j] = {}
			vertsInnerFinal[i][j] = {}
			for k = 1,#vertsInnerStart[i][j] do
				vertsInnerExtNS[i][j][k] = vertsInnerStart[i][j][k] + 0
				vertsInnerExtEW[i][j][k] = vertsInnerStart[i][j][k] + 0
				vertsInnerFinal[i][j][k] = vertsInnerStart[i][j][k] + 0
			end
		end
		if i > 1 then
			vertsInnerExtEW[i][1][1] = vertsInnerExtEW[i][1][1] + sbW*signEW[i-1]/2
			vertsInnerExtNS[i][1][2] = vertsInnerExtNS[i][1][2] + sbH*signNS[i-1]/2
			vertsInnerFinal[i][1][1] = vertsInnerExtEW[i][1][1]
			vertsInnerFinal[i][1][2] = vertsInnerExtNS[i][1][2]
		end
	end

	vertsOuterCall  = {
		}
	vertsInnerCall  = {
		}


	_SB_[#_SB_ + 1] = Def.ActorMultiVertex{
		Name = 'SpeechBubbleBGOuter',
		InitCommand = function(self)
			self:SetVertices(vertsOuterStart)
				:SetDrawState{Mode="DrawMode_Fan", First=1, Num=-1}
		end,
		OnCommand = function(self)
		end,
		SpeechBubbleBGStartMessageCommand = function(self, args)
			self:decelerate(8.0 / BPS)
				:SetVertices(vertsOuterStart)
		end,
		SpeechBubbleBGExtNSMessageCommand = function(self, args)
			self:decelerate(8.0 / BPS)
				:SetVertices(vertsOuterExtNS)
		end,
		SpeechBubbleBGExtEWMessageCommand = function(self, args)
			self:decelerate(8.0 / BPS)
				:SetVertices(vertsOuterExtEW)
		end,
		SpeechBubbleBGFinalMessageCommand = function(self, args)
			self:decelerate(8.0 / BPS)
				:SetVertices(vertsOuterFinal)
		end
	}
	_SB_[#_SB_ + 1] = Def.ActorMultiVertex{
		Name = 'SpeechBubbleBGInner',
		InitCommand = function(self)
			self:SetVertices(vertsInnerStart)
				:SetDrawState{Mode="DrawMode_Fan", First=1, Num=-1}
		end,
		OnCommand = function(self)
		end,
		SpeechBubbleBGStartMessageCommand = function(self, args)
			self:decelerate(8.0 / BPS)
				:SetVertices(vertsInnerStart)
		end,
		SpeechBubbleBGExtNSMessageCommand = function(self, args)
			self:decelerate(8.0 / BPS)
				:SetVertices(vertsInnerExtNS)
		end,
		SpeechBubbleBGExtEWMessageCommand = function(self, args)
			self:decelerate(8.0 / BPS)
				:SetVertices(vertsInnerExtEW)
		end,
		SpeechBubbleBGFinalMessageCommand = function(self, args)
			self:decelerate(8.0 / BPS)
				:SetVertices(vertsInnerFinal)
		end
	}
	_SB_[#_SB_ + 1] = Def.ActorMultiVertex{
		Name = 'SpeechBubbleCallOuter',
		InitCommand = function(self)
		end,
		OnCommand = function(self)
		end
	}
	_SB_[#_SB_ + 1] = Def.ActorMultiVertex{
		Name = 'SpeechBubbleCallInner',
		InitCommand = function(self)
		end,
		OnCommand = function(self)
		end
	}


	for i = 1,#sbPages do
		_SB_[#_SB_ + 1] = Def.Sprite{
			Texture = '_venice classic 38px ['..sbPages[i]..']',
			InitCommand = function(self)
				self:xy(sbX[i], sbY[i] - sbH/2)
					:animate(false)
					:setstate(sbIndex[i])
					:aux(sbCol[i])
					:diffusealpha(0.0)					
			end,
			OnCommand = function(self)
				self:sleep((0.0 + sbT[i]) / BPS)
					:queuecommand('Materialize')
			end,
			MaterializeCommand = function(self)
				self:diffusealpha(1.0)
					:bob()
					:effectclock('bgm')
					:effectoffset( 6 * (sbX[i]+sbY[i]) / (sbH+sbW) )
					:effecttiming(0.5, 0, 0.5, 7, 0)
					:effectmagnitude(0, 6, 0)
					:sleep((sbTClose - sbT[i]) / BPS)
					:queuecommand('Dematerialize')
			end,
			DematerializeCommand = function(self)
				self:diffusealpha(0.0)
			end
		}
	end

	_SB_[#_SB_ + 1] = Def.ActorFrame{
		Name = 'ScratchController',
		InitCommand = function(self)
		end,
		OnCommand = function(self)
			self:sleep(4.0/BPS)
				:queuecommand('F1')
		end,
		F1Command = function(self)
			MESSAGEMAN:Broadcast('SpeechBubbleBGExtNS')
			self:sleep(2.0/BPS)
				:queuecommand('F2')
		end,
		F2Command = function(self)
			MESSAGEMAN:Broadcast('SpeechBubbleBGFinal')
			self:sleep(2.0/BPS)
		end,
	}


	return _SB_
end
-- TESTING AREA
-------------------------------------------------------------------------------





local PlayerProxyActors 	= {nil, nil}
local PlayerProxyTextures 	= {nil, nil}
local PlayerProxySprites 	= {nil, nil}

local nGhostSubjects = 5
	-- Can't count arrays full of nil
	-- Even though I explicitly set five nils
	-- ...bitch. 
	--
	-- my nils are on flique

local ghostSubjects = {
	nil,				-- Player 1 active sprite
	nil,				-- Player 2 active sprite
	nil,				-- Crowdsource / Eleison high
	nil,				-- Eleison low
	nil,				-- Who knows?
}

local aftMemoryActor = nil
local aftOutputActor = nil
local aftOutSprActor = nil
local ghostDudeActor = nil
local ghostSubjActors = {}



--
--	Texture constants
--
local ttw = math.pow(2, math.ceil(math.log(sw) / LOG2))
local tth = math.pow(2, math.ceil(math.log(sh) / LOG2))
local twscale = sw / ttw
local thscale = sh / tth

--
-- 	some funktion !
--
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


local _DZ_ = Def.ActorFrame {}
local _FG_ = Def.ActorFrame {
	InitCommand = function(self)
	end,
	OnCommand = function(self)
		self:fov(45)
			:vanishpoint(sw/2, sh/4)			
			:SetDrawByZPosition(true)

		plr[1] = SCREENMAN:GetTopScreen():GetChild('PlayerP1')
		plr[2] = SCREENMAN:GetTopScreen():GetChild('PlayerP2')
		SCREENMAN:GetTopScreen():SetDrawByZPosition(true)


		-- Random one of four charts, and set both P1 and P2 to this chosen chart.
		local stepChoices 	= GAMESTATE:GetCurrentSong():GetStepsByStepsType('StepsType_Dance_Single')
		local whichSteps	= math.random(#stepChoices)
		for i = 1,20 do
			if stepChoices[whichSteps]:GetDifficulty() ~= 'Difficulty_Challenge' then
				break
			end
			whichSteps	= math.random(#stepChoices)
		end


		local hamburger = SCREENMAN:GetTopScreen()
		if hamburger:GetScreenType() == "ScreenType_Gameplay" then
			hamburger:GetChild("Overlay" ):decelerate(4.0 / BPS):diffusealpha(0.0)
			hamburger:GetChild("Underlay"):decelerate(4.0 / BPS):diffusealpha(0.0)
		end

				
		local playersFound = 0
		local pickedNewCharts = false
		local needNoteskinReset = false
		local targetNoteskin = 'shadow'
		for pn = 1,2 do
			pv = plr[pn]
			if pv then
				pv:GetChild("Combo"):hibernate(1573)

				pops = GAMESTATE:GetPlayerState("PlayerNumber_P"..pn):GetPlayerOptions("ModsLevel_Song")
				pops:FailSetting('FailType_Off')

				pops = GAMESTATE:GetPlayerState("PlayerNumber_P"..pn):GetPlayerOptions("ModsLevel_Preferred")
				local currentNoteskin, isNoteskinSet = pops:NoteSkin(targetNoteskin)

				if currentNoteskin == targetNoteskin or not isNoteskinSet then
					if not isNoteskinSet then
						Trace("WARNING: The '"..targetNoteskin.."' noteskin could not be set!")
					end
				else
--					needNoteskinReset = true
				end

				if GAMESTATE:GetCurrentSteps(pn-1):GetDifficulty() == 'Difficulty_Challenge' then
					GAMESTATE:SetCurrentSteps(pn-1, stepChoices[whichSteps])
					pickedNewCharts = true
				end
			end
			
		end

		if pickedNewCharts or needNoteskinReset then
			_G['satesystScreenCycleComplete'] = true
			SCREENMAN:SetNewScreen("ScreenGameplay")
		end


		self:sleep(1573)
	end
};





-------------------------------------------------------------------------------
--
--	The ancient discotheque
--

--
--		Instead of projecting the ghost to a rectangular Sprite, we're gonna
--		try slapping it on a distorted ActorMultiVertex instead.
--		Setting up the vertex coordinates for that takes a little bit of work.
--
--		This is a physical vertex shifter.
--		For the textural vertex shifter (gradient), used in Spectrum's ghosting,
--		go consult that file's FG change! 
--
local stretchyRows = 35					-- assuming 16:9
local stretchyCols = 63					-- assuming 16:9
local stretchyDX = sw/stretchyCols
local stretchyDY = sh/stretchyRows
local texturalDX = twscale/stretchyCols
local texturalDY = thscale/stretchyRows
local qq = -- math.sqrt(sw * sh) * 0.05	-- I don't think we'll use this but w/e
		   sw 							-- turns out we do!

local nDiscoProxies 	= 4
local Discothexture 	= null
local DiscoProxies 	 	= {{}, {}}

-- Enforce adjacent playfields.
local discoYNativeScale	= 1.0			-- The playfields are a little smaller than normal.
local discoYCurve		= 0.3			-- The AMV curves down at the edges.
local discoXNativeScale = 1.1			-- The playfield is stretched so the curve edge is not visible.
local discoCentralScale = 2 / (discoXNativeScale * PI)
	-- Internal playfield true scale at center.
local discoTinify 		= math.log( ((2 * nDiscoProxies - 1) * discoCentralScale * 256) / sw ) / LOG2
	-- One unit of Tiny/Mini shrinks by 50%, so the whole thing is multiplied by 2 for full-scale
local discoScreenCrop	= (2 * nDiscoProxies) / (2 * nDiscoProxies - 1)

local discoCrowd		= false
local discoStartTime	= 1573			-- in beats
local discoTweenTime	= 0				-- in beats
local discoProxyPeriod 	= 16			-- in beats
local discoScrAuxActor	= nil			-- controls scrolling of wall
local discoScrFunction	= Scroller_NullShift	-- controls scrolling of wall (domain and range [0, 1])

function CalculateRowBaseVertices(rowIndex, useNativeTexCoords)
	useNativeTexCoords = useNativeTexCoords or false

	local tdx = texturalDX
	local tdy = texturalDY
	if useNativeTexCoords then
		tdx = 1.0/stretchyCols
		tdy = 1.0/stretchyRows
	end

	local verts = {}
	
	--
	-- 1--3--5--7-...
	-- |  |  |  |
	-- 2--4--6--8-...
	--
	for tateIndex = 0, stretchyCols do
		verts[#verts+1] = {
			{tateIndex * stretchyDX - sw/2, (rowIndex-1) * stretchyDY - sh/2, 0},
			{1, 1, 1, 1},
			{tateIndex * tdx,				(rowIndex-1) * tdy}
		}
		verts[#verts+1] = {
			{tateIndex * stretchyDX - sw/2,  rowIndex    * stretchyDY - sh/2, 0},
			{1, 1, 1, 1},
			{tateIndex * tdx, 				 rowIndex    * tdy}
		}
	end
	
	return verts
end

-- For pixel AMV only!
local pixelRows =  80					-- assuming 4:3
local pixelCols = 105					-- assuming 4:3
local pixelDX = sw/pixelCols
local pixelDY = sh/pixelRows
local texelDX = twscale/pixelCols
local texelDY = thscale/pixelRows
function CalculateQuadsBaseVertices()
	local verts = {}
	
	--
	-- 1--4  5--8  ...
	-- |  |  |  |
	-- 2--3  6--7  ...
	--
	for yokoIndex = 1, pixelRows do
		for tateIndex = 1, pixelCols do
			verts[#verts+1] = {
				{(tateIndex-1) * pixelDX - sw/2, (yokoIndex-1) * pixelDY - sh/2, 0},
				{1, 1, 1, 1},
				{(tateIndex-1) * texelDX, 		 (yokoIndex-1) * texelDY}
			}
			verts[#verts+1] = {
				{(tateIndex-1) * pixelDX - sw/2,  yokoIndex    * pixelDY - sh/2, 0},
				{1, 1, 1, 1},
				{(tateIndex-1) * texelDX,  		  yokoIndex    * texelDY}
			}
			verts[#verts+1] = {
				{ tateIndex    * pixelDX - sw/2,  yokoIndex    * pixelDY - sh/2, 0},
				{1, 1, 1, 1},
				{ tateIndex    * texelDX,  		  yokoIndex    * texelDY}
			}
			verts[#verts+1] = {
				{ tateIndex    * pixelDX - sw/2, (yokoIndex-1) * pixelDY - sh/2, 0},
				{1, 1, 1, 1},
				{ tateIndex    * texelDX, 		 (yokoIndex-1) * texelDY}
			}
		end
	end
	
	return verts
end

local nPathVertices = 60
local nPathHalf		= 30
function CalculatePathBaseVertices(radius)
	radius 		= radius or 0.5 * sh

	local verts = {}
	
	for tateIndex = 0, nPathVertices do
		local angle = tateIndex * 2 * PI / nPathVertices
		verts[#verts+1] = {
			{radius * math.cos(angle), 0, radius * math.sin(angle)},
			{1, 1, 1, 1},
			{0, 0}
		}
	end
	
	return verts
end


function Stretcher_NullShift(x, y, z, a)
	return x, y, z
end
function Alphabeter_NullShift(x, y, z, a)
	return 1
end
function Scroller_NullShift(t)
	return 0
end
discoScrFunction = Scroller_NullShift


function Stretcher_DiscoBall(x, y, z, a)
	local phi = 0.5 * PI * y
	local theta =     PI * x

	return a * math.cos(phi) * math.cos(theta), math.sin(phi), a * math.cos(phi) * math.sin(theta)
end

function CalculateStretchedTextures(verts, stretcher, soul, alphabeter)
	stretcher = stretcher or Stretcher_NullShift
	soul = soul or 0
	alphabeter = alphabeter or Alphabeter_NullShift
	
	-- Coordinate the texture all at once.
	for vertIndex = 1,#verts do
		local x = verts[vertIndex][1][1] / sw
		local y = verts[vertIndex][1][2] / sh
		local z = verts[vertIndex][1][3] / qq
		
		-- The stretching function operates on [-1, 1] × [-1, 1].
		-- The magnitude of the stretcher is expected to be scaled to that same space.
		-- The last parameter is used to parameterize the shape of the stretcher.
		xn, yn, zn = stretcher(2*x, 2*y, 2*z, soul)
		
		-- Apply the stretcher onto the vertices after scaling to texture space.
		-- Note that this is a replacement operation, so don't compound this function.
		verts[vertIndex][1][1] = xn * 0.5 * sw
		verts[vertIndex][1][2] = yn * 0.5 * sh
		verts[vertIndex][1][3] = zn * 0.5 * qq

		-- Huh! Whoa! This is edgy.
		verts[vertIndex][2][4] = alphabeter(2*x, 2*y, 2*z, soul)
	end

	return verts	
end

function CalculatePixelCenteredTextures(verts)	
	-- Coordinate the texture all at once.
	for quadIndex = 1,#verts / 4 do
		local vertIndex = (quadIndex-1) * 4
		local xn = 0
		local yn = 0

		-- Pull all quad texture from the center of the quad.
		for vt = 1,4 do
			xn = xn + 0.25 * verts[vertIndex + vt][1][1]
			yn = yn + 0.25 * verts[vertIndex + vt][1][2]
		end

		local xt = RangeClamp(xn/sw + 0.5, 0, sw-1) * twscale
		local yt = RangeClamp(yn/sh + 0.5, 0, sh-1) * thscale

--		Trace("### ### "..xt..","..yt)
				
		-- Apply the gradient onto the vertices after scaling to texture space.
		for vt = 1,4 do
--			verts[vertIndex + vt][3][1] = 2 * verts[vertIndex + vt][3][1] - xt
--			verts[vertIndex + vt][3][2] = 2 * verts[vertIndex + vt][3][2] - yt
			verts[vertIndex + vt][3][1] = xt
			verts[vertIndex + vt][3][2] = yt
		end
	end

	return verts	
end



local JupinvrRotateXAuxActor	= nil
local JupinvrRotateYAuxActor	= nil
local JupinvrRingTiltAuxActor	= nil
local JupinvrOrbitalAuxActor	= nil
local JupinvrTransitAuxActor	= nil

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		JupinvrRotateXAuxActor = self
		self:aux(0)
	end,

	JupinvrRotateXMessageCommand = function(self, args)
		local duration 	= (#args >= 1) and args[1] or 8
		local newValue 	= (#args >= 2) and args[2] or 0
		local tweenType	= (#args >= 3) and args[3] or 'smooth'

		self[tweenType](self, duration / BPS)
		self:aux(newValue)
	end,
}

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		JupinvrRotateYAuxActor = self
		self:aux(0)
	end,

	JupinvrRotateYMessageCommand = function(self, args)
		local duration 	= (#args >= 1) and args[1] or 8
		local newValue 	= (#args >= 2) and args[2] or 0
		local tweenType	= (#args >= 3) and args[3] or 'smooth'

		self[tweenType](self, duration / BPS)
		self:aux(newValue)
	end,
}

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		JupinvrRingTiltAuxActor = self
		self:aux(0)
	end,

	JupinvrRingTiltMessageCommand = function(self, args)
		local duration 	= (#args >= 1) and args[1] or 8
		local newValue 	= (#args >= 2) and args[2] or 0
		local tweenType	= (#args >= 3) and args[3] or 'smooth'

		self[tweenType](self, duration / BPS)
		self:aux(newValue)
	end,
}

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		JupinvrOrbitalAuxActor = self
		self:aux(0)
	end,

	JupinvrOrbitalMessageCommand = function(self, args)
		local duration 	= (#args >= 1) and args[1] or 8
		local newValue 	= (#args >= 2) and args[2] or 0
		local tweenType	= (#args >= 3) and args[3] or 'smooth'

		self[tweenType](self, duration / BPS)
		self:aux(newValue)
	end,
}

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		JupinvrTransitAuxActor = self
		self:aux(0)
	end,

	EnterJupinvrMessageCommand = function(self, args)
		local tweenTime 	= (#args >= 1) and args[1] or 8
		local endingZoom 	= (#args >= 2) and args[2] or 1.0

		self:decelerate(tweenTime / BPS)
			:aux(endingZoom)
	end,
	LeaveJupinvrMessageCommand = function(self, args)
		local tweenTime 	= (#args >= 1) and args[1] or 8
		local endingZoom 	= (#args >= 2) and args[2] or 0.0

		self:accelerate(tweenTime / BPS)
			:aux(endingZoom)
	end,
}




local JupinvrFrame		= nil
local DiscoBallAMV 		= nil
local SatelliteRingActors = {nil, nil}
local SatelliteProxyActors = {nil, nil}
local ringTilt 			= 15
local ringRadius 		= math.sqrt(sh * sw) * 0.4
local StarsBGActor		= nil
local starsW			= 2048
local starsH			= 512
local starsTweenWidth	= starsW * 0.5 - sw


function JupinvrUpdateFunction()
	local sysRotationX 	= JupinvrRotateXAuxActor :getaux()		-- in degrees, 0 to 90
	local sysRotationY 	= JupinvrRotateYAuxActor :getaux()		-- in degrees, -180 to 180
	local sysTilt		= JupinvrRingTiltAuxActor:getaux()		-- in degrees
	local orbitalParam	= JupinvrOrbitalAuxActor :getaux()		-- [0, 1) periodic
	local sysTransition	= JupinvrTransitAuxActor :getaux()		-- [0, 1]

	JupinvrFrame
		:zoom(sysTransition)

	DiscoBallAMV
		:rotationx(sysRotationX)
		:rotationy(sysRotationY)
	StarsBGActor
		:x(starsTweenWidth * -sysRotationY / 180.0)

	local srai
	for srai = 1,2 do
		SatelliteRingActors[srai]
			:rotationx(sysTilt)
			-- Do not rotate around the Y-axis!
			:rotationz(ringTilt)
	end

	local playerIndex
	local playerAlpha = 1.0 - sysTransition --(1.0 - sysTransition) * (1.0 - sysTransition)
	-- Orbital parameter a:		(cos a, 0, sin a)
	-- After system tilt w:		(cos a, sin a sin w, sin a cos w)
	-- After ring tilt   t:		(cos a cos t - sin a sin w sin t,
	--							 sin a sin w cos t + cos a sin t,
	--							 sin a cos w)
	local jca = math.cos(orbitalParam 	* 2 * PI) * ringRadius
	local jsa = math.sin(orbitalParam 	* 2 * PI) * ringRadius
	local jcw = math.cos(sysTilt 	* DEG_TO_RAD)
	local jsw = math.sin(sysTilt 	* DEG_TO_RAD)
	local jct = math.cos(ringTilt 	* DEG_TO_RAD)
	local jst = math.sin(ringTilt 	* DEG_TO_RAD)
	
	-- z abscissa, x ordinate!
	local xx = jsa*jct - jca*jsw*jst
	local yy = jca*jsw*jct + jsa*jst
	local zz = jca*jcw
	for playerIndex = 1,2 do
		local ss = SideSign(playerIndex)

		SatelliteProxyActors[playerIndex]
			:xy(ss * xx - sw * 0.5, ss * yy - sh * 0.5)
			:z(ss * zz)

		PlayerProxySprites[playerIndex]:diffusealpha(playerAlpha)
	end

end



local JupinvrFrameProto	= Def.ActorFrame {
	Name = "JupinvrFrame",
	InitCommand = function(self)
		JupinvrFrame = self
		ghostSubjects[3] = self

		self:SetUpdateFunction(JupinvrUpdateFunction)
	end,
	OnCommand = function(self)
		self:fov(45)
			:vanishpoint(sw*0.50, sh*0.25)	
			:SetDrawByZPosition(true)
			:zoom(0.0)
			:xy(sw / 2, sh / 2)
			:z(-1)
	end,
}


local DiscoBallProto 	= nil
local DiscoBallPrefetch	= {nil}

function substrateAMV(stratagem)
	local stretchyAMV = 
		Def.ActorFrame {
			Name = stratagem
		}

	for rowIndex = 1,stretchyRows do
		stretchyAMV[#stretchyAMV + 1] =	Def.ActorMultiVertex {
				Name = "StretchyAMVStrip_"..rowIndex,
				InitCommand = function(self)
					local verts = CalculateRowBaseVertices(rowIndex)
					self:aux(rowIndex)
					self:xy(0, 0)
						:SetVertices(verts)
						:SetDrawState{First = 1,
									  Num = (stretchyCols + 1) * 2,
									  Mode = "DrawMode_QuadStrip"}
				end,
			}
	end

	return stretchyAMV
end

for rowIndex = 1,stretchyRows do
	local verts = CalculateRowBaseVertices(rowIndex, true)
	verts = CalculateStretchedTextures(verts, Stretcher_DiscoBall, sh/sw, Alphabeter_NullShift)
	DiscoBallPrefetch[rowIndex] = verts
end


DiscoBallProto = substrateAMV("DiscoBallAMV")
DiscoBallProto["InitCommand"] = function(self)
	self:z(5)
		:zoom(0.6)
		:diffusealpha(1.0)
	DiscoBallAMV = self
end
DiscoBallProto["OnCommand"] = function(self)
	for rowIndex = 1,stretchyRows do
		self:GetChild("StretchyAMVStrip_"..rowIndex)
			:SetVertices(DiscoBallPrefetch[rowIndex])
	end
end

DiscoBallProto["RotateJupinvrMessageCommand"] = function(self, args)
	local tweenTime 	= (#args >= 1) and args[1] or 8
	local endingAngle 	= (#args >= 2) and args[2] or {0, 0, 0}

	self:smooth(tweenTime / BPS)
		:rotationx(endingAngle[1])
		:rotationy(endingAngle[2])
		:rotationz(endingAngle[3])
end


JupinvrFrameProto[#JupinvrFrameProto + 1] = DiscoBallProto


-- Textures of interest
JupinvrFrameProto[#JupinvrFrameProto + 1] = Def.Sprite {
	Name = "GMSurface",
	Texture = "jupinvr.png",
	InitCommand = function(self)
		self:visible(false)

		for rowIndex=1,stretchyRows do
			DiscoBallAMV:GetChild("StretchyAMVStrip_"..rowIndex)
					    :SetTexture( self:GetTexture() )
		end
	end,
}

local ringLineWidth = 12
for ringFB = 1,2 do
	JupinvrFrameProto[#JupinvrFrameProto + 1] = Def.ActorMultiVertex {
		Name = "GMSatelliteRingHalf_"..ringFB,
		InitCommand = function(self)
			local verts = CalculatePathBaseVertices(ringRadius)

			SatelliteRingActors[ringFB] = self
			self:SetVertices(verts)
				:SetLineWidth(ringLineWidth)
				:SetDrawState{First = (ringFB-1) * nPathHalf + 1,
							  Num = nPathHalf+1,
							  Mode = "DrawMode_LineStrip"}
				:z(5.0 - 0.01 * SideSign(ringFB))
				:diffuse({0, 1, 1, 0.6})

		end,
		
		RotateSatPathMessageCommand = function(self, args)
			local tweenTime 	= (#args >= 1) and args[1] or 8
			local endingAngle 	= (#args >= 2) and args[2] or {0, 0}

			self:smooth(tweenTime / BPS)
				:rotationx(endingAngle[1])
				-- Do not rotate around the Y-axis!
				:rotationz(endingAngle[2])
		end
	}
end

for pn = 1,2 do
	JupinvrFrameProto[#JupinvrFrameProto + 1] = Def.ActorProxy {					
		Name = "JupinvrProxyP"..pn,
		InitCommand = function(self)
			SatelliteProxyActors[pn] = self
			self:aux( Whomst(self) )
		end,
		BeginCommand=function(self)
			local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..  self:getaux())
			if McCoy then
				self:SetTarget(McCoy)
				return
			end

			local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..3-self:getaux())
			if McCoy then
				self:SetTarget(McCoy)
				return
			end
			
			self:hibernate(1573)
		end,
	}
end

_FG_[#_FG_ + 1] = JupinvrFrameProto



_FG_[#_FG_ + 1] = Def.Sprite {
	Name = "GMSpace",
	Texture = "stars.png",
	InitCommand = function(self)
		StarsBGActor = self

		self:xy(sw - starsW/2, sh/2)
			:z(-3)
			:zoom(2)
	end,
}

--
--	The ancient discotheque
--
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--
--	Haruka mukashii...
--


--
-- Intro base texture
--
local IntroBaseTexture = nil

local harukaTilt 	= 45	-- degrees
local harukaL 		= 1024
local harukaW 		= 720

_FG_[#_FG_ + 1] = Def.ActorFrameTexture {
	Name = "IntroBaseTexture",
	InitCommand = function(self)
		IntroBaseTexture = self

		self:SetTextureName( self:GetName() )
			:SetWidth( sw )
			:SetHeight( sh )
			:EnableAlphaBuffer( true )
			:Create()
	end,

	Def.ActorFrame {
		OnCommand = function(self)
			self:fov(70)
				:vanishpoint(sw / 2, sh / 2)
		end,

		Def.Sprite {
			Name = "HarukaMukashii",
			Texture = "satesyst-intro.png",
			InitCommand = function(self)
				self:x(sw / 2)
					:y(sh + math.cos(harukaTilt * DEG_TO_RAD) * harukaL * 0.5)
					:z(math.sin(harukaTilt * DEG_TO_RAD) * harukaL * 0.5)
					:rotationx(-harukaTilt)
					:diffuse(1.0, 1.0, 1.0, 1.0)
			end,

			HarukaSlideInMessageCommand = function(self, args)
				local distance 	= args[1] and args[1] or -1.0
				local tweenTime	= args[2] and args[2] or 16.0

				self:linear(tweenTime)
					:addy(distance * harukaL * math.cos(harukaTilt * DEG_TO_RAD))
					:addz(distance * harukaL * math.sin(harukaTilt * DEG_TO_RAD))
			end,
		},
	},
}

-- 
-- Glitch 4
--
local PixelPrefetchNull 	= CalculateQuadsBaseVertices()
local PixelPrefetchEngaged 	= CalculatePixelCenteredTextures(PixelPrefetchNull)

_FG_[#_FG_ + 1] = Def.ActorMultiVertex {
	Name = "PixelAMV",
	InitCommand = function(self)
		self:xy(sw/2, sh/2)
			:SetVertices(PixelPrefetchEngaged)
			:SetDrawState{First = 1,
						  Num = (pixelCols) * (pixelRows) * 4,
						  Mode = "DrawMode_Quads"}
			:diffusealpha(0.0)
	end,

	OnCommand = function(self)
		self:SetTexture( IntroBaseTexture:GetTexture() )
	end,

	PixelShowMessageCommand = function(self, args)
		local alpha 	= args[1] and args[1] or 1.0
		local tweenTime	= args[2] and args[2] or 1.0

		self:decelerate(tweenTime / BPS)
			:diffusealpha(alpha)
	end,
}

--
--	Haruka mukashii...
--
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--
--	Cyberspace frame
--

local cyberMini			= 0.4
local cyberMininininini	= 0.8
local cyberXScl			= 1 - cyberMini * 0.5

local SQRT2_REM			= SQRT2 - 1
local CornSpriteSize	= 48						-- pixels
local CyberspaceFrame 	= nil
local CyberspaceAuxer 	= nil
local CyberspaceLRAux 	= nil
local CyberspaceTBAux 	= nil
local CyberspaceAlpha	= nil
local CyberCornActors	= {nil, nil, nil, nil}		-- DR, DL, UL, UR
local CyberSideActors	= {nil, nil, nil, nil}		--  D,  L,  U,  R
local CyberQuadActors	= {nil, nil, nil, nil}		--  D,  L,  U,  R
local CyberCornStarts	= {							-- DR, DL, UL, UR
	{ 128 * cyberXScl + 32 * SQRT2_REM * cyberXScl,  160 + 32 * SQRT2_REM * cyberXScl},
	{-128 * cyberXScl - 32 * SQRT2_REM * cyberXScl,  160 + 32 * SQRT2_REM * cyberXScl},
	{-128 * cyberXScl - 32 * SQRT2_REM * cyberXScl, -160 - 32 * SQRT2_REM * cyberXScl},
	{ 128 * cyberXScl + 32 * SQRT2_REM * cyberXScl, -160 - 32 * SQRT2_REM * cyberXScl},	
}
local CyberCornPoints	= {							-- DR, DL, UL, UR
	{ 128 * cyberXScl + 32 * SQRT2_REM * cyberXScl,  160 + 32 * SQRT2_REM * cyberXScl},
	{-128 * cyberXScl - 32 * SQRT2_REM * cyberXScl,  160 + 32 * SQRT2_REM * cyberXScl},
	{-128 * cyberXScl - 32 * SQRT2_REM * cyberXScl, -160 - 32 * SQRT2_REM * cyberXScl},
	{ 128 * cyberXScl + 32 * SQRT2_REM * cyberXScl, -160 - 32 * SQRT2_REM * cyberXScl},	
}

function MatrixRotate(angle, point)
	local cx = math.cos(angle)
	local sx = math.sin(angle)

	return {
		point[1] * cx - point[2] * sx,
		point[1] * sx + point[2] * cx
	}
end

function MinArray(a)
	if #a < 1 then
		return nil
	end

	local a_min = a[1]
	local minIndex
	for minIndex = 2,#a do
		a_min = (a[minIndex] < a_min) and a[minIndex] or a_min
	end

	return a_min, minIndex
end

function MaxArray(a)
	if #a < 1 then
		return nil
	end

	local a_max = a[1]
	local maxIndex
	for maxIndex = 2,#a do
		a_max = (a[maxIndex] > a_max) and a[maxIndex] or a_max
	end
	
	return a_max, maxIndex
end

function Extents(angle, cornPoints)
	local cornRotated   = {}
	local cornTpose 	= {{}, {}}		-- x coordinates, y coordinates
	local cornIndex
	for cornIndex = 1,#cornPoints do
		local cr = MatrixRotate(angle, cornPoints[cornIndex])
		cornTpose[1][cornIndex]	= cr[1]
		cornTpose[2][cornIndex]	= cr[2]
		cornRotated[cornIndex]	= cr
	end

	local extents = {{nil, nil}, {nil, nil}}	-- {{xmin, xmax}, {ymin, ymax}}
	extents[1][1] = MinArray(cornTpose[1])
	extents[1][2] = MaxArray(cornTpose[1])
	extents[2][1] = MinArray(cornTpose[2])
	extents[2][2] = MaxArray(cornTpose[2])
	return extents
end

function CornExtents(extents)
	return {
		{extents[1][2], extents[2][2]},
		{extents[1][1], extents[2][2]},
		{extents[1][1], extents[2][1]},
		{extents[1][2], extents[2][1]},
	}
end


function CyberspaceFrameUpdate()
	local angle 	= CyberspaceAuxer:getaux()
	local alpha 	= CyberspaceAlpha:getaux()
	local presLR 	= CyberspaceLRAux:getaux()
	local presTB 	= CyberspaceTBAux:getaux()

	local cornPoints = CornExtents(Extents(angle, CyberCornStarts))


	for cornIndex = 1,4 do
		local vbasA = cornPoints[cornIndex]
		local vbasB = cornPoints[(cornIndex % #cornPoints) + 1]

		-- Fix engagement of LR/TB
		local scrAX =  (vbasA[1] < 0 and -1 or 1) * sw * 0.5
		local scrAY =  (vbasA[2] < 0 and -1 or 1) * sh * 0.5
		local scrBX =  (vbasB[1] < 0 and -1 or 1) * sw * 0.5
		local scrBY =  (vbasB[2] < 0 and -1 or 1) * sh * 0.5

		local vertA = {
			vbasA[1] * presLR + scrAX * (1 - presLR),
			vbasA[2] * presTB + scrAY * (1 - presTB)
		}
		local vertB = {
			vbasB[1] * presLR + scrBX * (1 - presLR),
			vbasB[2] * presTB + scrBY * (1 - presTB)
		}


		local sideCenter = {
			(vertA[1] + vertB[1]) / 2,
			(vertA[2] + vertB[2]) / 2
		}
		local sideLength = {
			math.abs(vertB[1] - vertA[1]),
			math.abs(vertB[2] - vertA[2])
		}

		-- Corner
		CyberCornActors[cornIndex]
			:xy(vertA[1], vertA[2])
			:diffusealpha(alpha)

		-- Side
		CyberSideActors[cornIndex]
			:xy(sideCenter[1], sideCenter[2])
			:diffusealpha(alpha)

		if sideLength[1] > 0.01 then
			CyberSideActors[cornIndex]:zoomx(sideLength[1] / CornSpriteSize - 0.8)		-- Actually too long by 48 px, underlapping corners, but that's OK
		end
		if sideLength[2] > 0.01 then
			CyberSideActors[cornIndex]:zoomx(sideLength[2] / CornSpriteSize - 0.8)		-- Actually too long by 48 px, underlapping corners, but that's OK
		end

		-- Quad
		CyberQuadActors[cornIndex]
			:stretchto(
				sw * 0.5 * (vertA[1] < 0 and -1 or 1), 
				sh * 0.5 * (vertA[2] < 0 and -1 or 1),
				vertB[1],
				vertB[2]
				)
			:diffusealpha(alpha)
	end
end


local CyberspaceFrameProto = Def.ActorFrame {
	Name = "CyberspaceFrame",
	InitCommand = function(self)
		CyberspaceFrame = self
		self:xy(sw / 2, sh / 2)
			:z(3)
			:SetUpdateFunction(CyberspaceFrameUpdate)
	end,
	OnCommand = function(self)
		self:SetDrawByZPosition(true)
	end,
}

for cornIndex = 1,4 do
	-- Corners
	CyberspaceFrameProto[#CyberspaceFrameProto + 1] = Def.Sprite {
		Name = "CyberspaceCorn"..cornIndex,
		Texture = "corner-tpz.png",
		OnCommand = function(self)
			CyberCornActors[cornIndex] = self

			self:baserotationz(90 * (cornIndex - 1))
				:xy(0, 0)
				:z(0.2)
				:diffuse({1, 0, 1, 0})
		end,
	}

	-- Sides
	CyberspaceFrameProto[#CyberspaceFrameProto + 1] = Def.Sprite {
		Name = "CyberspaceSide"..cornIndex,
		Texture = "side-tpz.png",
		OnCommand = function(self)
			CyberSideActors[cornIndex] = self

			self:baserotationz(90 * (cornIndex - 1))
				:xy(0, 0)
				:z(0.1)
				:diffuse({1, 0, 1, 0})
		end,
	}

	-- Quads
	CyberspaceFrameProto[#CyberspaceFrameProto + 1] = Def.Quad {
		Name = "CyberspaceQuad"..cornIndex,
		OnCommand = function(self)
			CyberQuadActors[cornIndex] = self

			self:stretchto(0, 0, 0, 0)
				:z(0.0)
				:diffuse({0,0,0,0})
		end,
	}
end



_FG_[#_FG_ + 1] = CyberspaceFrameProto

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		CyberspaceAuxer = self
		self:aux(0.0)
	end,

	RotateWholeFieldMessageCommand = function(self, args)
		local tweenTime 	= (#args >= 1) and args[1] or 4
		local pn 			= (#args >= 2) and args[2] or 1
		local endingAngle 	= (#args >= 3) and args[3] or 0

		self:smooth(tweenTime / BPS)
			:aux(endingAngle * DEG_TO_RAD)
	end,
}

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		CyberspaceAlpha = self
		self:aux(1.0)
	end,
}

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		CyberspaceLRAux = self
		self:aux(0.0)
	end,

	EngageLRMessageCommand = function(self, args)
		local tweenTime 	= (#args >= 1) and args[1] or 4.0
		local auxExtent 	= (#args >= 2) and args[2] or 1.0

		self:decelerate(tweenTime / BPS)
			:aux(auxExtent)
	end,
	DisengageLRMessageCommand = function(self, args)
		local tweenTime 	= (#args >= 1) and args[1] or 4.0
		local auxExtent 	= (#args >= 2) and args[2] or 0.0

		self:accelerate(tweenTime / BPS)
			:aux(auxExtent)
	end,
}

_FG_[#_FG_ + 1] = Def.Actor {
	InitCommand = function(self)
		CyberspaceTBAux = self
		self:aux(0.0)
	end,

	EngageTBMessageCommand = function(self, args)
		local tweenTime 	= (#args >= 1) and args[1] or 4.0
		local auxExtent 	= (#args >= 2) and args[2] or 1.0

		self:decelerate(tweenTime / BPS)
			:aux(auxExtent)
	end,
	DisengageTBMessageCommand = function(self, args)
		local tweenTime 	= (#args >= 1) and args[1] or 4.0
		local auxExtent 	= (#args >= 2) and args[2] or 0.0

		self:accelerate(tweenTime / BPS)
			:aux(auxExtent)
	end,
}


--
--	Cyberspace frame
--
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
--
-- 		Proxies (as usual)
--

--
--	Player proxies (one apiece)
--
for pn = 1,2 do
	i = 1
	_FG_[#_FG_ + 1] = Def.ActorFrameTexture {	
		Name = "ProxyP"..pn.."Tex",
		Def.ActorFrame {	
			Name = "ProxyP"..pn.."Inner",
			Def.ActorProxy {					
				Name = "ProxyP"..pn,
				InitCommand = function(self)
					self:aux( Whomst(self) )
				end,
				BeginCommand=function(self)
					local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..self:getaux())
					if McCoy then self:SetTarget(McCoy) else self:hibernate(1573) end
				end,
				OnCommand=function(self)
					local McCoy = SCREENMAN:GetTopScreen():GetChild('PlayerP'..self:getaux())
					if McCoy then 
						self:xy(-McCoy:GetX(), -McCoy:GetY())
						self:GetParent():xy(McCoy:GetX(), McCoy:GetY())
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
--				self:aux( Whichst(self) )
				self:fov(75)
				PlayerProxyActors[pn] = self
			end,
			OnCommand = function(self)
			end,

			RotateWholeFieldMessageCommand = function(self, args)
				if args[2] == Whomst(self) or args[2] == 3 then	
					self:finishtweening()
						:smooth(args[1] / BPS)
						:rotationz(args[3])
				end
			end,
		},
		InitCommand = function(self)
--			self:aux( Whichst(self) )
			PlayerProxyTextures[pn] = self
			self:SetTextureName( self:GetName() )
				:SetWidth( sw )
				:SetHeight( sh )
				:EnableAlphaBuffer( true )
				:Create()
		end,
		OnCommand = function(self)
			self:xy(0, 0)
				:z(1)
		end,
	}

	_FG_[#_FG_ + 1] = Def.Sprite {
		Name = "ProxyP"..pn.."Outer",
		InitCommand = function(self)
			PlayerProxySprites[pn] = self
			ghostSubjects[pn] = self

			self:xy(sw / 2, sh / 2)
				:z(0.1)
				:diffuse(1.0, 1.0, 1.0, 1.0)
		end,

		BeginCommand = function(self)
			if PlayerProxyTextures[pn] then
				self:SetTexture( PlayerProxyTextures[pn]:GetTexture() )
			end
		end,

	}
end


--
--	Judgment proxies
--
for pn = 1,2 do
	_FG_[#_FG_ + 1] = Def.ActorProxy {
		Name = "JudgeP"..pn.."Proxy",
		InitCommand = function(self)
			self:aux( Whomst(self) )
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
			self:xy(sw * (0.5 + 0.4 * SideSign(Whomst(self))), sh/2)
				:z(5)
				:zoom(0.75)
		end,
	}
end

--
-- 		Proxies (as usual)
--
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
--
--		Some ghosting!
--

local aftMemory = 
	Def.ActorFrameTexture{
		Name = "GhostMemory",
		InitCommand=function(self)
			aftMemoryActor = self
			self:SetTextureName( self:GetName() )
				:SetWidth( sw )
				:SetHeight( sh )
				:EnableAlphaBuffer( true )
				:Create()
		end,
	}

local aftMemorySubstrateProto = substrateAMV("GhostMemorySubstrate")
aftMemorySubstrateProto["InitCommand"] = function(self)
	aftMemorySubstrate = self
	self:xy(sw/2, sh/2)
		:diffusealpha(1.0)
end
aftMemory[#aftMemory + 1] = aftMemorySubstrateProto



local aftOutput = 
	Def.ActorFrameTexture{
		Name = "GhostOutput",
		InitCommand=function(self)
			aftOutputActor = self
			self:SetTextureName( self:GetName() )
				:SetWidth( sw )
				:SetHeight( sh )
				:EnableAlphaBuffer( true )
				:Create()
				
			for rowIndex=1,stretchyRows do
				Trace("### Setting ghost AMV textures...")
				aftMemorySubstrate
					:GetChild("StretchyAMVStrip_"..rowIndex)
					:SetTexture( self:GetTexture() )
			end
		end,

		Def.Sprite{	
			Name = "GhostSprite",
			InitCommand=function(self)
				aftOutSprActor = self
				self:Center()
					:diffusealpha(0.99)
			end,
			BeginCommand=function(self)
				if aftMemoryActor then
					self:SetTexture(aftMemoryActor:GetTexture())
					Trace("### Set ghost sprite to memory texture!!")
				else
					Trace("### No ghost memory texture!!")
				end
			end,
			StopTrailMessageCommand=function(self)
				self:diffusealpha(0.0)
			end,
			StartTrailMessageCommand=function(self)
				self:diffusealpha(0.99)
					:blend("BlendMode_Add")
			end,
			HighTrailMessageCommand=function(self)
				self:diffusealpha(1.0)
					:blend("BlendMode_Normal")
			end,
		},

		GhostProxiesPulseMessageCommand=function(self, args)
			for _,gsi in ipairs(args) do
				ghostSubjActors[gsi]:visible(true)
			end
			self:GetParent():Draw()
			for _,gsi in ipairs(args) do
				ghostSubjActors[gsi]:visible(false)
			end
		end,
	}


-- TODO: who gets the proxies?
for ghostSubjIndex = 1,nGhostSubjects do
	aftOutput[#aftOutput + 1] = 
		Def.ActorProxy {
			Name = "GhostSubject_"..ghostSubjIndex,
			InitCommand = function(self)
				ghostSubjActors[ghostSubjIndex] = self
				self:aux( Whichst(self) )
			end,
			BeginCommand = function(self)
				Trace("### Looking for ghost subject #"..ghostSubjIndex.."!")
				local McCoy = ghostSubjects[ghostSubjIndex]
				if McCoy then 
					self:SetTarget(McCoy)
					Trace("### Got ghost subject #"..ghostSubjIndex.."!")
				else 
					self:hibernate(1573)
				end
			end,
			OnCommand = function(self)
			end,

			GhostProxiesOffMessageCommand=function(self, args)
				if args[1] == Whichst(self) then
					self:visible(false)
				end
			end,
			GhostProxiesOnMessageCommand=function(self, args)
				if args[1] == Whichst(self) then
					self:visible(true)
				end
			end,
		}
end
	
local ghostDude = 
	Def.Sprite{
		Name = "GhostDude",
		InitCommand=function(self)
			ghostDudeActor = self
			self:Center()
		end,
		BeginCommand=function(self)
			if aftOutputActor then
				self:SetTexture(aftOutputActor:GetTexture())
			else
				Trace("### No ghost output texture!!")
			end
		end,
		OnCommand=function(self)
			self:z(0.5)
				:blend("BlendMode_Add")
				:diffuse({1,1,1,0.3})
				:visible(true)
		end,
		GhostDiffuseMessageCommand=function(self, args)
			if args[1] then
				self:finishtweening()
					:decelerate(args[1] / BPS)
			else
				self:finishtweening()
			end

			if args[2] then
				if #args[2] == 3 then
					local alpha = self:GetDiffuseAlpha()
					self:diffuse(args[2][1], args[2][2], args[2][3], alpha)
				elseif #args[2] == 4 then
					self:diffuse(args[2][1], args[2][2], args[2][3], args[2][4])
				elseif type(args[2]) == "number" then
					self:diffusealpha(args[2])
				else
					self:diffusealpha(args[2][1])
				end
			else
			end
		end,
	}
	
_FG_[#_FG_ + 1] = aftMemory
_FG_[#_FG_ + 1] = aftOutput
_FG_[#_FG_ + 1] = ghostDude

--
--		Some ghosting!
--
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--
-- 		This is where the shit will be happening.
--

local messageList = {
	{  0.000, "DisengageTB",		{ 0.0}},
	{  0.000, "DisengageLR",		{ 0.0}},
	{  4.000, "RecenterProxy"},


	{  0.000, "JupinvrRotateX",		{ 0.0,   15}},
	{  0.000, "JupinvrRingTilt",	{ 0.0,   15}},
	{  0.000, "JupinvrRotateY",		{ 0.0, -180}},

	{  4.000, "PixelShow",			{ 1.0, 4}},
	{  4.000, "HarukaSlideIn",		{-3.0, 32}},
	{ 32.000, "PixelShow",			{ 0.0, 4}},

	{ 24.500, "EngageTB",			{ 3.0}},	
	{ 28.000, "EngageLR",			{ 4.0}},


	{ 98.000, "DisengageTB",		{ 1.5}},
	{ 98.000, "DisengageLR",		{ 1.5}},
	{ 99.000, "EnterJupinvr",		{ 1.0, 1.0}},

	{100.000, "JupinvrRotateY",		{ 7.0,  -90, 'linear'}},
	{108.000, "JupinvrRotateY",		{ 7.0,    0, 'linear'}},
	{116.000, "JupinvrRotateY",		{ 7.0,   90, 'linear'}},
	{124.000, "JupinvrRotateY",		{ 7.0,  180, 'linear'}},
	{100.000, "JupinvrOrbital",		{ 7.0,  0.5, 'smooth'}},
	{108.000, "JupinvrOrbital",		{ 7.0,    0, 'smooth'}},
	{116.000, "JupinvrOrbital",		{ 7.0,  0.5, 'smooth'}},
	{124.000, "JupinvrOrbital",		{ 7.0,    0, 'smooth'}},
	{100.000, "JupinvrRingTilt",	{ 7.0,  -10}},
	{108.000, "JupinvrRingTilt",	{ 7.0,   10}},
	{116.000, "JupinvrRingTilt",	{ 7.0,  -20}},
	{124.000, "JupinvrRingTilt",	{ 7.0,   20}},

	{130.500, "LeaveJupinvr",		{ 1.5}},

	{130.500, "EngageTB",			{ 1.5, 0.5}},
	{130.500, "EngageLR",			{ 1.5, 0.2}},

	{163.000, "EngageTB",			{ 1.0}},
	{163.000, "EngageLR",			{ 1.0}},

	{164.000, "RotateWholeField",	{ 7.0, 3,   75}},
	{172.000, "RotateWholeField",	{ 7.0, 3,    0}},
	{180.000, "RotateWholeField",	{ 7.0, 3,  -75}},
	{188.000, "RotateWholeField",	{ 7.0, 3,    0}},


	{195.000, "DisengageTB",		{ 1.0}},
	{195.000, "DisengageLR",		{ 1.0}},
	{195.000, "EnterJupinvr",		{ 1.0, 1.0}},

	{196.000, "JupinvrRotateY",		{ 7.0,   90, 'linear'}},
	{204.000, "JupinvrRotateY",		{ 7.0,    0, 'linear'}},
	{212.000, "JupinvrRotateY",		{ 7.0,  -90, 'linear'}},
	{220.000, "JupinvrRotateY",		{ 7.0, -180, 'linear'}},
	{196.000, "JupinvrOrbital",		{ 7.0, -0.5, 'smooth'}},
	{204.000, "JupinvrOrbital",		{ 7.0,    0, 'smooth'}},
	{212.000, "JupinvrOrbital",		{ 7.0, -0.5, 'smooth'}},
	{220.000, "JupinvrOrbital",		{ 7.0,    0, 'smooth'}},
	{196.000, "JupinvrRingTilt",	{ 7.0,  -15}},
	{204.000, "JupinvrRingTilt",	{ 7.0,   15}},
	{212.000, "JupinvrRingTilt",	{ 7.0,  -30}},
	{220.000, "JupinvrRingTilt",	{ 7.0,   30}},


	{224.000, "EngageTB",			{ 4.0}},
	{224.000, "EngageLR",			{ 4.0}},
	{220.000, "LeaveJupinvr",		{ 8.0}},


}

for chunkIndex = 0,3 do
	for repIndex = 0,8 do
		local beatIndex =  36 + 0.75 *  repIndex	  +  8 * chunkIndex
		local beatDeg 	=		  10 * (repIndex + 1) + 90 * chunkIndex
		messageList[#messageList + 1] = {beatIndex, "RotateWholeField",	{0.5, 3, beatDeg}}
	end
end

for chunkIndex = 0,3 do
	for repIndex = 0,8 do
		local beatIndex =  68 + 0.75 *  repIndex	  +  8 * chunkIndex
		local beatDeg 	= 360 -   10 * (repIndex + 1) - 90 * chunkIndex
		messageList[#messageList + 1] = {beatIndex, "RotateWholeField",	{0.5, 3, beatDeg}}
	end
end


messageList = SortModsTable(messageList)

gfxUpdateFunction = function()
	-- Most things are determined by beat, believe it or not.		
	overtime = GAMESTATE:GetSongBeat() - visualOffset
	
	-- TODO: this assumes the effect applies over a constant BPM section!!
	BPS = GAMESTATE:GetSongBPS()
	
	-- Initializations
	if overtime >=   0.0 and not checked then
		for i,v in ipairs(plr) do
			if v then
				v:visible(false)
				 :x(sw/2)
--				 :y(sh/2 - 30)
				 :z(0)
			end
		end

		checked = true
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
				break
			end
		else
			break
		end
	end


	for pn = 1,2 do
		if PlayerProxyActors[pn] then
			PlayerProxyActors[pn]:x(sw * 0.5 + sw * 0.25 * SideSign(pn) * (1 - CyberspaceLRAux:getaux()))
		end
	end

--	Trace('Update @ ' .. GAMESTATE:GetSongBeat() .. " (" .. GAMESTATE:GetCurMusicSeconds() .. " sec.)")
end


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


-- Load the mods table parser into this script.
local sheefturzerus = 0.1
modsTable = {
	-- [1]: beat start
	-- [2]: mod type
	-- [3]: mod strength (out of unity),
	-- [4]: mod approach (in beats to complete)
	-- [5]: player application (1 = P1, 2 = P2, 3 = both, 0 = neither)
		
		{   0.0,	"ScrollSpeed",			  1.0,    4.0,	3}, 
		{   0.0,	"MaxScrollBPM",			  420,    4.0,	3}, 
		{   0.0,	"Dark",					  1.0,    0.0,	3}, 
		{   0.0,	"Mini",				cyberMini,    4.0,	3}, 


		{   4.0,	"Dark",					  0.0,   32.0,	3}, 
		{  99.0,	"Mini",		cyberMininininini,    1.0,	3}, 
		{  99.0,	"Reverse",				  0.2,    1.0,	3}, 

		{ 130.5,	"Mini",				cyberMini,    1.5,	3}, 
		{ 130.5,	"Reverse",				  0.0,    1.5,	3}, 


		{ 132.25,	"Tiny",					  1.0,    0.25,	3}, 
		{ 132.75,	"Tiny",					  0.0,    0.25,	3}, 
		{ 133.25,	"Tiny",					 -0.5,    0.25,	3}, 
		{ 133.75,	"Tiny",					  0.0,    0.25,	3}, 

		{ 134.75,	"Cross",	  sheefturzerus*2,	  0.25,	3 },
		{ 134.75,	"Reverse",	 -sheefturzerus,  	  0.25,	3 },
		{ 135.25,	"Cross",	 -sheefturzerus*2,	  0.25,	3 },
		{ 135.25,	"Reverse",	  sheefturzerus,  	  0.25,	3 },
		{ 135.75,	"Cross",	  			  0.0,	  0.25,	3 },
		{ 135.75,	"Reverse",	 			  0.0, 	  0.25,	3 },

		{ 136.75,	"Cross",	 -sheefturzerus*2,	  0.25,	3 },
		{ 136.75,	"Reverse",	  sheefturzerus,  	  0.25,	3 },
		{ 137.25,	"Cross",	  sheefturzerus*2,	  0.25,	3 },
		{ 137.25,	"Reverse",	 -sheefturzerus,  	  0.25,	3 },
		{ 137.75,	"Cross",	  			  0.0,	  0.25,	3 },
		{ 137.75,	"Reverse",	 			  0.0, 	  0.25,	3 },

		{ 140.00,	"Tipsy",				  2.0,    5.25,	1}, 
		{ 140.00,	"Drunk",				  2.0,    5.25,	1}, 
		{ 140.00,	"Dizzy",				  3.0,    5.25,	1}, 
		{ 140.00,	"Twirl",				  0.5,    5.25,	1},
		{ 140.00,	"Tipsy",				 -2.0,    5.25,	2}, 
		{ 140.00,	"Drunk",				 -2.0,    5.25,	2}, 
		{ 140.00,	"Dizzy",				 -3.0,    5.25,	2}, 
		{ 140.00,	"Twirl",				 -0.5,    5.25,	2},
		{ 145.25,	"Tipsy",				  0.0,    0.75,	3}, 
		{ 145.25,	"Drunk",				  0.0,    0.75,	3}, 
		{ 145.25,	"Dizzy",				  0.0,    0.75,	3}, 
		{ 145.25,	"Twirl",				  0.0,    0.75,	3},

		{ 145.75,	"Alternate", -sheefturzerus*2,	  0.25,	3 },
		{ 145.75,	"Reverse",	  sheefturzerus,  	  0.25,	3 },
		{ 146.25,	"Alternate",  sheefturzerus*2,	  0.25,	3 },
		{ 146.25,	"Reverse",	 -sheefturzerus,  	  0.25,	3 },
		{ 146.75,	"Alternate", -sheefturzerus*2,	  0.25,	3 },
		{ 146.75,	"Reverse",	  sheefturzerus,  	  0.25,	3 },
		{ 147.25,	"Alternate",  sheefturzerus*2,	  0.25,	3 },
		{ 147.25,	"Reverse",	 -sheefturzerus,  	  0.25,	3 },
		{ 147.75,	"Alternate", 			  0.0,	  0.25,	3 },
		{ 147.75,	"Reverse",				  0.0,    0.25,	3 },


		{ 148.25,	"Tiny",					  1.0,    0.25,	3}, 
		{ 148.75,	"Tiny",					  0.0,    0.25,	3}, 
		{ 149.25,	"Tiny",					 -0.5,    0.25,	3}, 
		{ 149.75,	"Tiny",					  0.0,    0.25,	3}, 

		{ 150.75,	"Split",	  sheefturzerus*2,	  0.25,	3 },
		{ 150.75,	"Reverse",	 -sheefturzerus,  	  0.25,	3 },
		{ 151.25,	"Split",	 -sheefturzerus*2,	  0.25,	3 },
		{ 151.25,	"Reverse",	  sheefturzerus,  	  0.25,	3 },
		{ 151.75,	"Split",	  			  0.0,	  0.25,	3 },
		{ 151.75,	"Reverse",	 			  0.0, 	  0.25,	3 },

		{ 152.75,	"Split",	 -sheefturzerus*2,	  0.25,	3 },
		{ 152.75,	"Reverse",	  sheefturzerus,  	  0.25,	3 },
		{ 153.25,	"Split",	  sheefturzerus*2,	  0.25,	3 },
		{ 153.25,	"Reverse",	 -sheefturzerus,  	  0.25,	3 },
		{ 153.75,	"Split",	  			  0.0,	  0.25,	3 },
		{ 153.75,	"Reverse",	 			  0.0, 	  0.25,	3 },

		{ 156.00,	"Tipsy",				  2.0,    5.25,	1}, 
		{ 156.00,	"Drunk",				  2.0,    5.25,	1}, 
		{ 156.00,	"Roll",					  0.5,    5.25,	1}, 
		{ 156.00,	"Dizzy",				  3.0,    5.25,	1},
		{ 156.00,	"Tipsy",				 -2.0,    5.25,	2}, 
		{ 156.00,	"Drunk",				 -2.0,    5.25,	2}, 
		{ 156.00,	"Roll",					 -0.5,    5.25,	2}, 
		{ 156.00,	"Dizzy",				 -3.0,    5.25,	2},
		{ 161.25,	"Tipsy",				  0.0,    0.75,	3}, 
		{ 161.25,	"Drunk",				  0.0,    0.75,	3}, 
		{ 161.25,	"Roll",					  0.0,    0.75,	3}, 
		{ 161.25,	"Dizzy",				  0.0,    0.75,	3},

		{ 162.95,	"Stealth", 				  0.8,	  0.05,	3 },
		{ 162.95,	"Dark", 				  1.0,	  0.05,	3 },
		{ 163.00,	"Stealth", 				  0.0,	  1.00,	3 },
		{ 163.00,	"Dark", 				  0.0,	  1.00,	3 },



		{ 195.0,	"Mini",		cyberMininininini,    1.0,	3}, 
		{ 195.0,	"Reverse",				  0.2,    1.0,	3}, 

		{ 220.0,	"Mini",				cyberMini,    8.0,	3},
		{ 220.0,	"Reverse",				  0.0,    8.0,	3},  
		{ 220.0,	"Dark",					  1.0,    8.0,	3}, 
}


function AddURShift(playerNumber, beatIndex, duration, shiftU, shiftR)
	local i =  0.75 * shiftU - 0.25 * shiftR
	local f = -0.25 * shiftU - 0.25 * shiftR

	modsTable[#modsTable + 1] = {beatIndex,	"Flip",     f,	duration,	playerNumber}
	modsTable[#modsTable + 1] = {beatIndex,	"Invert",   i,	duration,	playerNumber}
end

-- Difficult Rhythms !!
for beatIndex = 100,116,8 do
	AddURShift(3, beatIndex - 0.25, 0.25,  0.00, -1.00)
	AddURShift(3, beatIndex + 6.00, 1.00,  0.00,  0.00)
end
for beatIndex = 196,212,8 do
	AddURShift(3, beatIndex - 0.25, 0.25,  0.00, -1.00)
	AddURShift(3, beatIndex + 6.00, 1.00,  0.00,  0.00)
end

-- wheeeeee
AddURShift(3, 135.00, 0.25,  1.00, -1.00)
AddURShift(3, 135.50, 0.25,  0.00,  0.00)
AddURShift(3, 137.00, 0.25,  1.00, -1.00)
AddURShift(3, 137.50, 0.25,  0.00,  0.00)

AddURShift(3, 146.00, 0.25,  1.00, -1.00)
AddURShift(3, 146.50, 0.25,  0.00,  0.00)
AddURShift(3, 147.00, 0.25,  1.00, -1.00)
AddURShift(3, 147.50, 0.25,  0.00,  0.00)

AddURShift(3, 151.00, 0.25, -2.00, -2.00)
AddURShift(3, 151.50, 0.25,  0.00,  0.00)
AddURShift(3, 153.00, 0.25, -2.00, -2.00)
AddURShift(3, 153.50, 0.25,  0.00,  0.00)



modsTable = SortModsTable(modsTable)
_FG_[#_FG_ + 1] = LoadActor("./modsHQ.lua", {modsTable, 0})



return _FG_
