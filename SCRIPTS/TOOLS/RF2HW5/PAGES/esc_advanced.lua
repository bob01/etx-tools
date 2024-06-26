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

local restartTime = {
    [0] = "1s",
    "1.5s",
    "2s",
    "2.5s",
    "3s",
}

labels[#labels + 1] = { t = "ESC",                    x = x,                y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp - indent,  y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
labels[#labels + 1] = { t = "---",                    x = x + sp * 1.9,     y = inc.y(lineSpacing) }

labels[#labels + 1] = { t = "Governor",               x = x,          y = inc.y(lineSpacing * 2) }
fields[#fields + 1] = { t = "P-Gain",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 9, vals = { 70 } }
fields[#fields + 1] = { t = "I-Gain",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 9, vals = { 71 } }

labels[#labels + 1] = { t = "Soft Start",             x = x,          y = inc.y(lineSpacing * 2) }
fields[#fields + 1] = { t = "Startup Time",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 4, max = 25, vals = { 69 } }
fields[#fields + 1] = { t = "Restart Time",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #restartTime, vals = { 73 }, table = restartTime }
fields[#fields + 1] = { t = "Auto Restart",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 90, vals = { 72 } }

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
        -- esc type
        local l = self.labels[1]
        -- local type = getText(self, 33, 48)
        local name = getText(self, 49, 64)
        l.t = name

        -- HW ver
        l = self.labels[2]
        l.t = getText(self, 17, 32)

        -- FW ver
        l = self.labels[3]
        l.t = getText(self, 1, 16)

        -- Startup Time
        f = self.fields[3]
        f.value = f.value + 4
    end,

    preSave = function (self)
        -- Startup Time
        local f = self.fields[3]
        setPageValue(self, 69, f.value - 4)
        return self.values
    end,
}
