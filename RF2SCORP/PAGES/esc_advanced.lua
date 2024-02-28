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

local onOff = {
    [0] = "On",
    "Off"
}


labels[#labels + 1] = { t = "Scorpion ESC",           x = x,          y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
fields[#fields + 1] = {                               x = x,          y = inc.y(lineSpacing), sp = x + sp + indent * 4, vals = { 55, 56, 57, 58 }, ro = true }
y = yMinLim - lineSpacing
fields[#fields + 1] = {                               x = x,          y = inc.y(lineSpacing), sp = x + sp * 1.8 + indent * 3, vals = { 59, 60 }, ro = true }

fields[#fields + 1] = { t = "Soft Start Time (s)",    x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp + indent, min = 0, max = 60000, scale = 1000, mult = 1000, vals = { 61, 62 } }
fields[#fields + 1] = { t = "Runup Time (s)",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, min = 0, max = 60000, scale = 1000, mult = 1000, vals = { 63, 64 } }
fields[#fields + 1] = { t = "Bailout (s)",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, min = 0, max = 100000, scale = 1000, mult = 1000, vals = { 65, 66 } }

-- dont appear to be populated
-- fields[#fields + 1] = { t = "Stick Zero (us)",        x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, vals = { 79, 80, 81, 82 } }
-- fields[#fields + 1] = { t = "Stick Max (us)",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, vals = { 75, 76, 77, 78 } }

-- data types are IQ22 - currently not understood
-- fields[#fields + 1] = { t = "Gov Proportional",       x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp + indent, min = 0, max = 100000, vals = { 67, 68, 69, 70 } }
-- fields[#fields + 1] = { t = "Gov Integral",           x = x + indent, y = inc.y(lineSpacing), sp = x + sp + indent, min = 0, max = 100000, vals = { 71, 72, 73, 74 } }

fields[#fields + 1] = { t = "Motor Startup Sound",    x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp + indent, min = 0, max = #onOff, vals = { 53, 54 }, table = onOff }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Advanced Setup",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    svFlags     = 0,

    postLoad = function(self)
        -- esc type
        local l = self.labels[1]
        local dname = {}
        for _, v in ipairs(self.values) do
            if v == 0 then
                break
            end
            table.insert(dname, string.char(v))
        end
        l.t = table.concat(dname)

        -- SN
        local f = self.fields[1]
        f.value = string.format("%08X", f.value)

        -- FW version
        f = self.fields[2]
        f.value = "v"..f.value
    end,

    preSave = function (self)
    end,
}
