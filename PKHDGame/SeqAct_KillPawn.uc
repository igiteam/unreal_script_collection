class SeqAct_KillPawn extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() class<EvilDmgType_Base> EvilDamageType;
var Pawn TargetPawn;
var Controller Instigator;
var() bool bGibHead;

event Activated()
{
    local EvilPawn EPawn;

    EPawn = EvilPawn(TargetPawn);
    // End:0x133
    if(EPawn != none)
    {
        // End:0xD1
        if(bGibHead)
        {
            EPawn.TryDetachLimb(9999, EvilDamageType, EPawn.CurrentHitInformation.HitLocation, EPawn.CurrentHitInformation.Momentum, 'Head', true);
        }
        EPawn.Died(Instigator, EvilDamageType, EPawn.CurrentHitInformation.HitLocation);
    }
    //return;    
}

defaultproperties
{
    bGibHead=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="TargetPawn",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="EvilDamageType",LinkVar="None",PropertyName="EvilDamageType",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Kill pawn"
}