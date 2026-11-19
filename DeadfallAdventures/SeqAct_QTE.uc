class SeqAct_QTE extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var bool bResult;
var() bool ReturnFailedIfBadButton;
var() bool bShowButton;
var() EvilTypes.EGameButtons EventButton;
var() float TimeToPress;
var transient array<EvilPlayerController> CachedPCs;
var transient float ElapsedTime;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilPlayerController PC;
    local int I;

    ElapsedTime = 0.0000000;
    CachedPCs.Remove(0, CachedPCs.Length);    
    // End:0xD1
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        P = EvilPawn(ObjVar.GetObjectValue());
        // End:0xD0
        if(P != none)
        {
            PC = FindPC(P);
            // End:0xD0
            if(PC != none)
            {
                CachedPCs.AddItem(PC);                
            }
        }        
    }    
    // End:0x1AF
    foreach CachedPCs(PC)
    {
        // End:0x13C
        if(bShowButton)
        {
            AdvGFxHudWrapper(PC.myHUD).ShowQTEButton(EventButton);
        }
        I = 0;
        J0x147:

        // End:0x1AE [Loop If]
        if(I < 25)
        {
            EvilPlayerInput(PC.PlayerInput).ForceButtonRelease(byte(I), true);
            I++;
            // [Loop Continue]
            goto J0x147;
        }        
    }    
    //return;    
}

event Deactivated()
{
    local EvilPlayerController PC;

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
    local EvilPlayerController PC;
    local int I;

    ElapsedTime += DeltaTime;
    // End:0x14B
    if(ElapsedTime < TimeToPress)
    {
        // End:0x145
        foreach CachedPCs(PC)
        {
            // End:0xA7
            if(EvilPlayerInput(PC.PlayerInput).IsButtonActive(EventButton))
            {
                bResult = true;
                bAborted = false;                
                return false;
            }
            // End:0x144
            if(ReturnFailedIfBadButton)
            {
                I = 0;
                J0xBF:

                // End:0x144 [Loop If]
                if(I < 16)
                {
                    // End:0x136
                    if(EvilPlayerInput(PC.PlayerInput).IsButtonActive(byte(I)))
                    {
                        bResult = false;
                        bAborted = true;                        
                        return false;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0xBF;
                }
            }            
        }        
        return true;        
    }
    else
    {
        bResult = false;
        bAborted = true;
        return false;
    }
    //return ReturnValue;    
}

function EvilPlayerController FindPC(EvilPawn P)
{
    local EvilPlayerController PC;

    // End:0xA6
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'EvilGame.EvilPlayerController', PC)
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
    ReturnFailedIfBadButton=true
    bShowButton=true
    bAutoActivateOutputLinks=false
    OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="Result",LinkVar="None",PropertyName="bResult",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Quick Time Event"
}