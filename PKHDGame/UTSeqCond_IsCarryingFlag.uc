class UTSeqCond_IsCarryingFlag extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

var Actor Target;
var() EvilGameObjective FlagBase;

event Activated()
{
    local EvilPlayerReplicationInfo PRI;
    local Pawn P;
    local Controller C;
    local EvilCarriedObject Flag;

    P = Pawn(Target);
    // End:0x5F
    if(P != none)
    {
        PRI = EvilPlayerReplicationInfo(P.PlayerReplicationInfo);        
    }
    else
    {
        C = Controller(Target);
        // End:0xBB
        if(C != none)
        {
            PRI = EvilPlayerReplicationInfo(C.PlayerReplicationInfo);
        }
    }
    // End:0xFB
    if(PRI == none)
    {
        ScriptLog("Invalid target specified for" @ string(self));        
    }
    else
    {
        // End:0x133
        if(FlagBase != none)
        {
            Flag = FlagBase.GetFlag();
        }
        OutputLinks[((PRI.bHasFlag && (Flag == none) || PRI.GetFlag() == Flag) ? 0 : 1)].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Has Flag",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="No Flag",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Flag Base (Optional)",LinkVar="None",PropertyName="FlagBase",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Is Carrying Flag"
}