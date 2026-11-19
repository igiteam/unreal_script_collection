class SeqAct_PickTreasure extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvTreasureTrigger_Base TreasureActor;

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPlayerController PC;
    local AdvPawn P;

    // End:0x11
    if(TreasureActor == none)
    {
        return;
    }
    // End:0x17D
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Player")
    {
        // End:0xCC
        if(AdvPlayerController(ObjVar.GetObjectValue()) != none)
        {
            PC = AdvPlayerController(ObjVar.GetObjectValue());
            P = AdvPawn(PC.Pawn);            
        }
        else
        {
            P = AdvPawn(ObjVar.GetObjectValue());
        }
        // End:0x17C
        if((P != none) && !TreasureActor.bCollected)
        {
            TreasureActor.Enabled = true;
            TreasureActor.UsedBy(P);
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Player",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TreasureTrigger Actor",LinkVar="None",PropertyName="TreasureActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Pick Treasure Emulation"
}