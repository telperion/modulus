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

_SB_ = Def.ActorFrame{
	InitCommand = function(self)
	end,
	OnCommand = function(self)
		self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
			:sleep(1573)
	end,


	Def.Sprite {
		Texture = '_venice classic 38px [main]',
		InitCommand = function(self)
		end,
		OnCommand = function(self)
			self:animate(false)
				:setstate(54)
		end
	}
}

return _SB_
