local ui = require "ui"

local function getdesktops()
  local list = {}
  for entry in each(sys.Directory(sys.env["HOMEPATH"].."\\.desktopChanger")) do
    table.insert(list,entry.name)
  end
  return list
end
local function openInExplorer(desktopName)
  sys.cmd("explorer \""..sys.env["HOMEPATH"].."\\.desktopChanger\\"..desktopName.."\"")
end
local function makeJunction(desktopName)
  sys.cmd("rmdir \""..sys.env["HOMEPATH"].."\\Desktop\"")
  sys.cmd("cd \""..sys.env["HOMEPATH"].."\\\" & mklink /J Desktop \".\\.desktopChanger\\"..desktopName.."\"")
end
local function linkExisting(folder,name)
  sys.cmd("cd \""..sys.env["HOMEPATH"].."\\.desktopChanger\" & mklink /J \""..name.."\" \""..folder.."\"")
end
local desktopDir = sys.Directory(sys.env["HOMEPATH"].."\\.desktopChanger\\")
if desktopDir:make() then -- if the directory is created successfully then it did not exist
  ui.info("The program has detected that changeable desktops are not yet installed. After closing this prompt, the changeable desktops will be installed.")
  sys.cmd("taskkill /im explorer.exe /f")
  sys.cmd("cd \""..sys.env["HOMEPATH"].."\" & xcopy /e Desktop .desktopChanger\\Desktop\\ & rmdir /s /q Desktop")
  makeJunction("Desktop")
  sys.cmd("start explorer.exe",true,true)
end


local win = ui.Window("DesktopChanger",350,240)
local tab = ui.Tab(win,{"Set desktop", "Add desktops"})
local dropdown = ui.List(tab.items[1], getdesktops())
local button_switch = ui.Button(tab.items[1], "Switch", dropdown.width+10)
function button_switch:onClick()
  if dropdown.selected ~= nil then makeJunction(dropdown.selected.text) end
end
local button_openexplorer = ui.Button(tab.items[1], "Open in explorer", dropdown.width+10, button_switch.y + button_switch.height+5)
function button_openexplorer:onClick()
  if dropdown.selected ~= nil then openInExplorer(dropdown.selected.text) end
end
local button_refresh = ui.Button(tab.items[1], "Refresh", dropdown.width+10, button_openexplorer.y + button_openexplorer.height+5)
function button_refresh:onClick()
  sys.cmd("taskkill /im explorer.exe /f")
  sys.cmd("start explorer.exe",true,true)
  dropdown.items = getdesktops()
end
local button_delete = ui.Button(tab.items[1], "Delete desktop", dropdown.width+10,button_refresh.y + button_refresh.height+5)
function button_delete:onClick()
  local dir = sys.Directory(sys.env["HOMEPATH"].."\\.desktopChanger\\"..dropdown.selected.text)
  if not dir:remove() then
    if ui.confirm("The desktop could not be deleted, as it may have files inside. Delete all files?","Error") == "yes" then
      dir:removeall()
    end
  end
  dropdown.items = getdesktops()
end
local button_totray = ui.Button(tab.items[1], "Move to tray", dropdown.width+10, button_delete.y + button_delete.height+5)
local intray = false
function button_totray:onClick()
  if intray then
    win:loadtrayicon()
    button_totray.text = "Move to tray"
  else
    win:loadtrayicon(arg[-1])
    button_totray.text = "Remove from tray"
    win:hide()
  end
  intray = not intray
end
function win:onTrayHover()
  self.traytooltip = "DesktopChanger"
end

local dc_menu = ui.Menu("Show window","Set desktop","Refresh desktop list","Close program")
local desktops_submenu = ui.Menu()
for i in each(getdesktops()) do
  local added = desktops_submenu:add(i)
  function added:onClick()
    makeJunction(self.text)
  end
end
local show_win = dc_menu.items[1]
local refresh_choice = dc_menu.items[3]
local close_choice = dc_menu.items[4]
function close_choice:onClick()
  os.exit()
end
function show_win:onClick()
  win:show()
end
function refresh_choice:onClick()
  desktops_submenu.items = {}
  for i in each(getdesktops()) do
    local added = desktops_submenu:add(i)
    function added:onClick()
      makeJunction(self.text)
    end
  end
end
dc_menu.items[2].submenu = desktops_submenu
function win:onTrayContext()
  win:popup(dc_menu)
end
function win:onTrayClick()
  win:show()
end

local desktopname = ui.Entry(tab.items[2], "New desktop name")
desktopname.text = ""
local button_turnintodesktop = ui.Button(tab.items[2], "Link an existing folder",nil,desktopname.height + desktopname.y + 10)
function button_turnintodesktop:onClick()
  local chosen = ui.dirdialog()
  if chosen ~= nil then
    linkExisting(chosen.fullpath,desktopname.text)
    desktopname.text = ""
  end
  dropdown.items = getdesktops()
end
local button_createnew = ui.Button(tab.items[2], "Create a new desktop",nil,button_turnintodesktop.y + button_turnintodesktop.height+10)
function button_createnew:onClick()
  sys.Directory(sys.env["HOMEPATH"].."\\.desktopChanger\\"..desktopname.text):make()
  desktopname.text = ""
  dropdown.items = getdesktops()
end

ui.Label(win,"Made by Miron Samokhvalov using LuaRT framework",nil,tab.height+tab.y+10).fgcolor = 0x777777
win:show()
repeat
  ui.update()
until not win.visible and not intray
