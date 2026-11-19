class AdvInventoryItem_Compass extends AdvInventoryItem_Base
    config(Weapon)
    hidecategories(Navigation);

var SkelControlSingleBone PointerController;
var MaterialInstanceConstant MaterialControler;
var SkelControlSingleBone WarpController;
var AdvTreasureTrigger_Base NextTarget;
var Vector NorthVector;
var bool bUsingNorthVector;
var bool AutomaticTargetFinding;
var bool AllowShowHints;
var float TimeElapsed;
var float CurrentDegree;
var float TransitionTime;
var float TransitionDelay;
var int LastTargetYaw;
var float MaxDistanceToTarget;
var export editinline ParticleSystemComponent WarpParticleSystem;
var transient float alienFxIntervalCounter;
var AdvPlayerController PC;

simulated function bool FindBestTargetFor(EvilPawn P, out Actor SelectedActor)
{
    local AdvTreasureTrigger_Base TargetProp, BestTarget;
    local float DistanceProp, BestDistance;

    // End:0x389
    if(AutomaticTargetFinding)
    {
        BestDistance = MaxDistanceToTarget;
        // End:0x14E
        foreach AllActors(Class'AdvTreasureTrigger_Base', TargetProp)
        {
            // End:0x14D
            if(((TargetProp != NextTarget) && !TargetProp.bCollected) && TargetProp.bShowOnCompassEvenWhenNotEnabled || TargetProp.Enabled)
            {
                DistanceProp = VSize2D(TargetProp.Location - P.Location);
                // End:0x14D
                if(DistanceProp < BestDistance)
                {
                    BestDistance = DistanceProp;
                    BestTarget = TargetProp;
                }
            }            
        }        
        // End:0x199
        if(PC == none)
        {
            PC = AdvPlayerController(AdvPlayerPawn(Owner).GetPlayerController());
        }
        // End:0x23A
        if((AdvPlayerPawn(Owner).WeaponLeft != self) && NextTarget != none)
        {
            TickAlienwareFXCompass(float(Min(int(BestDistance), int(VSize2D(NextTarget.Location - P.Location)))));
        }
        // End:0x2FF
        if(((NextTarget == none) && BestTarget != none) || ((NextTarget != none) && BestTarget != none) && VSize2D(NextTarget.Location - P.Location) > BestDistance)
        {
            SelectedActor = BestTarget;
            SetNextTarget(BestTarget);
            return true;            
        }
        else
        {
            // End:0x389
            if((NextTarget != none) && NextTarget.bCollected || !NextTarget.bShowOnCompassEvenWhenNotEnabled && !NextTarget.Enabled)
            {
                SetNextTarget(none);
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool CheckTargetIsValidFor(EvilPawn P, bool InRange)
{
    local Vector ToTarget;
    local float ToTargetLength;

    // End:0x10D
    if(((NextTarget != none) && !NextTarget.bCollected) && NextTarget.bShowOnCompassEvenWhenNotEnabled || NextTarget.Enabled)
    {
        // End:0x10B
        if(InRange)
        {
            ToTarget = NextTarget.Location - P.Location;
            ToTargetLength = VSize2D(ToTarget);
            // End:0x108
            if(ToTargetLength < MaxDistanceToTarget)
            {
                return true;
            }            
        }
        else
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function float GetToTargetDistancePercFor(EvilPawn P)
{
    local Vector ToTarget;
    local float ToTargetLength;

    // End:0xA1
    if(NextTarget != none)
    {
        ToTarget = NextTarget.Location - P.Location;
        ToTargetLength = VSize2D(ToTarget);
        return ((MaxDistanceToTarget == float(0)) ? 2.0000000 : ToTargetLength / MaxDistanceToTarget);
    }
    return 0.0000000;
    //return ReturnValue;    
}

function TickAlienwareFXCompass(float Distance)
{
    // End:0x35A
    if(Distance < MaxDistanceToTarget)
    {
        // End:0x1CF
        if(AdvPlayerPawn(Owner).WeaponLeft == self)
        {
            PC.compassDuration = FClamp(Distance / MaxDistanceToTarget, PC.minBlinkTime, 1.0000000);
            // End:0x108
            if(PC.CheckAlienFxLight(1) && PC.CheckAlienFx(1))
            {
                PC.ClearAlienFx(1);
            }
            // End:0x17C
            if(!PC.CheckAlienFx(1))
            {
                PC.SetAlienFxLight(0, 255, 150, 0, 1, 0, PC.compassDuration, -1);
            }
            PC.SetAlienFxTimerRate(1, 0, 'SetAlienFxLast', PC.compassDuration * float(2));            
        }
        else
        {
            PC.compassDuration = FClamp(Distance / MaxDistanceToTarget, PC.minBlinkTime, 1.0000000);
            // End:0x293
            if(PC.CheckAlienFxLight(0) && PC.CheckAlienFx(1))
            {
                PC.ClearAlienFx(1);
            }
            // End:0x307
            if(!PC.CheckAlienFx(1))
            {
                PC.SetAlienFxLight(1, 255, 150, 0, 1, 1, PC.compassDuration, -1);
            }
            PC.SetAlienFxTimerRate(1, 1, 'SetAlienFxLast', PC.compassDuration * float(2));
        }        
    }
    else
    {
        // End:0x3A0
        if(PC.CheckAlienFx(1))
        {
            PC.ClearAlienFx(1);
        }
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Vector ToTarget;
    local Rotator TargetDirection, CRotation;
    local int Offset, Correction;
    local float ToTargetLength, SineDistortions, Alpha;
    local bool bHasValidTarget;
    local LinearColor LC;
    local float PercentToTarget, Highlight;

    TimeElapsed += (DeltaTime * float(10));
    Highlight = 0.0000000;
    // End:0x4C
    if(NextTarget != none)
    {
        alienFxIntervalCounter += DeltaTime;
    }
    // End:0x834
    if(PointerController != none)
    {
        // End:0x81
        if(int(WeaponHand) == int(3))
        {
            Correction = -1;            
        }
        else
        {
            Correction = 1;
        }
        // End:0x15C
        if(NextTarget != none)
        {
            ToTarget = NextTarget.Location - self.Location;
            ToTargetLength = VSize2D(ToTarget);
            // End:0x15C
            if((alienFxIntervalCounter >= 0.2500000) && AdvPlayerPawn(Owner).WeaponLeft == self)
            {
                alienFxIntervalCounter = 0.0000000;
                TickAlienwareFXCompass(ToTargetLength);
            }
        }
        bHasValidTarget = (ToTargetLength > float(0)) && ToTargetLength < MaxDistanceToTarget;
        // End:0x26A
        if(!bHasValidTarget && !IsZero(NorthVector))
        {
            ToTarget = NorthVector;
            ToTargetLength = MaxDistanceToTarget * 0.1000000;
            // End:0x24F
            if(!bUsingNorthVector && TransitionTime > TransitionDelay)
            {
                TransitionTime = 0.0000000;
                LastTargetYaw = PointerController.BoneRotation.Yaw;
            }
            bUsingNorthVector = true;
            bHasValidTarget = true;            
        }
        else
        {
            bUsingNorthVector = false;
        }
        // End:0x6E2
        if(bHasValidTarget)
        {
            CRotation = self.Rotation;
            CRotation.Yaw = CRotation.Yaw * Correction;
            TargetDirection = Rotator(ToTarget);
            TargetDirection.Yaw = TargetDirection.Yaw * Correction;
            Offset = 3000 * Correction;
            SineDistortions = Sin(TimeElapsed / float(3)) * ((float(3000) * ToTargetLength) / MaxDistanceToTarget);
            CurrentDegree = float((TargetDirection.Yaw - CRotation.Yaw) + Offset) + SineDistortions;
            TransitionTime += DeltaTime;
            Alpha = TransitionTime / TransitionDelay;
            // End:0x4F9
            if(Alpha < 1.0000000)
            {
                PointerController.BoneRotation.Yaw = int(Lerp(float(LastTargetYaw), CurrentDegree - SineDistortions, Alpha));
                WarpController.BoneRotation.Yaw = PointerController.BoneRotation.Yaw;                
            }
            else
            {
                PointerController.BoneRotation.Yaw = int(CurrentDegree);
                WarpController.BoneRotation.Yaw = int(float(PointerController.BoneRotation.Yaw) - SineDistortions);
            }
            // End:0x6DF
            if(!bUsingNorthVector)
            {
                PercentToTarget = 1.0000000 - (ToTargetLength / MaxDistanceToTarget);
                Highlight = (PercentToTarget * PercentToTarget) * PercentToTarget;
                switch(Class'AdvTreasureTrigger_Base'.static.GetTreasureTypeFromID(NextTarget.TreasureID))
                {
                    // End:0x67C
                    case 0:
                        LC = MakeLinearColor(0.5900000, 0.7600000, 0.8600000, 1.0000000);
                        // End:0x6DF
                        break;
                    // End:0x6AC
                    case 1:
                        LC = MakeLinearColor(0.4400000, 0.1100000, 0.8600000, 1.0000000);
                        // End:0x6DF
                        break;
                    // End:0x6DC
                    case 2:
                        LC = MakeLinearColor(1.0000000, 0.7500000, 0.0600000, 1.0000000);
                        // End:0x6DF
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
            }
            else
            {                
            }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x6DF! */
            else
            {
                CurrentDegree += ((DeltaTime * float(22000)) + (Sin(TimeElapsed / float(3)) * float(40)));
                // End:0x73C
                if(CurrentDegree > float(32767))
                {
                    CurrentDegree = -32768.0000000;
                }
                PointerController.BoneRotation.Yaw = int(CurrentDegree);
                TransitionTime = 0.0000000;
                LastTargetYaw = PointerController.BoneRotation.Yaw;
            }
            // End:0x834
            if(MaterialControler != none)
            {
                MaterialControler.SetScalarParameterValue('Highlight', Highlight);
                MaterialControler.SetVectorParameterValue('ColorHighlight', LC);
            }
        }
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x04C! */
}

function SetNextTarget(AdvTreasureTrigger_Base NewTarget)
{
    // End:0x14F
    if(NewTarget != none)
    {
        // End:0xF3
        if((PC != none) && AdvPlayerPawn(Owner).WeaponLeft == self)
        {
            // End:0x93
            if(PC.CheckAlienFx(1))
            {
                PC.ClearAlienFx(1);
            }
            PC.SetAlienFxLight(0, 255, 150, 0, 1, 0, PC.compassDuration, -1);
            alienFxIntervalCounter = 0.0000000;            
        }
        TransitionTime = 0.0000000;
        // End:0x14C
        if(PointerController != none)
        {
            LastTargetYaw = PointerController.BoneRotation.Yaw;
        }        
    }
    else
    {
        // End:0x180
        if(PC != none)
        {
            PC.ClearAlienFx(1);
        }
    }
    NextTarget = NewTarget;
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super(Actor).PostInitAnimTree(SkelComp);
    // End:0x150
    if(SkelComp == Mesh)
    {
        PointerController = SkelControlSingleBone(SkelComp.FindSkelControl('PointerController'));
        // End:0xBD
        if(PointerController != none)
        {
            PointerController.SetSkelControlActive(true);
            PointerController.SetSkelControlStrength(1.0000000, 0.0000000);
        }
        WarpController = SkelControlSingleBone(SkelComp.FindSkelControl('WarpController'));
        // End:0x150
        if(PointerController != none)
        {
            WarpController.SetSkelControlActive(true);
            WarpController.SetSkelControlStrength(1.0000000, 0.0000000);
        }
    }
    PC = AdvPlayerController(AdvPlayerPawn(Owner).GetPlayerController());
    //return;    
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    super(EvilWeap_Base).AttachWeaponTo(MeshCpnt, SocketName);
    MaterialControler = Mesh.CreateAndSetMaterialInstanceConstant(0);
    //return;    
}

function CreateCheckpointRecord(out InventoryRecord Record)
{
    super(EvilWeap_Base).CreateCheckpointRecord(Record);
    Record.MagazineAmmoCount = int(MaxDistanceToTarget);
    Record.CustomData = 0;
    Record.CustomData = Record.CustomData | (int(bUsingNorthVector) << 0);
    Record.CustomData = Record.CustomData | (int(AutomaticTargetFinding) << 1);
    Record.CustomData = Record.CustomData | (int(AllowShowHints) << 2);
    //return;    
}

function ApplyCheckpointRecord(const out InventoryRecord Record)
{
    super(EvilWeap_Base).ApplyCheckpointRecord(Record);
    MaxDistanceToTarget = float(Record.MagazineAmmoCount);
    bUsingNorthVector = (Record.CustomData & (1 << 0)) != 0;
    AutomaticTargetFinding = (Record.CustomData & (1 << 1)) != 0;
    AllowShowHints = (Record.CustomData & (1 << 2)) != 0;
    //return;    
}

defaultproperties
{
    AutomaticTargetFinding=true
    TransitionDelay=0.6000000
    MaxDistanceToTarget=3000.0000000
    // Reference: ParticleSystemComponent'Default__AdvInventoryItem_Compass.Particle0'
    begin object name=Particle0 class=Class'Engine.ParticleSystemComponent'
        Template=ParticleSystem'ps_wp_Compass.Effects.ps_wp_compasswarp'
        bAutoActivate=false
        ReplacementPrimitive=none
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_Foreground
        Scale=0.3000000
        TickGroup=ETickingGroup.TG_EffectsUpdateWork
    end object
    WarpParticleSystem=Particle0
    ControlDOFWhenOffhand=true
    ZoomedCrosshair=true
    UsesOffhand=true
    OffHandDoesNotFire=true
    // Reference: ForceFeedbackWaveform'Default__AdvInventoryItem_Compass.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=67
    ZoomedMeshTranslation=(X=0.0000000,Y=-5.0000000,Z=3.0000000)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=30.0000000
    ZoomedWeaponIdleAnims=/* Array type was not detected. */
    ZoomedWeaponFireAnim=/* Array type was not detected. */
    ZoomedArmIdleAnims=/* Array type was not detected. */
    ZoomedArmFireAnim=/* Array type was not detected. */
    ZoomedMovementSpeedModifier=0.6000000
    ArmsAnimSet=AnimSet'wp_Compass_01.Anim.as_wp_Compass_hands_02'
    // Reference: AudioComponent'Default__AdvInventoryItem_Compass.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    WeaponCrouchStartAnim="WeaponCrouchStart"
    ArmCrouchStartAnim="WeaponCrouchStart"
    WeaponCrouchEndAnim="WeaponStandStart"
    ArmCrouchEndAnim="WeaponStandStart"
    WeaponJumpStartAnim="WeaponJumpStart"
    ArmJumpStartAnim="WeaponJumpStart"
    WeaponJumpFlyAnim="WeaponJumpFall"
    ArmJumpFlyAnim="WeaponJumpFall"
    WeaponJumpLandAnim="WeaponJumpLanding"
    ArmJumpLandAnim="WeaponJumpLanding"
    CrouchStartCameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CrouchStart'
    CrouchEndCameraAnim=CameraAnim'an_CameraAnims.Anim.CA_StandStart'
    WeaponPutDownSnd=SoundCue'a_Compass.a_CompassOut'
    WeaponEquipSnd=SoundCue'a_Compass.a_Equip'
    // Reference: DynamicLightEnvironmentComponent'Default__AdvInventoryItem_Compass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Compass"
    PlayerViewOffset=(X=30.0000000,Y=12.0000000,Z=-12.0000000)
    PlayerRotationOffset=(Pitch=546,Yaw=-2548,Roll=2548)
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvInventoryItem_Compass.FirstPersonMesh'
    begin object name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'wp_Compass_01.Mesh.sk_wp_Compass_01_01'
        AnimTreeTemplate=AnimTree'wp_Compass_01.at_wp_Compass_01_01'
        AnimSets[0]=AnimSet'wp_Compass_01.Anim.as_wp_Compass_01'
        ReplacementPrimitive=none
        Scale=1.3000000
    end object
    Mesh=FirstPersonMesh
    ItemName="Compass"
    // Reference: SkeletalMeshComponent'Default__AdvInventoryItem_Compass.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    Components[2]=Particle0
}