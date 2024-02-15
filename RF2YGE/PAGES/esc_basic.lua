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

local escType = {
    [8273] = "YGE 205 HVT BEC",
}

local escMode = { 
    [0] = "Free (Attention!)",
    "Heli Ext Governor", 
    "Heli Governor", 
    "Heli Governor Store", 
    "Aero Glider", 
    "Aero Motor", 
    "Aero F3A"
}

local direction = {
    [0] = "Normal", 
    "Reverse"
}

local cuttoff = {
    [0] = "Off",
    "Soft",
    "Cutoff"
}

local cuttoffVoltage = {
    [0] = "2.9 V",
    "3.0 V",
    "3.1 V",
    "3.2 V",
    "3.3 V",
    "3.4 V",
}


labels[#labels + 1] = { t = "YGE ESC",                x = x,          y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
fields[#fields + 1] = {                               x = x,          y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 29, 30, 31, 32 }, ro = true }
y = yMinLim - lineSpacing
fields[#fields + 1] = {                               x = x,          y = inc.y(lineSpacing), sp = x + sp * 1.8, vals = { 25, 26, 27, 28 }, scale = 100000, ro = true }

labels[#labels + 1] = { t = "Basic",                  x = x,          y = inc.y(lineSpacing * 2) }
fields[#fields + 1] = { t = "ESC Mode",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = #escMode, vals = { 3, 4 }, table = escMode }
fields[#fields + 1] = { t = "Direction",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1, vals = { 53 }, table = direction }
fields[#fields + 1] = { t = "BEC",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 55, max = 123, vals = { 5, 6 }, scale = 10 }

labels[#labels + 1] = { t = "Protection and Limits",  x = x,          y = inc.y(lineSpacing * 2) }
fields[#fields + 1] = { t = "Cutoff Handling",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #cuttoff, vals = { 17, 18 }, table = cuttoff }
fields[#fields + 1] = { t = "Cutoff Cell Voltage",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #cuttoffVoltage, vals = { 19, 20 }, table = cuttoffVoltage }
fields[#fields + 1] = { t = "Current Limit (A)",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 50, max = 400, vals = { 55, 56 } }

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
        -- esc type
        local l = self.labels[1]
        local idx = bit32.bor(bit32.lshift(self.values[24], 8), self.values[23])
        l.t = escType[idx] or l.t

        -- direction
        local f = self.fields[4]
        f.value = bit32.btest(f.value, 1) and 1 or 0

        -- current limit
        f = self.fields[8]
        f.value = f.value > 0 and f.value / 100 or 0
    end,

    preSave = function (self)
        
    end,
}