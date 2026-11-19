class EvilRailCarWheels_Base extends Actor
    notplaceable
    hidecategories(Navigation);

struct VehicleWheel
{
    var() float WheelRadius;
    var() name BoneName;
    var() name SkelControlName;
    var SkelControlWheel WheelControl;
    var() bool bIsSteeringWheel;
    var Matrix WheelRefPoseTM;
    var() float FreeSpinningFrictionDecel;
    var bool bHasContact;
    var bool bHadContact;
    var Vector LastContactPos;
    var float RollVel;
    var Rotator LastRot;
    var Vector Location;
    var Rotator Rotation;
    var() float WheelRoll;
    var() Vector WheelRayBaseOffset;
    var int FramesSinceLastTrace;
    var float WheelDispPerFrameAdjust;

    structdefaultproperties
    {
        WheelRadius=0.0000000
        BoneName="None"
        SkelControlName="None"
        WheelControl=none
        bIsSteeringWheel=false
        WheelRefPoseTM=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        FreeSpinningFrictionDecel=0.0000000
        bHasContact=false
        bHadContact=false
        LastContactPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RollVel=0.0000000
        LastRot=(Pitch=0,Yaw=0,Roll=0)
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        WheelRoll=0.0000000
        WheelRayBaseOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FramesSinceLastTrace=0
        WheelDispPerFrameAdjust=0.0000000
    }
};

var() protected const export editinline SkeletalMeshComponent Mesh;
var transient EvilRailCar_Vehicle_Base VehicleBody;
var() protected const name SteeringPivotBoneName;
var protected transient Vector LastSteeringPivotLoc;
var protected transient Rotator LastLocalSteerRot;
var() protected const float SteerInterpSpeed;
var protected transient float SteerYaw;
var export editinline transient AudioComponent EngineAudio_Player_Left;
var protected const SoundCue EngineAudio_Player_LeftCue;
var export editinline transient AudioComponent EngineAudio_Player_Right;
var protected const SoundCue EngineAudio_Player_RightCue;
var protected export editinline AudioComponent SuspensionAudio_Player_FrontRight;
var protected const SoundCue SuspensionAudio_Player_FrontRightCue;
var protected export editinline AudioComponent SuspensionAudio_Player_FrontLeft;
var protected const SoundCue SuspensionAudio_Player_FrontLeftCue;
var() protected const Vector2D SuspensionAudioRandomTimeRange;
var() protected const float SuspensionAudioVelocityThreshold;
var() array<VehicleWheel> Wheels;
var() int WheelTraceInterval;
var protected transient bool bForceUpdateWheelsNextTick;
var protected transient bool bResetInterpolation;
var() float MinDistFactorForUpdate;
var protected transient SkelControlBase LeftDoorControl;
var protected transient SkelControlBase RightDoorControl;
var protected const SoundCue DoorOpenCue;
var protected const SoundCue DoorCloseCue;
var protected transient AnimNodeBlend JiggleAnimControl;
var protected transient Vector LastVelocity;
var() protected const float AccelJiggleScalar;
var() protected const float JiggleFadeTime;

protected simulated function AudioComponent CreateAndAttachAudioComponent(SoundCue Cue, name SocketName, optional bool bPlayImmediately)
{
    local editinline AudioComponent AC;

    AC = CreateAudioComponent(Cue, false, true,,, false);
    // End:0xF2
    if(AC != none)
    {
        AC.bUseOwnerLocation = true;
        Mesh.AttachComponentToSocket(AC, SocketName);
        AC.bAutoDestroy = false;
        AC.bShouldRemainActiveIfDropped = true;
        // End:0xF2
        if(bPlayImmediately)
        {
            AC.Play();
        }
    }
    return AC;
    //return ReturnValue;    
}

protected simulated function TriggerSuspensionSound_FrontRight()
{
    // End:0x48
    if(VSize(Velocity) > SuspensionAudioVelocityThreshold)
    {
        SuspensionAudio_Player_FrontRight = PlayVehicleAudioComponent(SuspensionAudio_Player_FrontRight, SuspensionAudio_Player_FrontRightCue, 'SuspensionAudio_FrontRight');
    }
    SetTimer(RandRange(SuspensionAudioRandomTimeRange.X, SuspensionAudioRandomTimeRange.Y), false, 'TriggerSuspensionSound_FrontRight');
    //return;    
}

protected simulated function TriggerSuspensionSound_FrontLeft()
{
    // End:0x48
    if(VSize(Velocity) > SuspensionAudioVelocityThreshold)
    {
        SuspensionAudio_Player_FrontLeft = PlayVehicleAudioComponent(SuspensionAudio_Player_FrontLeft, SuspensionAudio_Player_FrontLeftCue, 'SuspensionAudio_FrontLeft');
    }
    SetTimer(RandRange(SuspensionAudioRandomTimeRange.X, SuspensionAudioRandomTimeRange.Y), false, 'TriggerSuspensionSound_FrontLeft');
    //return;    
}

simulated function AttachToVehicle(EvilRailCar_Vehicle_Base Vehicle)
{
    VehicleBody = Vehicle;
    SetBase(Vehicle);
    SetRelativeLocation(vect(0.0000000, 0.0000000, 0.0000000));
    SetRelativeRotation(rot(0, 0, 0));
    Mesh.SetShadowParent(Vehicle.StaticMeshComponent);
    Mesh.SetLightEnvironment(Vehicle.LightEnvironment);
    Mesh.ForcedLodModel = Vehicle.StaticMeshComponent.ForcedLodModel;
    // End:0x149
    if(Vehicle.bHidden)
    {
        SetWheelsHidden(true);
    }
    UpdateDoorState(true);
    //return;    
}

protected simulated function AudioComponent PlayVehicleAudioComponent(AudioComponent AC, SoundCue Cue, name SocketName)
{
    // End:0x36
    if(AC == none)
    {
        AC = CreateAndAttachAudioComponent(Cue, SocketName);
    }
    // End:0x64
    if(AC != none)
    {
        AC.Play();
    }
    return AC;
    //return ReturnValue;    
}

protected simulated function StopAudioComponent(AudioComponent AC, optional float FadeOutTime)
{
    // End:0x3D
    if(AC != none)
    {
        AC.FadeOut(FadeOutTime, 0.0000000);
    }
    //return;    
}

simulated function SetupAudio(bool bDoingPlayerAudio, bool bDoingNonPlayerAudio)
{
    // End:0x10E
    if(bDoingPlayerAudio)
    {
        EngineAudio_Player_Left = PlayVehicleAudioComponent(EngineAudio_Player_Left, EngineAudio_Player_LeftCue, 'EngineAudio_Left');
        EngineAudio_Player_Right = PlayVehicleAudioComponent(EngineAudio_Player_Right, EngineAudio_Player_RightCue, 'EngineAudio_Right');
        SetTimer(RandRange(SuspensionAudioRandomTimeRange.X, SuspensionAudioRandomTimeRange.Y), false, 'TriggerSuspensionSound_FrontRight');
        SetTimer(RandRange(SuspensionAudioRandomTimeRange.X, SuspensionAudioRandomTimeRange.Y), false, 'TriggerSuspensionSound_FrontLeft');        
    }
    else
    {
        StopAudioComponent(EngineAudio_Player_Left);
        StopAudioComponent(EngineAudio_Player_Right);
        ClearTimer('TriggerSuspensionSound_FrontRight');
        ClearTimer('TriggerSuspensionSound_FrontLeft');
    }
    //return;    
}

function PostBeginPlay()
{
    local int Idx;

    super.PostBeginPlay();
    CacheWheelRefPoseTMs();
    Idx = 0;
    J0x1F:

    // End:0xEF [Loop If]
    if(Idx < Wheels.Length)
    {
        Wheels[Idx].WheelControl = SkelControlWheel(Mesh.FindSkelControl(Wheels[Idx].SkelControlName));
        Wheels[Idx].FramesSinceLastTrace = Rand(WheelTraceInterval - 1);
        ++Idx;
        // [Loop Continue]
        goto J0x1F;
    }
    JiggleAnimControl = AnimNodeBlend(Mesh.FindAnimNode('JiggleControl'));
    LeftDoorControl = UDKSkelControl_Rotate(Mesh.FindSkelControl('DoorLeft'));
    RightDoorControl = UDKSkelControl_Rotate(Mesh.FindSkelControl('DoorRight'));
    //return;    
}

simulated function SetWheelsHidden(bool bNewHidden)
{
    SetHidden(bNewHidden);
    // End:0x36
    if(bNewHidden)
    {
        bResetInterpolation = true;
        SetCollision(false, false, true);        
    }
    else
    {
        bForceUpdateWheelsNextTick = true;
        SetCollision(default.bCollideActors, default.bBlockActors, default.bIgnoreEncroachers);
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local bool bRecentlyRendered;
    local Vector ActualAccel, UVec;
    local Matrix RotMat;
    local float ZAxisAccelMag, NewJigglePct, FadedNewJigglePct;

    super.Tick(DeltaTime);
    bRecentlyRendered = LastRenderTime > (WorldInfo.TimeSeconds - 0.5000000);
    // End:0x368
    if((((bRecentlyRendered && !bHidden) && Mesh.MaxDistanceFactor >= MinDistFactorForUpdate) || (VehicleBody != none) && VehicleBody.bAlwaysUpdateWheels) || bForceUpdateWheelsNextTick)
    {
        // End:0x327
        if((JiggleAnimControl != none) && VehicleBody != none)
        {
            ActualAccel = (VehicleBody.Velocity - LastVelocity) / DeltaTime;
            RotMat = MakeRotationMatrix(Rotation);
            UVec.X = RotMat.ZPlane.X;
            UVec.Y = RotMat.ZPlane.Y;
            UVec.Z = RotMat.ZPlane.Z;
            ZAxisAccelMag = Abs(ActualAccel Dot UVec);
            NewJigglePct = FMin(ZAxisAccelMag * AccelJiggleScalar, 1.0000000);
            FadedNewJigglePct = FMax(JiggleAnimControl.Child2Weight - (DeltaTime / JiggleFadeTime), 0.0000000);
            JiggleAnimControl.SetBlendTarget(FMax(FadedNewJigglePct, NewJigglePct), 0.0000000);
            LastVelocity = VehicleBody.Velocity;
        }
        UpdateSteering(DeltaTime);
        UpdateWheels(DeltaTime);
        bResetInterpolation = false;
        bForceUpdateWheelsNextTick = false;        
    }
    else
    {
        bResetInterpolation = true;
    }
    //return;    
}

simulated function UpdateEngineAudio(float EngineSpeed)
{
    // End:0x40
    if(EngineAudio_Player_Left != none)
    {
        EngineAudio_Player_Left.SetFloatParameter('EngineSpeed', EngineSpeed);
    }
    // End:0x80
    if(EngineAudio_Player_Right != none)
    {
        EngineAudio_Player_Right.SetFloatParameter('EngineSpeed', EngineSpeed);
    }
    //return;    
}

simulated function CacheWheelRefPoseTMs()
{
    local int BoneIndex, I;
    local Matrix tmp;
    local BoneAtom ba;

    // End:0x909
    if((Mesh != none) && Mesh.SkeletalMesh != none)
    {
        I = 0;
        J0x40:

        // End:0x909 [Loop If]
        if(I < Wheels.Length)
        {
            BoneIndex = Mesh.MatchRefBone(Wheels[I].BoneName);
            // End:0xBC
            if(BoneIndex == -1)
            {
                return;
            }
            ba = Mesh.SkeletalMesh.RefBasesInvMatrix[BoneIndex];
            tmp = MakeRotationTranslationMatrix(ba.Translation, QuatToRotator(ba.Rotation));
            Wheels[I].WheelRefPoseTM.XPlane.X = tmp.XPlane.X;
            Wheels[I].WheelRefPoseTM.YPlane.X = tmp.XPlane.Y;
            Wheels[I].WheelRefPoseTM.ZPlane.X = tmp.XPlane.Z;
            Wheels[I].WheelRefPoseTM.XPlane.Y = tmp.YPlane.X;
            Wheels[I].WheelRefPoseTM.YPlane.Y = tmp.YPlane.Y;
            Wheels[I].WheelRefPoseTM.ZPlane.Y = tmp.YPlane.Z;
            Wheels[I].WheelRefPoseTM.XPlane.Z = tmp.ZPlane.X;
            Wheels[I].WheelRefPoseTM.YPlane.Z = tmp.ZPlane.Y;
            Wheels[I].WheelRefPoseTM.ZPlane.Z = tmp.ZPlane.Z;
            Wheels[I].WheelRefPoseTM.XPlane.W = -tmp.WPlane.X;
            Wheels[I].WheelRefPoseTM.YPlane.W = -tmp.WPlane.Y;
            Wheels[I].WheelRefPoseTM.ZPlane.W = -tmp.WPlane.Z;
            Wheels[I].WheelRefPoseTM.WPlane.X = -tmp.XPlane.W;
            Wheels[I].WheelRefPoseTM.WPlane.Y = -tmp.YPlane.W;
            Wheels[I].WheelRefPoseTM.WPlane.Z = -tmp.ZPlane.W;
            Wheels[I].WheelRefPoseTM.WPlane.W = 1.0000000;
            ++I;
            // [Loop Continue]
            goto J0x40;
        }
    }
    //return;    
}

simulated function UpdateWheels(float DeltaTime)
{
    local Vector BaseVel, BaseWheelPosWorld, StartTrace, EndTrace, HitLocation, HitNormal;

    local float DesiredWheelDisplacement, CurrentDelta, DegreesRot;
    local int I;

    // End:0x9FD
    if((Mesh != none) && Mesh.SkeletalMesh != none)
    {
        // End:0x6C
        if(Base != none)
        {
            BaseVel = Base.Velocity;
        }
        I = 0;
        J0x77:

        // End:0x9FD [Loop If]
        if(I < Wheels.Length)
        {
            // End:0xFE
            if(Wheels[I].bIsSteeringWheel)
            {
                Wheels[I].WheelControl.WheelSteering = SteerYaw;
            }
            // End:0x9EF
            if(Wheels[I].WheelControl != none)
            {
                BaseWheelPosWorld = Mesh.GetBoneLocation(Wheels[I].BoneName) + (Wheels[I].WheelRayBaseOffset >> Rotation);
                StartTrace = BaseWheelPosWorld + (vect(0.0000000, 0.0000000, 1.0000000) * Wheels[I].WheelRadius);
                EndTrace = BaseWheelPosWorld - (vect(0.0000000, 0.0000000, 1.0000000) * (Wheels[I].WheelRadius + 64.0000000));
                Wheels[I].FramesSinceLastTrace++;
                DesiredWheelDisplacement = 0.0000000;
                // End:0x497
                if((Wheels[I].FramesSinceLastTrace >= WheelTraceInterval) || bResetInterpolation)
                {
                    Wheels[I].FramesSinceLastTrace = 0;
                    Wheels[I].bHasContact = VehicleBody.Trace(HitLocation, HitNormal, EndTrace, StartTrace, false) != none;
                    // End:0x40A
                    if(Wheels[I].bHasContact)
                    {
                        DesiredWheelDisplacement = FClamp(Wheels[I].WheelRadius - VSize(HitLocation - BaseWheelPosWorld), 0.0000000, Wheels[I].WheelControl.WheelMaxRenderDisplacement);
                    }
                    CurrentDelta = DesiredWheelDisplacement - Wheels[I].WheelControl.WheelDisplacement;
                    Wheels[I].WheelDispPerFrameAdjust = CurrentDelta / float(WheelTraceInterval);
                }
                // End:0x54A
                if(bResetInterpolation)
                {
                    Wheels[I].WheelControl.WheelDisplacement = DesiredWheelDisplacement;
                    Wheels[I].WheelDispPerFrameAdjust = 0.0000000;
                    Wheels[I].FramesSinceLastTrace = Rand(WheelTraceInterval);                    
                }
                else
                {
                    Wheels[I].WheelControl.WheelDisplacement += Wheels[I].WheelDispPerFrameAdjust;
                }
                // End:0x77E
                if(Wheels[I].bHasContact)
                {
                    // End:0x752
                    if(Wheels[I].bHadContact)
                    {
                        DegreesRot = ((180.0000000 * (BaseVel Dot (VehicleBody.ForwardDir >> Rotation))) * DeltaTime) / (3.1415930 * Wheels[I].WheelRadius);
                        Wheels[I].WheelRoll += DegreesRot;
                        Wheels[I].WheelControl.WheelRoll = Wheels[I].WheelRoll;
                        Wheels[I].RollVel = DegreesRot / DeltaTime;                        
                    }
                    Wheels[I].bHadContact = true;                    
                }
                else
                {
                    // End:0x85E
                    if(Wheels[I].RollVel < 0.0000000)
                    {
                        Wheels[I].RollVel += (Wheels[I].FreeSpinningFrictionDecel * DeltaTime);
                        Wheels[I].RollVel = FMin(Wheels[I].RollVel, 0.0000000);                        
                    }
                    else
                    {
                        Wheels[I].RollVel -= (Wheels[I].FreeSpinningFrictionDecel * DeltaTime);
                        Wheels[I].RollVel = FMax(Wheels[I].RollVel, 0.0000000);
                    }
                    Wheels[I].WheelRoll += (Wheels[I].RollVel * DeltaTime);
                    Wheels[I].WheelControl.WheelRoll = Wheels[I].WheelRoll;
                    Wheels[I].bHadContact = false;
                }
            }
            ++I;
            // [Loop Continue]
            goto J0x77;
        }
    }
    //return;    
}

simulated function bool AreSteeringWheelsOnGround()
{
    local VehicleWheel Wheel;

    // End:0x5D
    foreach Wheels(Wheel)
    {
        // End:0x5C
        if(Wheel.bIsSteeringWheel && Wheel.bHasContact)
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

simulated function UpdateSteering(float DeltaTime)
{
    local Vector SteeringLoc, SteeringDisplacement, SteeringDirNorm;
    local float SteeringDisplacementLen;
    local Rotator IdealLocalSteerRot, LocalSteerRot;

    SteeringLoc = Mesh.GetBoneLocation(SteeringPivotBoneName);
    SteeringDisplacement = SteeringLoc - LastSteeringPivotLoc;
    SteeringDisplacementLen = VSize(SteeringDisplacement);
    // End:0x1B5
    if((SteeringDisplacementLen > 0.1000000) && AreSteeringWheelsOnGround())
    {
        SteeringDirNorm = SteeringDisplacement / SteeringDisplacementLen;
        // End:0xFA
        if((SteeringDirNorm Dot (VehicleBody.ForwardDir >> Rotation)) < 0.0000000)
        {
            SteeringDirNorm = -SteeringDirNorm;
        }
        SteeringDirNorm = (SteeringDirNorm << Rotation) << Rotator(VehicleBody.ForwardDir);
        IdealLocalSteerRot = Rotator(SteeringDirNorm);
        LocalSteerRot = ((bResetInterpolation) ? IdealLocalSteerRot : RInterpTo(LastLocalSteerRot, IdealLocalSteerRot, DeltaTime, SteerInterpSpeed));
        LastLocalSteerRot = LocalSteerRot;
    }
    SteerYaw = float(LocalSteerRot.Yaw) * 0.0054932;
    LastSteeringPivotLoc = SteeringLoc;
    //return;    
}

simulated function UpdateDoorState(optional bool quiet = false)
{
    local int I;
    local SkelControlBase SC;
    local bool Open;

    SC = LeftDoorControl;
    Open = VehicleBody.bLeftDoorOpen;
    I = 0;
    J0x4D:

    // End:0x1D2 [Loop If]
    if(I < 2)
    {
        // End:0x187
        if(SC != none)
        {
            // End:0x187
            if((SC.ControlStrength ~= 1.0000000) != Open)
            {
                // End:0xED
                if(quiet)
                {
                    SC.SetSkelControlStrength(((Open) ? 1.0000000 : 0.0000000), 0.0000000);                    
                }
                else
                {
                    // End:0x126
                    if(Open && DoorOpenCue != none)
                    {
                        PlaySound(DoorOpenCue);                        
                    }
                    else
                    {
                        // End:0x15E
                        if(!Open && DoorCloseCue != none)
                        {
                            PlaySound(DoorCloseCue);
                        }
                    }
                    SC.SetSkelControlActive(Open);
                }
            }
        }
        SC = RightDoorControl;
        Open = VehicleBody.bRightDoorOpen;
        ++I;
        // [Loop Continue]
        goto J0x4D;
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__EvilRailCarWheels_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0" class=Class'Engine.SkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=false
        ReplacementPrimitive=none
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
    end object
    Mesh=SkeletalMeshComponent0
    SteeringPivotBoneName="b_SteeringPivot"
    SteerInterpSpeed=2.0000000
    SuspensionAudioRandomTimeRange=(X=8.0000000,Y=20.0000000)
    SuspensionAudioVelocityThreshold=-1.0000000
    WheelTraceInterval=10
    MinDistFactorForUpdate=0.3000000
    AccelJiggleScalar=0.0150000
    JiggleFadeTime=2.0000000
    Components[0]=SkeletalMeshComponent0
    CollisionType=ECollisionType.COLLIDE_BlockWeapons
    TickGroup=ETickingGroup.TG_DuringAsyncWork
    bHardAttach=true
    bCollideActors=true
    bProjTarget=true
    CollisionComponent=SkeletalMeshComponent0
}