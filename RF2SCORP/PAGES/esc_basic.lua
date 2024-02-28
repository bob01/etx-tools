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

local escMode = { 
    [0] = "Heli Governor",
    "Heli Governor (stored)",
    "VBar Governor",
    "External Governor",
    "Airplane mode",
    "Boat mode",
    "Quad mode",
}

local rotation = {
    [0] = "CCW",
    "CW",
}

local becVoltage = {
    [0] = "5.1 V",
    "6.1 V",
    "7.3 V",
    "8.3 V",
    "Disabled",
}

local teleProtocol = {
    [0] = "Standard",
    "VBar",
    "Jeti Exbus",
    "Unsolicited",
    "Futaba SBUS",
}


labels[#labels + 1] = { t = "Scorpion ESC",           x = x,          y = inc.y(lineSpacing) }
y = yMinLim - lineSpacing
fields[#fields + 1] = {                               x = x,          y = inc.y(lineSpacing), sp = x + sp + indent * 4, vals = { 55, 56, 57, 58 }, ro = true }
y = yMinLim - lineSpacing
fields[#fields + 1] = {                               x = x,          y = inc.y(lineSpacing), sp = x + sp * 1.8 + indent * 3, vals = { 59, 60 }, ro = true }

fields[#fields + 1] = { t = "ESC Mode",               x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 0, max = #escMode, vals = { 33, 34 }, table = escMode }
fields[#fields + 1] = { t = "Rotation",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #rotation, vals = { 37, 38 }, table = rotation }
fields[#fields + 1] = { t = "BEC Voltage",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #becVoltage, vals = { 35, 36 }, table = becVoltage }

fields[#fields + 1] = { t = "Telemetry Protocol",     x = x + indent, y = inc.y(lineSpacing * 2), sp = x + sp, min = 0, max = #teleProtocol, vals = { 39, 40 }, table = teleProtocol }

return {
    read        = 217, -- MSP_ESC_PARAMETERS
    write       = 218, -- MSP_SET_ESC_PARAMETERS
    eepromWrite = true,
    reboot      = false,
    title       = "Basic Setup",
    minBytes    = mspBytes,
    labels      = labels,
    fields      = fields,

    svFlags     = 0,

    postLoad = function(self)
        -- esc type
        local l = self.labels[1]
        local tt = {}
        for _, v in ipairs(self.values) do
            if v == 0 then
                break
            end
            table.insert(tt, string.char(v))
        end
        l.t = table.concat(tt)

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
