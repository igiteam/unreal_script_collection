class SeqAct_ToggleRadarObjectAbstract extends SequenceAction
    abstract
    native;

/** MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS CPP TEXT      NATIVE FUNCTION DECLARATIONS */
var() float VerticalOffset;
var() bool bAccountForObjectBounds;

function float GetVerticalOffset(Actor theObject)
{
    local float theVerticalOffset, Radius, Height;

    theVerticalOffset = VerticalOffset;
    // End:0x3E
    if(bAccountForObjectBounds)
    {
        theObject.GetBoundingCylinder(Radius, Height);
        theVerticalOffset += Height;
    }
    return theVerticalOffset;
    //return ReturnValue;    
}

event AddRadarObject(Actor theObject)
{
    local PandoraPlayerController PC;
    local float theVerticalOffset;

    theVerticalOffset = GetVerticalOffset(theObject);
    // End:0x4D
    foreach GetWorldInfo().LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {
        InternalAddRadarObject(PC, theObject, theVerticalOffset);        
    }    
    //return;    
}

event RemoveRadarObject(Actor theObject)
{
    local PandoraPlayerController PC;

    // End:0x33
    foreach GetWorldInfo().LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {
        InternalRemoveRadarObject(PC, theObject);        
    }    
    //return;    
}

event ToggleRadarObject(Actor theObject)
{
    local PandoraPlayerController PC;
    local SPHud theHud;
    local float theVerticalOffset;

    theVerticalOffset = GetVerticalOffset(theObject);
    // End:0xED
    foreach GetWorldInfo().LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {
        theHud = SPHud(PC.myHUD);
        // End:0xEC
        if(theHud != none)
        {
            // End:0x81
            if(theHud.RTM == none)
            {
                theHud.InitTargetManager();
            }
            // End:0xEC
            if(theHud.RTM != none)
            {
                // End:0xD3
                if(theHud.RTM.IsTarget(theObject))
                {
                    InternalRemoveRadarObject(PC, theObject);
                    // End:0xEC
                    continue;
                }
                InternalAddRadarObject(PC, theObject, theVerticalOffset);
            }
        }        
    }    
    //return;    
}

function bool InternalAddRadarObject(PandoraPlayerController PC, Actor theObject, float Offset)
{
    local SPGameDifficultyTuneGamePlay gdData;
    local SPHud theHud;

    gdData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    theHud = SPHud(PC.myHUD);
    // End:0x111
    if(theHud != none)
    {
        // End:0x6E
        if(theHud.RTM == none)
        {
            theHud.InitTargetManager();
        }
        // End:0x111
        if(theHud.RTM != none)
        {
            // End:0x111
            if(!theHud.RTM.IsTarget(theObject))
            {
                theHud.RTM.AddTarget(theObject, Offset, gdData.SinglePlayerRadarImage, gdData.SinglePlayerRadarColor, gdData.SinglePlayerRadarFontSize, gdData.SinglePlayerRadarTextColor);
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function InternalRemoveRadarObject(PandoraPlayerController PC, Actor theObject)
{
    local SPHud theHud;

    // End:0x91
    if(PC != none)
    {
        theHud = SPHud(PC.myHUD);
        // End:0x91
        if(theHud != none)
        {
            // End:0x59
            if(theHud.RTM == none)
            {
                theHud.InitTargetManager();
            }
            // End:0x91
            if(theHud.RTM != none)
            {
                theHud.RTM.RemoveTarget(theObject);
            }
        }
    }
    //return;    
}
