local args = {...}
local lines = {}
local vars = {}
local vval = {}
local x = ""
local i = 0
local err = ""
local errn = 0
io.input(args[1])
require "sparser"

function GetFileExtension(f) --pulled from stackexchange
  return f:match("^.+(%..+)$")
end

if GetFileExtension(args[1]) == ".sen" then --check if file has correct extension
	for line in io.lines() do
		table.insert(lines, line)
	end
	while i < #lines do
		i = i + 1
		x = sps(lines[i])
		if x == nil then break end
		if x:sub(1,2) == "gt" then
			i = tonumber(x:sub(3,-1))
			if i == nil then
				err = "Attempted to go to the non-numeric line " .. x:sub(3,-1)
				errn = 1
				break
			end
			i=i-1
		end
		if x == "die" then
			i = #lines
		end
	end
	if err ~= "" then
		print("Error number SEN" .. errn .. ": " .. err .. ", interpreter halted")
	end
else
	print("Incorrect file extension.")
end