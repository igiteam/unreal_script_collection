class SkyInteractionButtonMashRequest extends SkyInteractionInputRequest
    native
    editinlinenew;

var(Input) array<name> ButtonVariants;
var(Input) array<name> KeyboardVariants;
var transient int CurrentVariantIdx;
var(Input) float RequestDelay;
var const name InstigatorStartTimer;
var const name TargetStartTimer;
var transient float InstigatorMashMeter;
var transient float TargetMashMeter;
var() float PressValue;
var() float UpdateFrequency;
var const name UpdateTimer;
var() float DecayRate;
var const float DISABLED_MASH_METER;
var const float EMPTY_MASH_METER;
var const float FULL_MASH_METER;
var transient bool bDisplayInstigatorUI;
var transient bool bDisplayTargetUI;
var deprecated array<ButtonToSceneMap> ButtonScenes;
var transient SkyHUD hudRef;

// Export USkyInteractionButtonMashRequest::execScoreCanBeTallied(FFrame&, void* const)
native function bool ScoreCanBeTallied();

// Export USkyInteractionButtonMashRequest::execDidInstigatorSucceed(FFrame&, void* const)
native function bool DidInstigatorSucceed();

// Export USkyInteractionButtonMashRequest::execRequestInstigatorInput(FFrame&, void* const)
native function RequestInstigatorInput();

// Export USkyInteractionButtonMashRequest::execRequestTargetInput(FFrame&, void* const)
native function RequestTargetInput();

// Export USkyInteractionButtonMashRequest::execUpdate(FFrame&, void* const)
native function Update();

function DrawInteractionInputRequest(HUD Display, bool bInstigator)
{
    local int PrevX, PrevY;
    local float BarWidth, barHeight;
    local SkyPlayerController SPC;

    SPC = SkyPlayerController(Display.PlayerOwner);
    hudRef = SkyHUD(Display);
    // End:0x37
    if(hudRef == none)
    {
        return;
    }
    // End:0x2E4
    if(((bInstigator && bDisplayInstigatorUI) || !bInstigator && bDisplayTargetUI) || (SPC.bIsInMatinee == true) && bDisplayInstigatorUI)
    {
        // End:0x2AF
        if(Display.bShowDebugInfo && Display.ShouldDisplayDebug('InputRequests'))
        {
            PrevX = int(Display.Canvas.CurX);
            PrevY = int(Display.Canvas.CurY);
            BarWidth = 200.0000000;
            barHeight = 40.0000000;
            Display.Canvas.SetDrawColor(255, 255, 0);
            Display.Canvas.SetPos(Display.CenterX - (BarWidth / 2.0000000), Display.CenterY - barHeight);
            Display.Canvas.DrawBox(BarWidth, barHeight);
            Display.Canvas.DrawRect(BarWidth * (float(Max(int(EMPTY_MASH_METER), int(InstigatorMashMeter))) / 100.0000000), barHeight);
            Display.Canvas.SetPos(Display.CenterX - float(100), Display.CenterY);
            Display.Canvas.DrawBox(BarWidth, barHeight);
            Display.Canvas.DrawRect(BarWidth * (float(Max(int(EMPTY_MASH_METER), int(TargetMashMeter))) / 100.0000000), barHeight);
            Display.Canvas.SetPos(float(PrevX), float(PrevY));
        }
        hudRef.SetInteraction(GetHUDInteractionName(!hudRef.bControllerConnected));        
    }
    else
    {
        // End:0x333
        if((bInstigator && !bDisplayInstigatorUI) || !bInstigator && !bDisplayTargetUI)
        {
            hudRef.SetInteraction('None');
        }
    }
    //return;    
}

function name GetHUDInteractionName(optional bool bKeyboard)
{
    // End:0x26
    if(bKeyboard)
    {
        return name(string(KeyboardVariants[CurrentVariantIdx]) $ "_mash");        
    }
    else
    {
        return name(string(ButtonVariants[CurrentVariantIdx]) $ "_mash");
    }
    //return ReturnValue;    
}

event ProvideFeedback(bool bInstigator, bool bSuccess)
{
    // End:0x14
    if(bInstigator)
    {
        bDisplayInstigatorUI = false;        
    }
    else
    {
        bDisplayTargetUI = false;
    }
    //return;    
}
