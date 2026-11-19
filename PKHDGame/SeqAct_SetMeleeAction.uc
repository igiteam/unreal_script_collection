class SeqAct_SetMeleeAction extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool ChangeMeleeWeapon;
var() bool ForceKick;
var() bool ShowMessage;
var() class<EvilWeap_Melee_Base> MeleeWeaponClass;
var() string LocKey;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilPlayerController PC;
    local bool Result;

    Result = false;
    // End:0x21F
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x1C9
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Targets")
        {
            P = EvilPawn(ObjVar.GetObjectValue());
            // End:0xC8
            if(P != none)
            {
                PC = EvilPlayerController(P.Controller);
            }
            // End:0x1C8
            if(PC != none)
            {
                // End:0x12D
                if(ChangeMeleeWeapon)
                {
                    Result = PC.GetMeleeActionsManager().ChangeMeleeWeapon(MeleeWeaponClass);
                }
                // End:0x17B
                if(ForceKick)
                {
                    PC.GetMeleeActionsManager().ForceKick();
                    Result = true;
                }
                // End:0x1C8
                if(ShowMessage)
                {
                    PC.GetMeleeActionsManager().ShowLocalizedHintMessage(LocKey);
                }
            }            
        }        
        // End:0x1FB
        if(Result)
        {
            OutputLinks[0].bHasImpulse = true;            
        }
        else
        {
            OutputLinks[1].bHasImpulse = true;
        }        
    }
    else
    {
        // End:0x2FE
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Targets")
        {
            P = EvilPawn(ObjVar.GetObjectValue());
            // End:0x2B9
            if(P != none)
            {
                PC = EvilPlayerController(P.Controller);
            }
            // End:0x2FD
            if(PC != none)
            {
                PC.GetMeleeActionsManager().Reset();
            }            
        }        
        OutputLinks[2].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    ShowMessage=true
    LocKey="Default"
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Reset",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="OnReset",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Targets",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Set Melee Action"
}