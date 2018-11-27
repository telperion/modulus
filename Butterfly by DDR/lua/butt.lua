-------------------------------------------------------------------------------
--
--		Butt***** by DDR
--		
--		Author: 	Telperion
--		Date: 		2018-11-25
--
-------------------------------------------------------------------------------

buttVariety = ... or 1

flapSpeed = 1.0		-- seconds per full cycle
flapCrisp = 0.2		-- proportion spent flapping up/in

local B = Def.ActorFrame {
	Def.Actor { 
		Name = "slep",
		OnCommand = function(self) self:sleep(1573) end
	},

	InitCommand = function(self)
	end,
	OnCommand = function(self)
	end,

	Def.ActorFrame {
		Name = "WingLOuter",
		Def.Sprite {
			Name = "WingLInner",
			Texture = "butts/butt-"..string.char(buttVariety+64)..".png",

			InitCommand = function(self)
				self:xy(-128, 0)
					:SetWidth(256)
					:SetHeight(512)
			end,
			OnCommand = function(self)
			end,
		},
		OnCommand = function(self)
			self:queuecommand("WingUp")
		end,
		WingUpCommand = function(self)
			self:decelerate(flapSpeed * flapCrisp)
				:rotationy(-90)
				:queuecommand("WingDn")
		end,
		WingDnCommand = function(self)
			self:decelerate(flapSpeed * (1.0-flapCrisp))
				:rotationy(0)
				:queuecommand("WingUp")
		end,
	},
	Def.ActorFrame {
		Name = "WingROuter",
		Def.Sprite {
			Name = "WingRInner",
			Texture = "butts/butt-"..string.char(buttVariety+64)..".png",

			InitCommand = function(self)
				self:xy(128, 0)
					:SetWidth(256)
					:SetHeight(512)
					:zoomx(-1)
			end,
			OnCommand = function(self)
			end,
		},
		InitCommand = function(self)
			self:SetDrawByZPosition(true)
		end,
		OnCommand = function(self)
			self:queuecommand("WingUp")
		end,
		WingUpCommand = function(self)
			self:decelerate(flapSpeed * flapCrisp)
				:rotationy(90)
				:queuecommand("WingDn")
		end,
		WingDnCommand = function(self)
			self:decelerate(flapSpeed * (1.0-flapCrisp))
				:rotationy(0)
				:queuecommand("WingUp")
		end,
	},
}

return B