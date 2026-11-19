class UIAction_ClearCheats extends UIAction
    hidecategories(Object);

event Activated()
{
    local PlayerController PC;

    Class'Engine.SaveLoadSystem'.static.ClearCheats("");
    // End:0x52
    foreach GetWorldInfo().LocalPlayerControllers(PC)
    {
        // End:0x51
        if(MOHAPlayerController(PC) != none)
        {
            MOHAPlayerController(PC).ClearCheats();
        }        
    }    
    super(SequenceOp).Activated();
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Clear Cheats"
}