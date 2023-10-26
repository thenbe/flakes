#!/usr/bin/env lua

local bp = require("lua-shepi")
local rofi_markup = print("\0markup-rows\x1ftrue\n")

local function GetTabs(sin, sout, serr)
	local delim = print("\x00delim\x1f\x0f")
	local markup_s =
		'%s | <span foreground="#A0B0C0">%s</span> | <span foreground="#70787A"><small><i>%s</i></small></span>\x0f'
	local pipe_in = sin:read("a")
	for line in pipe_in:gmatch("([^\n]*)\n") do
		local id, title, url = line:match("([^\t]+)\t([^\t]+)\t([^\t]+)")
		local result = string.format(markup_s, title, url:match("https?://[www%.]*(.*)"), id)
		local prune_s = result:gsub("&", "&amp;")
		sout:write(prune_s)
	end
end

args = { ... }
local pipe = bp.bt("list") | bp.tac("-s", "\n") | bp.fun(GetTabs)
if not args[1] then
	io.write(pipe())
else
	local id = args[1]:match("<i>(.-)</i>")
	-- title is whatever is before the first <span> tag
	local title = args[1]:match("^(.-)<span")
	-- remove last character (tab)
	title = title:sub(1, -2)
	-- local url = args[1]:match("<small><i>(.-)</i></small>")

	-- log id and title. To read logs: `journalctl -t brotab`
	-- os.execute(string.format("echo 'id: %s, title: %s' | systemd-cat -t brotab", id, title))

	-- select the tab in the browser window
	os.execute(string.format("bt activate '%s'", id))

	-- find the correct browser window
	local handle = io.popen("wmctrl -l")

	if not handle then
		print("Failed to run wmctrl")
		return
	end

	local window_id = nil
	-- Iterate over each line in the output
	for line in handle:lines() do
		-- Check if title is a substring of the line
		if string.find(line, title, 1, true) then
			print(line)
			window_id = line:match("^(.-)%s")
			break
		end
	end

	-- Close the handle
	handle:close()

	-- focus the browser window (schedule the command to run after this lua script exits)
	os.execute("nohup sh -c '(sleep 0.2; wmctrl -i -a " .. window_id .. ") &' > /dev/null 2>&1")
end
