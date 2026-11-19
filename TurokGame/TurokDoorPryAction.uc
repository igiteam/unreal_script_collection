class TurokDoorPryAction extends TurokContextAction
    native
    nativereplication
    notplaceable
    hidecategories(Navigation);

var @NULL mController;
var @NULL mPawn;
var @NULL mDoorActor;

replication
{
    // Pos:0x000
    if(bNetInitial
        mDoorActor, mPawn;
}

// Export UTurokDoorPryAction::execIsRequirementsMet(FFrame&, void* const)
native simulated function bool IsRequirementsMet();

// Export UTurokDoorPryAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

// Export UTurokDoorPryAction::execDrawActivationMessage(FFrame&, void* const)
native simulated function DrawActivationMessage(@NULL HUD);

// Export UTurokDoorPryAction::execIsFinished(FFrame&, void* const)
native simulated function bool IsFinished();

// Export UTurokDoorPryAction::execOnStart(FFrame&, void* const)
native simulated function OnStart();

// Export UTurokDoorPryAction::execOnUpdate(FFrame&, void* const)
native simulated function OnUpdate(float DeltaTime);

// Export UTurokDoorPryAction::execOnCancel(FFrame&, void* const)
native simulated function OnCancel();

// Export UTurokDoorPryAction::execOnInterrupt(FFrame&, void* const)
native simulated function OnInterrupt();

// Export UTurokDoorPryAction::execOnEnd(FFrame&, void* const)
native simulated function OnEnd();

// Export UTurokDoorPryAction::execGetProgressPercent(FFrame&, void* const)
native simulated function float GetProgressPercent();

// Export UTurokDoorPryAction::execIsInProgress(FFrame&, void* const)
native simulated function bool IsInProgress();

simulated function EndPrematurely()
{
    // End:0x1E
    if(mDoorActor != none)
    {
        mDoorActor.CancelPryPrematurely();
    }
    //return;    
}

simulated event @NULL GetDoorActionVolume()
{
    return TurokDoorActionVolume(mVolume);
    //return ReturnValue;    
}

simulated event bool IsDoorPryInState(name stateName)
{
    // End:0x1E
    if(mDoorActor != none)
    {
        return mDoorActor.IsInState(stateName);
    }
    return false;
    //return ReturnValue;    
}

simulated event @NULL GetTransitionGraphSet()
{
    // End:0x2D
    if(mDoorActor != none)
    {
        return mDoorActor.GetPryGraphSet(mController.Pawn);
    }
    return none;
    //return ReturnValue;    
}

simulated event DrawStateDebug(@NULL HUD)
{
    HUD.Canvas.__NFUN_465__(" STATE - Unknown", false);
    //return;    
}

simulated event OnButtonPress()
{
    ServerOnButtonPress();
    // End:0x2E
    if(int(Role) != int(ROLE_Authority))
    {
        mDoorActor.OnButtonPress(self);
    }
    // End:0xB1
    if(((mDoorActor != none) && mDoorActor.GetStateName() == 'PryDoorPry') && int(mPawn.mPlayingSpeechType) == int(0))
    {
        mPawn.mSoundController.TryPlayLimitedSound('PryExert', mPawn.mExertionSndCue, mPawn.Location, true);
    }
    mbHudFlashThisFrame = true;
    //return;    
}

reliable server event ServerOnButtonPress()
{
    // End:0x1F
    if(mDoorActor != none)
    {
        mDoorActor.OnButtonPress(self);
    }
    //return;    
}

simulated event OnScriptUpdate(float DeltaTime)
{
    //return;    
}

simulated function SetScrubPercent(float animScrubPercent)
{
    mPawn.mAnimScrubPercent = animScrubPercent;
    //return;    
}

function NotifyGraphStart(@NULL graph, byte actorType)
{
    // End:0x34
    if(mDoorActor != none)
    {
        mDoorActor.GetAnimController().PlayTransitionGraph(graph, mDoorActor, 3);
    }
    //return;    
}

function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    // End:0x2D
    if(mDoorActor != none)
    {
        mDoorActor.NotifyGraphEndToGraph(prevGraph, newGraph, actorType);
    }
    //return;    
}

function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    // End:0x2D
    if(mDoorActor != none)
    {
        mDoorActor.NotifyGraphEndToLoco(graph, locoAsset, actorType);
    }
    //return;    
}

simulated function PlayTransitionGraph(name graphName)
{
    local @NULL deltaPos, FacingDir, actionRot, graphSet, graph;

    // End:0x12
    if(int(Role) != int(ROLE_Authority))
    {
        return;
    }
    // End:0x1F
    if(mDoorActor == none)
    {
        return;
    }
    graphSet = GetTransitionGraphSet();
    // End:0x3C
    if(graphSet == none)
    {
        return;
    }
    graph = graphSet.FindGraph(graphName);
    // End:0x67
    if(graph == none)
    {
        return;
    }
    // End:0xC1
    if(mPawn.GetRightHandWeapon().GetAttachment() != none)
    {
        mPawn.GetRightHandWeapon().GetAttachment().StopAmbience();        
    }
    else
    {
        // End:0x10A
        if(mPawn.GetLeftHandWeapon() != none)
        {
            mPawn.GetLeftHandWeapon().GetAttachment().StopAmbience();
        }
    }
    // End:0x14D
    if(mDoorActor != none)
    {
        deltaPos = mDoorActor.Location - mPawn.Location;
        actionRot = mDoorActor.Rotation;
    }
    actionRot.Yaw += int(90.0000000 * (65535.0000000 / 360.0000000));
    FacingDir = Vector(actionRot);
    actionRot = mDoorActor.Rotation;
    // End:0x1CE
    if((deltaPos Dot FacingDir) >= float(0))
    {
        actionRot.Yaw += int(180.0000000 * (65535.0000000 / 360.0000000));
    }
    SetScrubPercent(0.0000000);
    mPawn.SetActionLocation(mDoorActor.Location, actionRot);
    mPawn.PlayGraphReplicated(graph, Owner, 0);
    //return;    
}

simulated function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    // End:0x41
    if((IsDoorPryInState('PryDoorPry')) && mDoorActor != none)
    {
        mDoorActor.mDesiredPercent -= (float(Damage) * 0.0100000);
    }
    //return;    
}

defaultproperties
{
    mActivationMessageHash=-29528132
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
    mButtonImageFrames=1.0000000
    mButtonAnimLength=0.0500000
    mArrowImage=Texture2D'TurokControllerButtons.ArrowDown'
    mButtonDownImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B_White'
    mButtonDownImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_1_HD'
    bAlwaysRelevant=true
}