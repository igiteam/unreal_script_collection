class SeqAct_RemoveSurvivalIcon extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor Target;

event Activated()
{
    local AdvPlayerController PC;

    // End:0x73
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        PC.RemoveObjectiveIcon(Target);        
    }    
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Remove Survival Icon"
}