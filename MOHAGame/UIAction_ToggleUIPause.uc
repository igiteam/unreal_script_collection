class UIAction_ToggleUIPause extends UIAction
    hidecategories(Object);

var() bool bEnableExternalUIPause;

event Activated()
{
    // End:0x23
    if(GetWorldInfo() != none)
    {
        GetWorldInfo().CanExternalUIPause = bEnableExternalUIPause;
    }
    //return;    
}

defaultproperties
{
    bEnableExternalUIPause=true
    VariableLinks=none
    ObjName="Toggle External UI Pause"
}