local toolName = "TNS|SCORPION ESC|TNE"
moduleName = "RF2SCORP"
moduleTitle = "Scorpion ESC"
chdir("/SCRIPTS/TOOLS/"..moduleName)

mspSignature = 0x53
mspHeaderBytes = 2
mspBytes = 84

apiVersion = 0
mcuId = nil
runningInSimulator = string.sub(select(2,getVersion()), -4) == "simu"

local run = nil
local scriptsCompiled = assert(loadScript("COMPILE/scripts_compiled.lua"))()

function getEscType(page)
    -- esc type
    local tt = {}
    for i = 1,32 do
        v = page.values[i + mspHeaderBytes]
        if v == 0 then
            break
        end
        table.insert(tt, string.char(v))
    end
    return table.concat(tt)
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
