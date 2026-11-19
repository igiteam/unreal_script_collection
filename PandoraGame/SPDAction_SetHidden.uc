class SPDAction_SetHidden extends SPDAction
    editinlinenew
    collapsecategories;

var(SPDAction) bool bHide;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    // End:0x25
    if(Actor != none)
    {
        Actor.SetHiddenFlag(bHide);
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    bHide=true
    Action="Set Hidden - Hide or unhide the actor"
}