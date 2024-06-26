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

local startupResponse = {
    [0] = "Normal",
    "Smooth"
}

local throttleResponse = {
    [0] = "Slow",
    "Medium",
    "Fast",
    "Custom (PC defined)"
}

local motorTiming = {
    [0] = "Auto Normal",
    "Auto Efficient",
    "Auto Power",
    "Auto Extreme",
    "0 deg",
    "6 deg",
    "12 deg",
    "18 deg",
    "24 deg",
    "30 deg",
}

local motorTimingToUI = {
    [0] = 0,
    4,
    5,
    6,
    7,
    8,
    9,
    [16] = 0,
    [17] = 1,
    [18] = 2,
    [19] = 3,
}

local motorTimingFromUI = {
    [0] = 0,
    17,
    18,
    19,
    1,
    2,
    3,
    4,
    5,
    6,
}

local freewheel = {
    [0] = "Off",
    "Auto",
    "*unused*",
    "Always On",
}

labels[#labels + 1] = { t = "ESC",                    x = x,                y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp + indent,  y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp * 1.8,     y = inc.y(lineSpacing) }


fields[#fields + 1] = { t = "Min Start Power (%)",    x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 0, max = 26, vals = { 47, 48 } }
fields[#fields + 1] = { t = "Max Start Power (%)",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 31, vals = { 49, 50 } }
fields[#fields + 1] = { t = "Startup Response",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #startupResponse, vals = { 9, 10 }, table = startupResponse }
fields[#fields + 1] = { t = "Throttle Response",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #throttleResponse, vals = { 15, 16 }, table = throttleResponse }

fields[#fields + 1] = { t = "Motor Timing",           x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 0, max = #motorTiming, vals = { 7, 8 }, table=motorTiming }
fields[#fields + 1] = { t = "Active Freewheel",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #freewheel, vals = { 21, 22 }, table = freewheel }
fields[#fields + 1] = { t = "F3C Autorotation",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1, vals = { 53 }, table = offOn }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Advanced Setup",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    svTiming    = 0,
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

        -- motor timing
        local f = self.fields[5]
        self.svTiming = bit32.lshift(getPageValue(self, f.vals[2]), 8) + getPageValue(self, f.vals[1])
        f.value = motorTimingToUI[self.svTiming] or 0

        -- F3C autorotation
        f = self.fields[7]
        self.svFlags = getPageValue(self, f.vals[1])
        f.value = bit32.extract(f.value, escFlags.f3cAuto)
    end,

    preSave = function (self)
        -- motor timing
        f = self.fields[5]
        local value = motorTimingFromUI[f.value] or 0
        setPageValue(self, f.vals[1], bit32.band(value, 0xFF))
        setPageValue(self, f.vals[2], bit32.rshift(value, 8))

        -- F3C autorotation
        -- apply bits to saved flags
        local f = self.fields[7]
        setPageValue(self, f.vals[1], bit32.replace(self.svFlags, f.value, escFlags.f3cAuto))
        
        return self.values
    end,
}
