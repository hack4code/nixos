-- autorun --


local msg = require("mp.msg")


local function send_mpv_state(state)
  local cmd = string.format("curl -s -o /dev/null 'http://127.0.0.1:8080/mpv/state/%s'", state)
  os.execute(cmd)
end


local function on_pause_change(_, value)
  if value == false then
    send_mpv_state("play")
  else
    send_mpv_state("pause")
  end
end


local function on_open()
  local fn = nil
  local path = mp.get_property("path")
  local m, _ = string.find(path, "https://")
  if (m == 1) then
    fn = path
  else
    fn = mp.get_property("filename")
  end
  if (fn == nil) then
    return
  end
  local data = string.format('{"file_name": "%s"}', fn)
  local cmd = string.format("curl -s -o /dev/null -X POST -H 'Content-Type: application/json' --data '%s' http://127.0.0.1:8080/mpv/open", data)
  os.execute(cmd)
end


local function on_shutdown()
  local cmd = "curl -s -o /dev/null 'http://127.0.0.1:8080/mpv/shutdown'"
  os.execute(cmd)
end


local function set_audio_id(tracks)
  for _, track in ipairs(tracks) do
    local id = track["id"]
    local lang = track["lang"]
    if (lang ~= nil) then
      local i, _ = string.find(string.lower(lang), "en")
      if (i ~= nil) then
        if (track["type"] == "audio") then
          msg.info("set aid to ", id)
          msg.info("audio language is ", lang)
          mp.set_property_native("aid", id)
          return
        end
      end
    end
  end
end


local function set_sub_ass(tracks)
  for _, track in ipairs(tracks) do
    local id = track["id"]
    if (track["type"] == "sub") then
      local name = track["external-filename"]
      if (name ~= nil) then
          mp.set_property_native("sid", id)
          return
      end
    end
  end
end


local function on_file_loaded()
  on_open()
  local tracks = mp.get_property_native("track-list")
  if (tracks == nil) then
    return
  end
  set_audio_id(tracks)
  set_sub_ass(tracks)
end


mp.observe_property("pause", "bool", on_pause_change)
mp.register_event("file-loaded", on_file_loaded)
mp.register_event("shutdown", on_shutdown)


-- vim: ts=2 sw=2 sts=2 ft=lua et:
