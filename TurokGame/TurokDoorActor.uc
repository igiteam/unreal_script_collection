class TurokDoorActor extends Actor
    native
    nativereplication
    notplaceable
    hidecategories(Navigation,Attachment,Collision,Display,Object,Movement);

enum EDoorActionType
{
    DAT_OpenDoor,                   // 0
    DAT_CloseDoor,                  // 1
    DAT_LockDoor,                   // 2
    DAT_MakeAccessible,             // 3
    DAT_MakePryDoor,                // 4
    DAT_None,                       // 5
    DAT_MAX                         // 6
};

enum EStateOfDoor
{
    SOD_Accessible,                 // 0
    SOD_Locked,                     // 1
    SOD_ScriptControlled,           // 2
    SOD_Pry,                        // 3
    SOD_Invalid,                    // 4
    SOD_MAX                         // 5
};

enum EDoorState
{
    DS_OpenDoor,                    // 0
    DS_CloseDoor,                   // 1
    DS_Closed,                      // 2
    DS_Opened,                      // 3
    DS_PryDoorWalkUp,               // 4
    DS_PryDoorPry,                  // 5
    DS_PryDoorSuccess,              // 6
    DS_PryDoorFail,                 // 7
    DS_MAX                          // 8
};

var() protected bool mbCanBeOpenedByPlayer;
var() protected bool mbCanBeOpenedByEnemyHumans;
var() protected bool mbCanBeOpenedByFriendlyHumans;
var() protected bool mbCanBeOpenedByCreatures;
var protected repnotify bool mbIsOpen;
var bool bDoorPryIsOpening;
var(Lighting) const bool bIgnoreTickOptimization;
var() protected byte mStateOfDoor;
var protected repnotify byte mDoorState;
var protected repnotify byte mDoorAction;
var protected repnotify transient byte mCurrentStateOfDoor;
var(Multiplayer) protected noclear export editinline @NULL mGameModeRestriction;
var() protected editconst @NULL MyMarker;
var protected transient @NULL mPryDoorVolumeDimensions;
var protected transient @NULL mMoverDoorVolumeDimensions;
var() @NULL mPryDoorVolumeOffset;
var() @NULL mMoverDoorVolumeOffset;
var @NULL mMoverDoorVolume;
var @NULL mPryDoorVolume;
var export editinline @NULL mSoundController;
var int mSoundChannelIndex;
var @NULL mDoorOpenStartSndCue;
var @NULL mDoorOpenLoopSndCue;
var @NULL mDoorOpenEndSndCue;
var @NULL mDoorCloseStartSndCue;
var @NULL mDoorCloseLoopSndCue;
var @NULL mDoorCloseEndSndCue;
var @NULL mDoorPryOpeningSndCue;
var @NULL mDoorPryClosingSndCue;
var @NULL mDoorPryFailedSndCue;
var @NULL mDoorPryOpenSndCue;
var @NULL mDoorPryCloseSndCue;
var float mPreviousPercent;
var protected array mDoorStateLightMaterials;
var protected @NULL mCurrentStateLightMaterial;
var(ProximityDoor) const float mDoorSpeed;
var(PryDoor) const export editinline @NULL mPryDoorMesh;
var private transient @NULL mAnimController;
var transient float mAnimScrubPercent;
var @NULL mPryDoorAction;
var transient @NULL mLeftDoorLoc;
var transient @NULL mRightDoorLoc;
var(PryDoor) float mDecreaseRate;
var(PryDoor) float mIncreaseRate;
var(PryDoor) float mAmountEachPressAdds;
var(PryDoor) float mInitialValue;
var(PryDoor) float mSuccessPercent;
var(PryDoor) float mFailurePercent;
var name mSuccessGraph;
var name mFailureGraph;
var transient float mCurrentPercent;
var transient float mDesiredPercent;
var(Lighting) export editinline @NULL mLightEnvironment;

replication
{
    // Pos:0x000
    if(bNetDirty
        mAnimScrubPercent, mCurrentStateOfDoor, 
        mDoorAction, mDoorState, 
        mLeftDoorLoc, mPryDoorAction, 
        mRightDoorLoc, mbIsOpen;
}

// Export UTurokDoorActor::execBuildDoorVolume(FFrame&, void* const)
native function BuildDoorVolume();

// Export UTurokDoorActor::execGetAnimController(FFrame&, void* const)
native function @NULL GetAnimController();

// Export UTurokDoorActor::execCreateCollision(FFrame&, void* const)
native function CreateCollision();

// Export UTurokDoorActor::execWorldToCharacter(FFrame&, void* const)
native function WorldToCharacter(@NULL SkelComponent, @NULL worldPos, @NULL worldRot, out @NULL characterPos, out @NULL characterRot);

// Export UTurokDoorActor::execSetupVolumes(FFrame&, void* const)
native function SetupVolumes();

// Export UTurokDoorActor::execSetDoorPose(FFrame&, void* const)
native function SetDoorPose(name AnimName, float Time);

// Export UTurokDoorActor::execDirtyDoorVolumes(FFrame&, void* const)
native function DirtyDoorVolumes();

protected simulated function SetPryDoorClosedOffsets()
{
    //return;    
}

protected simulated function SetNormalDoorClosedOffsets()
{
    //return;    
}

protected simulated function PryTick(float Time)
{
    //return;    
}

simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    //return;    
}

simulated function CancelPryPrematurely()
{
    // End:0x1A
    if(mAnimController != none)
    {
        mAnimController.Reset();
    }
    CloseDoor();
    //return;    
}

simulated function @NULL GetPryGraphSet(@NULL pryer)
{
    return none;
    //return ReturnValue;    
}

simulated function bool IsDoorMoving()
{
    return ((IsInState('PryDoorWalkUp') || IsInState('OpenDoorState')) || IsInState('CloseDoorState')) || bDoorPryIsOpening;
    //return ReturnValue;    
}

function OnDoorAction(@NULL Action)
{
    SetDoorAction(Action.mDoorAction);
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x25
    if(VarName == 'mDoorAction')
    {
        SetDoorAction(mDoorAction);        
    }
    else
    {
        // End:0x4B
        if(VarName == 'mbIsOpen')
        {
            SetDoorOpen(mbIsOpen);            
        }
        else
        {
            // End:0x128
            if(VarName == 'mDoorState')
            {
                switch(mDoorState)
                {
                    // End:0x7B
                    case 0:
                        GotoState('OpenDoorState');
                        // End:0x11B
                        break;
                    // End:0x91
                    case 1:
                        GotoState('CloseDoorState');
                        // End:0x11B
                        break;
                    // End:0xA7
                    case 2:
                        GotoState('ClosedState');
                        // End:0x11B
                        break;
                    // End:0xBD
                    case 3:
                        GotoState('OpenedState');
                        // End:0x11B
                        break;
                    // End:0xD3
                    case 4:
                        GotoState('PryDoorWalkUp');
                        // End:0x11B
                        break;
                    // End:0xE9
                    case 5:
                        GotoState('PryDoorPry');
                        // End:0x11B
                        break;
                    // End:0xFF
                    case 6:
                        GotoState('PryDoorSuccessfullyOpened');
                        // End:0x11B
                        break;
                    // End:0x115
                    case 7:
                        GotoState('PryDoorFailedToOpen');
                        // End:0x11B
                        break;
                    // End:0xFFFF
                    default:
                        // End:0x11B
                        break;
                        break;
                }
                UpdateState();                
            }
            else
            {
                // End:0x145
                if(VarName == 'mCurrentStateOfDoor')
                {
                    UpdateState();
                }
            }
        }
    }
    //return;    
}

simulated function SetDoorAction(byte DoorAction)
{
    mDoorAction = DoorAction;
    switch(mDoorAction)
    {
        // End:0x20
        case 0:
            OpenDoor();
            // End:0x83
            break;
        // End:0x32
        case 1:
            CloseDoor();
            // End:0x83
            break;
        // End:0x4C
        case 2:
            mCurrentStateOfDoor = 1;
            CloseDoor();
            // End:0x83
            break;
        // End:0x66
        case 3:
            mCurrentStateOfDoor = 0;
            CloseDoor();
            // End:0x83
            break;
        // End:0x80
        case 4:
            mCurrentStateOfDoor = 3;
            CloseDoor();
            // End:0x83
            break;
        // End:0xFFFF
        default:
            break;
    }
    UpdateState();
    //return;    
}

simulated function SetDoorOpen(bool bIsOpen)
{
    // End:0x55
    if(int(Role) == int(ROLE_Authority))
    {
        mbIsOpen = bIsOpen;
        // End:0x3F
        if(mbIsOpen)
        {
            GotoState('OpenedState');
            mDoorState = 3;            
        }
        else
        {
            GotoState('ClosedState');
            mDoorState = 2;
        }
    }
    //return;    
}

simulated function bool CanOpen(@NULL P)
{
    // End:0x7C
    if(TurokPawnHuman(P) != none)
    {
        // End:0x30
        if((TurokPawnPlayer(P) != none) && mbCanBeOpenedByPlayer)
        {
            return true;            
        }
        else
        {
            // End:0x79
            if(TurokPawnHumanNpcNative(P) != none)
            {
                // End:0x6E
                if((int(TurokPawnHumanNpcNative(P).mNPCType) == int(0)) && mbCanBeOpenedByEnemyHumans)
                {
                    return true;                    
                }
                else
                {
                    // End:0x79
                    if(mbCanBeOpenedByFriendlyHumans)
                    {
                        return true;
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x87
        if(mbCanBeOpenedByCreatures)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event bool IsConsideredAProximityDoor()
{
    return int(mCurrentStateOfDoor) == int(0);
    //return ReturnValue;    
}

simulated event bool IsConsideredAPryDoor()
{
    return int(mCurrentStateOfDoor) == int(3);
    //return ReturnValue;    
}

private final simulated function SetClosedOffsets()
{
    // End:0x34
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x2A
        if(IsConsideredAPryDoor())
        {
            SetPryDoorClosedOffsets();            
        }
        else
        {
            SetNormalDoorClosedOffsets();
        }
    }
    //return;    
}

private final simulated function OpenDoor()
{
    switch(mCurrentStateOfDoor)
    {
        // End:0x15
        case 0:
            OpenMoverDoor();
            // End:0x36
            break;
        // End:0x1D
        case 3:
            // End:0x36
            break;
        // End:0x2B
        case 2:
            OpenMoverDoor();
            // End:0x36
            break;
        // End:0x33
        case 1:
            // End:0x36
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

simulated function CloseDoor()
{
    // End:0x4C
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x4C
        if(!IsInState('ClosedState') && !IsInState('CloseDoorState'))
        {
            GotoState('CloseDoorState');
            mDoorState = 1;
        }
    }
    //return;    
}

private final simulated function OpenMoverDoor()
{
    // End:0x12
    if(int(mCurrentStateOfDoor) == int(1))
    {
        return;
    }
    // End:0x38
    if(int(Role) == int(ROLE_Authority))
    {
        GotoState('OpenDoorState');
        mDoorState = 0;
    }
    //return;    
}

protected simulated function bool MoveDoor(float DeltaTime, @NULL doorOffset, @NULL doorMesh)
{
    local @NULL Delta;
    local bool bDoorIsInPosition;
    local float Distance;

    Distance = mDoorSpeed * DeltaTime;
    Delta = doorOffset - doorMesh.Translation;
    bDoorIsInPosition = VSize(Delta) < Distance;
    // End:0x66
    if(bDoorIsInPosition)
    {
        doorMesh.SetTranslation(doorOffset);        
    }
    else
    {
        doorMesh.SetTranslation(doorMesh.Translation + (Distance * Normal(Delta)));
    }
    return bDoorIsInPosition;
    //return ReturnValue;    
}

private final simulated event PopulateFromAnimTag(@NULL graph)
{
    local @NULL pryDoorTag;

    pryDoorTag = TurokAnimTransitionGraphTagPryDoor(graph.FindTagByType(Class'TurokAnimTransitionGraphTagPryDoor'));
    // End:0xCE
    if(pryDoorTag != none)
    {
        mDecreaseRate = pryDoorTag.mDecreaseRate;
        mIncreaseRate = pryDoorTag.mIncreaseRate;
        mAmountEachPressAdds = pryDoorTag.mAmountEachPressAdds;
        mInitialValue = pryDoorTag.mInitialValue;
        mSuccessPercent = pryDoorTag.mSuccessPercent;
        mFailurePercent = pryDoorTag.mFailurePercent;
        mSuccessGraph = pryDoorTag.mSuccessGraph;
        mFailureGraph = pryDoorTag.mFailureGraph;
    }
    //return;    
}

function OnButtonPress(@NULL Action)
{
    mPryDoorAction = Action;
    // End:0x31
    if(int(Role) == int(ROLE_Authority))
    {
        GotoState('PryDoorWalkUp');
        mDoorState = 4;
    }
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x1C
    if(!bIgnoreTickOptimization)
    {
        DetachComponent(mLightEnvironment);
    }
    mCurrentStateOfDoor = mStateOfDoor;
    // End:0x56
    if(mSoundChannelIndex == -1)
    {
        mSoundChannelIndex = mSoundController.CreateAudioChannel(mDoorOpenLoopSndCue, false, true);
    }
    SetClosedOffsets();
    UpdateState();
    GotoState('ClosedState');
    //return;    
}

simulated event Destroyed()
{
    super.Destroyed();
    // End:0x1D
    if(mMoverDoorVolume != none)
    {
        mMoverDoorVolume.Destroy();
    }
    // End:0x34
    if(mPryDoorVolume != none)
    {
        mPryDoorVolume.Destroy();
    }
    //return;    
}

function Reset()
{
    mCurrentStateOfDoor = mStateOfDoor;
    SetClosedOffsets();
    SetDoorOpen(false);
    super.Reset();
    //return;    
}

simulated function ModifyLightsColor()
{
    mCurrentStateLightMaterial = mDoorStateLightMaterials[int(mCurrentStateOfDoor)];
    //return;    
}

simulated function UpdateState()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        SetupVolumes();
    }
    DirtyDoorVolumes();
    ModifyLightsColor();
    //return;    
}

state OpenDoorState
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x45
        if(!mbIsOpen)
        {
            mSoundController.TryPlayLocalSound(mDoorOpenStartSndCue);
            mSoundController.ChangeAudioChannel(mSoundChannelIndex, mDoorOpenLoopSndCue, true, true);
        }
        StartTicking();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x3F
        if(!mbIsOpen)
        {
            mSoundController.TryPlayLocalSound(mDoorOpenEndSndCue);
            mSoundController.StopAudioChannel(mSoundChannelIndex);
        }
        //return;        
    }
    stop;    
}

state CloseDoorState
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x2A
        if(!IsConsideredAPryDoor())
        {
            mSoundController.TryPlayLocalSound(mDoorCloseStartSndCue);
        }
        mSoundController.ChangeAudioChannel(mSoundChannelIndex, mDoorCloseLoopSndCue, true, true);
        StartTicking();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2A
        if(!IsConsideredAPryDoor())
        {
            mSoundController.TryPlayLocalSound(mDoorCloseEndSndCue);
        }
        mSoundController.StopAudioChannel(mSoundChannelIndex);
        //return;        
    }
    stop;    
}

state ClosedState
{
    simulated function BeginState(name PreviousStateName)
    {
        mbIsOpen = false;
        // End:0x33
        if(MyMarker != none)
        {
            MyMarker.bBlocked = int(mCurrentStateOfDoor) != int(0);            
        }
        TriggerEventClass(Class'TurokSeqEvent_DoorStatus', self, Class'TurokSeqEvent_DoorStatus'.default.DoorIsClosedLink);
        mAnimController = none;
        DetachComponent(mPryDoorMesh);
        // End:0x75
        if(!bIgnoreTickOptimization)
        {
            StopTicking();
        }
        //return;        
    }
    stop;    
}

state OpenedState
{
    simulated function BeginState(name PreviousStateName)
    {
        mbIsOpen = true;
        // End:0x27
        if(MyMarker != none)
        {
            MyMarker.bBlocked = false;            
        }
        TriggerEventClass(Class'TurokSeqEvent_DoorStatus', self, Class'TurokSeqEvent_DoorStatus'.default.DoorIsOpenLink);
        mAnimController = none;
        DetachComponent(mPryDoorMesh);
        // End:0x69
        if(!bIgnoreTickOptimization)
        {
            StopTicking();
        }
        //return;        
    }
    stop;    
}

state PryDoorWalkUp
{
    simulated function BeginState(name PreviousStateName)
    {
        AttachComponent(mPryDoorMesh);
        mbIsOpen = false;
        mPryDoorAction.PlayTransitionGraph('dooropenwalkup');
        StartTicking();
        //return;        
    }

    simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        PopulateFromAnimTag(newGraph);
        // End:0x31
        if(int(Role) == int(ROLE_Authority))
        {
            GotoState('PryDoorPry');
            mDoorState = 5;
        }
        //return;        
    }

    simulated event Tick(float Time)
    {
        super(Actor).Tick(Time);
        PryTick(Time);
        //return;        
    }
    stop;    
}

state PryDoorPry
{
    simulated function BeginState(name PreviousStateName)
    {
        mCurrentPercent = mInitialValue;
        mAnimScrubPercent = mCurrentPercent;
        mDesiredPercent = mInitialValue + mAmountEachPressAdds;
        mPryDoorAction.SetScrubPercent(mAnimScrubPercent);
        // End:0x5B
        if(int(Role) == int(ROLE_Authority))
        {
            NetUpdateFrequency = 30.0000000;
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x1B
        if(int(Role) == int(ROLE_Authority))
        {
            NetUpdateFrequency = default.NetUpdateFrequency;
        }
        //return;        
    }

    simulated event Tick(float DeltaTime)
    {
        // End:0x6A
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x35
            if(mDesiredPercent > mCurrentPercent)
            {
                mCurrentPercent += (mIncreaseRate * DeltaTime);                
            }
            else
            {
                mDesiredPercent -= (mDecreaseRate * DeltaTime);
                mCurrentPercent = mDesiredPercent;
            }
            mAnimScrubPercent = FClamp(mCurrentPercent, 0.0000000, 1.0000000);
        }
        // End:0xB0
        if((mPreviousPercent < mAnimScrubPercent) && !bDoorPryIsOpening)
        {
            mSoundController.ChangeAudioChannel(mSoundChannelIndex, mDoorPryOpenSndCue, true, true);
            bDoorPryIsOpening = true;            
        }
        else
        {
            // End:0x117
            if((mPreviousPercent > mAnimScrubPercent) && bDoorPryIsOpening)
            {
                mSoundController.ChangeAudioChannel(mSoundChannelIndex, mDoorPryCloseSndCue, true, true);
                mSoundController.TryPlayLimitedSound('DoorFail', mDoorPryFailedSndCue, Location);
                bDoorPryIsOpening = false;
            }
        }
        mPreviousPercent = mAnimScrubPercent;
        mPryDoorAction.SetScrubPercent(mAnimScrubPercent);
        // End:0x197
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x172
            if(mCurrentPercent < mFailurePercent)
            {
                GotoState('PryDoorFailedToOpen');
                mDoorState = 7;                
            }
            else
            {
                // End:0x197
                if(mCurrentPercent >= mSuccessPercent)
                {
                    GotoState('PryDoorSuccessfullyOpened');
                    mDoorState = 6;
                }
            }
        }
        PryTick(DeltaTime);
        global.Tick(DeltaTime);
        //return;        
    }

    function OnButtonPress(@NULL Action)
    {
        mDesiredPercent += mAmountEachPressAdds;
        //return;        
    }
    stop;    
}

state PryDoorSuccessfullyOpened
{
    simulated function BeginState(name PreviousStateName)
    {
        mPryDoorAction.PlayTransitionGraph(mSuccessGraph);
        mSoundController.TryPlayLocalSound(mDoorPryOpeningSndCue);
        mSoundController.StopAudioChannel(mSoundChannelIndex);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mbIsOpen = true;
        //return;        
    }

    simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x26
        if(int(Role) == int(ROLE_Authority))
        {
            GotoState('OpenedState');
            mDoorState = 3;
        }
        //return;        
    }

    simulated event Tick(float Time)
    {
        super(Actor).Tick(Time);
        PryTick(Time);
        //return;        
    }
    stop;    
}

state PryDoorFailedToOpen
{
    simulated function BeginState(name PreviousStateName)
    {
        mPryDoorAction.PlayTransitionGraph(mFailureGraph);
        mSoundController.TryPlayLocalSound(mDoorPryClosingSndCue);
        mSoundController.StopAudioChannel(mSoundChannelIndex);
        //return;        
    }

    simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x26
        if(int(Role) == int(ROLE_Authority))
        {
            GotoState('CloseDoorState');
            mDoorState = 1;
        }
        //return;        
    }

    simulated event Tick(float Time)
    {
        super(Actor).Tick(Time);
        PryTick(Time);
        //return;        
    }
    stop;    
}

defaultproperties
{
    mbCanBeOpenedByPlayer=true
    mbCanBeOpenedByEnemyHumans=true
    mbCanBeOpenedByFriendlyHumans=true
    mDoorState=2
    mDoorAction=5
    mCurrentStateOfDoor=4
    // Reference: TurokMPGameModeRestriction'Default__TurokDoorActor.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    mPryDoorVolumeDimensions=(X=120.0000000,Y=200.0000000,Z=200.0000000)
    mMoverDoorVolumeDimensions=(X=200.0000000,Y=350.0000000,Z=200.0000000)
    // Reference: TurokSoundController'Default__TurokDoorActor.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
        mLimitedSounds=/* Array type was not detected. */
    end object
    mSoundController=TurokSoundControllerComponent
    mSoundChannelIndex=-1
    mDoorStateLightMaterials=/* Array type was not detected. */
    mDoorSpeed=100.0000000
    // Reference: SkeletalMeshComponent'Default__TurokDoorActor.pryDoorMeshComponent'
    begin object name=pryDoorMeshComponent class=Class'Engine.SkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
        HiddenGame=true
        HiddenEditor=true
    end object
    mPryDoorMesh=pryDoorMeshComponent
    mDecreaseRate=1.0000000
    mIncreaseRate=1.0000000
    mAmountEachPressAdds=0.2000000
    mSuccessPercent=1.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__TurokDoorActor.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
        mUpdateOnMoveOnly=true
        bEnabled=false
    end object
    mLightEnvironment=MyLightEnvironment
    bNoDelete=true
    bWorldGeometry=true
    bAlwaysRelevant=true
    bReplicateMovement=false
    bSkipActorPropertyReplication=true
    bOnlyDirtyReplication=true
    bNetInitialRotation=true
    bCollideActors=true
    bBlockActors=true
    Components[0]=MyLightEnvironment
    Components[1]=TurokSoundControllerComponent
    RemoteRole=1
    NetPriority=1.6000000
    SupportedEvents=/* Array type was not detected. */
}