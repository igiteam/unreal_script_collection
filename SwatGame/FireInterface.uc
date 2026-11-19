class FireInterface extends PlayerFocusInterface
    Config(PlayerInterface_Fire)
    native;

// The FireInterface determines the Player's Focus for what happens if (s)he
//  presses fire while holding something that isn't a FiredWeapon.

var SwatDoor LastDoorFocus;

//
// Update Sequence - See documentation above PlayerFocusInterface::PreUpdate()
//

simulated protected function bool PreUpdateHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
    local HandheldEquipment ActiveItem;
    Local SwatPlayer PlayerPawn;

    PlayerPawn = SwatPlayer(Player.Pawn);
    ActiveItem = PlayerPawn.GetActiveItem();

    if  (   
            Player.ActiveViewport != None   //player is controlling a viewport
        ||  ActiveItem == None              //no active item
        ||  !ActiveItem.IsIdle()            //active item is busy
        ||  PlayerPawn.CanBeArrestedNow()   //is affected by non-lethal
        ||  PlayerPawn.IsArrested()         //is arrested
        )
    {
        //we don't want to update, but we want to clear the HUD icon

        if( Player == Level.GetLocalPlayerController() )
            Player.GetHUDPage().Reticle.CenterPreviewImage = None;

        return false;
    }
    else
        return true;
}

simulated protected function ResetFocusHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
    //TMC Note: see comment in UseInterface::ResetFocusHook() for a tricky detail

    if( Player == Level.GetLocalPlayerController() )
        Player.GetHUDPage().Reticle.CenterPreviewImage = None;
        
    HUDPage.Feedback.FireText = "";

    Player.EquipmentSlotForQualify = SLOT_Invalid;
}

native function bool RejectFocus(
        PlayerController Player,
        Actor CandidateActor, 
        vector CandidateLocation, 
        vector CandidateNormal, 
        Material CandidateMaterial, 
        ESkeletalRegion CandidateSkeletalRegion, 
        float Distance, 
        bool Transparent);

simulated protected event PostFocusAdded(PlayerInterfaceContext inContext, Actor Target, ESkeletalRegion SkeletalRegionHit)
{
    local FireInterfaceContext Context;
    local SwatGamePlayerController Player;
    local HUDPageBase HUD;

    Context = FireInterfaceContext(inContext);
    Player = SwatGamePlayerController(Level.GetLocalPlayerController());
    HUD = Player.GetHUDPage();

    HUD.Feedback.FireText = Context.FireFeedbackText;
    HUD.Reticle.CenterPreviewImage = Context.ReticleImage;
    UpdateReticlePreviewAlpha(Player, HUD, Target, SkeletalRegionHit);

    Player.EquipmentSlotForQualify = Context.EquipmentSlotForQualify;
}

simulated protected event PostDoorRelatedFocusAdded(PlayerInterfaceDoorRelatedContext inContext, Actor Target, ESkeletalRegion SkeletalRegionHit)
{
    local FireInterfaceDoorRelatedContext Context;
    local SwatGamePlayerController Player;
    local HUDPageBase HUD;
    
    Context = FireInterfaceDoorRelatedContext(inContext);
    Player = SwatGamePlayerController(Level.GetLocalPlayerController());
    HUD = Player.GetHUDPage();
    
    HUD.Feedback.FireText = Context.FireFeedbackText;
    HUD.Reticle.CenterPreviewImage = Context.ReticleImage;
    UpdateReticlePreviewAlpha(Player, HUD, Target, SkeletalRegionHit);

    Player.EquipmentSlotForQualify = Context.EquipmentSlotForQualify;

    //handle any side effect
    switch (Context.SideEffect)
    {
        case '':
            break;  //no side effect

        default:
            assertWithDescription(false,
                "[tcohen] The FireInterfaceDoorRelatedContext named "$Context.name
                $" specifies the SideEffect '"$Context.SideEffect
                $"', but that SideEffect is not recognized.");
            break;
    }
}

//
// (End of Update Sequence)
//

function UpdateReticlePreviewAlpha(
        SwatGamePlayerController Player, 
        HUDPageBase HUD, 
        Actor Target, 
        ESkeletalRegion SkeletalRegion)
{
    local SwatDoor Door;
    local vector BoxCenter;
    local vector CameraToBoxCenter;
    local float DirectPct;
    local float DirectAlpha;
    local float Alpha;

    Door = SwatDoor(Target);
    if (Door == None)
    {
        HUD.Reticle.CenterPreviewAlpha = 255;
        return;
    }

    //we want to fade-in the reticle preview image as the player points closer to the center of the skeletal region.
    //to do this, we'll look at the dot of two vectors:
    //  1) the vector from the camera to the center of the box,
    //  2) the forward vector.

    BoxCenter = Door.GetSkeletalRegionCenter(SkeletalRegion);
    CameraToBoxCenter = Normal(BoxCenter - Player.FocusTraceOrigin);

    DirectPct = CameraToBoxCenter Dot Normal(Player.FocusTraceVector);
    DirectAlpha = (1.0 - DirectPct) * 10000.0;
    Alpha = 255.0 - DirectAlpha;

    HUD.Reticle.CenterPreviewAlpha = byte(Alpha);
}


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)






// Decompiled with UE Explorer.
defaultproperties
{
    Range=128.0000000
    DoorRelatedContext[0]="DoorWay"
    DoorRelatedContext[1]="DoorModel"
    DoorRelatedContext[2]="ToolkitOnDoor"
    DoorRelatedContext[3]="C2ChargeOnDoor"
    DoorRelatedContext[4]="BreachingShotgunOnDoor"
    DoorRelatedContext[5]="WedgeOnDoor"
    DoorRelatedContext[6]="OptiwandOnDoor"
    DoorRelatedContext[7]="DoorAnimation"
    DoorRelatedContextClass=Class'FireInterfaceDoorRelatedContext'
    Context[0]="Glass"
    Context[1]="ToolkitOnWedge"
    Context[2]="ToolkitOnC2Charge"
    Context[3]="ToolkitOnBomb"
    Context[4]="CuffsOnSuspect"
    Context[5]="CuffsOnCivilian"
    Context[6]="CuffsOnVIP"
    Context[7]="CuffsOnPlayer"
    Context[8]="ToolkitOnArrestedVIP"
    Context[9]="DoorBufferVolume"
    Context[10]="GenericObject"
    ContextClass=Class'FireInterfaceContext'
}