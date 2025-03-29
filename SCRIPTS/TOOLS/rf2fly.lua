local toolName = "TNS|FLYROTOR ESC|TNE"
moduleName = "RF2FLY"
moduleTitle = "FLYROTOR ESC v0.44"
chdir("/SCRIPTS/TOOLS/"..moduleName)

mspSignature = 0x73
mspHeaderBytes = 2
mspBytes = 46

apiVersion = 0
mcuId = nil
runningInSimulator = string.sub(select(2,getVersion()), -4) == "simu"

local run = nil
local scriptsCompiled = assert(loadScript("COMPILE/scripts_compiled.lua"))()

local escLabel = {
    [0] = "Helicopter",
    "Fixed wing"
}

function getEscLabel(page)
    local type = escLabel[getPageValue(page, 1)] or "FLYROTOR"
    local curr = getUInt(page, { 3, 2 })
    return type.." ["..curr.."A]"
end

function getUInt(page, vals)
    local v = 0
    for idx=1, #vals do
        local raw_val = page.values[vals[idx] + mspHeaderBytes] or 0
        raw_val = bit32.lshift(raw_val, (idx-1)*8)
        v = bit32.bor(v, raw_val)
    end
    return v
end

function getText(page, st, en)
    local tt = {}
    for i = st, en do
        local v = page.values[i + mspHeaderBytes]
        if v == 0 then
            break
        end
        table.insert(tt, string.char(v))
    end
    return table.concat(tt)
end

function getPageValue(page, index)
    return page.values[mspHeaderBytes + index]
end

function setPageValue(page, index, value)
    page.values[mspHeaderBytes + index] = value
end

if scriptsCompiled then
    protocol = assert(loadScript("protocols.lua"))()
    radio = assert(loadScript("radios.lua"))().msp
    assert(loadScript(protocol.mspTransport))()
    assert(loadScript("MSP/common.lua"))()
    run = assert(loadScript("ui.lua"))()
else
    run = assert(loadScript("COMPILE/compile.lua"))()
end

return { run=run }
