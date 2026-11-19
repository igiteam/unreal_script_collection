class SeqAct_QuickTap extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() EvilTypes.EGameButtons EventButton;
var() bool bShowButton;
var transient bool bKeyTaken;
var() float TapIntervalTime;
var() float NoTapIntervalTime;
var() float MultiplyFactor;
var transient array<AdvPlayerController> CachedPCs;
var editconst transient float Frequency;
var transient float CurrentTime;

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPawn P;
    local AdvPlayerController PC;

    // End:0x16C
    if(InputLinks[0].bHasImpulse)
    {
        CurrentTime = 0.0000000;
        CachedPCs.Remove(0, CachedPCs.Length);        
        // End:0xF3
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
        {
            P = AdvPawn(ObjVar.GetObjectValue());
            // End:0xF2
            if(P != none)
            {
                PC = FindPC(P);
                // End:0xF2
                if(PC != none)
                {
                    CachedPCs.AddItem(PC);                    
                }
            }            
        }        
        // End:0x15F
        foreach CachedPCs(PC)
        {
            // End:0x15E
            if(bShowButton)
            {
                AdvGFxHudWrapper(PC.myHUD).ShowQTEButton(EventButton);
            }            
        }        
        ActivateOutputLink(2);
    }
    //return;    
}

event Deactivated()
{
    local AdvPlayerController PC;

    // End:0x65
    if(bShowButton)
    {
        // End:0x64
        foreach CachedPCs(PC)
        {
            AdvGFxHudWrapper(PC.myHUD).ShowQTEButton(255);            
        }        
    }
    //return;    
}

event bool Update(float DeltaTime)
{
    local AdvPlayerController PC;

    // End:0x32
    if(InputLinks[1].bHasImpulse)
    {
        ActivateOutputLink(1);
        return false;        
    }
    else
    {
        // End:0x62
        if(InputLinks[2].bHasImpulse)
        {
            ActivateOutputLink(0);
            return false;
        }
    }
    CurrentTime += DeltaTime;
    // End:0x1C7
    if(CurrentTime > NoTapIntervalTime)
    {
        // End:0x192
        foreach CachedPCs(PC)
        {
            // End:0x10B
            if(!AdvPlayerInput(PC.PlayerInput).IsButtonActive(EventButton) && bKeyTaken)
            {
                bKeyTaken = false;
            }
            // End:0x191
            if(AdvPlayerInput(PC.PlayerInput).IsButtonActive(EventButton) && !bKeyTaken)
            {
                bKeyTaken = true;
                Frequency += (DeltaTime * MultiplyFactor);
            }            
        }        
        // End:0x1C4
        if(CurrentTime > (TapIntervalTime + NoTapIntervalTime))
        {
            CurrentTime = 0.0000000;
        }        
    }
    else
    {
        Frequency -= DeltaTime;
    }
    Frequency = FClamp(Frequency, 0.0100000, 1.5000000);
    PopulateLinkedVariableValues();
    return true;
    //return ReturnValue;    
}

function AdvPlayerController FindPC(AdvPawn P)
{
    local AdvPlayerController PC;

    // End:0xA6
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0xA5
        if(PC.bIsPlayer && PC.Pawn == P)
        {            
            return PC;
        }        
    }    
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    bShowButton=true
    TapIntervalTime=0.1000000
    NoTapIntervalTime=0.2000000
    MultiplyFactor=6.0000000
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Start->Out",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Stop->Abort",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Stop->Finish",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Finish",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Abort",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Frequency",LinkVar="None",PropertyName="Frequency",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Quick Tap Event"
}