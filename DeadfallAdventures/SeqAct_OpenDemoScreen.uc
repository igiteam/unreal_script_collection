class SeqAct_OpenDemoScreen extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local AdvPlayerController PC;

    // End:0x6A
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        PC.OpenDemoScreen();        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Open Demo Screen"
}