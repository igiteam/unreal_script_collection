class SeqAct_UpgradeWeaponFromUI extends SequenceAction
    hidecategories(Object);

var() MOHAIncludeClass.EWeaponType SelectedWeaponType;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

function Activated()
{
    //return;    
}

defaultproperties
{
    ObjName="Upgrade Weapon From UI"
    ObjCategory="UI"
}