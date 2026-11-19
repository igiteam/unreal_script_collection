class UIAction_SaveCheats extends UIAction
    hidecategories(Object);

event Activated()
{
    Class'Engine.SaveLoadSystem'.static.SaveCheats("");
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Save Cheats"
}