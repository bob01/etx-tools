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
    "Slow Down",
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

labels[#labels + 1] = { t = "ESC",                    x = x,                y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp + indent,  y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp * 1.8,     y = inc.y(lineSpacing) }

fields[#fields + 1] = { t = "ESC Mode",               x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 1, max = #escMode, vals = { 3, 4 }, table = escMode }
fields[#fields + 1] = { t = "Direction",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1, vals = { 53 }, table = direction }
fields[#fields + 1] = { t = "BEC",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 55, max = 84, vals = { 5, 6 }, scale = 10 }

labels[#labels + 1] = { t = "Protection and Limits",  x = x,          y = inc.y(lineSpacing * 2) }
fields[#fields + 1] = { t = "Cutoff Handling",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #cuttoff, vals = { 17, 18 }, table = cuttoff }
fields[#fields + 1] = { t = "Cutoff Cell Voltage",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #cuttoffVoltage, vals = { 19, 20 }, table = cuttoffVoltage }
fields[#fields + 1] = { t = "Current Limit (A)",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 65500, scale = 100, mult = 100, vals = { 55, 56 } }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Basic Setup",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    svFlags     = 0,

    postLoad = function(self)
        -- esc type
        local l = self.labels[1]
        l.t = getEscTypeLabel(self.values)

        -- SN
        l = self.labels[2]
        l.t = getUInt(self, { 29, 30, 31, 32 })

        -- FW ver
        l = self.labels[3]
        l.t = string.format("%.5f", getUInt(self, { 25, 26, 27, 28 }) / 100000)

        -- direction
        -- save flags, changed bit will be applied in pre-save
        local f = self.fields[2]
        self.svFlags = getPageValue(self, f.vals[1])
        f.value = bit32.extract(f.value, escFlags.spinDirection)

        -- set BEC voltage max (8.4 or 12.3)
        f = self.fields[3]
        f.max = bit32.extract(self.svFlags, escFlags.bec12v) == 0 and 84 or 123
    end,

    preSave = function (self)
        -- direction
        -- apply bits to saved flags
        local f = self.fields[2]
        setPageValue(self, f.vals[1], bit32.replace(self.svFlags, f.value, escFlags.spinDirection))

        return self.values
    end,
}
