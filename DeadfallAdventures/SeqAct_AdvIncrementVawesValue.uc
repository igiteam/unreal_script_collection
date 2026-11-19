class SeqAct_AdvIncrementVawesValue extends SeqAct_AIFactoryObserver
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    AdvPRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().PlayerReplicationInfo).WavesCount++;
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Increment Vawes Value"
}