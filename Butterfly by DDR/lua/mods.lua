--THE FUTURE OF ENTERTAINMENT AND MODIFIERS 2016
--(C) TaroNuke

--Note: may be missing one or two mods.....

function mod_strSplit(str, delim, maxNb)
	-- Eliminate bad cases...
	if string.find(str, delim) == nil then
		return { str }
	end
	if maxNb == nil or maxNb < 1 then
		maxNb = 0    -- No limit
	end
	local result = {}
	local pat = '(.-)' .. delim .. '()'
	local nb = 0
	local lastPos
	for part, pos in string.gfind(str, pat) do
		nb = nb + 1
		result[nb] = part
		lastPos = pos
		if nb == maxNb then break end
	end
	-- Handle the last field
	if nb ~= maxNb then
		result[nb + 1] = string.sub(str, lastPos)
	end
	return result
end

function taronuke_mods(str, pn)
	if pn and type(pn) == "number" then pn = 'PlayerNumber_P' .. pn end
	local ps = GAMESTATE:GetPlayerState(pn)
	local po = ps:GetPlayerOptions('ModsLevel_Song')
	
	local m = mod_strSplit(str,',')
	
	for i=1,#m do
		local mod = mod_strSplit(m[i],' ')
		
		if mod[1] == ' ' or mod[1] == '' or not mod[1] then
			table.remove(mod,1);
		end
		
		if mod == {'clearall'} then
			mod_clearall(po)
		elseif #mod == 1 then
			if tonumber(string.sub(mod[1],1,-2)) and string.lower(string.sub(mod[1],-1)) == 'x' then
				mod_xmod(po,tonumber(string.sub(mod[1],1,-2)),1);
			elseif tonumber(string.sub(mod[1],2)) and string.lower(string.sub(mod[1],1,1)) == 'c' then
				mod_cmod(po,tonumber(string.sub(mod[1],2)),1);
			elseif tonumber(string.sub(mod[1],2)) and string.lower(string.sub(mod[1],1,1)) == 'm' then
				mod_mmod(po,tonumber(string.sub(mod[1],2)),1);
			elseif _G['mod_'..string.lower(mod[1])] then
				_G['mod_'..string.lower(mod[1])](po,1,1)
			end
		elseif #mod == 2 then
			if string.sub(mod[1],1,1) == '*' then
				if tonumber(string.sub(mod[2],1,-2)) and string.lower(string.sub(mod[2],-1)) == 'x' then
					mod_xmod(po,tonumber(string.sub(mod[2],1,-2)),tonumber(string.sub(mod[1],2)));
				elseif tonumber(string.sub(mod[2],2)) and string.lower(string.sub(mod[2],1,1)) == 'c' then
					mod_cmod(po,tonumber(string.sub(mod[2],2)),tonumber(string.sub(mod[1],2)));
				elseif tonumber(string.sub(mod[2],2)) and string.lower(string.sub(mod[2],1,1)) == 'm' then
					mod_mmod(po,tonumber(string.sub(mod[2],2)),tonumber(string.sub(mod[1],2)));
				elseif _G['mod_'..string.lower(mod[2])] then
					_G['mod_'..string.lower(mod[2])](po,1,tonumber(string.sub(mod[1],2)))
				end
			else
				local amt = 100
				if not tonumber(string.sub(mod[1],1,-2)) or string.lower(mod[1]) == 'no' then
					amt = 0
				elseif string.sub(mod[1],-1) == '%' then
					amt = tonumber(string.sub(mod[1],1,-2))/100
				else
					amt = tonumber(mod[1])/100
				end
				_G['mod_'..string.lower(mod[2])](po,amt,1)
			end
		elseif #mod == 3 then
			if _G['mod_'..string.lower(mod[3])] then
				local amt = 100
				if not tonumber(string.sub(mod[2],1,-2)) or string.lower(mod[2]) == 'no' then
					amt = 0
				elseif string.sub(mod[2],-1) == '%' then
					amt = tonumber(string.sub(mod[2],1,-2))/100
				else
					amt = tonumber(mod[2])/100
				end
				_G['mod_'..string.lower(mod[3])](po,amt,tonumber(string.sub(mod[1],2)))
			end
		end
		
	end
end

function mod_split(po,val,spd)
	po:Split(val,spd);
end
function mod_alternate(po,val,spd)
	po:Alternate(val,spd);
end
function mod_cross(po,val,spd)
	po:Cross(val,spd);
end
function mod_reverse(po,val,spd)
	po:Reverse(val,spd);
end
function mod_centered(po,val,spd)
	po:Centered(val,spd);
end

function mod_flip(po,val,spd)
	po:Flip(val,spd);
end

function mod_invert(po,val,spd)
	po:Invert(val,spd);
end

function mod_xmode(po,val,spd)
	po:Xmode(val,spd);
end

function mod_dizzy(po,val,spd)
	po:Dizzy(val,spd);
end
function mod_twirl(po,val,spd)
	po:Twirl(val,spd);
end
function mod_roll(po,val,spd)
	po:Roll(val,spd);
end
function mod_confusion(po,val,spd)
	po:Confusion(val,spd);
end

function mod_beat(po,val,spd)
	po:Beat(val,spd);
end
function mod_bumpy(po,val,spd)
	po:Bumpy(val,spd);
end
function mod_drunk(po,val,spd)
	po:Drunk(val,spd);
end
function mod_tipsy(po,val,spd)
	po:Tipsy(val,spd);
end
function mod_tornado(po,val,spd)
	po:Tornado(val,spd);
end
function mod_wave(po,val,spd)
	po:Wave(val,spd)
end
function mod_expand(po,val,spd)
	po:Expand(val,spd)
end

function mod_boost(po,val,spd)
	po:Boost(val,spd);
end
function mod_brake(po,val,spd)
	po:Brake(val,spd);
end

function mod_dark(po,val,spd)
	po:Dark(val,spd);
end
function mod_blind(po,val,spd)
	po:Blind(val,spd);
end
function mod_cover(po,val,spd)
	po:Cover(val,spd);
end

function mod_stealth(po,val,spd)
	po:Stealth(val,spd);
end
function mod_hidden(po,val,spd)
	po:Hidden(val,spd);
end
function mod_sudden(po,val,spd)
	po:Sudden(val,spd);
end
function mod_hiddenoffset(po,val,spd)
	po:HiddenOffset(val,spd);
end
function mod_suddenoffset(po,val,spd)
	po:SuddenOffset(val,spd);
end
function mod_blink(po,val,spd)
	po:Blink(val,spd);
end

function mod_overhead(po,val,spd)
	po:Overhead(val,spd)
end
function mod_hallway(po,val,spd)
	po:Hallway(val,spd)
end
function mod_distant(po,val,spd)
	po:Distant(val,spd)
end
function mod_incoming(po,val,spd)
	po:Incoming(val,spd)
end
function mod_space(po,val,spd)
	po:Space(val,spd)
end

function mod_boomerang(po,val,spd)
	po:Boomerang(val,spd)
end

function mod_mini(po,val,spd)
	po:Mini(val,spd)
end
function mod_tiny(po,val,spd)
	po:Tiny(val,spd)
end
--I added these three mod_functions. -Kid
function mod_scrollspeed(po,val,spd)--We need these for combining CMod and XMod.
	po:ScrollSpeed(val,spd)
end
function mod_timespacing(po,val,spd)--We need these for combining CMod and XMod.
	po:TimeSpacing(val,spd)
end
function mod_scrollbpm(po,val,spd)--We need these for combining CMod and XMod.
	po:ScrollBPM(val,spd)
end

function mod_clearall(po)
	po:Split(0,1)
	po:Alternate(0,1)
	po:Cross(0,1)
	po:Mini(0,1)
	po:Tiny(0,1)
	po:Hallway(0,1)
	po:Distant(0,1)
	po:Incoming(0,1)
	po:Space(0,1)
	po:Beat(0,1)
	po:Bumpy(0,1)
	po:Wave(0,1)
	po:Expand(0,1)
	po:Drunk(0,1)
	po:Tipsy(0,1)
	po:Boost(0,1)
	po:Brake(0,1)
	po:Dizzy(0,1)
	po:Twirl(0,1)
	po:Roll(0,1)
	po:Confusion(0,1)
	po:Flip(0,1)
	po:Invert(0,1)
	po:Xmode(0,1)
	po:Tornado(0,1)
	po:Reverse(0,1)
	po:Centered(0,1)
	po:Stealth(0,1)
	po:Hidden(0,1)
	po:Sudden(0,1)
	po:HiddenOffset(0,1)
	po:SuddenOffset(0,1)
	po:Blink(0,1)
	po:Dark(0,1)
	po:Blind(0,1)
	po:Cover(0,1)
end

function mod_xmod(po,val,spd)
	po:XMod(val,spd)
        --SCREENMAN:SystemMessage("XMod("..val..","..spd..")");
end
function mod_cmod(po,val,spd)
	po:CMod(val,spd)
end
function mod_mmod(po,val,spd)
	po:MMod(val,spd)
end
