class EvilRailCar_Vehicle_Base extends EvilRailCar_Base
    hidecategories(Navigation);

var() protected transient EvilRailCarWheels_Base WheelActor;
var protected const editconst class<EvilRailCarWheels_Base> WheelActorClass;
var protected export editinline transient SkeletalMeshComponent EditorWheelsPreviewMesh;
var() protected const bool bNoAudio;
var transient bool bPlayerAudioIsPlaying;
var transient bool bNonPlayerAudioIsPlaying;
var() protected repnotify bool bEngineRunning;
var() protected const bool bNoJiggle;
var() bool bAlwaysUpdateWheels;
var() bool bLeftDoorOpen;
var() bool bRightDoorOpen;
var() protected transient float EngineRPM;
var protected transient float LastEngineRPM;
var() protected const float EngineRPMInterpSpeed;
var() protected const Vector2D EngineRPMAccelRange;
var() protected const Vector2D EngineRPMVelRange;
var protected transient Vector LastActualVelocity;
var() Vector ForwardDir;
var export editinline AudioComponent PlayerEngineMainLoop;
var() protected transient SoundCue PlayerEngineMainLoopCue;
var export editinline AudioComponent EngineMainLoop;
var() protected transient SoundCue EngineMainLoopCue;
var() protected const SoundCue StopEngineSound;
var() protected const SoundCue StartEngineSound;

replication
{
    // Pos:0x000
    if(bNetDirty)
        bEngineRunning, bLeftDoorOpen, 
        bRightDoorOpen;
}

protected simulated function AudioComponent CreateNonSpatializedComponent(SoundCue Cue, Pawn P)
{
    local editinline AudioComponent AC;

    AC = P.CreateAudioComponent(Cue, false, true);
    // End:0xE9
    if(AC != none)
    {
        AC.bUseOwnerLocation = true;
        AC.bAllowSpatialization = false;
        AC.bAutoDestroy = false;
        AC.bShouldRemainActiveIfDropped = true;
        AC.Play();
    }
    return AC;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x7B
    if(WheelActorClass != none)
    {
        WheelActor = Spawn(WheelActorClass, self,, Location, Rotation,, true);
        // End:0x7B
        if(WheelActor != none)
        {
            WheelActor.AttachToVehicle(self);
        }
    }
    // End:0xFA
    if(!Class'Engine.Engine'.static.IsEditor() && EditorWheelsPreviewMesh != none)
    {
        EditorWheelsPreviewMesh.SetHidden(true);
        EditorWheelsPreviewMesh.DetachFromAny();
        EditorWheelsPreviewMesh = none;
    }
    // End:0x131
    if(StaticMeshComponent != none)
    {
        StaticMeshComponent.SetLightEnvironment(LightEnvironment);
    }
    DetachComponent(EditorWheelsPreviewMesh);
    EditorWheelsPreviewMesh = none;
    // End:0x178
    if(bShouldShadowParentAllAttachedActors)
    {
        SetShadowParentOnAllAttachedComponents(StaticMeshComponent, LightEnvironment);
    }
    //return;    
}

protected simulated event SetupAudio(bool bDoingPlayerAudio, bool bDoingNonPlayerAudio, Pawn LocallyControlledPawn)
{
    // End:0xEA
    if(bDoingPlayerAudio)
    {
        // End:0x5C
        if(PlayerEngineMainLoop == none)
        {
            PlayerEngineMainLoop = CreateNonSpatializedComponent(((PlayerEngineMainLoopCue != none) ? PlayerEngineMainLoopCue : EngineMainLoopCue), LocallyControlledPawn);
        }
        // End:0xB9
        if(PlayerEngineMainLoop != none)
        {
            // End:0x9A
            if(bEngineRunning)
            {
                PlayerEngineMainLoop.Play();                
            }
            else
            {
                PlayerEngineMainLoop.Stop();
            }
        }
        // End:0xE7
        if(EngineMainLoop != none)
        {
            EngineMainLoop.Stop();
        }        
    }
    else
    {
        // End:0x123
        if(EngineMainLoop == none)
        {
            EngineMainLoop = CreateAudioComponent(EngineMainLoopCue, true, true, true, Location, true);
        }
        // End:0x180
        if(EngineMainLoop != none)
        {
            // End:0x161
            if(bEngineRunning)
            {
                EngineMainLoop.Play();                
            }
            else
            {
                EngineMainLoop.Stop();
            }
        }
        // End:0x1AE
        if(PlayerEngineMainLoop != none)
        {
            PlayerEngineMainLoop.Stop();
        }
    }
    // End:0x1F0
    if(WheelActor != none)
    {
        WheelActor.SetupAudio(bDoingPlayerAudio, bDoingNonPlayerAudio);
    }
    bPlayerAudioIsPlaying = bDoingPlayerAudio;
    bNonPlayerAudioIsPlaying = bDoingNonPlayerAudio;
    //return;    
}

simulated event ShutDown()
{
    super(InterpActor).ShutDown();
    // End:0x3C
    if(WheelActor != none)
    {
        WheelActor.Destroy();
        WheelActor = none;
    }
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super(Actor).OnToggleHidden(Action);
    // End:0x7B
    if((WheelActor != none) && bHidden != WheelActor.bHidden)
    {
        WheelActor.SetWheelsHidden(bHidden);
    }
    // End:0x98
    if(bHidden)
    {
        SetupAudio(false, false, none);        
    }
    else
    {
        bPlayerAudioIsPlaying = false;
        bNonPlayerAudioIsPlaying = false;
    }
    //return;    
}

simulated function StopEngine()
{
    SetupAudio(false, false, none);
    PlaySound(StopEngineSound, true);
    bEngineRunning = false;
    //return;    
}

simulated function StartEngine()
{
    PlaySound(StartEngineSound, true);
    bEngineRunning = true;
    bPlayerAudioIsPlaying = false;
    bNonPlayerAudioIsPlaying = false;
    //return;    
}

simulated function OnRailCarVehicleControl(SeqAct_RailCarVehicleControl Action)
{
    // End:0x89
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x50
        if(!bEngineRunning)
        {
            StartEngine();
        }
        Action.InputLinks[0].bHasImpulse = false;        
    }
    else
    {
        // End:0x10D
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0xD7
            if(bEngineRunning)
            {
                StopEngine();
            }
            Action.InputLinks[1].bHasImpulse = false;
        }
    }
    // End:0x18B
    if(Action.InputLinks[2].bHasImpulse)
    {
        ChangeDoorState(true, true);
        Action.InputLinks[2].bHasImpulse = false;        
    }
    else
    {
        // End:0x206
        if(Action.InputLinks[3].bHasImpulse)
        {
            ChangeDoorState(true, false);
            Action.InputLinks[3].bHasImpulse = false;
        }
    }
    // End:0x284
    if(Action.InputLinks[4].bHasImpulse)
    {
        ChangeDoorState(false, true);
        Action.InputLinks[4].bHasImpulse = false;        
    }
    else
    {
        // End:0x2FF
        if(Action.InputLinks[5].bHasImpulse)
        {
            ChangeDoorState(false, false);
            Action.InputLinks[5].bHasImpulse = false;
        }
    }
    ForceNetRelevant();
    //return;    
}

simulated function ChangeDoorState(bool Left, bool Open)
{
    // End:0x25
    if(Left)
    {
        bLeftDoorOpen = Open;        
    }
    else
    {
        bRightDoorOpen = Open;
    }
    // End:0x69
    if(WheelActor != none)
    {
        WheelActor.UpdateDoorState();
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x3E
    if(VarName == 'bEngineRunning')
    {
        // End:0x31
        if(bEngineRunning)
        {
            StartEngine();            
        }
        else
        {
            StopEngine();
        }        
    }
    else
    {
        super(DynamicSMActor).ReplicatedEvent(VarName);
    }
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    super(InterpActor).ApplyCheckpointRecord(Record);
    // End:0x4B
    if(WheelActor != none)
    {
        WheelActor.SetWheelsHidden(bHidden);
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Pawn LocallyControlledRiderPawn;
    local EvilPlayerController PC;
    local Vector ActualAccel, VehicleFVec;
    local float ForwardAccelMag, RPMFromAccel, RPMFromVel, TotalRPM;

    super.Tick(DeltaTime);
    // End:0x5B2
    if((!bHidden && bEngineRunning) && !bNoAudio)
    {
        LocallyControlledRiderPawn = none;
        // End:0x188
        foreach WorldInfo.LocalPlayerControllers(Class'EvilPlayerController', PC)
        {
            // End:0x187
            if(((PC != none) && PC.Pawn != none) && PC.Pawn.Base == self)
            {
                LocallyControlledRiderPawn = PC.Pawn;
                // End:0x184
                if(EvilPawn(PC.Pawn) != none)
                {
                    EvilPawn(PC.Pawn).ClampedBase = self;
                }
                // End:0x188
                break;
            }            
        }        
        // End:0x1D0
        if((LocallyControlledRiderPawn == none) && bPlayerAudioIsPlaying || !bNonPlayerAudioIsPlaying)
        {
            SetupAudio(false, true, LocallyControlledRiderPawn);            
        }
        else
        {
            // End:0x214
            if((LocallyControlledRiderPawn != none) && !bPlayerAudioIsPlaying || bNonPlayerAudioIsPlaying)
            {
                SetupAudio(true, false, LocallyControlledRiderPawn);
            }
        }
        // End:0x278
        if(bPlayerAudioIsPlaying && PlayerEngineMainLoop != none)
        {
            // End:0x275
            if(!PlayerEngineMainLoop.IsPlaying())
            {
                PlayerEngineMainLoop.Play();
            }            
        }
        else
        {
            // End:0x2D9
            if(bNonPlayerAudioIsPlaying && EngineMainLoop != none)
            {
                // End:0x2D9
                if(!EngineMainLoop.IsPlaying())
                {
                    EngineMainLoop.Play();
                }
            }
        }
        ActualAccel = (Velocity - LastActualVelocity) / DeltaTime;
        // End:0x375
        if(VSizeSq(ActualAccel) > 0.0010000)
        {
            ActualAccel += (vect(0.0000000, 0.0000000, 1.0000000) * ((self.GetGravityZ() * Normal(Velocity).Z) / -DeltaTime));
        }
        VehicleFVec = Vector(Rotation) >> Rotator(ForwardDir);
        ForwardAccelMag = ActualAccel Dot VehicleFVec;
        RPMFromAccel = FMax(FPctByRange(ForwardAccelMag, EngineRPMAccelRange.X, EngineRPMAccelRange.Y), 0.0000000);
        RPMFromVel = FMax(FPctByRange(VSize(Velocity), EngineRPMVelRange.X, EngineRPMVelRange.Y), 0.0000000);
        TotalRPM = FClamp(RPMFromVel + RPMFromAccel, 0.0000000, 1.0000000);
        EngineRPM = FInterpTo(LastEngineRPM, TotalRPM, DeltaTime, EngineRPMInterpSpeed);
        // End:0x512
        if(PlayerEngineMainLoop != none)
        {
            PlayerEngineMainLoop.SetFloatParameter('EngineSpeed', EngineRPM);
        }
        // End:0x552
        if(EngineMainLoop != none)
        {
            EngineMainLoop.SetFloatParameter('EngineSpeed', EngineRPM);
        }
        // End:0x589
        if(WheelActor != none)
        {
            WheelActor.UpdateEngineAudio(EngineRPM);
        }
        LastActualVelocity = Velocity;
        LastEngineRPM = EngineRPM;        
    }
    else
    {
        // End:0x5DB
        if(bPlayerAudioIsPlaying || bNonPlayerAudioIsPlaying)
        {
            SetupAudio(false, false, none);
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__EvilRailCar_Vehicle_Base.EditorWheelsPreviewMesh0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'EditorWheelsPreviewMesh0'
    begin object name="EditorWheelsPreviewMesh0" class=Class'Engine.SkeletalMeshComponent'
        ReplacementPrimitive=none
        HiddenGame=true
    end object
    EditorWheelsPreviewMesh=EditorWheelsPreviewMesh0
    bNoJiggle=true
    EngineRPMInterpSpeed=0.3500000
    EngineRPMAccelRange=(X=30.0000000,Y=2500.0000000)
    EngineRPMVelRange=(X=100.0000000,Y=1400.0000000)
    ForwardDir=(X=1.0000000,Y=0.0000000,Z=0.0000000)
    bAlwaysConfineToClampedBase=true
    // Reference: StaticMeshComponent'Default__EvilRailCar_Vehicle_Base.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Default__EvilRailCar_Base.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilRailCar_Vehicle_Base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilRailCar_Vehicle_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilRailCar_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=EditorWheelsPreviewMesh0
    CollisionType=ECollisionType.COLLIDE_BlockAll
    BlockRigidBody=true
    bCollideActors=true
    bBlockActors=true
    CollisionComponent=StaticMeshComponent0
}