class SeqAct_DisableHealthRegen extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bIgnoreLastHitDmgStop;

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPlayerPawn APP;
    local AdvPlayerController APC;

    // End:0x1B5
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0xBC
        if(AdvPlayerController(ObjVar.GetObjectValue()) != none)
        {
            APC = AdvPlayerController(ObjVar.GetObjectValue());
            APP = AdvPlayerPawn(APC.Pawn);            
        }
        else
        {
            APP = AdvPlayerPawn(ObjVar.GetObjectValue());
            APC = AdvPlayerController(APP.Controller);
        }
        // End:0x165
        if(InputLinks[0].bHasImpulse)
        {
            APP.bForceStopHealthRegen = true;
            // End:0x1B4
            continue;
        }
        APP.bForceStopHealthRegen = false;
        // End:0x1B4
        if(bIgnoreLastHitDmgStop)
        {
            APP.bStopHealthRegenByDamage = false;
        }        
    }    
    //return;    
}

defaultproperties
{
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Disable Player HP regen"
}