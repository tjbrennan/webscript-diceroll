-- dice roll script
-- formatted to receive and respond to outgoing webhooks on slack

local default = "2d6"
local inText = request and request.form.text or ""
local outText = ""
local parsed = {}
local dice
local sides
local roll
local sum = 0

math.randomseed(os.time())

if inText == "" then
  inText = default
end

for i in inText:gmatch("%d+") do
  table.insert(parsed, i)
end

dice = tonumber(parsed[1])
sides = tonumber(parsed[2])

if dice == nil or sides == nil then
  outText = "<number>d<sides>"
elseif dice < 1 or dice > 99 then
  outText = "dice out of range"
elseif sides < 1 or sides > 99 then
  outText = "sides out of range"
else
  for i=1, dice do
    roll = math.random(1, sides)
    sum = sum + roll
    outText = outText .. roll .. ((i == dice) and " = " or " + ")
  end
  outText = outText .. sum
end

print(outText)
return({ text = outText })
