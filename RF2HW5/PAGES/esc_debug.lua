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
labels[#labels + 1] = { t = "fw-ver",                 x = x + indent, y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "---",                    x = x + sp,     y = y }
labels[#labels + 1] = { t = "hw-ver",                 x = x + indent, y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "---",                    x = x + sp,     y = y }
labels[#labels + 1] = { t = "type",                   x = x + indent, y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "---",                    x = x + sp,     y = y }
labels[#labels + 1] = { t = "name",                   x = x + indent, y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "---",                    x = x + sp,     y = y }
fields[#fields + 1] = { t = "flight mode",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 64 } } --
fields[#fields + 1] = { t = "lipo cells",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 65 } } --
fields[#fields + 1] = { t = "volt cutoff type",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 66 } } --
fields[#fields + 1] = { t = "cuttoff voltage",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 67 } } --
fields[#fields + 1] = { t = "bec voltage",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 68 } } --
fields[#fields + 1] = { t = "startup time",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 69 } } --#
fields[#fields + 1] = { t = "gov P",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 70 } } --#
fields[#fields + 1] = { t = "gov I",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 71 } } --#
fields[#fields + 1] = { t = "auto restart",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 72 } } --#
fields[#fields + 1] = { t = "restart acc time",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 73 } } --#
fields[#fields + 1] = { t = "brake type",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 74 } } --!
fields[#fields + 1] = { t = "brake force",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 75 } } --!
fields[#fields + 1] = { t = "timing",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 76 } } --!
fields[#fields + 1] = { t = "rotation",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 77 } } --
fields[#fields + 1] = { t = "active freewheel",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 78 } } --!
fields[#fields + 1] = { t = "startup power",          x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 79 } } --!

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    eepromWrite = false,
    reboot      = false,
    title       = "Debug",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    postLoad = function(self)
        -- fw ver
        local l = self.labels[3]
        l.t = getText(self, 1, 16)

        -- hw-ver
        l = self.labels[5]
        l.t = getText(self, 17, 32)

        -- type
        l = self.labels[7]
        l.t = getText(self, 33, 48)

        -- name
        l = self.labels[9]
        l.t = getText(self, 49, 64)
    end,
}
