local vars = {}

function cs (t)
	return table.concat(t, " ")
end

function ctyp (pst) --check type
	if type(pst) == "string" then
		if string.sub(pst, 1, 1) == "*" and string.sub(pst, -1, -1) == "*" then
			return "v"
		elseif string.sub(pst, 1, 1) == "\"" and string.sub(pst, -1, -1) == "\"" then
			return "s"
		else
			return "f"
		end
	else
		return "n"
	end
end

function gvval (nm) --get variable value
	if vars[nm] ~= nil then return vars[nm] else return "NULL" end
end

function cvar (dex, spl) --check if variable and return value if true
	if ctyp(spl[dex]) == "v" then
		spl[dex] = gvval(string.sub(spl[dex], 2, -2))
	end
end

function svar (n, v) --set / init variable with value
	vars[n] = v
end

function ilt(st, lt)
	for x in ipairs(lt) do --modified from stackoverflow
		if lt[x] == st then
			return true
		end
	end
	return false
end

function xrd()
	return io.stdin:read()
end

function sps (st)
	if st == nil then return end
	local stt = {}
	local args = {}
	local sargs = {}
	local fargs = {}
	local sfunc = {}
	local ffunc = {}
	local nlwds = {"'CAUSE"}
	for w in st:gmatch("%S+") do table.insert(stt, w) end
	for i in ipairs(stt) do
		cvar(i, stt)
	end
	local i = 1
	while i <= #stt do
		if stt[i]:sub(-2, -1) == "\\," then
			stt[i] = stt[i]:sub(1, -3) .. ","
		elseif stt[i]:sub(-1, -1) == "," then
			stt[i] = stt[i]:sub(1, -2)
		end
		if stt[i] == "/" and stt[i-1] ~= nil and stt[i+1] ~= nil then
			stt[i-1] = tostring(tonumber(stt[i-1]) / tonumber(stt[i+1]))
			for x = 1, 2 do table.remove(stt, i) end
		end
		if stt[i] == "*" and stt[i-1] ~= nil and stt[i+1] ~= nil then
			stt[i-1] = tostring(tonumber(stt[i-1]) * tonumber(stt[i+1]))
			for x = 1, 2 do table.remove(stt, i) end
		end
		if stt[i] == "+" and stt[i-1] ~= nil and stt[i+1] ~= nil then
			stt[i-1] = tostring(tonumber(stt[i-1]) + tonumber(stt[i+1]))
			for x = 1, 2 do table.remove(stt, i) end
		end
		if stt[i] == "-" and stt[i-1] ~= nil and stt[i+1] ~= nil then
			stt[i-1] = tostring(tonumber(stt[i-1]) - tonumber(stt[i+1]))
			for x = 1, 2 do table.remove(stt, i) end
		end
		if stt[i] == ".." and stt[i-1] ~= nil and stt[i+1] ~= nil then
			stt[i-1] = stt[i-1] .. stt[i+1]
			for x = 1, 2 do table.remove(stt, i) end
		end
		if stt[i] == ">" and stt[i-1] ~= nil and stt[i+1] ~= nil then
			if tonumber(stt[i-1]) > tonumber(stt[i+1]) then
				stt[i-1] = "TRUE"
			else
				stt[i-1] = "FALSE"
			end
			for x = 1, 2 do table.remove(stt, i) end
		end
		if stt[i] == "<" and stt[i-1] ~= nil and stt[i+1] ~= nil then
			if tonumber(stt[i-1]) < tonumber(stt[i+1]) then
				stt[i-1] = "TRUE"
			else
				stt[i-1] = "FALSE"
			end
			for x = 1, 2 do table.remove(stt, i) end
		end
		if stt[i] == "=" and stt[i-1] ~= nil and stt[i+1] ~= nil then
			if stt[i-1] == stt[i+1] then
				stt[i-1] = "TRUE"
			else
				stt[i-1] = "FALSE"
			end
			for x = 1, 2 do table.remove(stt, i) end
		end
		--print(stt[i], ilt(stt[i], nlwds))
		if ilt(stt[i], nlwds) then
			table.remove(stt, i)
		else
			i = i + 1
		end
	end
	for i in ipairs(stt) do
		if stt[i] == "OPPOSITE" and stt[i+1] ~= nil then
			if stt[i+1] == "FALSE" then
				stt[i+1] = "TRUE"
			else
				stt[i+1] = "FALSE"
			end
			table.remove(stt, i)
		end
	end
	local fnnil = stt[5] ~= nil
	if stt[1] == "WHEN" and stt[3] == "THAT" and stt[4] == "BOY" and stt[5] == "WILL" and stt[6] ~= nil then
		if stt[2] == "TRUE" then
			for x = 1, 5 do table.remove(stt, 1) end
		else
			for x = 1, 5 do table.remove(stt, 1) end
			table.insert(stt, 1, "NOT GONNA HAPPEN")
		end
	end
	if #stt > 1 then for w = 2, #stt do table.insert(args, stt[w]) end end
	if #stt > 4 then for w = 5, #stt do table.insert(sargs, stt[w]) end end
	if #stt > 3 then for w = 4, #stt do table.insert(fargs, stt[w]) end end
	if #stt > 3 then for w = 1, 4 do table.insert(sfunc, stt[w]) end end
	if #stt > 2 then for w = 1, 3 do table.insert(ffunc, stt[w]) end end
	if cs(sfunc) == "GET OFF MY LAWN" and fnnil then
		print(cs(sargs))
	end
	if cs(sfunc) == "BACK IN MY DAY" and fnnil then
		print(cs(sargs))
	end
	if cs(ffunc) == "THESE DAMN MILLENIALS!" and stt[4] ~= nil then
		print(cs(fargs))
	end
	if stt[1] == "OUR" and stt[3] == "JUST" and stt[4] == "ATE" and fnnil then
		svar(stt[2], cs(sargs))
	end
	if tostring(stt[2]) .. " " .. tostring(stt[3]) .. " " .. tostring(stt[4]) .. " " .. tostring(stt[5]) == "IS YOUR ANSWER BOY?" then
		svar(stt[1], xrd())
	end
	if cs(sfunc) == "GET OUTTA MY HOUSE" and fnnil then
		print(cs(sargs))
	end
	if cs(sfunc) == "GET OFF MY PROPERTY" and fnnil then
		print(cs(sargs))
	end
	if cs(sfunc) == "GET AWAY FROM ME" and stt[5] ~= nil then
		return "gt" .. stt[5]
	end
	if cs(ffunc) == "GET AWAY FROM" and stt[4] ~= nil then
		return "gt" .. stt[4]
	end
	if cs(ffunc) == "I'M DYING! HELP!" then
		return "die"
	end
	if cs(ffunc) == "HELP! I'M DYING!" then
		return "die"
	end
	return "nop"
end