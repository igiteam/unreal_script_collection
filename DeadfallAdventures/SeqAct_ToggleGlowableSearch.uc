class SeqAct_ToggleGlowableSearch extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() float FlashLightPower;
var() bool bInfiniteBattery;
var() bool bLookForGlowableElements;
var() float DrainRate;
var() float RecoveryRate;
var() int TraceColumns;

event Activated()
{
    local SeqVar_Player PlayerVar;
    local SeqVar_Object ObjVar;
    local AdvPlayerPawn P;
    local int I;

    // End:0x40A
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        PlayerVar = SeqVar_Player(ObjVar);
        // End:0x57
        if(PlayerVar == none)
        {
            continue;            
        }
        PlayerVar.UpdatePlayersList();
        I = 0;
        J0x81:

        // End:0x409 [Loop If]
        if(I < PlayerVar.Players.Length)
        {
            // End:0x1A1
            if(PlayerVar.bAllPlayers)
            {
                // End:0x163
                if(AdvPlayerController(PlayerVar.Players[I]) != none)
                {
                    P = AdvPlayerPawn(AdvPlayerController(PlayerVar.Players[I]).Pawn);                    
                }
                else
                {
                    P = AdvPlayerPawn(PlayerVar.Players[I]);
                }                
            }
            else
            {
                // End:0x222
                if(AdvPlayerController(PlayerVar.GetObjectValue()) != none)
                {
                    P = AdvPlayerPawn(AdvPlayerController(PlayerVar.GetObjectValue()).Pawn);                    
                }
                else
                {
                    P = AdvPlayerPawn(PlayerVar.GetObjectValue());
                }
                I = PlayerVar.Players.Length;
            }
            // End:0x3FB
            if(P != none)
            {
                // End:0x377
                if(InputLinks[0].bHasImpulse)
                {
                    P.MyTorch.ChangeTorchPowerFromVolume(true, FlashLightPower, DrainRate, RecoveryRate, 0.0000000, bInfiniteBattery, bLookForGlowableElements, TraceColumns);
                    P.ChangeTorchPowerFromVolume(true, FlashLightPower, DrainRate, RecoveryRate, 0.0000000, bInfiniteBattery, bLookForGlowableElements);                    
                }
                else
                {
                    // End:0x3FB
                    if(InputLinks[1].bHasImpulse)
                    {
                        P.MyTorch.ChangeTorchPowerFromVolume(false);
                        P.ChangeTorchPowerFromVolume(false);
                    }
                }
            }
            ++I;
            // [Loop Continue]
            goto J0x81;
        }        
    }    
    //return;    
}

defaultproperties
{
    FlashLightPower=0.6000000
    bInfiniteBattery=true
    bLookForGlowableElements=true
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Toggle Glowable Search"
}