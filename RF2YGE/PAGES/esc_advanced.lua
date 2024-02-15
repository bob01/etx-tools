local template = assert(loadScript(radio.template))()
local margin = template.margin
local indent = template.indent
local lineSpacing = template.lineSpacing
local tableSpacing = template.tableSpacing
local sp = template.listSpacing.field
local yMinLim = radio.yMinLimit
local x = margin
local y = yMinLim - lineSpacing
local inc = { x = function(val) x = x + val return x end, y = function(val) y = y + val return y end }
local labels = {}
local fields = {}

local offOn = {
    [0] = "Off",
    "On"
}

labels[#labels + 1] = { t = "Advanced",               x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "F3C Autorotation",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1, vals = { 53 }, table = offOn }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "YGE ESC Setup",
    minBytes    = 80,
    labels      = labels,
    fields      = fields,

    postLoad = function(self)
        -- F3C autorotation
        f = self.fields[1]
        f.value = bit32.btest(f.value, 2) and 1 or 0
    end,

    preSave = function (self)
        
    end,
}
