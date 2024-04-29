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


labels[#labels + 1] = { t = "Scorpion ESC",           x = x, y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp + indent * 4, y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp * 1.8 + indent * 3, y = inc.y(lineSpacing) }

fields[#fields + 1] = { t = "Protection Delay (s)",   x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp + indent, min = 0, max = 5000, scale = 1000, mult = 100, vals = { 41, 42 } }
fields[#fields + 1] = { t = "Cutoff Handling (%)",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, min = 0, max = 10000, scale = 100, mult = 100, vals = { 49, 50 } }

fields[#fields + 1] = { t = "Max Temperature (C)",    x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp + indent, min = 0, max = 40000, scale = 100, mult = 100, vals = { 45, 46 } }
fields[#fields + 1] = { t = "Max Current (A)",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, min = 0, max = 30000, scale = 100, mult = 100, vals = { 47, 48 } }
fields[#fields + 1] = { t = "Min Voltage (V)",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, min = 0, max = 7000, scale = 100, mult = 100, vals = { 43, 44 } }
fields[#fields + 1] = { t = "Max Used (Ah)",          x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, min = 0, max = 6000, scale = 100, mult = 100, vals = { 51, 52 } }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Protection and Limits",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    svFlags     = 0,

    postLoad = function(self)
        -- esc type
        local l = self.labels[1]
        l.t = getEscType(self)

        -- SN
        l = self.labels[2]
        l.t = string.format("%08X", getUInt(self, { 55, 56, 57, 58 }))

        -- FW version
        l = self.labels[3]
        l.t = "v"..getUInt(self, { 59, 60 })
    end,
}
