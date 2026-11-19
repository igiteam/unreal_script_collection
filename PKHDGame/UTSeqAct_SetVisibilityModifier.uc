class UTSeqAct_SetVisibilityModifier extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() float NewVisibilityModifier;

event Activated()
{
    local UTMapInfo MapInfo;

    MapInfo = UTMapInfo(GetWorldInfo().GetMapInfo());
    // End:0x7B
    if(MapInfo == none)
    {
        ScriptLog("SetVisibilityModifier: Missing UTMapInfo!");        
    }
    else
    {
        // End:0xC0
        if(NewVisibilityModifier < 1.0000000)
        {
            MapInfo.VisibilityModifier = 0.8000000 * NewVisibilityModifier;            
        }
        else
        {
            MapInfo.VisibilityModifier = NewVisibilityModifier;
        }
    }
    //return;    
}

defaultproperties
{
    NewVisibilityModifier=1.0000000
    VariableLinks=none
    ObjName="Set Visibility Modifier"
}