class TurokContextAction extends Actor
    abstract
    native
    nativereplication
    notplaceable
    hidecategories(Navigation);

var protected int mActivationMessageHash;
var protected int mActivationMessageHash2;
var protected const @NULL mButtonImagePS3;
var protected const @NULL mButtonImageXBox360;
var protected const @NULL mPcKeyImage;
var protected const @NULL mPcMouseImage;
var protected const @NULL mDrawFont;
var protected const float mButtonImageFrames;
var protected const bool mButtonAnimReverse;
var protected bool mbHudFlashThisFrame;
var bool mIsEnabled;
var protected const float mButtonAnimTime;
var protected const float mButtonAnimLength;
var protected const float mTextScale;
var protected const @NULL mArrowImage;
var protected const @NULL mButtonDownImageXBox360;
var protected const @NULL mButtonDownImagePS3;
var @NULL mVolume;

replication
{
    // Pos:0x000
    if(bNetOwner && bNetDirty
        mIsEnabled, mVolume;
}

event BeginAction()
{
    // End:0x13
    if(mIsEnabled)
    {
        OnStart();
    }
    //return;    
}

event UpdateAction(float DeltaTime)
{
    OnUpdate(DeltaTime);
    // End:0x30
    if(IsFinished())
    {
        OnComplete();
        OnEnd();
    }
    //return;    
}

event StopAction(bool isInterrupted)
{
    // End:0x16
    if(isInterrupted)
    {
        OnInterrupt();        
    }
    else
    {
        OnCancel();
    }
    OnEnd();
    //return;    
}

simulated function EndPrematurely()
{
    OnInterrupt();
    //return;    
}

// Export UTurokContextAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokContextAction::execIsFinished(FFrame&, void* const)
native function bool IsFinished();

// Export UTurokContextAction::execGetButtonTexture(FFrame&, void* const)
native function @NULL GetButtonTexture();

// Export UTurokContextAction::execGetButtonDownTexture(FFrame&, void* const)
native function @NULL GetButtonDownTexture();

event @NULL GetTransitionGraphSet()
{
    return none;
    //return ReturnValue;    
}

function NotifyGraphStart(@NULL graph, byte actorType)
{
    //return;    
}

function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    //return;    
}

function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    //return;    
}

// Export UTurokContextAction::execOnStart(FFrame&, void* const)
native function OnStart();

// Export UTurokContextAction::execOnUpdate(FFrame&, void* const)
native function OnUpdate(float DeltaTime);

// Export UTurokContextAction::execOnComplete(FFrame&, void* const)
native function OnComplete();

// Export UTurokContextAction::execOnCancel(FFrame&, void* const)
native function OnCancel();

// Export UTurokContextAction::execOnInterrupt(FFrame&, void* const)
native function OnInterrupt();

// Export UTurokContextAction::execOnEnd(FFrame&, void* const)
native function OnEnd();

// Export UTurokContextAction::execGetProgressPercent(FFrame&, void* const)
native simulated function float GetProgressPercent();

// Export UTurokContextAction::execIsInProgress(FFrame&, void* const)
native simulated function bool IsInProgress();

// Export UTurokContextAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

// Export UTurokContextAction::execDrawActivationMessage(FFrame&, void* const)
native simulated function DrawActivationMessage(@NULL HUD);

// Export UTurokContextAction::execDrawHoldButtonMessage(FFrame&, void* const)
native simulated function DrawHoldButtonMessage(@NULL HUD);

// Export UTurokContextAction::execDrawMashButtonMessage(FFrame&, void* const)
native simulated function DrawMashButtonMessage(@NULL HUD);

// Export UTurokContextAction::execDrawPressButtonMessage(FFrame&, void* const)
native simulated function DrawPressButtonMessage(@NULL HUD);

// Export UTurokContextAction::execDrawProgressBar(FFrame&, void* const)
native simulated function DrawProgressBar(@NULL HUD);

simulated function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    //return;    
}

defaultproperties
{
    mPcKeyImage=Texture2D'TurokControllerButtons.PcKey'
    mPcMouseImage=Texture2D'TurokControllerButtons.PcMouse'
    mDrawFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mTextScale=0.3130000
    bOnlyRelevantToOwner=true
    bReplicateMovement=false
    bSkipActorPropertyReplication=true
    RemoteRole=1
    NetUpdateFrequency=15.0000000
    NetPriority=2.4000000
}