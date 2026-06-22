local dropdown = {
  title = "Dropdown",
  session = "Dropdown",
  heightRatio = 0.42,
  window = nil,
  task = nil,
}

local function dropdownFrame(screen)
  local frame = screen:frame()
  return {
    x = frame.x,
    y = frame.y,
    w = frame.w,
    h = math.floor(frame.h * dropdown.heightRatio),
  }
end

local function position(win)
  win:setFrame(dropdownFrame(win:screen()), 0)
end

local function findDropdownWindow()
  for _, win in ipairs(hs.window.filter.new("Ghostty"):getWindows()) do
    if win:title():lower():find(dropdown.title, 1, true) then
      return win
    end
  end
  return nil
end

local function spawnDropdown()
  dropdown.task = hs.task
    .new("/usr/bin/open", function()
      dropdown.task = nil
    end, {
      "-n",
      "-a",
      "Ghostty",
      "--args",
      "--title",
      dropdown.title,
      "-e",
      "fish",
      "-c",
      "tmux new-session -As " .. dropdown.session,
    })
    :start()

  hs.timer.doAfter(0.4, function()
    local win = findDropdownWindow()
    if win then
      dropdown.window = win
      position(win)
      win:focus()
      hs.timer.doAfter(0.2, function()
        if win and win:isStandard() then position(win) end
      end)
    end
  end)
end

function toggleDropdown()
  local win = dropdown.window
  if not win or not win:isStandard() then
    win = findDropdownWindow()
    dropdown.window = win
  end

  local focused = hs.window.frontmostWindow()
  if focused and focused:application():name() == "Ghostty" and (not win or focused:id() ~= win:id()) then
    hs.eventtap.keyStroke({ "ctrl" }, "t", 0)
    return
  end

  if not win then
    spawnDropdown()
    return
  end

  if win:isMinimized() then
    win:unminimize()
    position(win)
    win:focus()
    hs.task.new("/run/current-system/sw/bin/aerospace", nil, { "layout", "floating" }):start()
    return
  end

  if win:isFrontmost() then
    win:minimize()
    return
  end

  position(win)
  win:focus()
  hs.task.new("/run/current-system/sw/bin/aerospace", nil, { "layout", "floating" }):start()
end

hs.hotkey.bind({ "ctrl" }, "t", toggleDropdown)
