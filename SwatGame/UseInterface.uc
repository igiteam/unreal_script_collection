class UseInterface extends PlayerFocusInterface
    Config(PlayerInterface_Use)
    native;

var string UseFeedbackText;        //feedback for use interface
var string OtherFeedbackText;   //other feedback to display in the HUD feedback
var HUDPageBase CachedHUDPage;

var bool LookingThruGlass;

//
// Update Sequence - See documentation above PlayerFocusInterface::PreUpdate()
//

simulated protected function bool PreUpdateHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
    //we don't update the UseInterface while the player is controlling a viewport (including the Optiwand)
    return (Player.ActiveViewport == None);
}

simulated protected function ResetFocusHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
    //reset feedback text and update the HUD's Feedback's cache variables
    //
    //TMC Note: there was a tricky bug here.
    //  There are two conflicting goals:
    //  1) Don't do a lot of text processing and GUI interaction unless something has changed.
    //  2) When we lose focus (Use or Fire), update the HUD's Feedback box so it goes away.
    //  The trick is that if the player is looking at something which can be used, and then
    //      looks away quickly, there may not be an update that hits something that _can't_ be used.
    //  So the correct flow looks like this:
    //  - Reset focus of UseInterface [UseInterface::ResetFocusHook()]
    //  - Reset HUD's Feedback's cached feedback variables [UseInterface::PostUpdate()]
    //  - Consider any new focus (there may be none), and potentially update object variables [UseInterface::ConsiderNewFocus()]
    //  - Update the HUD's Feedback's cached feedback variables again [UseInterface::PostUpdate()]
    //  - Update HUD's Feedback's Caption from cached feedback variables [GUIFeedback::UpdateCaption()]

    UseFeedbackText = "";
    OtherFeedbackText = "";
    CachedHUDPage = HUDPage;

    LookingThruGlass = false;

    PostUpdate();
}

simulated protected event PostContextMatched(PlayerInterfaceContext Context, Actor Target)
{
    local string localUseFeedbackText, localOtherFeedbackText;

    if (UseInterfaceContext(Context).IsGlass)
        LookingThruGlass = true;

    localUseFeedbackText = UseInterfaceContext(Context).UseFeedbackText;
    localOtherFeedbackText = UseInterfaceContext(Context).OtherFeedbackText;

    if (localUseFeedbackText != "")
        UseFeedbackText = localUseFeedbackText;
    if (localOtherFeedbackText != "")
        OtherFeedbackText = localOtherFeedbackText;
}

simulated protected event PostDoorRelatedFocusAdded(PlayerInterfaceDoorRelatedContext inContext, Actor Target, ESkeletalRegion SkeletalRegionHit)
{
    local UseInterfaceDoorRelatedContext Context;
    
    Context = UseInterfaceDoorRelatedContext(inContext);
    
    UseFeedbackText = Context.UseFeedbackText;
    OtherFeedbackText = Context.OtherFeedbackText;
}

simulated function PostUpdate()
{
    local GUIFeedback Feedback;

    Feedback = CachedHUDPage.Feedback;

    //in ConsiderNewFocus(), we already computed the feedback text to display on the HUD
    Feedback.UseText = UseFeedbackText;
    Feedback.OtherText = OtherFeedbackText;
}

//
// (End of Update Sequence)
//

simulated function Interact()
{
    local ICanBeUsed Target;
    local SwatGamePlayerController PC;

    mplog( "---UseInterface::Interact()." );

    if (FociLength > 0)
    {
        Target = ICanBeUsed(Foci[0].Actor);

        mplog( "...Target="$Target );

        //there are occasions that a Focus of the UseInterface is not an ICanBeUsed,
        //  for example, another player in MP is a UseInterface Focus (so that we can
        //  report, "Equip Zipcuffs to Restrain"), but it can not be used.
        if (Target == None)
            return;         //nothing to use

        PC = SwatGamePlayerController(Level.GetLocalPlayerController());
        if (Target.CanBeUsedNow())
        {
            mplog( "...UniqueID="$Target.UniqueID() );
            PC.ServerRequestInteract( Target, Target.UniqueID() );
        }
    }
//  else
//      TMC TODO need feedback "nothing to use here"
        
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)






// Decompiled with UE Explorer.
defaultproperties
{
    Range=2000.0000000
    DoorRelatedContext[0]="DoorWay"
    DoorRelatedContext[1]="SwatDoor"
    DoorRelatedContext[2]="DoorModelThruGlass"
    DoorRelatedContext[3]="LockedWedgedDoor"
    DoorRelatedContext[4]="LockedDoor"
    DoorRelatedContext[5]="WedgedDoor"
    DoorRelatedContext[6]="ClosedDoor"
    DoorRelatedContext[7]="BrokenDoor"
    DoorRelatedContext[8]="OpenDoor"
    DoorRelatedContext[9]="DistantDoor"
    DoorRelatedContextClass=Class'UseInterfaceDoorRelatedContext'
    Context[0]="Glass"
    Context[1]="Evidence"
    Context[2]="TrainingButton"
    Context[3]="MissionExitDoor"
    Context[4]="IncapacitatedOfficer"
    Context[5]="IncapacitatedPlayer"
    Context[6]="DeadEnemy"
    Context[7]="IncapacitatedEnemy"
    Context[8]="RestrainedEnemy"
    Context[9]="ArrestableAI"
    Context[10]="ArrestablePlayer"
    Context[11]="DOA"
    Context[12]="DeadHostage"
    Context[13]="IncapacitatedHostage"
    Context[14]="RestrainedHostage"
    Context[15]="Pickup"
    Context[16]="ICanBeUsed"
    Context[17]="DoorBufferVolume"
    Context[18]="CatchAll"
    ContextClass=Class'UseInterfaceContext'
}