local toolName = "TNS|HobbyWing ESC|TNE"
moduleName = "RF2HW5"
moduleTitle = "HobbyWing ESC v0.42"
chdir("/SCRIPTS/TOOLS/"..moduleName)

mspSignature = 0xFD
mspHeaderBytes = 2
mspBytes = 80

apiVersion = 0
mcuId = nil
runningInSimulator = string.sub(select(2,getVersion()), -4) == "simu"

local run = nil
local scriptsCompiled = assert(loadScript("COMPILE/scripts_compiled.lua"))()

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
