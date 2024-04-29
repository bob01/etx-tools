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

-- update pole count label text
local function updatePoles(self)
    local f = self.fields[3]
    local l = self.labels[4]
    l.t = f.value * 2
end

-- update gear ratio label text
local function updateRatio(self)
    local fm = self.fields[4]
    local fp = self.fields[5]
    local l = self.labels[5]
    local v = fp.value ~= 0 and fm.value / fp.value or 0
    l.t = string.format("%.2f", v)..":1"
end

labels[#labels + 1] = { t = "ESC",                    x = x,                y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp + indent,  y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp * 1.8,     y = inc.y(lineSpacing) }

fields[#fields + 1] = { t = "P-Gain",                 x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 1, max = 10, vals = { 11, 12 } }
fields[#fields + 1] = { t = "I-Gain",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 10, vals = { 13, 14 } }

fields[#fields + 1] = { t = "Motor Pole Pairs",       x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 1, max = 100, vals = { 41, 42 }, upd = updatePoles }
labels[#labels + 1] = { t = "0",                      x = x + sp * 1.6, y = y }
fields[#fields + 1] = { t = "Main Teeth",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 1800, vals = { 45, 46 }, upd = updateRatio }
labels[#labels + 1] = { t = ":",                      x = x + sp * 1.6, y = y }
fields[#fields + 1] = { t = "Pinion Teeth",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 255, vals = { 43, 44 } }

fields[#fields + 1] = { t = "Stick Zero (us)",        x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 900, max = 1900, vals = { 35, 36 } }
fields[#fields + 1] = { t = "Stick Range (us)",       x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 600, max = 1500, vals = { 37, 38 } }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Other Settings",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    updatePoles = updatePoles,
    updateRatio = updateRatio,

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

        -- update pole count
        self.updatePoles(self)

        -- update gear ratio
        self.updateRatio(self)
    end,
}
