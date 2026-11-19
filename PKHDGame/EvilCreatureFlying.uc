class EvilCreatureFlying extends EvilCreature
    config(Game)
    hidecategories(Navigation);

enum EBirdBlendIndices
{
    BBI_Idle,                       // 0
    BBI_Takeoff,                    // 1
    BBI_FlyFast,                    // 2
    BBI_FlySlow,                    // 3
    BBI_FlySoar,                    // 4
    BBI_Landing,                    // 5
    BBI_MAX                         // 6
};

var() float LookAheadInterval;
var() float LookAheadTime;
var transient float LandingTime;
var transient Rotator LastDir;
var transient bool bFirstSetDestinationPass;

simulated function Takeoff()
{
    //return;    
}

function LookAhead()
{
    local Vector TestPoint;
    local EvilCreatureRoamVolume CRV;
    local bool Found;

    // End:0x33
    if(IsInState('Idle') || IsInState('Stop') && bFoundSpot)
    {
        return;
    }
    TestPoint = Location + ((DesiredSpeed * Vector(DesiredRotation)) * LookAheadTime);
    Found = false;
    // End:0xDC
    foreach MyArea.Volumes(CRV)
    {
        // End:0xDB
        if(CRV.EncompassesPoint(TestPoint))
        {
            Found = true;            
        }
        else
        {            
        }
    }    
    // End:0xFC
    if(!Found)
    {
        UpdateDesiredRotation(3.0000000);
    }
    //return;    
}

function UpdateDesiredRotation(optional float SpeedMult = 1.0000000, optional bool bSlowdownLinearVel = true)
{
    local float Delta, InterpTime;
    local Vector Diff;

    Diff = DesiredLocation - Location;
    MyDesiredRotation = Rotator(Diff);
    Delta = FindDeltaAngle(float(NormalizeRotAxis(MyDesiredRotation.Yaw)) * 0.0000959, float(NormalizeRotAxis(Rotation.Yaw)) * 0.0000959);
    // End:0x11A
    if((MyDesiredRotation == DesiredRotation) && ((Abs(Delta) < 0.0880000) && !IsDesiredRotationInUse()) || (Abs(Delta) >= 0.0880000) && IsDesiredRotationInUse())
    {
        return;
    }
    MyDesiredRotation.Roll = Clamp(int((Delta * 10430.3800000) * -0.7000000), -16384, 16384);
    InterpTime = (10430.3800000 * Abs(FindDeltaAngle(float(Rotation.Yaw) * 0.0000959, float(MyDesiredRotation.Yaw) * 0.0000959))) / float(default.RotationRate.Yaw);
    SpeedMult = 1.0000000 / SpeedMult;
    SpeedMult *= FClamp((VSize(Diff) / 1024.0000000) + 0.2000000, 0.5000000, 1.0000000);
    SpeedMult *= FClamp((Diff Dot Vector(Rotation)) + 0.3000000, 0.5000000, 1.0000000);
    InterpTime *= SpeedMult;
    // End:0x2A0
    if(bSlowdownLinearVel)
    {
        DesiredSpeed = default.Speed * SpeedMult;
    }
    LockDesiredRotation(false);
    SetDesiredRotation(MyDesiredRotation, true, true, InterpTime, true);
    //return;    
}

function SetRandDest(optional bool reschedule = true)
{
    local float MoveInterval;
    local bool InLockDesiredRotation, InUnlockWhenReached;
    local float InterpolationTime, angbet;
    local Vector MoveDirection;

    DesiredLocation = GetAccessibleRoamPoint();
    MoveDirection = DesiredLocation - Location;
    MyDesiredRotation = Rotator(MoveDirection);
    angbet = 10430.3800000 * Abs(FindDeltaAngle(float(Rotation.Yaw) * 0.0000959, float(Rotator(MoveDirection).Yaw) * 0.0000959));
    // End:0x185
    if(!bFoundSpot)
    {
        DesiredSpeed = RandRange(0.5000000, 1.5000000) * default.Speed;
        // End:0x146
        if(DesiredSpeed < default.Speed)
        {
            BaseBlendNode.SetActiveChild(3, BaseBlendNode.BlendTime);            
        }
        else
        {
            BaseBlendNode.SetActiveChild(2, BaseBlendNode.BlendTime);
        }
    }
    MyDesiredRotation.Roll = Clamp(int((-FindDeltaAngle(float(MyDesiredRotation.Yaw) * 0.0000959, float(Rotation.Yaw) * 0.0000959) * 10430.3800000) * 0.7000000), -16384, 16384);
    MoveInterval = VSize(MoveDirection) / Speed;
    LockDesiredRotation(false);
    InLockDesiredRotation = true;
    InUnlockWhenReached = true;
    InterpolationTime = angbet / float(default.RotationRate.Yaw);
    SetDesiredRotation(MyDesiredRotation, InLockDesiredRotation, InUnlockWhenReached, InterpolationTime);
    // End:0x309
    if(reschedule)
    {
        SetTimer(RandRange(FMin(MinTravelTime, MoveInterval), FMin(MaxTravelTime, MoveInterval)), false, 'SetRandDest');
    }
    //return;    
}

function SetStopDestination()
{
    local int I, AngleDiffPitch, AngleDiffYaw;
    local EvilCreatureSpot DestSpot;
    local Vector HitLocation, HitNormal, LandOffset;

    // End:0x4E2
    if((MyArea != none) && MyArea.Spots.Length > 0)
    {
        I = 0;
        J0x41:

        // End:0x493 [Loop If]
        if(I < MyArea.Spots.Length)
        {
            LandOffset = (Normal(VRand()) * vect(1.0000000, 1.0000000, 0.0000000)) * (MyArea.Spots[I].Radius - ((GetCollisionRadius()) * float(2)));
            DestSpot = MyArea.Spots[I];
            AngleDiffPitch = int(Abs(FindDeltaAngle(float(Rotator((DestSpot.Location + LandOffset) - Location).Pitch) * 0.0000959, float(Rotation.Pitch) * 0.0000959) * 57.2957800));
            AngleDiffYaw = int(Abs(FindDeltaAngle(float(Rotator((DestSpot.Location + LandOffset) - Location).Yaw) * 0.0000959, float(Rotation.Yaw) * 0.0000959) * 57.2957800));
            // End:0x485
            if((AngleDiffPitch < 60) && AngleDiffYaw < 45)
            {
                // End:0x2D9
                if(Trace(HitLocation, HitNormal, DestSpot.Location + LandOffset,, false) == none)
                {
                    HitLocation = DestSpot.Location + LandOffset;
                }
                // End:0x485
                if(!DestSpot.bCheckCollision || Trace(HitLocation, HitNormal, HitLocation - (DestSpot.Radius * vect(0.0000000, 0.0000000, 2.0000000)), HitLocation + (DestSpot.Radius * vect(0.0000000, 0.0000000, 2.0000000)), false) != none)
                {
                    // End:0x485
                    if(VSize(HitLocation - DestSpot.Location) < (DestSpot.Radius - ((GetCollisionRadius()) * float(2))))
                    {
                        DesiredLocation = DestSpot.Location + LandOffset;
                        bFoundSpot = true;
                        StopFailureCounter = 0;
                        Mesh.SetAbsolute(false, true, false);
                        Mesh.SetRotation(Rotation);
                        // [Explicit Break]
                        goto J0x493;
                    }
                }
            }
            I++;
            // [Loop Continue]
            goto J0x41;
        }
        J0x493:

        // End:0x4E2
        if(!bFoundSpot)
        {
            SetTimer(RandRange(MinTravelTime, MaxTravelTime), false, 'SetStopDestination');
            SetRandDest(false);
            ++StopFailureCounter;
        }
    }
    //return;    
}

function SetRunAwayDestination()
{
    local int I;
    local Vector HitLocation, HitNormal;

    I = 0;
    J0x0B:

    // End:0x1D0 [Loop If]
    if(I < 10)
    {
        DesiredLocation = GetAccessibleRoamPoint();
        // End:0x6B
        if(Trace(HitLocation, HitNormal, DesiredLocation,, true) == none)
        {
            HitLocation = DesiredLocation;
        }
        DesiredLocation = DesiredLocation;
        // End:0x1C2
        if(VSizeSq(HitLocation - DesiredLocation) <= float(64 * 64))
        {
            bFoundSpot = true;
            LockDesiredRotation(false);
            SetDesiredRotation(Rotator(DesiredLocation - Location), true, true, GetRangeValueByPct(vect2d(0.5000000, 5.0000000), GetRangePctByValue(vect2d(100.0000000, 1000.0000000), FClamp(VSize(DesiredLocation - Location), 100.0000000, 1000.0000000)) * (1.0000000 - GetRangePctByValue(vect2d(4096.0000000, 32767.0000000), float(Clamp(NormalizeRotAxis(Rotator(DesiredLocation - Location).Yaw - Rotation.Yaw), 4096, 32767))))), true);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    SetTimer(RandRange(1.0000000, 2.0000000), false, 'SetRunAwayDestination');
    //return;    
}

simulated function OrientAndPropelPawn()
{
    //return;    
}

private final function RandomizeLookAhead()
{
    SetTimer(LookAheadInterval, true, 'LookAhead');
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(FRand() * LookAheadInterval, false, 'RandomizeLookAhead');
    SetTimer(1.0000000, true, 'RecalcVolumeCoverage');
    //return;    
}

function RecalcVolumeCoverage()
{
    local bool Found;
    local EvilCreatureRoamVolume CRV;
    local float sum;

    Found = IsInState('Idle') || IsInState('Stop') && bFoundSpot;
    // End:0xA5
    if(!Found)
    {
        // End:0xA4
        foreach MyArea.Volumes(CRV)
        {
            // End:0xA3
            if(CRV.Encompasses(self))
            {
                Found = true;
            }            
        }        
    }
    // End:0xE9
    if(Found)
    {
        TimeInsideVolumes += (WorldInfo.TimeSeconds - LastVolumeBoundaryCrossTime);        
    }
    else
    {
        TimeOutsideVolumes += (WorldInfo.TimeSeconds - LastVolumeBoundaryCrossTime);
    }
    LastVolumeBoundaryCrossTime = WorldInfo.TimeSeconds;
    sum = TimeInsideVolumes + TimeOutsideVolumes;
    VolumeCoverage = ((sum == float(0)) ? 1.0000000 : TimeInsideVolumes / sum);
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    super(Actor).Bump(Other, OtherComp, HitNormal);
    // End:0x5F
    if(Other.IsA('Pawn'))
    {
        MakeNoise(float(PanicRange), 'AggresiveStop');
    }
    //return;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    super(Actor).HitWall(HitNormal, Wall, WallComp);
    GotoState('RunAway');
    //return;    
}

function SetSpeed(float DeltaTime)
{
    super.SetSpeed(DeltaTime);
    Speed = FMax(100.0000000, Speed);
    //return;    
}

auto state Idle
{
    ignores Bump, HitWall;

    function SetMovementPhysics()
    {
        Velocity.X = 0.0000000;
        Velocity.Y = 0.0000000;
        SetPhysics(1);
        //return;        
    }

    simulated function Tick(float Delta)
    {
        IdleTimer -= Delta;
        // End:0xDE
        if((IdleTimer <= float(0)) && BaseBlendNode.ActiveChildIndex != 1)
        {
            BaseBlendNode.SetActiveChild(1, BaseBlendNode.BlendTime);
            AnimNodeSequence(BaseBlendNode.Children[1].Anim).PlayAnim();
        }
        //return;        
    }

    simulated function Takeoff()
    {
        GotoState('TakingOff');
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0xBD
        if((BaseBlendNode.ActiveChildIndex != 5) || !AnimNodeSequence(BaseBlendNode.Children[5].Anim).bPlaying)
        {
            BaseBlendNode.SetActiveChild(0, BaseBlendNode.BlendTime);
        }
        ResetTimers();
        SetPhysics(1);
        LockDesiredRotation(false);
        SetDesiredRotation(MakeRotator(0, Rotation.Yaw, 0), false, true);
        SetRotation(DesiredRotation);
        ClearTimer('SetRandDest');
        ResetDesiredRotation();
        RotationRate = MakeRotator(0, 0, 0);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        AccelRate = default.AccelRate;
        Speed = default.Speed * 0.5000000;
        //return;        
    }

    simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        BaseBlendNode.SetActiveChild(0, BaseBlendNode.BlendTime);
        //return;        
    }
Begin:

    ResetTimers();
    stop;        
}

state RunAway
{
    simulated function Tick(float Delta)
    {
        super(EvilCreature).Tick(Delta);
        // End:0x24
        if(MyArea == none)
        {
            return;
        }
        SetSpeed(Delta);
        // End:0x85
        if((VSize(DesiredLocation - Location) <= float(512)) && bFoundSpot == true)
        {
            bFoundSpot = false;
            GotoState('Run');
        }
        OrientAndPropelPawn();
        //return;        
    }

    simulated function OrientAndPropelPawn()
    {
        Velocity = Normal(Vector(DesiredRotation)) * Speed;
        // End:0x157
        if(Abs(float(DesiredRotation.Yaw - Rotation.Yaw)) > float(15))
        {
            // End:0x100
            if(DesiredRotation.Yaw > Rotation.Yaw)
            {
                SetRotation(MakeRotator(Rotation.Pitch, int(float(Rotation.Yaw) + (float(5) * 182.0444000)), 0));                
            }
            else
            {
                SetRotation(MakeRotator(Rotation.Pitch, int(float(Rotation.Yaw) - (float(5) * 182.0444000)), 0));
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetCollision(false, false);
        // End:0x6B
        if(BaseBlendNode.ActiveChildIndex == 0)
        {
            BaseBlendNode.SetActiveChild(1, BaseBlendNode.BlendTime);            
        }
        else
        {
            BaseBlendNode.SetActiveChild(2, BaseBlendNode.BlendTime);
        }
        SetPhysics(4);
        ResetTimers();
        bFoundSpot = false;
        DesiredSpeed = default.Speed;
        SetRunAwayDestination();
        //return;        
    }

    function ResetTimers()
    {
        global.ResetTimers();
        ClearTimer('SetRandDest');
        ClearTimer('SetStopDestination');
        //return;        
    }

    simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        BaseBlendNode.SetActiveChild(2, BaseBlendNode.BlendTime);
        //return;        
    }
Begin:

    ResetTimers();
    stop;        
}

state Run
{
    simulated function Tick(float Delta)
    {
        super(EvilCreature).Tick(Delta);
        // End:0x24
        if(MyArea == none)
        {
            return;
        }
        SetSpeed(Delta);
        // End:0x64
        if(VSize(DesiredLocation - Location) <= float(256))
        {
            SetRandDest();
        }
        Velocity = Normal(Vector(Rotation)) * Speed;
        RunTimer -= Delta;
        // End:0xBC
        if(RunTimer <= float(0))
        {
            GotoState('Stop');            
        }
        else
        {
            UpdateDesiredRotation(1.0000000);
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        BaseBlendNode.SetActiveChild(2, BaseBlendNode.BlendTime);
        ResetTimers();
        DesiredSpeed = default.Speed;
        SetRandDest();
        bCollideWorld = false;
        //return;        
    }

    function ResetTimers()
    {
        global.ResetTimers();
        ClearTimer('SetRunAwayDestination');
        ClearTimer('SetStopDestination');
        //return;        
    }
Begin:

    ResetTimers();
    stop;        
}

state Stop
{
    function SetMovementPhysics()
    {
        SetPhysics(4);
        //return;        
    }

    simulated function Tick(float Delta)
    {
        local Rotator Rot;
        local float D, rotmod;

        super(EvilCreature).Tick(Delta);
        // End:0x24
        if(MyArea == none)
        {
            return;
        }
        SetSpeed(Delta);
        D = VSize(DesiredLocation - Location);
        // End:0x6D2
        if(bFoundSpot)
        {
            // End:0xA7
            if(D <= ((GetCollisionRadius()) * float(2)))
            {
                ClearTimer('SetStopDestination');
                GotoState('Idle');                
            }
            else
            {
                // End:0x207
                if(!bCollideWorld)
                {
                    SetRotation(Normalize(Rotation));
                    LockDesiredRotation(false, true);
                    ResetDesiredRotation();
                    RotationRate = default.RotationRate;
                    SetDesiredRotation(Rotator(DesiredLocation - Location), true, true,, true);
                    DesiredSpeed = 20.0000000;
                    rotmod = RDiff(DesiredRotation, Rotation) / 180.0000000;
                    rotmod = 1.0000000 + (4.0000000 * rotmod);
                    AccelRate = (Speed * Speed) / (2.0000000 * ((D * rotmod) - float(96)));
                    LandingTime = WorldInfo.TimeSeconds + ((Speed - float(100)) / AccelRate);
                    bCollideWorld = true;
                }
                // End:0x3B6
                if((BaseBlendNode.ActiveChildIndex != 5) && (LandingTime - WorldInfo.TimeSeconds) <= (Mesh.GetAnimLength(AnimNodeSequence(BaseBlendNode.Children[5].Anim).AnimSeqName) * AnimNodeSequence(BaseBlendNode.Children[5].Anim).Rate))
                {
                    BaseBlendNode.SetActiveChild(5, BaseBlendNode.BlendTime);
                    AnimNodeSequence(BaseBlendNode.Children[5].Anim).PlayAnim();
                }
                UpdateDesiredRotation(,, false);
                // End:0x421
                if((VSizeSq(Location - LastLocation) < 1.0000000) && D <= float(256))
                {
                    MakeNoise(float(PanicRange), 'AggresiveStop');
                    GotoState('RunAway');                    
                }
                else
                {
                    // End:0x4E7
                    if(D <= float(384))
                    {
                        SetRotation(Rotator(DesiredLocation - Location));
                        Rot = Rotation;
                        Rot.Pitch = int(FInterpTo(float(Rot.Pitch), 0.0000000, Delta, 4.0000000));
                        Mesh.SetRotation(Rot);                        
                    }
                    else
                    {
                        // End:0x5B4
                        if(D <= float(1024))
                        {
                            Rot = Rotation;
                            Rot.Pitch = int(FInterpTo(float(Rot.Pitch), float(Rotation.Pitch + 8000), Delta, 4.0000000));
                            Mesh.SetRotation(Rot);                            
                        }
                        else
                        {
                            Rot = Rotation;
                            Rot.Pitch = int(FInterpTo(float(Rot.Pitch), 8000.0000000, Delta, 4.0000000));
                            Mesh.SetRotation(Rot);
                        }
                    }
                }
                Rot = Rotation + (Rotator(DesiredLocation - Location) - LastDir);
                SetRotation(Rot);
                LastDir = Rotator(DesiredLocation - Location);
                Velocity = Normal(Vector(Rotation)) * Speed;
            }            
        }
        else
        {
            // End:0x6FE
            if(VSize(DesiredLocation - Location) <= float(256))
            {
                SetStopDestination();
            }
            UpdateDesiredRotation(1.0000000);
            Velocity = Normal(Vector(Rotation)) * Speed;
        }
        LastLocation = Location;
        //return;        
    }

    function ResetTimers()
    {
        global.ResetTimers();
        ClearTimer('SetRunAwayDestination');
        ClearTimer('SetRandDest');
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetCollision(true, false);
        ResetTimers();
        bFoundSpot = false;
        SetStopDestination();
        //return;        
    }

    function EndState(name NewStateName)
    {
        Mesh.SetAbsolute(false, false, false);
        Mesh.SetRotation(MakeRotator(0, 0, 0));
        //return;        
    }
Begin:

    ResetTimers();
    stop;        
}

state TakingOff extends RunAway
{
    simulated function OrientAndPropelPawn()
    {
        Velocity = Normal(Vector(Rotation)) * Speed;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        bFirstSetDestinationPass = true;
        bCollideWorld = false;
        super.BeginState(PreviousStateName);
        //return;        
    }

    function SetRunAwayDestination()
    {
        // End:0x1D
        if(!bFirstSetDestinationPass)
        {
            GotoState('RunAway');
        }
        bFirstSetDestinationPass = false;
        super(EvilCreatureFlying).SetRunAwayDestination();
        //return;        
    }
    stop;    
}

defaultproperties
{
    LookAheadInterval=0.5000000
    LookAheadTime=0.5000000
    bRollToDesired=true
    // Reference: SkeletalMeshComponent'Default__EvilCreatureFlying.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__EvilCreature.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilCreatureFlying.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilCreatureFlying.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilCreature.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__EvilCreatureFlying.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilCreature.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    Components[0]=MyLightEnvironment
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=WPawnSkeletalMeshComponent
    CollisionComponent=CollisionCylinder
}