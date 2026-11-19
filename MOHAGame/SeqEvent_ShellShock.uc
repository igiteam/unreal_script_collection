class SeqEvent_ShellShock extends SequenceEvent
    hidecategories(Object);

enum EShellShock
{
    SHELL_SHOCK_START,              // 0
    SHELL_SHOCK_STOP,               // 1
    SHELL_SHOCK_MAX                 // 2
};

defaultproperties
{
    MaxTriggerCount=0
    OutputLinks[0]=(Links=none,LinkDesc="Started",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Stopped",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Shell Shock"
    ObjCategory="Player"
}