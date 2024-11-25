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

local fanControl = { 
    [0] = "Temperature Control",
    "Always On"
}

labels[#labels + 1] = { t = "ESC",                    x = x,                y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp - indent,  y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp * 2.2,     y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "---",                    x = x,                y = inc.y(lineSpacing) }

fields[#fields + 1] = { t = "Fan Control",            x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 0, max = #fanControl, vals = { 34 }, table = fanControl }
fields[#fields + 1] = { t = "Buzzer volume",          x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 5, vals = { 32 } }

fields[#fields + 1] = { t = "Current Gain",           x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = -20, max = 20, vals = { 33 } }
fields[#fields + 1] = { t = "Motor ERPM Max",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1000000, mult = 100, vals = { 44, 43, 42 } }

-- fields[#fields + 1] = { t = "Throttle Min (us)",      x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, ro = true, vals = { 20, 19 } }
-- fields[#fields + 1] = { t = "Throttle Max (us)",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 22, 21 } }

labels[#labels + 1] = { t = "Throttle Range",         x = x + indent,       y = inc.y(lineSpacing * 2) }
y = y - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp,  y = inc.y(lineSpacing) }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Other Settings",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    postLoad = function(self)
        -- esc label
        local l = self.labels[1]
        l.t = getEscLabel(self)

        -- SN
        l = self.labels[2]
        l.t = "sn:"..string.format("%08X", getUInt(self, { 7, 6, 5, 4 }))..string.format("%08X", getUInt(self, { 11, 10, 9, 8 }))

        -- FW version
        l = self.labels[3]
        l.t = "fw:"..getPageValue(self, 15).."."..getPageValue(self, 16).."."..getPageValue(self, 17)

        -- HW version + IAP
        l = self.labels[4]
        l.t = "hw:".."1."..getPageValue(self, 18).."-iap:"..getPageValue(self, 12).."."..getPageValue(self, 13).."."..getPageValue(self, 14)

        -- throttle range
        l = self.labels[6]
        l.t = getUInt(self, { 20, 19 }).." - "..getUInt(self, { 22, 21 }).."us"

        -- current gain
        local f = self.fields[3]
        f.value = getPageValue(self, f.vals[1]) - 20
    end,

    preSave = function (self)
        -- current gain
        local f = self.fields[3]
        setPageValue(self, f.vals[1], f.value + 20)
        return self.values
    end,
}
