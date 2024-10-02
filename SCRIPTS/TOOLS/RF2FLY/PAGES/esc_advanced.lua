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

labels[#labels + 1] = { t = "ESC",                    x = x,                y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp - indent,  y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp * 2.2,     y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "---",                    x = x,                y = inc.y(lineSpacing) }

fields[#fields + 1] = { t = "Soft start",             x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 5, max = 55, vals = { 35 } }
fields[#fields + 1] = { t = "Starting Torque",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 15, vals = { 30 } }
fields[#fields + 1] = { t = "Response Speed",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 50, vals = { 31 } }
fields[#fields + 1] = { t = "Timing angle (°)",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 5, max = 25, vals = { 28 } }

fields[#fields + 1] = { t = "Gov P-Gain",             x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 0, max = 1000, vals = { 37, 36 }, scale = 100 }
fields[#fields + 1] = { t = "Gov I-Gain",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1000, vals = { 39, 38 }, scale = 100 }
fields[#fields + 1] = { t = "Gov D-Gain",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1000, vals = { 41, 40 }, scale = 100 }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Advanced Setup",
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
        l.t = "hw:"..(getPageValue(self, 18) + 1)..".0/"..getPageValue(self, 12).."."..getPageValue(self, 13).."."..getPageValue(self, 14)
    end,
}
