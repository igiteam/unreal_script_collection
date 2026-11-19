class SeqVar_WeaponFireTargets extends SeqVar_ObjectList
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

simulated event Initialize()
{
    local AdvPlayerController PC;

    // End:0x6A
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientIterateOverWeaponFireTargets();        
    }    
    //return;    
}

simulated event NotifyElementAdded(Object Obj)
{
    local AdvPlayerController PC;

    // End:0x1A
    if(Actor(Obj) == none)
    {
        return;
    }
    // End:0x97
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        PC.NotifyWeaponFireTargetChanged(Actor(Obj), true);        
    }    
    //return;    
}

simulated event NotifyElementRemoved(Object Obj)
{
    local AdvPlayerController PC;

    // End:0x1A
    if(Actor(Obj) == none)
    {
        return;
    }
    // End:0x97
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        PC.NotifyWeaponFireTargetChanged(Actor(Obj), false);        
    }    
    //return;    
}

defaultproperties
{
    SupportedClasses=/* Array type was not detected. */
    VarName="WeaponTargetList"
    ObjName="Weapon Target List"
}