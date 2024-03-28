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

labels[#labels + 1] = { t = "ESC Telemetry Frame",      x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "sync",                     x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 1 } }
fields[#fields + 1] = { t = "version",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 2 } }
fields[#fields + 1] = { t = "frame_type",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 3 } }
fields[#fields + 1] = { t = "frame_length",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 4 } }
fields[#fields + 1] = { t = "seq",                      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 5 } }
fields[#fields + 1] = { t = "device",                   x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 6 } }
fields[#fields + 1] = { t = "reserved",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 7 } }
fields[#fields + 1] = { t = "temperature",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 8 } }
fields[#fields + 1] = { t = "voltage",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 9, 10 } }
fields[#fields + 1] = { t = "current",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 11,12 } }
fields[#fields + 1] = { t = "consumption",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 13,14 } }
fields[#fields + 1] = { t = "rpm",                      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 15, 16 } }
fields[#fields + 1] = { t = "pwm",                      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 17 } }
fields[#fields + 1] = { t = "throttle",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 18 } }
fields[#fields + 1] = { t = "bec_voltage",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 19, 20 } }
fields[#fields + 1] = { t = "bec_current",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 21, 22 } }
fields[#fields + 1] = { t = "bec_temp",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 23 } }
fields[#fields + 1] = { t = "status1",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 24 } }
fields[#fields + 1] = { t = "cap_temp",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 25 } }
fields[#fields + 1] = { t = "aux_temp",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 26 } }
fields[#fields + 1] = { t = "status2",                  x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 27 } }
fields[#fields + 1] = { t = "reserved1",                x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 28 } }
fields[#fields + 1] = { t = "pidx",                     x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 29, 30 } }
fields[#fields + 1] = { t = "pdata",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 31, 32 } }
fields[#fields + 1] = { t = "crc",                      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, ro = true, vals = { 33, 34 } }

return {
    read        = 229, -- MSP_ESC_DEBUG
    eepromWrite = false,
    reboot      = false,
    title       = "Debug Frame",
    minBytes    = mspHeaderBytes + 6,
    labels      = labels,
    fields      = fields,

    autoRefresh = 100,

    postRead = function (self)
        -- adjust databind for v2 frame
        if self.values[mspHeaderBytes + 2] < 3 then
            -- invalidate .seq and .device
            local f = self.fields[5]
            f.vals = nil
            f.value = "---"
            f = self.fields[6]
            f.vals = nil
            f.value = "---"
            -- offset remaining fields
            for fidx = 7, #self.fields do
                f = self.fields[fidx]
                if f.vals then
                    local vals = {}
                    for vidx = 1, #f.vals do
                        vals[vidx] = f.vals[vidx] - 2
                    end
                    f.vals = vals
                end
            end
        end
    end,

    postLoad = function (self)
        -- hex(sync)
        local f = self.fields[1]
        f.value = string.format("x%02X", f.value)

        -- hex(device)
        f = self.fields[6]
        if f.vals then
            f.value = string.format("x%02X", f.value)
        end

        -- hex(crc)
        f = self.fields[#self.fields]
        f.value = string.format("x%04X", f.value)
    end,
}
