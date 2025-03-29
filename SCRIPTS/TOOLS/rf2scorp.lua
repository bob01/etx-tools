local toolName = "TNS|Scorpion ESC|TNE"
moduleName = "RF2SCORP"
moduleTitle = "Scorpion ESC v0.44"
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
        local v = page.values[i + mspHeaderBytes]
        if v == 0 then
            break
        end
        table.insert(tt, string.char(v))
    end
    return table.concat(tt)
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
