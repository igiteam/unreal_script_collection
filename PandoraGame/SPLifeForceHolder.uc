class SPLifeForceHolder extends Actor
    native
    placeable;

const NUM_SOURCE_SOCKETS = 1;
const NUM_SOURCE_AVAILABLE_SOCKETS = 9;
const curveOffset = Vect(100.0,-100.0,125);

struct native RepTargetPawn
{
    var PlayerPawn Pawn;
    var int TimesChanged;

    structdefaultproperties
    {
        Pawn=none
        TimesChanged=0
    }
};

var repnotify RepTargetPawn ReplicatedTargetPawn;
var float InitialLifeForceAmount;
var() repnotify float LifeForceAmount;
var float SiphonDelay;
var protected PlayerPawn TargetPawn;
var protected int LastTargetPawnTimesChanged;
var repnotify Actor ParentActor;
var SPDAction_SpawnLifeForce ParentSPDAction;
var array<Actor> ChildList;
var array<Actor> ActivatedChildList;
var SPDProcessManager Manager;
var ParticleSystem SyphoningParticleSystem;
var ParticleSystem AnimusPackParticleSystem;
var array<SPEmitterSpawnable> AnimusEmitter;
var SPEmitterSpawnable AnimusPackEmitter;
var SPGameDifficultyTuneGamePlay m_GameplayGDTuneData;
var Vector ParentLoc;
var() bool m_bAddToAnimusManager;
var bool m_AnimusPackInitiated;
var bool m_bAnimusPackHidden;
var bool m_bIsAnimusPack;
var bool m_bAddedAnimusToManager;
var bool m_bSiphonable;
var PandoraGameInfo m_GameInfo;
var export editinline AudioComponent AudioComp_AnimusIdle;
var SoundCue mSoundCue_AnimusIdle;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetInitial || bNetDirty
        LifeForceAmount, ParentActor, 
        ReplicatedTargetPawn;
}

// Export USPLifeForceHolder::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

simulated function ScaleAnimusCloud()
{
    // End:0x36
    if(AnimusPackEmitter != none)
    {
        AnimusPackEmitter.ParticleSystemComponent.SetScale(CalculateAnimusCloudScale());        
    }
    else
    {
        ScaleInfiniteLifespanEmittersInChildList(ChildList, CalculateAnimusCloudScale());
    }
    //return;    
}

function DBG_MsgLH(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

simulated function PostBeginPlay()
{
    local float MinDistance;

    InitialLifeForceAmount = LifeForceAmount;
    ScaleAnimusCloud();
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    m_GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x77
    if(m_GameInfo == none)
    {
        // End:0x74
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
        }        
    }
    else
    {
        // End:0xC9
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            // End:0xC6
            if(m_bAddToAnimusManager)
            {
                // End:0xC6
                if(m_GameInfo.AnimusMgr.AddAnimus(self))
                {
                    AssignAnimusTimer();
                }
            }            
        }
        else
        {
            AssignAnimusTimer();
        }
    }
    // End:0xF3
    if(ParentActor != none)
    {
        ParentLoc = ParentActor.Location;
    }
    AudioComp_AnimusIdle = CreateAudioComponent(mSoundCue_AnimusIdle, false, true);
    // End:0x124
    if(AudioComp_AnimusIdle != none)
    {
        AudioComp_AnimusIdle.Play();
    }
    // End:0x15A
    if(Class'PlayerPawn'.default.bActiveCollect)
    {
        MinDistance = Class'PandoraPlayerInput'.default.LifeForceParams.AMinDistance;        
    }
    else
    {
        MinDistance = Class'PandoraPlayerInput'.default.LifeForceParams.PMinDistance;
    }
    CylinderComponent(CollisionComponent).SetCylinderSize(MinDistance, MinDistance);
    //return;    
}

event AddToAnimusManager()
{
    m_bAddToAnimusManager = true;
    // End:0x5C
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x59
        if(m_GameInfo != none)
        {
            // End:0x59
            if(m_GameInfo.AnimusMgr.AddAnimus(self))
            {
                AssignAnimusTimer();
            }
        }        
    }
    else
    {
        AssignAnimusTimer();
    }
    //return;    
}

simulated function NotifyParentOfCreation(Actor newActor)
{
    // End:0x36
    if(newActor != none)
    {
        ChildList[ChildList.Length] = newActor;
        ScaleInfiniteLifespanEmittersInChildList(ChildList, CalculateAnimusCloudScale());
    }
    //return;    
}

simulated function float CalculateAnimusCloudScale()
{
    local SPGameDifficultyTuneGamePlay GameplayGD;
    local float AnimusCloudScaleMin, AnimusCloudScaleMax, LifeForceAmountMin, LifeForceAmountMax, LifeForceAmountClamped, LifeForceAmountPercent,
	    Scale;

    GameplayGD = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    AnimusCloudScaleMin = GameplayGD.AnimusCloudScaleMin;
    AnimusCloudScaleMax = GameplayGD.AnimusCloudScaleMax;
    LifeForceAmountMin = GameplayGD.LifeForceAmountMin;
    LifeForceAmountMax = GameplayGD.LifeForceAmountMax;
    LifeForceAmountClamped = float(Clamp(int(LifeForceAmount), int(LifeForceAmountMin), int(LifeForceAmountMax)));
    LifeForceAmountPercent = (LifeForceAmountClamped - LifeForceAmountMin) / (LifeForceAmountMax - LifeForceAmountMin);
    Scale = (LifeForceAmountPercent * (AnimusCloudScaleMax - AnimusCloudScaleMin)) + AnimusCloudScaleMin;
    return Scale;
    //return ReturnValue;    
}

simulated function ScaleInfiniteLifespanEmittersInChildList(array<Actor> targetChildList, float Scale)
{
    local int I;
    local EmitterSpawnable Emitter;
    local editinline ParticleSystemComponent psComp;

    I = targetChildList.Length - 1;
    J0x0F:

    // End:0x9B [Loop If]
    if(I >= 0)
    {
        // End:0x91
        if(targetChildList[I] != none)
        {
            Emitter = EmitterSpawnable(targetChildList[I]);
            // End:0x91
            if(Emitter != none)
            {
                // End:0x91
                if(Emitter.LifeSpan == float(0))
                {
                    psComp = Emitter.ParticleSystemComponent;
                    psComp.SetScale(Scale);
                }
            }
        }
        I--;
        // [Loop Continue]
        goto J0x0F;
    }
    //return;    
}

simulated function DestroyChildList(out array<Actor> targetChildList)
{
    local int I;

    I = targetChildList.Length - 1;
    J0x0F:

    // End:0x55 [Loop If]
    if(I >= 0)
    {
        // End:0x4B
        if(targetChildList[I] != none)
        {
            targetChildList[I].Destroy();
            targetChildList[I] = none;
        }
        I--;
        // [Loop Continue]
        goto J0x0F;
    }
    //return;    
}

simulated function DisableChildList(out array<Actor> targetChildList)
{
    local int I;
    local Emitter childEmitter;
    local editinline ParticleSystemComponent psComp;

    I = targetChildList.Length - 1;
    J0x0F:

    // End:0x6A [Loop If]
    if(I >= 0)
    {
        childEmitter = Emitter(targetChildList[I]);
        // End:0x60
        if(childEmitter != none)
        {
            psComp = childEmitter.ParticleSystemComponent;
            psComp.DeactivateSystem();
        }
        I--;
        // [Loop Continue]
        goto J0x0F;
    }
    //return;    
}

event bool CanActivate(Actor taker)
{
    return false;
    //return ReturnValue;    
}

simulated event bool Activate(Actor taker, float delay, optional bool bActivate = true)
{
    return false;
    //return ReturnValue;    
}

simulated event bool AbortActivate(Actor taker)
{
    return false;
    //return ReturnValue;    
}

simulated event bool IsActive(Actor taker)
{
    return false;
    //return ReturnValue;    
}

simulated function KillAttachedParticles()
{
    local int I;
    local SPEmitterSpawnable nEmitterSpawnable;

    I = 0;
    J0x07:

    // End:0x5B [Loop If]
    if(I < AnimusEmitter.Length)
    {
        nEmitterSpawnable = AnimusEmitter[I];
        // End:0x51
        if(nEmitterSpawnable != none)
        {
            nEmitterSpawnable.DetachObject(false);
            nEmitterSpawnable.Destroy();
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    AnimusEmitter.Remove(0, AnimusEmitter.Length);
    //return;    
}

simulated function PickRandomSockets(out array<int> numArray)
{
    local array<int> chooseArray;
    local int I, Seed, Value;

    I = 0;
    J0x07:

    // End:0x2E [Loop If]
    if(I < 9)
    {
        chooseArray[I] = I;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x35:

    // End:0x86 [Loop If]
    if(I < 1)
    {
        Seed = Rand(chooseArray.Length);
        Value = chooseArray[Seed];
        numArray[I] = Value;
        chooseArray.Remove(Seed, 1);
        I++;
        // [Loop Continue]
        goto J0x35;
    }
    //return;    
}

simulated function CreateParticleSystem(Actor taker)
{
    local Vector SourceVector, targetVector, differenceVector, scalerVector, scalerVector2;

    local int I, numAnimusEmitters;
    local string sourceString;
    local array<int> numArray;

    // End:0x16
    if(AnimusEmitter.Length > 0)
    {
        KillAttachedParticles();
    }
    targetVector = taker.Location;
    numAnimusEmitters = 0;
    // End:0x1AB
    if(1 == 1)
    {
        AnimusEmitter[numAnimusEmitters] = Spawn(Class'SPEmitterSpawnable', self);
        AnimusEmitter[numAnimusEmitters].bKillDuringLevelTransition = true;
        sourceString = "Center_3";
        SourceVector = Location;
        differenceVector = SourceVector - targetVector;
        scalerVector = Normal(differenceVector) * 0.2000000;
        scalerVector.Z += float(100);
        // End:0xF8
        if(m_bIsAnimusPack)
        {
            AnimusEmitter[numAnimusEmitters].SetFloatParameter('particleLifetime', 10000.0000000);
        }
        AnimusEmitter[numAnimusEmitters].SetTemplate(SyphoningParticleSystem, false);
        // End:0x155
        if(ParentActor != none)
        {
            InitializePathFollowingSignetCurve(ParentActor, taker, scalerVector, scalerVector, AnimusEmitter[numAnimusEmitters], sourceString);            
        }
        else
        {
            InitializePathFollowingSignetCurve(none, taker, scalerVector, scalerVector, AnimusEmitter[numAnimusEmitters], sourceString, ParentLoc, true, Location);
        }
        AnimusEmitter[numAnimusEmitters].ParticleSystemComponent.ActivateSystem();
        return;
    }
    PickRandomSockets(numArray);
    I = 0;
    J0x1C1:

    // End:0x389 [Loop If]
    if(I < 9)
    {
        // End:0x1E7
        if(-1 == numArray.Find(I))
        {
            // [Explicit Continue]
            goto J0x37F;
        }
        AnimusEmitter[numAnimusEmitters] = Spawn(Class'SPEmitterSpawnable', self);
        AnimusEmitter[numAnimusEmitters].bKillDuringLevelTransition = true;
        sourceString = "Center_3";
        SourceVector = Location;
        differenceVector = SourceVector - targetVector;
        scalerVector = Normal(differenceVector) * 0.2000000;
        scalerVector.Z += float(100);
        scalerVector2 = scalerVector;
        scalerVector2.Z -= float(200);
        // End:0x2C7
        if(m_bIsAnimusPack)
        {
            AnimusEmitter[numAnimusEmitters].SetFloatParameter('particleLifetime', 10000.0000000);
        }
        AnimusEmitter[numAnimusEmitters].SetTemplate(SyphoningParticleSystem, false);
        // End:0x324
        if(ParentActor != none)
        {
            InitializePathFollowingSignetCurve(ParentActor, taker, scalerVector, scalerVector2, AnimusEmitter[numAnimusEmitters], sourceString);            
        }
        else
        {
            InitializePathFollowingSignetCurve(none, taker, scalerVector, scalerVector2, AnimusEmitter[numAnimusEmitters], sourceString, ParentLoc, true, Location);
        }
        AnimusEmitter[numAnimusEmitters].ParticleSystemComponent.ActivateSystem();
        numAnimusEmitters++;
        J0x37F:

        I++;
        // [Loop Continue]
        goto J0x1C1;
    }
    //return;    
}

// Export USPLifeForceHolder::execInitializePathFollowingSignetCurve(FFrame&, void* const)
native final function InitializePathFollowingSignetCurve(Actor Source, Actor Target, Vector point1, Vector point2, Emitter emit, string sourceString, optional Vector SourceLocation, optional bool bNoTarget = false, optional Vector vNoTarget, optional bool bUseSkelMeshActors = false, optional bool bReverseDirection = false);

// Export USPLifeForceHolder::execDestroyPathFollowingSignetCurve(FFrame&, void* const)
native final function DestroyPathFollowingSignetCurve(Emitter emit);

function float GiveLifeForce(float DeltaTime)
{
    return TargetPawn.GiveLifeForce(LifeForceAmount, DeltaTime);
    //return ReturnValue;    
}

simulated function Destroyed()
{
    // End:0x62
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x2F
        if(ParentActor != none)
        {
            ParentActor.Destroy();
            ParentActor = none;
        }
        // End:0x62
        if(m_bAddToAnimusManager && m_bAddedAnimusToManager)
        {
            m_GameInfo.AnimusMgr.FindLifeForceHolderSlotAndReleaseIt(self);
        }
    }
    KillAttachedParticles();
    DestroyChildList(ChildList);
    DestroyChildList(ActivatedChildList);
    // End:0xA9
    if(TargetPawn != none)
    {
        TargetPawn.FinishSiphonSound();
    }
    // End:0xC8
    if(AnimusPackEmitter != none)
    {
        AnimusPackEmitter.Destroy();
        AnimusPackEmitter = none;
    }
    // End:0xEF
    if(TargetPawn != none)
    {
        TargetPawn.RemoveSiphonStream(self);
        TargetPawn = none;
    }
    super.Destroyed();
    //return;    
}

simulated event Tick(float DeltaTime)
{
    // End:0x5A
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x48
        if((NeedsToMove()) == true)
        {
            // End:0x32
            if(bCollideActors == true)
            {
                SetCollision(false, false, true);
            }
            SetLocation(ParentActor.Location);            
        }
        else
        {
            // End:0x5A
            if(bCollideActors == false)
            {
                SetCollision(true, false, false);
            }
        }
    }
    //return;    
}

function bool NeedsToMove()
{
    local Vector vectDist;
    local float distSQ;

    // End:0x0D
    if(ParentActor == none)
    {
        return false;
    }
    vectDist = ParentActor.Location - Location;
    distSQ = VSizeSq(vectDist);
    // End:0x4A
    if(distSQ < float(25))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function RemoveAnimus()
{
    Destroy();
    //return;    
}

function StartLifeForceDecay()
{
    SetTimer(0.2500000, true, 'LifeForceDecay');
    //return;    
}

function LifeForceDecay()
{
    local float Decay;

    Decay = 2.0000000;
    // End:0x33
    if(LifeForceAmount >= Decay)
    {
        LifeForceAmount -= Decay;
        ScaleAnimusCloud();        
    }
    else
    {
        ClearTimer('LifeForceDecay');
        SetTargetPawn(none);
        ReplicatedTargetPawn.TimesChanged = -1;
        GotoState('Dying');
    }
    //return;    
}

function AssignAnimusTimer()
{
    local float Lifetime;

    // End:0x9F
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x73
        if(m_GameInfo.AnimusMgr.m_AnimusCloudCount >= m_GameplayGDTuneData.MaxNumAnimusClouds)
        {
            Lifetime = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.SecsToKeepAnimusNorm);            
        }
        else
        {
            Lifetime = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.SecsToKeepAnimusTaxed);
        }        
    }
    else
    {
        Lifetime = 20.0000000;
    }
    SetTimer(Lifetime, false, 'StartLifeForceDecay');
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x118
    if(VarName == 'ReplicatedTargetPawn')
    {
        // End:0x115
        if(GetStateName() != 'Dying')
        {
            // End:0x94
            if(TargetPawn != ReplicatedTargetPawn.Pawn)
            {
                // End:0x5E
                if(TargetPawn != none)
                {
                    TargetPawn.RemoveSiphonStream(self);
                }
                // End:0x94
                if(ReplicatedTargetPawn.Pawn != none)
                {
                    ReplicatedTargetPawn.Pawn.AddSiphonStream(self);
                }
            }
            TargetPawn = ReplicatedTargetPawn.Pawn;
            LastTargetPawnTimesChanged = ReplicatedTargetPawn.TimesChanged;
            // End:0xDC
            if(TargetPawn != none)
            {
                GotoState('Activated');                
            }
            else
            {
                // End:0x107
                if(ReplicatedTargetPawn.TimesChanged != -1)
                {
                    GotoState('Idle');                    
                }
                else
                {
                    GotoState('Dying');
                }
            }
        }        
    }
    else
    {
        // End:0x138
        if(VarName == 'LifeForceAmount')
        {
            ScaleAnimusCloud();            
        }
        else
        {
            // End:0x16E
            if(VarName == 'ParentActor')
            {
                // End:0x16B
                if(ParentActor != none)
                {
                    ParentLoc = ParentActor.Location;
                }                
            }
            else
            {
                super.ReplicatedEvent(VarName);
            }
        }
    }
    //return;    
}

function SetTargetPawn(PlayerPawn NewPlayer)
{
    // End:0x89
    if(TargetPawn != NewPlayer)
    {
        // End:0x2F
        if(TargetPawn != none)
        {
            TargetPawn.RemoveSiphonStream(self);
        }
        // End:0x4F
        if(NewPlayer != none)
        {
            NewPlayer.AddSiphonStream(self);
        }
        ++LastTargetPawnTimesChanged;
        TargetPawn = NewPlayer;
        ReplicatedTargetPawn.Pawn = TargetPawn;
        ++ReplicatedTargetPawn.TimesChanged;
    }
    //return;    
}

simulated function PlayerPawn GetTargetPawn()
{
    return TargetPawn;
    //return ReturnValue;    
}

auto simulated state Idle
{
    simulated event bool Activate(Actor taker, float delay, optional bool bActivate = true)
    {
        // End:0x6A
        if(m_bSiphonable && LifeForceAmount > 0.0000000)
        {
            // End:0x65
            if(bActivate)
            {
                SetTargetPawn(PlayerPawn(taker));
                SiphonDelay = delay;
                // End:0x65
                if(int(Role) == int(ROLE_Authority))
                {
                    GotoState('Activated');
                }
            }
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }

    simulated event bool CanActivate(Actor taker)
    {
        return Activate(taker, 0.0000000, false);
        //return ReturnValue;        
    }
Begin:

    // End:0xCC
    if(m_bIsAnimusPack && !m_AnimusPackInitiated)
    {
        m_AnimusPackInitiated = true;
        AnimusPackEmitter = Spawn(Class'SPEmitterSpawnable', self,, Location, Rotator(vect(0.0000000, 0.0000000, 0.0000000)));
        // End:0xCC
        if(AnimusPackEmitter != none)
        {
            AnimusPackEmitter.SetTemplate(AnimusPackParticleSystem, true);
            AnimusPackEmitter.bDestroyOnSystemFinish = false;
            AnimusPackEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            AnimusPackEmitter.ParticleSystemComponent.ActivateSystem();
            AnimusPackEmitter.bKillDuringLevelTransition = true;
        }
    }
    stop;                
}

simulated state Activated
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x36
        if((ParentActor != none) && SPPawn(ParentActor) != none)
        {
            SPPawn(ParentActor).BeginSignetDraw();
        }
        DestroyChildList(ActivatedChildList);
        CreateParticleSystem(TargetPawn);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x36
        if((ParentActor != none) && SPPawn(ParentActor) != none)
        {
            SPPawn(ParentActor).AbortSignetDraw();
        }
        DisableChildList(ActivatedChildList);
        KillAttachedParticles();
        //return;        
    }

    simulated event bool AbortActivate(Actor taker)
    {
        // End:0x4E
        if((LifeForceAmount > 0.0000000) && taker == TargetPawn)
        {
            SetTargetPawn(none);
            // End:0x49
            if(int(Role) == int(ROLE_Authority))
            {
                GotoState('Idle');
            }
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }

    simulated function NotifyParentOfCreation(Actor newActor)
    {
        // End:0x1D
        if(newActor != none)
        {
            ActivatedChildList[ActivatedChildList.Length] = newActor;
        }
        //return;        
    }

    simulated event bool IsActive(Actor taker)
    {
        return (LifeForceAmount > 0.0000000) && taker == TargetPawn;
        //return ReturnValue;        
    }

    simulated event Tick(float DeltaTime)
    {
        local float takenLifeForceAmount;

        // End:0x103
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0xE6
            if(TargetPawn != none)
            {
                takenLifeForceAmount = GiveLifeForce(DeltaTime);
                LifeForceAmount = FMax(0.0000000, LifeForceAmount - takenLifeForceAmount);
                ScaleAnimusCloud();
                // End:0xE3
                if(LifeForceAmount <= 0.1000000)
                {
                    LifeForceAmount = 0.0000000;
                    ScaleAnimusCloud();
                    SetTargetPawn(none);
                    ReplicatedTargetPawn.TimesChanged = -1;
                    DisableChildList(ChildList);
                    DisableChildList(ActivatedChildList);
                    // End:0xD5
                    if(AnimusPackEmitter != none)
                    {
                        AnimusPackEmitter.Destroy();
                        AnimusPackEmitter = none;
                    }
                    GotoState('Dying');
                }                
            }
            else
            {
                DisableChildList(ActivatedChildList);
                GotoState('Idle');
            }
        }
        //return;        
    }

    function ProcessActivated()
    {
        local SPPawn MeltPawn;

        MeltPawn = SPPawn(ParentActor);
        // End:0x2F
        if(MeltPawn != none)
        {
            MeltPawn.MeltSkin();
        }
        //return;        
    }
Begin:

    // End:0x84
    if(TargetPawn != none)
    {
        // End:0x84
        if((ParentActor != none) && ParentSPDAction != none)
        {
            Manager = Class'SPDProcessManager'.static.Get(ParentActor);
            // End:0x7A
            if(Manager != none)
            {
                Manager.AddActionList(ParentSPDAction.OnTriggerActionList, self, true);
                Manager = none;
            }
            ProcessActivated();
        }
    }
    stop;                
}

simulated state Dying
{Begin:

    // End:0x27
    if(TargetPawn != none)
    {
        TargetPawn.RemoveSiphonStream(self);
        TargetPawn = none;
    }
    KillAttachedParticles();
    DestroyChildList(ChildList);
    DestroyChildList(ActivatedChildList);
    // End:0x7B
    if(AudioComp_AnimusIdle != none)
    {
        AudioComp_AnimusIdle.FadeOut(0.2500000 * 2.0000000, 0.0000000);
    }
    Sleep(2.0000000);
    // End:0xB8
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0xB5
        if(ParentActor != none)
        {
            ParentActor.Destroy();
            ParentActor = none;            
        }
        Destroy();
    }
    stop;                
}
