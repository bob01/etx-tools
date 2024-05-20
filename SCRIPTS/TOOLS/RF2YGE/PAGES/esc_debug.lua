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
fields[#fields + 1] = { t = "count",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 32, ro = true, vals = { 1, 2 } }
fields[#fields + 1] = { t = "Mode",                   x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 3, 4 } }
fields[#fields + 1] = { t = "BEC",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 5, 6 } }
fields[#fields + 1] = { t = "Motor Timing",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 7, 8 } }
fields[#fields + 1] = { t = "Initial Torque",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 9, 10 } }
fields[#fields + 1] = { t = "P-Gain",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 10, ro = true, vals = { 11, 12 } }
fields[#fields + 1] = { t = "I-Gain",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 10, ro = true, vals = { 13, 14 } }
fields[#fields + 1] = { t = "Throttle Response",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 15, 16 } }
fields[#fields + 1] = { t = "Cutoff Type",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 17, 18 } }
fields[#fields + 1] = { t = "Cutoff Cell Voltage",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 19, 20 } }
fields[#fields + 1] = { t = "Active Freewheel",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 21, 22 } }
fields[#fields + 1] = { t = "ESC Type",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 23, 24 } }
fields[#fields + 1] = { t = "FW Version (LSW)",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 25, 26 } }
fields[#fields + 1] = { t = "FW Version (MSW)",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 27, 28 } }
fields[#fields + 1] = { t = "Serial No. (LSW)",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 29, 30 } }
fields[#fields + 1] = { t = "Serial No. (MSW)",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 31, 32 } }
fields[#fields + 1] = { t = "mAh Limit (x10mAh)",     x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 33, 34 } }
fields[#fields + 1] = { t = "Stick Zero (us)",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 900, max = 1900, ro = true, vals = { 35, 36 } }
fields[#fields + 1] = { t = "Stick Range (us)",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 600, max = 1500, ro = true, vals = { 37, 38 } }
fields[#fields + 1] = { t = "PWM Rate (us)",          x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 300, max = 300, ro = true, vals = { 39, 40 } }
fields[#fields + 1] = { t = "Motor Pole Pairs",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 100, ro = true, vals = { 41, 42 } }
fields[#fields + 1] = { t = "Pinion Teeth",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 255, ro = true, vals = { 43, 44 } }
fields[#fields + 1] = { t = "Main Teeth",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 1800, ro = true, vals = { 45, 46 } }
fields[#fields + 1] = { t = "Min Start Power",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 26, ro = true, vals = { 47, 48 } }
fields[#fields + 1] = { t = "Max Start Power",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 31, ro = true, vals = { 49, 50 } }
fields[#fields + 1] = { t = "Telemetry Type",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 51, 52 } }
fields[#fields + 1] = { t = "Flags",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 53, 54 } }
fields[#fields + 1] = { t = "Batt Current Limit",     x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 655, ro = true, vals = { 55, 56 } }
fields[#fields + 1] = { t = "Soft Start",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 57, 58 } }
fields[#fields + 1] = { t = "Soft Run",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 59, 60 } }
fields[#fields + 1] = { t = "Soft Blend",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 61, 62 } }
fields[#fields + 1] = { t = "RPM/Throttle SetP.",     x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = -300, max = 300, ro = true, vals = { 63, 64 } }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    eepromWrite = false,
    reboot      = false,
    title       = "Debug",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,
}
