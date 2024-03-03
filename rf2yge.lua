local toolName = "TNS|YGE ESC|TNE"
moduleName = "RF2YGE"
moduleTitle = "YGE ESC"
chdir("/SCRIPTS/TOOLS/"..moduleName)

escType = {
    [8273] = "YGE 205 HVT BEC",
}

escFlags =
{
    spinDirection = 0,
    f3cAuto = 1,
    keepMah = 2,
    bec12v = 3,
}

mspSignature = 0xA5
mspHeaderBytes = 2
mspBytes = 66

apiVersion = 0
mcuId = nil
runningInSimulator = string.sub(select(2,getVersion()), -4) == "simu"

local run = nil
local scriptsCompiled = assert(loadScript("COMPILE/scripts_compiled.lua"))()

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
