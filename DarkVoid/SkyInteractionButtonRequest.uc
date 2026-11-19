class SkyInteractionButtonRequest extends SkyInteractionInputRequest
    native
    editinlinenew;

struct native ButtonToSceneMap
{
    var name ButtonName;
    var UIScene SceneReference;
    var bool bSceneVisible;

    structdefaultproperties
    {
        ButtonName="None"
        SceneReference=none
        bSceneVisible=false
    }
};

var transient float InstigatorStartTimeSeconds;
var transient float TargetStartTimeSeconds;
var name InstigatorStartTimer;
var name InstigatorStopTimer;
var name TargetStartTimer;
var name TargetStopTimer;
var transient float InstigatorPressTime;
var transient float TargetPressTime;
var() float RequestDelay;
var() float RequestTimeout;
var() array<name> ButtonVariants;
var() array<name> KeyboardVariants;
var() SoundCue SoundOfSuccess;
var() SoundCue SoundOfFailure;
var transient int CurrentVariantIdx;
var float BadPressTime;
var transient bool bDisplayInstigatorUI;
var transient bool bDisplayTargetUI;
var deprecated array<ButtonToSceneMap> ButtonScenes;
var transient SkyHUD hudRef;

// Export USkyInteractionButtonRequest::execScoreCanBeTallied(FFrame&, void* const)
native function bool ScoreCanBeTallied();

// Export USkyInteractionButtonRequest::execDidInstigatorSucceed(FFrame&, void* const)
native function bool DidInstigatorSucceed();

function RequestInstigatorInput()
{
    local Pawn Instigator;

    Instigator = ((Owner.bInstigatedInteraction) ? Pawn(Owner) : Pawn(Owner.GetInteractionPartner()));
    // End:0xA8
    if((Instigator != none) && Instigator.IsHumanControlled())
    {
        bDisplayInstigatorUI = true;
        InstigatorStartTimeSeconds = Owner.WorldInfo.TimeSeconds;
        Owner.SetTimer(FMax(0.0001000, RequestTimeout), false, InstigatorStopTimer, self);        
    }
    else
    {
        InstigatorPressTime = InstigatorStartTimeSeconds + RequestTimeout;
    }
    //return;    
}

event InstigatorInputTimedOut()
{
    local Pawn Instigator;

    // End:0x7F
    if(InstigatorPressTime < 0.0000000)
    {
        Instigator = ((Owner.bInstigatedInteraction) ? Pawn(Owner) : Pawn(Owner.GetInteractionPartner()));
        // End:0x7F
        if((Instigator != none) && Instigator.IsHumanControlled())
        {
            InstigatorPressTime = InstigatorStartTimeSeconds + BadPressTime;
        }
    }
    bDisplayInstigatorUI = false;
    // End:0xB1
    if(hudRef != none)
    {
        hudRef.SetInteraction('None');
    }
    //return;    
}

function RequestTargetInput()
{
    local Pawn Target;

    Target = ((!Owner.bInstigatedInteraction) ? Pawn(Owner) : Pawn(Owner.GetInteractionPartner()));
    // End:0xAA
    if((Target != none) && Target.IsHumanControlled())
    {
        bDisplayTargetUI = true;
        TargetStartTimeSeconds = Owner.WorldInfo.TimeSeconds;
        Owner.SetTimer(FMax(0.0001000, RequestTimeout), false, TargetStopTimer, self);        
    }
    else
    {
        TargetPressTime = TargetStartTimeSeconds + RequestTimeout;
    }
    //return;    
}

event TargetInputTimedOut()
{
    local Pawn Target;

    // End:0x81
    if(TargetPressTime < 0.0000000)
    {
        Target = ((!Owner.bInstigatedInteraction) ? Pawn(Owner) : Pawn(Owner.GetInteractionPartner()));
        // End:0x81
        if((Target != none) && Target.IsHumanControlled())
        {
            TargetPressTime = TargetStartTimeSeconds + BadPressTime;
        }
    }
    bDisplayTargetUI = false;
    // End:0xB3
    if(hudRef != none)
    {
        hudRef.SetInteraction('None');
    }
    //return;    
}

function DrawInteractionInputRequest(HUD Display, bool bInstigator)
{
    local SkyPlayerController SPC;

    SPC = SkyPlayerController(Display.PlayerOwner);
    hudRef = SkyHUD(Display);
    // End:0x37
    if(hudRef == none)
    {
        return;
    }
    // End:0xF1
    if(((bInstigator && bDisplayInstigatorUI) || !bInstigator && bDisplayTargetUI) || (SPC.bIsInMatinee == true) && bDisplayInstigatorUI)
    {
        // End:0xBD
        if(hudRef.bControllerConnected)
        {
            hudRef.SetInteraction(ButtonVariants[CurrentVariantIdx]);            
        }
        else
        {
            // End:0xEE
            if(CurrentVariantIdx < KeyboardVariants.Length)
            {
                hudRef.SetInteraction(KeyboardVariants[CurrentVariantIdx]);
            }
        }        
    }
    else
    {
        // End:0x140
        if((bInstigator && !bDisplayInstigatorUI) || !bInstigator && !bDisplayTargetUI)
        {
            hudRef.SetInteraction('None');
        }
    }
    //return;    
}

event ProvideFeedback(bool bInstigator, bool bSuccess)
{
    local Pawn P;
    local PlayerController PC;

    // End:0x14
    if(bInstigator)
    {
        bDisplayInstigatorUI = false;        
    }
    else
    {
        bDisplayTargetUI = false;
    }
    P = Pawn(Owner);
    // End:0xDD
    if((P != none) && P.Controller != none)
    {
        PC = PlayerController(P.Controller);
        // End:0xDD
        if(PC != none)
        {
            // End:0xAE
            if(bSuccess)
            {
                PC.ClientHearSound(SoundOfSuccess, PC, PC.Location, true, false);                
            }
            else
            {
                PC.ClientHearSound(SoundOfFailure, PC, PC.Location, true, false);
            }
        }
    }
    //return;    
}
