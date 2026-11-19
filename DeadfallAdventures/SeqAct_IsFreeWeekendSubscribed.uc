class SeqAct_IsFreeWeekendSubscribed extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPlayerController C;

    // End:0x10F
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        C = AdvPlayerController(ObjVar.GetObjectValue());
        // End:0xB9
        if(C == none)
        {
            C = AdvPlayerController(Pawn(ObjVar.GetObjectValue()).Controller);
        }
        // End:0x10E
        if(C != none)
        {
            // End:0x10E
            if(C.IsFreeWeekendSubscribed())
            {
                OutputLinks[0].bHasImpulse = true;                
                return;
            }
        }        
    }    
    OutputLinks[1].bHasImpulse = true;
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Yes",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="No",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Is Free Weekend Subscribed"
}