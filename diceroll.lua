-- dice roll script
-- formatted to receive and respond to outgoing webhooks on slack
-- may execute via cli for testing

math.randomseed(os.time())

local default = "1d20"
local inText = default
local outText = ""
local parsed = {}
local dice
local sides
local roll
local sum = 0


-- slack stuff
local form = request and request.form
local trigger
local user = ""

local bot = {
  username = "dicebot",
  icon_emoji = ":game_die:",
} 

-- remove trigger word from input text and trim
if form then
  trigger = form.trigger_word
  user = form.user_name
  inText = form.text:gsub(trigger, ""):gsub("^%s*(.-)%s*$", "%1")
end

if inText == "" then
  inText = default
end

-- get dice and sides from input text
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
    outText = outText .. roll .. ((i == dice) and "" or " + ")
  end
  if dice > 1 then
    outText = outText .. " = " .. sum
  end
end

-- format bot output text
bot.text = user .. " rolled " .. inText .. ": \n>" .. outText

print(outText)
return(bot)
