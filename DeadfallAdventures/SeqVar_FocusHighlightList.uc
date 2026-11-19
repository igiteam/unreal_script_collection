class SeqVar_FocusHighlightList extends SeqVar_ObjectList
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

simulated event Initialize()
{
    local AdvPlayerController PC;

    // End:0x6A
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientIterateOverFocusHighlights();        
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
        PC.NotifyFocusHighlightChanged(Actor(Obj), true);        
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
        PC.NotifyFocusHighlightChanged(Actor(Obj), false);        
    }    
    //return;    
}

defaultproperties
{
    SupportedClasses=/* Array type was not detected. */
    VarName="FocusHighlights"
    ObjName="Focus Highlight List"
}