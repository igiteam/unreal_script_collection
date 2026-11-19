class SPDAction_DONOTUSE extends SPDAction
    native
    editinlinenew
    collapsecategories;

// Export USPDAction_DONOTUSE::execDebugIt(FFrame&, void* const)
native function DebugIt(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo);

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    DebugIt(ElapsedTime, Actor, Manager, DamageInfo);
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Action="DO NOT USE. Does nothing. Only used for debugging"
}