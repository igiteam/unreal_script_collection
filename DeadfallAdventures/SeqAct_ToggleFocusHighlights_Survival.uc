class SeqAct_ToggleFocusHighlights_Survival extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local WorldInfo WI;
    local AdvGRI_MP GRIMP;

    super(SequenceOp).Activated();
    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x165
    if(int(WI.NetMode) != int(NM_Client))
    {
        GRIMP = AdvGRI_MP(WI.GRI);
        // End:0x9E
        if(GRIMP == none)
        {
            return;
        }
        // End:0x103
        if(InputLinks[0].bHasImpulse)
        {
            GRIMP.bFocusHighlightsEnabled = true;
            GRIMP.UpdateFocusHighlightsEnabled();            
        }
        else
        {
            // End:0x165
            if(InputLinks[1].bHasImpulse)
            {
                GRIMP.bFocusHighlightsEnabled = false;
                GRIMP.UpdateFocusHighlightsEnabled();
            }
        }
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Toggle Focus Highlights - Survival"
}