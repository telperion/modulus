Trace('### Tel needs help.')

if not telp then

	PI = math.pi
	LOG2 = math.log(2.0)
	LOG3 = math.log(3.0)
	DEG_TO_RAD = math.pi / 180.0

	telp = {}
	telp.S2 = function(a)
		return math.mod(a, 2) >= 1 and 1 or -1
	end
	telp.S4 = function(a)
		return math.mod(a, 4) >= 2 and 1 or -1
	end
	telp.b2t = function(b)
		local bpmHere = 60		-- for setmefree
		return b*(60/bpmHere)
	end
	telp.b2s = function(b)
		return 1/b2t(b)
	end
	telp.clamp = function(t, tLo, tHi)
		if 		((t < tLo) and (tLo < tHi)) or
				((tHi < tLo) and (tLo < t)) then
			return 0
		elseif 	((tLo < tHi) and (tHi < t)) or 
				((t < tHi) and (tHi < tLo))then
			return 1
		else
			return (t-tLo)/(tHi-tLo)
		end
	end

	-- telp.HSV2RGB()
	--
	-- receives: 3-element table
	--		[1]:	hue, 0.0 to 1.0 -> 0 to 360 degrees
	--		[2]:	sat, 0.0 to 1.0 -> fullscale saturation
	--		[3]:	val, 0.0 to 1.0 -> fullscale value
	--
	-- returns: 3-element table
	--		[1]:	red 	0.0 to 1.0 -> fullscale
	--		[2]:	green	0.0 to 1.0 -> fullscale
	--		[3]:	blue	0.0 to 1.0 -> fullscale
	--
	--
	telp.HSV2RGB = function(hsv)
		rgbTemp = {0, 0, 0}

		hueScale = ((hsv[1] % 1.0)*6.0 + 6.0) % 6.0
		if     hueScale < 1 then
	      rgbTemp[1] = 1.0
	      rgbTemp[2] = hueScale % 1.0
	      rgbTemp[3] = 0.0
		elseif hueScale < 2 then
	      rgbTemp[1] = 1.0 - (hueScale % 1.0)
	      rgbTemp[2] = 1.0
	      rgbTemp[3] = 0.0
		elseif hueScale < 3 then
	      rgbTemp[1] = 0.0
	      rgbTemp[2] = 1.0
	      rgbTemp[3] = hueScale % 1.0
		elseif hueScale < 4 then
	      rgbTemp[1] = 0.0
	      rgbTemp[2] = 1.0 - (hueScale % 1.0)
	      rgbTemp[3] = 1.0
		elseif hueScale < 5 then
	      rgbTemp[1] = hueScale % 1.0
	      rgbTemp[2] = 0.0
	      rgbTemp[3] = 1.0
		else --hueScale < 6
	      rgbTemp[1] = 1.0
	      rgbTemp[2] = 0.0
	      rgbTemp[3] = 1.0 - (hueScale % 1.0)
		end

		rgb = {
			hsv[3] + (rgbTemp[1] - hsv[3]) * hsv[2],
			hsv[3] + (rgbTemp[2] - hsv[3]) * hsv[2],
			hsv[3] + (rgbTemp[3] - hsv[3]) * hsv[2]
		}

		return rgb
	end

	telp.randlist = function(n)
		x = {}
		for i = 1,n do
			v = math.random(#x + 1)
			for j = #x,v,-1 do
				x[j+1] = x[j]
			end
			x[v] = i
		end
		return x
	end

	--[[

	-- THESE ARE DIRECT FROM nITG AND ARE NOT SUITABLE FOR SM5.x
	-- PLEASE UPDATE BEFORE YOU UNCOMMENT AND F:heck:NK YOURSELF

	--Thanks based FMS_Cat
	function nise_tel_createAft(aftSrc)
		aftSrc:SetWidth(DISPLAY:GetDisplayWidth())
		aftSrc:SetHeight(DISPLAY:GetDisplayHeight())
		aftSrc:EnableDepthBuffer(false)
		aftSrc:EnableAlphaBuffer(true)
		aftSrc:EnableFloat(false)
		aftSrc:EnablePreserveTexture(true)
		aftSrc:fov(60)
	--	aftSrc:sleep(0.04)	-- So RAM doesn't shit out garbage textures.
							-- actually this is REALLY BAD because then it's used before it's created
							-- do this in the target instead!!
		aftSrc:Create()
	--				Trace('@@@ alright a texture is create')
	end

	function nise_tel_prepAft(aftDst)
	--				Trace('@@@ alright im gonna try to prep texture')
		-- Make sure to specify this actor's RenderMeCommand.
		aftDst:basezoomx((SCREEN_WIDTH)/DISPLAY:GetDisplayWidth())
		aftDst:basezoomy(-(SCREEN_HEIGHT)/DISPLAY:GetDisplayHeight())
		aftDst:diffusealpha(0)
		aftDst:sleep(0.04)	-- So RAM doesn't shit out garbage textures.
		aftDst:queuecommand('RenderMe')	
	end

	function nise_tel_setAft(aftDst,aft,initialDiffuse)
		-- Placed in a RenderMeCommand.
		-- Man, I wish this was SM5 so I could just add the command directly :P
		if not aft then
			Trace('@@@ wtf you doing!! this AFT doesn\'t exist yet')
			return
		end
		if not aft:GetTexture() then
			Trace('@@@ wtf you doing!! this AFT\'d texture fuckening')
			return
		end
		
	--				Trace('@@@ alright im gonna try to set texture')
		aftDst:SetTexture(aft:GetTexture())
		if not initialDiffuse then initialDiffuse = 0; aftDst:hidden(1) end
		if initialDiffuse < 0 then initialDiffuse = 1; aftDst:hidden(1) end
		aftDst:diffusealpha(initialDiffuse)
	end




	-- im still need splines 			
	function applySpline(spd,axis,col,path,pn)
		for b=1,table.getn(path) do
			local a = Plr(pn)
			if a then
				if axis == 'x' then
					a:SetXSpline(b-1,col,path[b][2],path[b][1],spd)
				elseif axis == 'y' then
					a:SetYSpline(b-1,col,path[b][2],path[b][1],spd)
				elseif axis == 'z' then
					a:SetZSpline(b-1,col,path[b][2],path[b][1],spd)
				elseif axis == 'size' then
					a:SetSizeSpline(b-1,col,path[b][2],path[b][1],spd)
				end --etc.
				--Trace('$$$$$$$ b['..b..']')
			end
		end
		Trace('$$$ applySpline')
		Trace('$$$ '..spd..', '..axis..', '..col..', '..table.getn(path)..', '..pn)
	end

	function applySplineAllP(spd,axis,path)
		for pn=1,6 do
			applySplineAll(spd,axis,path,pn)
		end
		Trace('$$$ applySplineAllP')
	end

	function applySplineAll(spd,axis,path,pn)
		for b=1,table.getn(path) do
			local a = Plr(pn)
			if a then
				if axis == 'x' then
					a:SetXSpline(b-1,-1,path[b][2],path[b][1],spd)
				elseif axis == 'y' then
					a:SetYSpline(b-1,-1,path[b][2],path[b][1],spd)
				elseif axis == 'z' then
					a:SetZSpline(b-1,-1,path[b][2],path[b][1],spd)
				elseif axis == 'size' then
					a:SetSizeSpline(b-1,-1,path[b][2],path[b][1],spd)
				end
				--Trace('$$$$$$$ b['..b..']')
			end
		end
		Trace('$$$ applySplineAll')
	end
	]]--



	--s/o to BrotherMojo
	function mindf_reverseRotation(angleX, angleY, angleZ)
		local sinX = math.sin(angleX);
		local cosX = math.cos(angleX);
		local sinY = math.sin(angleY);
		local cosY = math.cos(angleY);
		local sinZ = math.sin(angleZ);
		local cosZ = math.cos(angleZ);
		return { math.atan2(-cosX*sinY*sinZ-sinX*cosZ,cosX*cosY),
				 math.asin(-cosX*sinY*cosZ+sinX*sinZ),
				 math.atan2(-sinX*sinY*cosZ-cosX*sinZ,cosY*cosZ) }
	end

	function mindf_rotateAndCounter(xDegrees, yDegrees, zDegrees, player_or_object)
		local DEG_TO_RAD = math.pi / 180;
		local angles = mindf_reverseRotation(xDegrees * DEG_TO_RAD, yDegrees * DEG_TO_RAD, zDegrees * DEG_TO_RAD);
		local str = ''
		if type(player_or_object) == 'number' then
		str = '*-1 '..xDegrees..' rotationx, *-1 '..
					yDegrees..' rotationy, *-1 '..
					zDegrees..' rotationz, '
		else
			if player_or_object then
				player_or_object:rotationx(xDegrees)
				player_or_object:rotationy(yDegrees)
				player_or_object:rotationz(zDegrees)
			end
		end
		str = str..'*-1 '..(angles[1]*100)..' confusionxoffset, *-1 '..
					(angles[2]*100)..' confusionyoffset, *-1 '..
					(angles[3]*100)..' confusionzoffset';
					
		return str
	end

	function mod_GetCounterRotation(xDegrees, yDegrees, zDegrees)
		local DEG_TO_RAD = math.pi / 180;
		local angles = mindf_reverseRotation(xDegrees * DEG_TO_RAD, yDegrees * DEG_TO_RAD, zDegrees * DEG_TO_RAD);
		return {angles[1]*100, angles[2]*100, angles[3]*100}
	end







	-- Have some vector ops 
	--
	-- IMPLEMENTED ON 3-ELEMENT VECTORS
	-- BUT YOU KNOW I'M A DOOFUS AND WILL FORGET
	-- SO CALL ME MAYBE
	vectors = {}
	vectors.sum = function(vec1, vec2)
	--					Trace('### vectors.sum')
		return {
			vec1[1] + vec2[1],
			vec1[2] + vec2[2],
			vec1[3] + vec2[3],
		}
	end
	vectors.difference = function(vec1, vec2)
	--					Trace('### vectors.difference')
		-- vec1 - vec2
		return {
			vec1[1] - vec2[1],
			vec1[2] - vec2[2],
			vec1[3] - vec2[3],
		}
	end
	vectors.scale = function(vec1, s1)
	--					Trace('### vectors.scale')
		return {
			vec1[1]*s1,
			vec1[2]*s1,
			vec1[3]*s1
		}
	end
	vectors.dot = function(vec1, vec2)
	--					Trace('### vectors.dot')
		return vec1[1]*vec2[1] + vec1[2]*vec2[2] + vec1[3]*vec2[3]
	end
	vectors.angle = function(vec1, vec2)
	--					Trace('### vectors.angle')
		return math.acos(vectors.dot(vec1, vec2) / (vectors.norm(vec1) * vectors.norm(vec2)))
	end
	vectors.norm = function(vec1)
	--					Trace('### vectors.norm')
		return math.sqrt(vectors.dot(vec1, vec1))
	end
	vectors.unit = function(vec1)
	--					Trace('### vectors.unit')
		return vectors.scale(vec1, 1.0 / vectors.norm(vec1))
	end
	vectors.cross = function(vec1, vec2, normalize)
	--					Trace('### vectors.cross')
		return {
			vec1[2]*vec2[3] - vec1[3]*vec2[2],
			vec1[3]*vec2[1] - vec1[1]*vec2[3],
			vec1[1]*vec2[2] - vec1[2]*vec2[1]
		}
	end
	vectors.trace = function(vec1, name1)	
		if not name1 then name1 = '' end
		Trace('### '..name1..': {'..
			vec1[1]..', '..
			vec1[2]..', '..
			vec1[3]..'}')
	end

end