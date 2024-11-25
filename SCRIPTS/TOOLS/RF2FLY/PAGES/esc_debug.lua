local template = assert(loadScript(radio.template))()
local margin = template.margin
local indent = template.indent
local lineSpacing = template.lineSpacing
local tableSpacing = template.tableSpacing
local sp = template.listSpacing.field + indent
local yMinLim = radio.yMinLimit
local x = margin
local y = yMinLim - lineSpacing
local inc = { x = function(val) x = x + val return x end, y = function(val) y = y + val return y end }
local labels = {}
local fields = {}

labels[#labels + 1] = { t = "ESC Parameters",         x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "ESC type",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 1 } } --
fields[#fields + 1] = { t = "Current spec",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 3, 2 } } --
fields[#fields + 1] = { t = "Hardware version",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 18 } } --
fields[#fields + 1] = { t = "Throttle min [us]",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 20, 19 } } --
fields[#fields + 1] = { t = "Throttle max [us]",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 22, 21 } } --

fields[#fields + 1] = { t = "ESC mode",               x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, ro = true, vals = { 23 } } --
fields[#fields + 1] = { t = "Lithium batteries",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 24 } } --
fields[#fields + 1] = { t = "Low voltage prot",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 25 } } --
fields[#fields + 1] = { t = "Temp prot",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 26 } } --
fields[#fields + 1] = { t = "BEC output",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 27 } } --
fields[#fields + 1] = { t = "Timing angle",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 28 } } ---
fields[#fields + 1] = { t = "Motor direction",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 29 } } --
fields[#fields + 1] = { t = "Starting torque",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = false, min = 0, max = 15, vals = { 30 } } ---
fields[#fields + 1] = { t = "Response speed",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = false, min = 1, max = 50, vals = { 31 } } ---
fields[#fields + 1] = { t = "Buzzer volume",          x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 32 } } ----
fields[#fields + 1] = { t = "Current gain",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 33 } } ----
fields[#fields + 1] = { t = "Fan control",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 34} } ----

fields[#fields + 1] = { t = "Soft start",             x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, ro = false, min = 5, max = 55, vals = { 35 } } ---
fields[#fields + 1] = { t = "Gov-P",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 37, 36 } } ---
fields[#fields + 1] = { t = "Gov-I",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 39, 38 } } ---
fields[#fields + 1] = { t = "Gov-D",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 41, 40 } } ---
fields[#fields + 1] = { t = "ERPM max",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 44, 43, 42 } } ----

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Debug",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    postLoad = function(self)
    end,
}
