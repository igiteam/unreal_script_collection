class UTSeqCond_CheckWeapon extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

var Actor Target;
var() class<EvilWeap_Base> TestForWeaponClass;

event Activated()
{
    local EvilPawn P;
    local EvilPlayerController PC;
    local bool Results;

    PC = EvilPlayerController(Target);
    // End:0xB4
    if(PC != none)
    {
        P = EvilPawn(PC.Pawn);
        // End:0xB4
        if(P != none)
        {
            Results = P.Weapon.Class == TestForWeaponClass;
        }
    }
    OutputLinks[((Results) ? 0 : 1)].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Weapon Equipped",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Weapon Not Equipped",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="UTWeaponTest"
}