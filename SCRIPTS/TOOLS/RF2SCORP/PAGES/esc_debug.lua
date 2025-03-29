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

labels[#labels + 1] = { t = "ESC",                    x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "ESC Mode",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 33, 34 } }
fields[#fields + 1] = { t = "BEC Voltage",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 35, 36 } }
fields[#fields + 1] = { t = "Rotation",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 37, 38 } }
fields[#fields + 1] = { t = "Telemetry Protocol",     x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 39, 40 } }
fields[#fields + 1] = { t = "Protection Delay (s)",   x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, ro = true, vals = { 41, 42 } }
fields[#fields + 1] = { t = "Min Voltage (V)",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, ro = true, vals = { 43, 44 } }
fields[#fields + 1] = { t = "Max Temperature (C)",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, ro = true, vals = { 45, 46 } }
fields[#fields + 1] = { t = "Max Current (A)",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, ro = true, vals = { 47, 48 } }
fields[#fields + 1] = { t = "Cutoff Handling (%)",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, ro = true, vals = { 49, 50 } }
fields[#fields + 1] = { t = "Max Used (Ah)",          x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, ro = true, vals = { 51, 52 } }
fields[#fields + 1] = { t = "Motor Startup Sound",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 53, 54 } }
labels[#labels + 1] = { t = "Serial Number",          x = x + indent, y = inc.y(lineSpacing) }  -- vals = { 55, 56, 57, 58 }
labels[#labels + 1] = { t = "Firmware Version",       x = x + indent, y = inc.y(lineSpacing) }  -- , sp = x + sp + indent, vals = { 59, 60 } }
fields[#fields + 1] = { t = "Soft Start Time (s)",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 61, 62 } }
fields[#fields + 1] = { t = "Runup Time (s)",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 63, 64 } }
fields[#fields + 1] = { t = "Bailout (s)",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 65, 66 } }
fields[#fields + 1] = { t = "Gov Proportional",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 67, 68, 69, 70 } }
fields[#fields + 1] = { t = "Gov Integral",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 71, 72, 73, 74 } }
fields[#fields + 1] = { t = "Stick Max (us)",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 75, 76, 77, 78 } }
fields[#fields + 1] = { t = "Stick Zero (us)",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, vals = { 79, 80, 81, 82 } }

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
        -- esc type
        local l = self.labels[1]
        l.t = getEscType(self)

        -- SN
        l = self.labels[2]
        l.t = "sn: " .. string.format("%08X", getUInt(self, { 55, 56, 57, 58 }))

        -- FW version
        l = self.labels[3]
        l.t = "fw: " .. getUInt(self, { 59, 60 })
    end,
}
