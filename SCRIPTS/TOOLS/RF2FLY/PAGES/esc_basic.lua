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

local govMode = {
    [0] = "Ext Governor",
    "Esc Governor"
}

local direction = {
    [0] = "Normal",
    "Reverse"
}

local becVoltage = {
    [0] = "7.5",
    "8.0",
    "8.5",
    "12.0"
}

local lipoCellCount = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"
}

labels[#labels + 1] = { t = "ESC",                    x = x,                y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp - indent,  y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp * 2.2,     y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "---",                    x = x,                y = inc.y(lineSpacing) }

fields[#fields + 1] = { t = "ESC Mode",               x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 0, max = #govMode, vals = { 23 }, table = govMode }
fields[#fields + 1] = { t = "Direction",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1, vals = { 29 }, table = direction }
fields[#fields + 1] = { t = "BEC Voltage[V]",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #becVoltage, vals = { 27 }, table = becVoltage }

labels[#labels + 1] = { t = "Protection and Limits",  x = x,          y = inc.y(lineSpacing * 2) }
fields[#fields + 1] = { t = "Lipo Cell Count[S]",     x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 4, max = #lipoCellCount, vals = { 24 }, table = lipoCellCount }
fields[#fields + 1] = { t = "Max Temperature[°C]",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 50, max = 135, vals = { 26 } }
fields[#fields + 1] = { t = "Min Voltage[V]",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 28, max = 38, vals = { 25 }, scale = 10 }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Basic Setup",
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
    end,
}
