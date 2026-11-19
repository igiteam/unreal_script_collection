class SeqAct_ToggleWeapon extends SeqAct_Toggle
    hidecategories(Object);

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    ObjName="Toggle Weapon"
}