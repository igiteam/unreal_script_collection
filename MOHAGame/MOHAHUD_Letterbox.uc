class MOHAHUD_Letterbox extends MOHAHUDObj
    native;

var Color letterBoxColor;
var WorldInfo WorldInfo;
var float barScreenHeightPercentage;
var float barHeight;
var float barAnimatePercent;
var float barAnimateTime;
var float currentBarAnimateTime;
var bool bActive;
var bool bAnimatingIn;
var bool bAnimatingOut;
var float lastWorldTimeSeconds;
var SeqAct_ToggleLetterbox inAction;
var SeqAct_ToggleLetterbox OutAction;

// Export UMOHAHUD_Letterbox::execDrawLetterbox(FFrame&, void* const)
native function DrawLetterbox(Canvas thisCanvas);

function ActivateLetterbox(bool bAnimate)
{
    // End:0x24
    if(bAnimate)
    {
        currentBarAnimateTime = 0.0000000;
        bAnimatingIn = true;
        bAnimatingOut = false;
    }
    bActive = true;
    //return;    
}

function DeactivateLetterbox(bool bAnimate)
{
    // End:0x2F
    if(bAnimate)
    {
        currentBarAnimateTime = 0.0000000;
        bAnimatingIn = false;
        bAnimatingOut = true;
        bActive = true;        
    }
    else
    {
        bAnimatingOut = false;
        bAnimatingIn = false;
        bActive = false;
    }
    //return;    
}

function SetNewClosingParams(SeqAct_ToggleLetterbox Action)
{
    OutAction = Action;
    currentBarAnimateTime = 0.0000000;
    barAnimatePercent = 0.0000000;
    // End:0x50
    if(Action.secondsToAnimate > 0.0000000)
    {
        barAnimateTime = Action.secondsToAnimate;        
    }
    else
    {
        barAnimateTime = 2.6400000;
    }
    //return;    
}

function SetNewOpeningParams(SeqAct_ToggleLetterbox Action)
{
    inAction = Action;
    currentBarAnimateTime = 0.0000000;
    barAnimatePercent = 0.0000000;
    // End:0x6A
    if((Action.barScreenPercentHeight > 0.0000000) && Action.barScreenPercentHeight < 0.5000000)
    {
        barScreenHeightPercentage = Action.barScreenPercentHeight;        
    }
    else
    {
        barScreenHeightPercentage = 0.0500000;
    }
    // End:0xA4
    if(Action.secondsToAnimate > 0.0000000)
    {
        barAnimateTime = Action.secondsToAnimate;        
    }
    else
    {
        barAnimateTime = 2.6400000;
    }
    //return;    
}

function float UpdateCurrentAnimTime()
{
    local float DeltaTime, retAnimTime;

    // End:0x31
    if(lastWorldTimeSeconds < 0.0000000)
    {
        lastWorldTimeSeconds = WorldInfo.TimeSeconds;
        DeltaTime = 0.0000000;        
    }
    else
    {
        DeltaTime = WorldInfo.TimeSeconds - lastWorldTimeSeconds;
        lastWorldTimeSeconds = WorldInfo.TimeSeconds;
    }
    retAnimTime = currentBarAnimateTime + DeltaTime;
    return retAnimTime;
    //return ReturnValue;    
}

function UpdateAnimationIn()
{
    currentBarAnimateTime = UpdateCurrentAnimTime();
    // End:0x69
    if(currentBarAnimateTime > barAnimateTime)
    {
        currentBarAnimateTime = 0.0000000;
        barAnimatePercent = 1.0000000;
        bAnimatingIn = false;
        lastWorldTimeSeconds = -1.0000000;
        // End:0x66
        if(inAction != none)
        {
            inAction.NotifyFinished();
        }        
    }
    else
    {
        barAnimatePercent = currentBarAnimateTime / barAnimateTime;
    }
    //return;    
}

function UpdateAnimationOut()
{
    currentBarAnimateTime = UpdateCurrentAnimTime();
    // End:0x71
    if(currentBarAnimateTime > barAnimateTime)
    {
        currentBarAnimateTime = 0.0000000;
        barAnimatePercent = 0.0000000;
        lastWorldTimeSeconds = -1.0000000;
        bAnimatingOut = false;
        bActive = false;
        // End:0x6E
        if(OutAction != none)
        {
            OutAction.NotifyFinished();
        }        
    }
    else
    {
        barAnimatePercent = 1.0000000 - (currentBarAnimateTime / barAnimateTime);
    }
    //return;    
}

function bool Render(Canvas Canvas)
{
    // End:0xAE
    if(bActive == true)
    {
        // End:0x2C
        if(WorldInfo == none)
        {
            WorldInfo = Class'Engine.Engine'.static.GetCurrentWorldInfo();
        }
        // End:0x52
        if(!bAnimatingIn && !bAnimatingOut)
        {
            barAnimatePercent = 1.0000000;            
        }
        else
        {
            // End:0x68
            if(bAnimatingIn)
            {
                UpdateAnimationIn();                
            }
            else
            {
                // End:0x7B
                if(bAnimatingOut)
                {
                    UpdateAnimationOut();
                }
            }
        }
        barHeight = (barScreenHeightPercentage * float(Canvas.SizeY)) * barAnimatePercent;
        DrawLetterbox(Canvas);
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    letterBoxColor=(R=0,G=0,B=0,A=255)
    barScreenHeightPercentage=0.0500000
    barAnimateTime=2.6400000
    lastWorldTimeSeconds=-1.0000000
    bRenderAlways=true
}