class SeqAct_AddObjectiveIcon extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor Target;

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPawn P;

    // End:0x13C
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0xA9
        if(AdvPlayerController(ObjVar.GetObjectValue()) != none)
        {
            P = AdvPawn(AdvPlayerController(ObjVar.GetObjectValue()).Pawn);            
        }
        else
        {
            P = AdvPawn(ObjVar.GetObjectValue());
        }
        // End:0x13B
        if(P != none)
        {
            AdvPlayerController(P.Controller).AddObjectiveIcon(Target, "objective");
        }        
    }    
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Add Objective Icon"
}