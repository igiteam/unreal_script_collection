class AdvRailCar_Minecart_Experimental_Base extends AdvRailCar_Base
    hidecategories(Navigation);

var() protected export editinline SkeletalMeshComponent MinecartWheels;
var bool bAnimPlaying;
var AnimNodeSlot MinecartAnimNodeSlot;
var AnimNodeScalePlayRate PlayRateNode;
var() AdvActionHands_Base ActionHands;
var() protected transient float RideRPM;
var protected transient float LastRideRPM;
var() protected const float RideRPMInterpSpeed;
var() protected const Vector2D RideRPMAccelRange;
var() protected const Vector2D RideRPMVelRange;
var() name FrontSeatSocket;
var() name BackSeatSocket;
var export editinline AudioComponent PlayerRideMainLoop;
var() protected transient SoundCue PlayerRideMainLoopCue;
var export editinline AudioComponent RideMainLoop;
var() protected transient SoundCue RideMainLoopCue;
var() protected const SoundCue BreaksRideSound;
var() protected const SoundCue JumpRideSound;
var() protected const SoundCue LandRideSound;

simulated function PostBeginPlay()
{
    local int Idx;
    local Vector SocketLocation;

    super(EvilRailCar_Vehicle_Base).PostBeginPlay();
    Idx = 0;
    J0x15:

    // End:0x113 [Loop If]
    if(Idx < AttachedKeyList.Length)
    {
        // End:0x72
        if(Idx == 0)
        {
            MinecartWheels.GetSocketWorldLocationAndRotation(FrontSeatSocket, SocketLocation);            
        }
        else
        {
            // End:0xB4
            if(Idx == 1)
            {
                MinecartWheels.GetSocketWorldLocationAndRotation(BackSeatSocket, SocketLocation);
            }
        }
        AttachedKeyList[Idx].SetLocation(SocketLocation);
        AttachedKeyList[Idx].SetBase(self);
        Idx++;
        // [Loop Continue]
        goto J0x15;
    }
    // End:0x142
    if(ActionHands != none)
    {
        ActionHands.SetHidden(true);
    }
    MinecartAnimNodeSlot = AnimNodeSlot(MinecartWheels.FindAnimNode('CustomAnim'));
    PlayRateNode = AnimNodeScalePlayRate(MinecartWheels.FindAnimNode('ScalePlayRate'));
    //return;    
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

protected simulated event SetupAudio(bool bDoingPlayerAudio, bool bDoingNonPlayerAudio, Pawn LocallyControlledPawn)
{
    // End:0xBB
    if(bDoingPlayerAudio)
    {
        // End:0x5C
        if(PlayerRideMainLoop == none)
        {
            PlayerRideMainLoop = CreateNonSpatializedComponent(((PlayerRideMainLoopCue != none) ? PlayerRideMainLoopCue : RideMainLoopCue), LocallyControlledPawn);
        }
        // End:0x8A
        if(PlayerRideMainLoop != none)
        {
            PlayerRideMainLoop.Play();
        }
        // End:0xB8
        if(RideMainLoop != none)
        {
            RideMainLoop.Stop();
        }        
    }
    else
    {
        // End:0xF4
        if(RideMainLoop == none)
        {
            RideMainLoop = CreateAudioComponent(RideMainLoopCue, true, true, true, Location, true);
        }
        // End:0x122
        if(RideMainLoop != none)
        {
            RideMainLoop.Play();
        }
        // End:0x150
        if(PlayerRideMainLoop != none)
        {
            PlayerRideMainLoop.Stop();
        }
    }
    bPlayerAudioIsPlaying = bDoingPlayerAudio;
    bNonPlayerAudioIsPlaying = bDoingNonPlayerAudio;
    //return;    
}

simulated function Breaks()
{
    PlaySound(BreaksRideSound, true);
    //return;    
}

simulated function Jump()
{
    SetupAudio(false, false, none);
    PlaySound(JumpRideSound, true);
    //return;    
}

simulated function Land()
{
    PlaySound(LandRideSound, true);
    bPlayerAudioIsPlaying = false;
    bNonPlayerAudioIsPlaying = false;
    //return;    
}

simulated function OnRailCarMinecartControl(SeqAct_RailCarMinecartControl Action)
{
    // End:0x77
    if(Action.InputLinks[0].bHasImpulse)
    {
        Breaks();
        Action.InputLinks[0].bHasImpulse = false;
    }
    // End:0xF1
    if(Action.InputLinks[1].bHasImpulse)
    {
        Jump();
        Action.InputLinks[1].bHasImpulse = false;        
    }
    else
    {
        // End:0x16D
        if(Action.InputLinks[2].bHasImpulse)
        {
            Land();
            Action.InputLinks[2].bHasImpulse = false;            
        }
        else
        {
            // End:0x2FE
            if(Action.InputLinks[3].bHasImpulse)
            {
                // End:0x2C7
                if(ActionHands != none)
                {
                    ActionHands.SetHidden(false);
                    ActionHands.PlayAnimation(Action.HandsAnimName, Action.Duration, Action.BlendInTime, Action.BlendOutTime, Action.bLooping, Action.bOverride, Action.StartTime);
                }
                Action.InputLinks[3].bHasImpulse = false;
            }
        }
    }
    ForceNetRelevant();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Pawn LocallyControlledRiderPawn;
    local EvilPlayerController PC;
    local Vector ActualAccel, VehicleFVec;
    local float ForwardAccelMag, RPMFromAccel, RPMFromVel, TotalRPM;
    local int Idx;

    super.Tick(DeltaTime);
    // End:0x73
    if(bForceAlignView)
    {
        Idx = 0;
        J0x2B:

        // End:0x73 [Loop If]
        if(Idx < AttachedPawnList.Length)
        {
            AttachedPawnList[0].ClampedBase = self;
            Idx++;
            // [Loop Continue]
            goto J0x2B;
        }
    }
    // End:0x657
    if(!bHidden && !bNoAudio)
    {
        LocallyControlledRiderPawn = none;
        // End:0x16E
        foreach WorldInfo.LocalPlayerControllers(Class'EvilGame.EvilPlayerController', PC)
        {
            // End:0x16D
            if(((PC != none) && PC.Pawn != none) && PC.Pawn.Base == self)
            {
                LocallyControlledRiderPawn = PC.Pawn;
                // End:0x16E
                break;
            }            
        }        
        // End:0x1B6
        if((LocallyControlledRiderPawn == none) && bPlayerAudioIsPlaying || !bNonPlayerAudioIsPlaying)
        {
            SetupAudio(false, true, LocallyControlledRiderPawn);            
        }
        else
        {
            // End:0x1FA
            if((LocallyControlledRiderPawn != none) && !bPlayerAudioIsPlaying || bNonPlayerAudioIsPlaying)
            {
                SetupAudio(true, false, LocallyControlledRiderPawn);
            }
        }
        // End:0x25E
        if(bPlayerAudioIsPlaying && PlayerRideMainLoop != none)
        {
            // End:0x25B
            if(!PlayerRideMainLoop.IsPlaying())
            {
                PlayerRideMainLoop.Play();
            }            
        }
        else
        {
            // End:0x2BF
            if(bNonPlayerAudioIsPlaying && RideMainLoop != none)
            {
                // End:0x2BF
                if(!RideMainLoop.IsPlaying())
                {
                    RideMainLoop.Play();
                }
            }
        }
        ActualAccel = (Velocity - LastActualVelocity) / DeltaTime;
        // End:0x35B
        if(VSizeSq(ActualAccel) > 0.0010000)
        {
            ActualAccel += (vect(0.0000000, 0.0000000, 1.0000000) * ((self.GetGravityZ() * Normal(Velocity).Z) / -DeltaTime));
        }
        VehicleFVec = Vector(Rotation) >> Rotator(ForwardDir);
        ForwardAccelMag = ActualAccel Dot VehicleFVec;
        RPMFromAccel = FMax(FPctByRange(ForwardAccelMag, RideRPMAccelRange.X, RideRPMAccelRange.Y), 0.0000000);
        RPMFromVel = FMax(FPctByRange(VSize(Velocity), RideRPMVelRange.X, RideRPMVelRange.Y), 0.0000000);
        TotalRPM = FClamp(RPMFromVel + RPMFromAccel, 0.0000000, 1.0000000);
        RideRPM = FInterpTo(LastRideRPM, TotalRPM, DeltaTime, RideRPMInterpSpeed);
        // End:0x4F8
        if(PlayerRideMainLoop != none)
        {
            PlayerRideMainLoop.SetFloatParameter('RideSpeed', RideRPM);
        }
        // End:0x538
        if(RideMainLoop != none)
        {
            RideMainLoop.SetFloatParameter('RideSpeed', RideRPM);
        }
        // End:0x62E
        if(MinecartAnimNodeSlot != none)
        {
            // End:0x5E1
            if(RideRPM > float(0))
            {
                // End:0x5A1
                if(!bAnimPlaying)
                {
                    MinecartAnimNodeSlot.PlayAnim(true, RideRPM, 0.0000000);
                    bAnimPlaying = true;
                }
                // End:0x5DE
                if(PlayRateNode != none)
                {
                    PlayRateNode.ScaleByValue = RPMFromVel * float(10);
                }                
            }
            else
            {
                // End:0x62E
                if((RPMFromVel <= 0.0100000) && bAnimPlaying)
                {
                    MinecartAnimNodeSlot.StopAnim();
                    bAnimPlaying = false;
                }
            }
        }
        LastActualVelocity = Velocity;
        LastRideRPM = RideRPM;        
    }
    else
    {
        // End:0x680
        if(bPlayerAudioIsPlaying || bNonPlayerAudioIsPlaying)
        {
            SetupAudio(false, false, none);
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvRailCar_Minecart_Experimental_Base.Minecart0'
    begin object name=Minecart0 class=Class'Engine.SkeletalMeshComponent'
        ReplacementPrimitive=none
        CanBlockCamera=false
    end object
    MinecartWheels=Minecart0
    RideRPMInterpSpeed=0.3500000
    RideRPMAccelRange=(X=30.0000000,Y=2500.0000000)
    RideRPMVelRange=(X=100.0000000,Y=1400.0000000)
    // Reference: SkeletalMeshComponent'Default__AdvRailCar_Minecart_Experimental_Base.EditorWheelsPreviewMesh0'
    begin object name=EditorWheelsPreviewMesh0
        ReplacementPrimitive=none
    end object
    EditorWheelsPreviewMesh=EditorWheelsPreviewMesh0
    bForceAlignView=true
    // Reference: StaticMeshComponent'Default__AdvRailCar_Minecart_Experimental_Base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvRailCar_Minecart_Experimental_Base.MyLightEnvironment'
        Rotation=(Pitch=0,Yaw=-16382,Roll=0)
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvRailCar_Minecart_Experimental_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=EditorWheelsPreviewMesh0
    Components[3]=Minecart0
    CollisionComponent=StaticMeshComponent0
}