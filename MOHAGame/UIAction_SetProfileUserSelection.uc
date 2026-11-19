class UIAction_SetProfileUserSelection extends UIAction
    native
    hidecategories(Object);

var() int nOption;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    ObjName="Set Profile User Selection"
    ObjCategory="Profile Manager"
}