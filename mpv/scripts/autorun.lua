-- autorun --


local msg = require("mp.msg")


function send_mpv_state(state)
  local cmd = string.format("curl -s -o /dev/null 'http://127.0.0.1:8080/mpv/state/%s'", state)
  os.execute(cmd)
end


function on_pause_change(name, value)
  if value == false then
    send_mpv_state("play")
  else
    send_mpv_state("pause")
  end
end


function on_open()
  local fn = nil
  local path = mp.get_property("path")
  local m, n = string.find(path, "https://")
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


function on_shutdown()
  local cmd = "curl -s -o /dev/null 'http://127.0.0.1:8080/mpv/shutdown'"
  os.execute(cmd)
end


function set_audio_id(tracks)
  for n, track in ipairs(tracks) do
    local id = track["id"]
    local lang = track["lang"]
    if (lang ~= nil) then
      local i, j = string.find(string.lower(lang), "en")
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


function set_sub_ass(tracks)
  local episode = nil
  local fn = mp.get_property("filename")
  if (fn ~= nil) then
    local i, j = string.find(string.lower(fn), "s%d%de%d%d")
    if (i ~= nil) then
      episode = string.sub(fn, string.find(string.lower(fn), "s%d%de%d%d"))
    end
  end

  local is_sub_set = false
  local is_simple_sub_set = false
  local is_traditional_sub_set = false
  for n, track in ipairs(tracks) do
    local id = track["id"]
    local lang = track["lang"]
    if (track["type"] == "sub") then
      local name = track["external-filename"]
      if (name ~= nil) then
        local i = nil
        local j = nil
        if (episode ~= nil) then
          i, j = string.find(string.lower(name), string.lower(episode))
        end
        if (i ~= nil) then
          is_sub_set = true
          mp.set_property_native("sid", id)
        end
        local m, n = string.find(name, "简体")
        local p, q = string.find(name, "繁体")
        if (p ~= nil) then
          is_traditional_sub_set = true
          mp.set_property_native("sid", id)
        elseif (m ~= nil) and (is_traditional_sub_set == false) then
          is_simple_sub_set = true
          mp.set_property_native("sid", id)
        end
        local u, v = string.find(name, "英文")
        if (u ~= nil) then
          if (p ~= nil) then
            return true
          elseif (is_simple_sub_set == false) then
            is_sub_set = true
            mp.set_property_native("sid", id)
          end
        end
      end
    end
  end
  if (is_sub_set == true) or (is_simple_sub_set == true) or (is_traditional_sub_set == true) then
    return true
  else
    return false
  end
end


function set_native_sub(tracks)
  local is_sub_set = false
  local is_chinese_sub_set = false
  local is_traditional_sub_set = false
  for n, track in ipairs(tracks) do
    if (track["type"] == "sub") then
      local id = track["id"]
      local name = track["title"]
      if (name ~= nil) then
        local i, j = string.find(string.lower(name), "chinese")
        if (i ~= nil) then
          mp.set_property_native("sid", id)
          local p, q = string.find(string.lower(name), "traditional")
          if (p ~= nil) then
            is_traditional_sub_set = true
            return true
          else
            is_chinese_sub_set = true
          end
        end
        i, j = string.find(string.lower(name), "ch")
        if (i ~= nil) then
          is_chinese_sub_set = true
          mp.set_property_native("sid", id)
        end
        i, j = string.find(string.lower(name), "en")
        if (i ~= nil) and (is_chinese_sub_set == false) then
          is_sub_set = true
          mp.set_property_native("sid", id)
        end
      else
        local lang = track["lang"]
        if (lang ~= nil) then
          local i, j = string.find(string.lower(lang), "ch")
          if (i ~= nil) then
            is_chinese_sub_set = true
            mp.set_property_native("sid", id)
          end
          i, j = string.find(string.lower(lang), "en")
          if (i ~= nil) then
            is_sub_set = true
            mp.set_property_native("sid", id)
          end
        end
      end
    end
  end
  if (is_sub_set == true) or (is_chinese_sub_set == true) then
    return true
  else
    return false
  end
end


function on_file_loaded()
  on_open()
  local tracks = mp.get_property_native("track-list")
  if (tracks == nil) then
    return
  end
  set_audio_id(tracks)
  if (set_sub_ass(tracks) == false) then
    set_native_sub(tracks)
  end
end


mp.observe_property("pause", "bool", on_pause_change)
mp.register_event("file-loaded", on_file_loaded)
mp.register_event("shutdown", on_shutdown)


-- vim: ts=2 sw=2 sts=2 ft=lua et:
