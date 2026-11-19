class SeqAct_StopLoadingMovie extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local AdvPlayerController PC;

    // End:0x6A
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientStopLevelLoadingMovie();        
    }    
    //return;    
}

defaultproperties
{
    bCallHandler=false
    ObjName="Stop Loading Movie"
}