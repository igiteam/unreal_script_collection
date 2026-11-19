class UTSeqAct_ToggleAnnouncements extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local UTGameReplicationInfo GRI;

    GRI = UTGameReplicationInfo(GetWorldInfo().GRI);
    // End:0xCA
    if(GRI != none)
    {
        // End:0x87
        if(InputLinks[0].bHasImpulse)
        {
            GRI.bAnnouncementsDisabled = false;            
        }
        else
        {
            // End:0xCA
            if(InputLinks[1].bHasImpulse)
            {
                GRI.bAnnouncementsDisabled = true;
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
    VariableLinks=none
    ObjName="Toggle Announcements"
}