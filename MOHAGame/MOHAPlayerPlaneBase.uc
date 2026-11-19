class MOHAPlayerPlaneBase extends SkeletalMeshActor
    abstract
    native
    hidecategories(Navigation);

struct native ShakeInfoStruct
{
    var() Vector ShakeAmplitude;
    var() Vector shakeFrequency;
    var() Vector camShakeAmplitude;
    var() Vector camShakeFrequency;
    var() Vector camRollAmplitude;
    var() Vector camRollFrequency;
    var() float rollAmplitude;
    var() float rollFrequency;
    var() float falloffTime;
    var() float holdTime;

    structdefaultproperties
    {
        ShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000)
        shakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000)
        camShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000)
        camShakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000)
        camRollAmplitude=(X=200.0000000,Y=200.0000000,Z=90.0000000)
        camRollFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000)
        rollAmplitude=20.0000000
        rollFrequency=1000.0000000
        falloffTime=0.7500000
        holdTime=0.2500000
    }
};

var() name referenceSocketName;
var() export editinline StaticMeshComponent planeInterior;
var() export editinline SkeletalMeshComponent planeExterior;
var() export editinline StaticMeshComponent planeWindows;
var() export editinline SkeletalMeshComponent destructionMesh;
var array<MOHAITPNPC> ITPNPCs;
var bool bPlayingHeroShake;
var bool bIsShaking;
var() bool bShakeSystemEnabled;
var() bool bCamShakeEnabled;
var() bool bCustomCamShakeEnabled;
var(Sounds) bool bPlayFlakSounds;
var bool bAnimatingDamage;
var(Shake) bool bScaleShakeWithDistance;
var bool bInitialized;
var(FlakBurstParams) float minTimeBetweenBursts;
var(FlakBurstParams) float maxTimeBetweenBursts;
var(FlakBurstParams) int minEffectsPerBurst;
var(FlakBurstParams) int maxEffectsPerBurst;
var(FlakBurstParams) float maxBurstTime;
var(FlakBurstParams) float minBurstTime;
var(FlakBurstParams) float minTimeBetweenEffects;
var(FlakBurstParams) float maxTimeBetweenEffects;
var(FlakBurstParams) ParticleSystem normalFlakPSys;
var(FlakBurstParams) ParticleSystem heroFlakPSys;
var(Sounds) SoundCue normalFlakSoundCue;
var export editinline array<export editinline AudioComponent> flakSoundAudioComponents;
var(Sounds) int maxNumFlakSounds;
var float timeUntilNextBurst;
var float timeUntilBurstEnd;
var float thisBurstTime;
var int numEffects;
var int nextEffect;
var int totalNumEffects;
var array<name> zeroFlakEffectSockets;
var array<name> heroFlakEffectSockets;
var ShakeInfoStruct defaultShakeInfo;
var ShakeInfoStruct customShakeInfo;
var ShakeInfoStruct currentShakeInfo;
var float fShakeTime;
var(Shake) float flakShakeMaxDistance;
var float dampFactor;
var float distanceScaleFactor;
var export editinline array<export editinline ParticleSystemComponent> flakSystems;
var export editinline array<export editinline ParticleSystemComponent> heroFlakSystems;
var array<int> burstEffectOrder;
var array<float> burstEffectTimes;
var array<float> effectDistances;
var MOHAPlayerController PlayerController;

// Export UMOHAPlayerPlaneBase::execApplyShake(FFrame&, void* const)
native function ApplyShake(float DeltaTime);

// Export UMOHAPlayerPlaneBase::execUpdateFlak(FFrame&, void* const)
native function UpdateFlak(float DeltaTime);

// Export UMOHAPlayerPlaneBase::execFireFlakEffect(FFrame&, void* const)
native function FireFlakEffect(int Index);

// Export UMOHAPlayerPlaneBase::execPlayFlakSoundCue(FFrame&, void* const)
native function PlayFlakSoundCue(int Index);

// Export UMOHAPlayerPlaneBase::execUnloadAnimset(FFrame&, void* const)
native function UnloadAnimset(int MeshIndex);

function OnPlayHeroFlak(SeqAct_PlayHeroFlak Action)
{
    local Vector effectLocation;

    // End:0x31
    if((Action.socketNum < 0) || Action.socketNum > heroFlakEffectSockets.Length)
    {
        return;
    }
    customShakeInfo = Action.customShakeInfo;
    currentShakeInfo = customShakeInfo;
    bPlayingHeroShake = true;
    dampFactor = 1.0000000;
    distanceScaleFactor = 1.0000000;
    bCustomCamShakeEnabled = Action.bShakePlayerCamera;
    fShakeTime = 0.0000000;
    ShakePlayerCamera(1.0000000);
    heroFlakSystems[Action.socketNum].ActivateSystem();
    SkeletalMeshComponent.GetSocketWorldLocationAndRotation(heroFlakEffectSockets[Action.socketNum], effectLocation);
    PlaySoundAt(Action.HeroFlakSoundCue, effectLocation);
    //return;    
}

event ShakePlayerCamera(float dampValue)
{
    // End:0x92
    if(PlayerController != none)
    {
        PlayerController.CameraShake(currentShakeInfo.holdTime + currentShakeInfo.falloffTime, currentShakeInfo.camRollAmplitude * dampValue, currentShakeInfo.camRollFrequency, currentShakeInfo.camShakeAmplitude * dampValue, currentShakeInfo.camShakeFrequency, 0.0000000, 0.0000000);
    }
    //return;    
}

function AddNPCToPlane(MOHAITPNPC NPCToAdd)
{
    local int Index;

    Index = ITPNPCs.Length;
    ITPNPCs.Insert(Index, 1);
    ITPNPCs[ITPNPCs.Length - 1] = NPCToAdd;
    //return;    
}

function PauseNPCsBehindPlayer()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(I < ITPNPCs.Length)
    {
        // End:0x4B
        if(ITPNPCs[I].bIsBehindPlayer == true)
        {
            ITPNPCs[I].PauseAnim();
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function ResumeNPCsBehindPlayer()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(I < ITPNPCs.Length)
    {
        // End:0x4B
        if(ITPNPCs[I].bIsBehindPlayer == true)
        {
            ITPNPCs[I].ContinueAnim();
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function SetupEffectSockets()
{
    local string zeroFlakEffectName, heroFlakEffectName;
    local bool searchingZero, searchingHero;
    local int Index, I;
    local SkeletalMeshSocket curZeroSocket, curHeroSocket;
    local Vector toSocket, socketPos;

    searchingZero = true;
    searchingHero = true;
    Index = 0;
    I = 0;
    toSocket = Location;
    socketPos = Location;
    J0x34:

    // End:0x2D9 [Loop If]
    if(searchingZero || searchingHero)
    {
        // End:0x1D3
        if(searchingZero == true)
        {
            zeroFlakEffectName = "flakEffect" $ string(Index);
            curZeroSocket = SkeletalMeshComponent.GetSocketByName(name(zeroFlakEffectName));
            // End:0xA1
            if(curZeroSocket == none)
            {
                searchingZero = false;                
            }
            else
            {
                zeroFlakEffectSockets.Insert(Index, 1);
                zeroFlakEffectSockets[Index] = curZeroSocket.SocketName;
                SkeletalMeshComponent.GetSocketWorldLocationAndRotation(curZeroSocket.SocketName, socketPos);
                flakSystems.Insert(Index, 1);
                flakSystems[Index] = new (self) Class'Engine.ParticleSystemComponent';
                flakSystems[Index].SetTemplate(normalFlakPSys);
                flakSystems[Index].DeactivateSystem();
                SkeletalMeshComponent.AttachComponentToSocket(flakSystems[Index], curZeroSocket.SocketName);
                effectDistances.Insert(Index, 1);
                toSocket = Location - socketPos;
                effectDistances[Index] = ((toSocket.X ** 2.0000000) + (toSocket.Y ** 2.0000000)) + (toSocket.Z ** 2.0000000);
            }
        }
        // End:0x2CF
        if(searchingHero == true)
        {
            heroFlakEffectName = "heroFlakEffect" $ string(Index);
            curHeroSocket = SkeletalMeshComponent.GetSocketByName(name(heroFlakEffectName));
            // End:0x230
            if(curHeroSocket == none)
            {
                searchingHero = false;
                // [Explicit Continue]
                goto J0x2CF;
            }
            heroFlakEffectSockets.Insert(Index, 1);
            heroFlakEffectSockets[Index] = curHeroSocket.SocketName;
            heroFlakSystems.Insert(Index, 1);
            heroFlakSystems[Index] = new (self) Class'Engine.ParticleSystemComponent';
            heroFlakSystems[Index].SetTemplate(heroFlakPSys);
            heroFlakSystems[Index].DeactivateSystem();
            SkeletalMeshComponent.AttachComponentToSocket(heroFlakSystems[Index], curHeroSocket.SocketName);
        }
        J0x2CF:

        Index++;
        // [Loop Continue]
        goto J0x34;
    }
    // End:0x2EB
    if(minEffectsPerBurst < 0)
    {
        minEffectsPerBurst = 0;
    }
    // End:0x307
    if(maxEffectsPerBurst > zeroFlakEffectSockets.Length)
    {
        maxEffectsPerBurst = zeroFlakEffectSockets.Length;
    }
    // End:0x321
    if(minEffectsPerBurst > maxEffectsPerBurst)
    {
        minEffectsPerBurst = maxEffectsPerBurst;
    }
    // End:0x33B
    if(minTimeBetweenBursts > maxTimeBetweenBursts)
    {
        minTimeBetweenBursts = maxTimeBetweenBursts;
    }
    burstEffectTimes.Insert(0, zeroFlakEffectSockets.Length);
    burstEffectOrder.Insert(0, zeroFlakEffectSockets.Length);
    I = 0;
    J0x35C:

    // End:0x387 [Loop If]
    if(I < burstEffectOrder.Length)
    {
        burstEffectOrder[I] = I;
        I++;
        // [Loop Continue]
        goto J0x35C;
    }
    totalNumEffects = zeroFlakEffectSockets.Length;
    return;
    //return;    
}

function ITPPlayerJump()
{
    UnloadAnimset(0);
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;

    SetupEffectSockets();
    timeUntilBurstEnd = minBurstTime + (FRand() * (maxBurstTime - minBurstTime));
    SkeletalMeshComponent.AttachComponentToSocket(planeInterior, referenceSocketName);
    SkeletalMeshComponent.AttachComponentToSocket(planeExterior, referenceSocketName);
    SkeletalMeshComponent.AttachComponentToSocket(planeWindows, referenceSocketName);
    SkeletalMeshComponent.AttachComponentToSocket(destructionMesh, referenceSocketName);
    // End:0x149
    if(normalFlakSoundCue != none)
    {
        flakSoundAudioComponents.Insert(0, maxNumFlakSounds);
        I = 0;
        J0xA9:

        // End:0x146 [Loop If]
        if(I < maxNumFlakSounds)
        {
            flakSoundAudioComponents[I] = WorldInfo.CreateAudioComponent(normalFlakSoundCue, false, false);
            // End:0x135
            if(flakSoundAudioComponents[I] != none)
            {
                flakSoundAudioComponents[I].bUseOwnerLocation = false;
                flakSoundAudioComponents[I].bAutoDestroy = false;
                flakSoundAudioComponents[I].bFinished = true;
                // [Explicit Continue]
                goto J0x13C;
            }
            normalFlakSoundCue = none;
            J0x13C:

            I++;
            // [Loop Continue]
            goto J0xA9;
        }        
    }
    currentShakeInfo = defaultShakeInfo;
    bInitialized = true;
    //return;    
}

simulated function CleanUpAudioComponents()
{
    local int I;
    local editinline AudioComponent AudioComp;

    I = 0;
    J0x07:

    // End:0x6F [Loop If]
    if(I < flakSoundAudioComponents.Length)
    {
        AudioComp = flakSoundAudioComponents[I];
        // End:0x65
        if(AudioComp != none)
        {
            AudioComp.bAutoDestroy = true;
            // End:0x65
            if(AudioComp.bFinished)
            {
                AudioComp.Stop();
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    flakSoundAudioComponents.Length = 0;
    //return;    
}

simulated event Destroyed()
{
    CleanUpAudioComponents();
    super(Actor).Destroyed();
    //return;    
}

event StreamOutCleanup()
{
    CleanUpAudioComponents();
    super(Actor).StreamOutCleanup();
    //return;    
}

simulated function OnToggleFlakSounds(SeqAct_ToggleFlakSounds Action)
{
    bPlayFlakSounds = Action.soundsActive;
    //return;    
}

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    local AnimNodeSequence SeqNode;

    SeqNode = AnimNodeSequence(destructionMesh.Animations);
    destructionMesh.AnimSets = InAnimSets;
    SeqNode.SetAnim('None');
    //return;    
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies)
{
    local AnimNodeSequence SeqNode;

    // End:0x11
    if(InPosition <= 0.0000000)
    {
        return;
    }
    planeInterior.SetHidden(true);
    planeExterior.SetHidden(true);
    planeWindows.SetHidden(true);
    destructionMesh.SetHidden(false);
    SeqNode = AnimNodeSequence(destructionMesh.Animations);
    // End:0x9A
    if(SeqNode.AnimSeqName != InAnimSeqName)
    {
        SeqNode.SetAnim(InAnimSeqName);
    }
    SeqNode.SetPosition(InPosition, bFireNotifies);
    //return;    
}

defaultproperties
{
    referenceSocketName="Reference"
    // Reference: StaticMeshComponent'Default__MOHAPlayerPlaneBase.InteriorStaticMesh'
    begin object name=InteriorStaticMesh class=Class'Engine.StaticMeshComponent'
        Rotation=(Pitch=0,Yaw=16384,Roll=0)
    end object
    planeInterior=InteriorStaticMesh
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlaneBase.ExteriorSkeletalMesh'
    begin object name=ExteriorSkeletalMesh class=Class'Engine.SkeletalMeshComponent'
    end object
    planeExterior=ExteriorSkeletalMesh
    // Reference: StaticMeshComponent'Default__MOHAPlayerPlaneBase.windowMesh'
    begin object name=windowMesh class=Class'Engine.StaticMeshComponent'
        Rotation=(Pitch=0,Yaw=16384,Roll=0)
    end object
    planeWindows=windowMesh
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlaneBase.destructionMeshComponent'
    begin object name=destructionMeshComponent class=Class'Engine.SkeletalMeshComponent'
        Animations=AnimNodeSequence'Default__MOHAPlayerPlaneBase.AnimNodeSeq1'
        HiddenGame=true
        HiddenEditor=true
    end object
    destructionMesh=destructionMeshComponent
    bCamShakeEnabled=true
    bCustomCamShakeEnabled=true
    bPlayFlakSounds=true
    bScaleShakeWithDistance=true
    minTimeBetweenBursts=2.0000000
    maxTimeBetweenBursts=3.0000000
    minEffectsPerBurst=5
    maxEffectsPerBurst=6
    maxBurstTime=4.0000000
    minBurstTime=3.0000000
    minTimeBetweenEffects=0.1000000
    maxTimeBetweenEffects=0.5000000
    maxNumFlakSounds=5
    timeUntilNextBurst=5.0000000
    defaultShakeInfo=(ShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),shakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),camShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),camShakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),camRollAmplitude=(X=200.0000000,Y=200.0000000,Z=90.0000000),camRollFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),rollAmplitude=20.0000000,rollFrequency=1000.0000000,falloffTime=0.7500000,holdTime=0.2500000)
    customShakeInfo=(ShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),shakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),camShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),camShakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),camRollAmplitude=(X=200.0000000,Y=200.0000000,Z=90.0000000),camRollFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),rollAmplitude=20.0000000,rollFrequency=1000.0000000,falloffTime=0.7500000,holdTime=0.2500000)
    currentShakeInfo=(ShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),shakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),camShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),camShakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),camRollAmplitude=(X=200.0000000,Y=200.0000000,Z=90.0000000),camRollFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),rollAmplitude=20.0000000,rollFrequency=1000.0000000,falloffTime=0.7500000,holdTime=0.2500000)
    flakShakeMaxDistance=3500.0000000
    dampFactor=1.0000000
    distanceScaleFactor=1.0000000
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlaneBase.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__MOHAPlayerPlaneBase.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAPlayerPlaneBase.MyLightEnvironment'
        CollideActors=false
        BlockZeroExtent=false
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAPlayerPlaneBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__MOHAPlayerPlaneBase.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    Components[3]=InteriorStaticMesh
    Components[4]=windowMesh
    Components[5]=destructionMeshComponent
    Components[6]=ExteriorSkeletalMesh
    Physics=7
    CollisionComponent=SkeletalMeshComponent0
    CollisionType=0
}