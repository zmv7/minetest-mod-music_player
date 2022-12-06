local modpath = core.get_modpath("music_player")
local muspath = modpath.."/sounds"
local playing = {}
local selected = {}
local dirlist = {}

local function mp_fs(name)
	if not name then return end
	dirlist = core.get_dir_list(muspath)
	table.sort(dirlist)
	local index = selected[name] or "1"
	local fs = "size[6.2,1.6]" ..
		"dropdown[0.1,0.1;6.3,1;list;"..table.concat(dirlist,",")..";"..index.."]"
	if playing[name] then
		fs = fs.."button[0.1,0.8;6,1;stop;Stop]"
	else
		fs = fs.."button[0.1,0.8;6,1;play;Play]"
	end
	core.show_formspec(name, "music_player", fs)
end

core.register_chatcommand("player", {
  description = "Open music player",
  func = function(name, param)
	mp_fs(name)
end})

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "music_player" then return end
	local name = player:get_player_name()
	local track = fields.list and fields.list
	if not (name and track) then return end
	local swapped = table.key_value_swap(dirlist)
	selected[name] = swapped[track]
	if fields.play then
		playing[name] = core.sound_play(track:gsub("%.ogg",""), {to_player=name})
		mp_fs(name)
	end
	if fields.stop then
		core.sound_stop(playing[name])
		playing[name] = nil
		mp_fs(name)
	end
end)
