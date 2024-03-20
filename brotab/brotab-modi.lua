#!/usr/bin/env lua

local bp = require("lua-shepi")
local rofi_markup = print("\0markup-rows\x1ftrue\n")

local rpad = function (s, l, c)
	local res = s .. string.rep(c or ' ', l - #s)
	return res
end

local function format_row(title, url, id)
	local SECTION_1_WIDTH = 100 -- title width
	local SECTION_2_WIDTH = 100 -- url width

	local formatted_title = title or ''
	local formatted_url = url or ''

	-- rm chars the interfere with alignment (e.g. em-dash, en-dash, etc.)
	formatted_title = formatted_title:gsub("—", ""):gsub('·', "")

	-- add padding
	formatted_title =  rpad(formatted_title, SECTION_1_WIDTH)
	formatted_url = rpad(formatted_url, SECTION_2_WIDTH)

	local markup_s =
	'|    %s | <span foreground="#A0B0C0">%s</span> | <span foreground="#70787A"><small><i>%s</i></small></span>\x0f'

	return string.format(markup_s, formatted_title, formatted_url, id)
end

local function GetTabs(sin, sout, serr)
---@diagnostic disable-next-line: unused-local
	local delim = print("\x00delim\x1f\x0f")
	local pipe_in = sin:read("a")
	for line in pipe_in:gmatch("([^\n]*)\n") do
		local id, title, full_url = line:match("([^\t]+)\t([^\t]+)\t([^\t]+)")
		local url = full_url:match("https?://[www%.]*(.*)")
		local result = format_row(title, url, id)
		local prune_s = result:gsub("&", "&amp;")
		sout:write(prune_s)
	end
end

---To read logs: `journalctl -ft brotab`
local function log(msg)
	os.execute(string.format("echo '%s' | systemd-cat -t brotab", msg))
end

args = { ... }
local pipe = bp.bt("list") | bp.tac("-s", "\n") | bp.fun(GetTabs)
if not args[1] then
	io.write(pipe())
else
	-- patterns based on `markup_s` in `GetTabs`
	local id = args[1]:match("<small><i>(.-)</i></small>")
	local title = args[1]:match("^(.-) | <span") -- title is whatever is before the first ` | <span>`
	local url = args[1]:match('| <span foreground="#A0B0C0">(.-)</span> |')
	log(string.format("id: %s, title: %s, url: %s", id, title, url))

	-- select the tab in the browser window
	local select_tab_command = string.format("bt activate '%s'", id)
	log(select_tab_command)
	os.execute(select_tab_command)

	-- Add a delay to ensure the window title has been updated
	os.execute("sleep 0.05")

	-- find the correct browser window
	local handle = io.popen("wmctrl -l")

	if not handle then
		log("Failed to run wmctrl")
		return
	end

	local window_id = nil
	-- Iterate over each line in the output
	for line in handle:lines() do
		-- log(line)
		-- Check if title is a substring of the line
		if string.find(line, title, 1, true) then
			window_id = line:match("^(.-)%s")
			break
		end
	end

	-- Close the handle
	handle:close()

	if window_id == nil then
		log("Failed to find window id")
		return
	end

	-- focus the browser window (schedule the command to run after this lua script exits)
	local select_window_command = "nohup sh -c '(sleep 0.2; wmctrl -i -a " .. window_id .. ") &' > /dev/null 2>&1"
	log(select_window_command)
	os.execute(select_window_command)
end
