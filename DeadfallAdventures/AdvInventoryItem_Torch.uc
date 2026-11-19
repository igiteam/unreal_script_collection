class AdvInventoryItem_Torch extends AdvInventoryItem_Base
    config(Weapon)
    hidecategories(Navigation);

struct PartComponents
{
    var() export editinline PointLightComponent PointLightC;
    var() export editinline SpotLightComponent SecondSpotLightC;
    var() export editinline UDKSkeletalMeshComponent Volume;
    var() MaterialInstanceConstant VolumeMI[2];
    var() export editinline SpotLightComponent SpotLight;
    var() MaterialInstanceConstant SpotLightMI;
    var() export editinline LensFlareComponent Flare;

    structdefaultproperties
    {
        PointLightC=none
        SecondSpotLightC=none
        Volume=none
        VolumeMI[0]=none
        VolumeMI[1]=none
        SpotLight=none
        SpotLightMI=none
        Flare=none
    }
};

var Weapon CurrentWeapon;
var export editinline UDKSkeletalMeshComponent CurrentMesh;
var repnotify bool bFlashlightOn;
var bool bPendingFlashlightOn;
var bool bBeamFxInBurningMode;
var transient bool bAutoActiveAfterEquip;
var() transient bool bBlinking;
var() transient bool bIndicateRechargeDone;
var repnotify bool FlashLightBeamActive;
var transient bool bDeadBattery;
var transient bool bBeamWasActive;
var repnotify bool bLookForGlowableElements;
var() SoundCue FlashlightOnSnd;
var() SoundCue FlashlightOffSnd;
var export editinline AudioComponent MagicSoundStart;
var export editinline AudioComponent MagicSoundLoop;
var export editinline AudioComponent MagicSoundEnd;
var() SoundCue ManaFinishedSnd;
var() SoundCue ManaRegeneratedSnd;
var() SoundCue SparkSnd;
var() SoundCue FlashlightOnSnd3p;
var() SoundCue FlashlightOffSnd3p;
var() SoundCue ManaFinishedSnd3p;
var() SoundCue ManaRegeneratedSnd3p;
var() SoundCue SparkSnd3p;
var() config LinearColor PostProcessTint;
var() config float PostProcessPower;
var() config float PostProcessFadeSpeed;
var() RadialBlurActor RadialBlur;
var() float Power;
var transient float FocusAlpha;
var transient UDKSkelControl_MassBoneScaling BoneScaler;
var() PartComponents Parts;
var export editinline UDKSkeletalMeshComponent AttachableMesh;
var export editinline ParticleSystemComponent FLBeamEmitter;
var name FLEndPointParamName;
var name FLBeamSocket;
var float ConeRadAngle;
var transient float ConeScale;
var() array<EvilPawn> OldLightTargets;
var() array<EvilPawn> LightTargets;
var ParticleSystem ShieldedHitEffect;
var ParticleSystem FrozenHitEffect;
var() ParticleSystem HitEffect;
var() ParticleSystem HitEffectWhenBurned;
var() config int PerBoneHitEffectInterval;
var transient int PerBoneHitEffectCounter;
var export editinline ParticleSystemComponent HitEffectComp;
var export editinline ParticleSystemComponent BeamHitEffectComp;
var float BeamAtachedScale;
var name BeamAtachedBoneName;
var() config array<config name> BonesToTest;
var AdvInventoryTorchParts TorchParts;
var transient int TemporaryFixedTotalCols;

replication
{
    // Pos:0x000
    if(bNetDirty
        FlashLightBeamActive, bFlashlightOn, 
        bLookForGlowableElements;
}

simulated event PostBeginPlay()
{
    super(EvilWeap_Base).PostBeginPlay();
    TorchParts = new (Outer) Class'AdvInventoryTorchParts';
    InternalAttachToWeapon(self, UDKSkeletalMeshComponent(Mesh), true);
    ConeRadAngle = (Parts.SpotLight.OuterConeAngle * 0.0174533) * 0.7500000;
    //return;    
}

function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
    local AdvPlayerController PC;

    super(AdvWeap_Base).GivenTo(thisPawn, bDoNotActivate);
    PC = AdvPlayerController(thisPawn.Controller);
    // End:0x80
    if(PC != none)
    {
        PC.ApplyTreasurePerk(false, 1);
    }
    //return;    
}

simulated function bool IsAttachedToAnotherWeapon()
{
    return CurrentWeapon != self;
    //return ReturnValue;    
}

simulated function bool IsEquipped()
{
    return !CurrentWeapon.IsInState('Inactive') || CurrentWeapon.IsInState('Frozen');
    //return ReturnValue;    
}

simulated function bool CanAttachToWeapon(EvilWeap_Base Weap)
{
    return (Weap == self) || (UDKSkeletalMeshComponent(Weap.Mesh) != none) && UDKSkeletalMeshComponent(Weap.Mesh).GetSocketByName('FlashLightSocket') != none;
    //return ReturnValue;    
}

simulated function AttachToWeapon(EvilWeap_Base Weap)
{
    local editinline SkeletalMeshComponent TargetMesh;
    local AdvMapInfo MapInfo;

    // End:0x102
    if(AttachableMesh == none)
    {
        AttachableMesh = new (self) Class'UDKBase.UDKSkeletalMeshComponent';
        AttachableMesh.SetSkeletalMesh(SkeletalMesh'wp_flashlight_01.Mesh.sk_wp_WeaponFlashlight_01');
        MapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
        // End:0x102
        if((MapInfo != none) && MapInfo.WeaponMaterialLight != 1.0000000)
        {
            SetWeaponMaterialLight(MapInfo.WeaponMaterialLight, AttachableMesh);
        }
    }
    // End:0x19A
    if((CurrentWeapon != none) && AttachableMesh.AttachedToSkelComponent == CurrentWeapon.Mesh)
    {
        UDKSkeletalMeshComponent(CurrentWeapon.Mesh).DetachComponent(AttachableMesh);
    }
    // End:0x206
    if(Weap.IsA('EvilVehicleWeap_Base'))
    {
        TargetMesh = EvilVehicle_Base(Weap.Owner).Mesh;        
    }
    else
    {
        TargetMesh = SkeletalMeshComponent(Weap.Mesh);
    }
    TargetMesh.AttachComponentToSocket(AttachableMesh, 'FlashLightSocket');
    // End:0x2D1
    if(TargetMesh.IsA('UDKSkeletalMeshComponent'))
    {
        AttachableMesh.SetFOV(UDKSkeletalMeshComponent(TargetMesh).FOV);
    }
    AttachableMesh.SetLightEnvironment(Weap.LightEnvironment);
    AttachableMesh.SetDepthPriorityGroup(TargetMesh.DepthPriorityGroup);
    AttachableMesh.bAcceptsDynamicDominantLightShadows = false;
    InternalAttachToWeapon(Weap, AttachableMesh, true);
    //return;    
}

simulated function DetachFromWeapon()
{
    // End:0xA9
    if(((CurrentWeapon != none) && AttachableMesh != none) && AttachableMesh.AttachedToSkelComponent == CurrentWeapon.Mesh)
    {
        UDKSkeletalMeshComponent(CurrentWeapon.Mesh).DetachComponent(AttachableMesh);
    }
    InternalAttachToWeapon(self, UDKSkeletalMeshComponent(Mesh), true);
    //return;    
}

reliable server function ServerUpdateCurrentWeapon(Weapon currentWeap)
{
    CurrentWeapon = currentWeap;
    //return;    
}

simulated function bool IsFlashLightBeamActive()
{
    return FlashLightBeamActive;
    //return ReturnValue;    
}

reliable client simulated function ClientActivateFlightBeam()
{
    ActivateFlightBeam();
    //return;    
}

simulated function ActivateFlightBeam()
{
    local AdvPlayerController PC;

    // End:0x0F
    if(bDeadBattery)
    {
        return;
    }
    // End:0x1E
    if(FlashLightBeamActive)
    {
        return;
    }
    // End:0x84
    if(Parts.VolumeMI[0] != none)
    {
        Parts.VolumeMI[0].SetScalarParameterValue('LuminosityScale', 2.0000000);
    }
    // End:0xEA
    if(Parts.VolumeMI[1] != none)
    {
        Parts.VolumeMI[1].SetScalarParameterValue('LuminosityScale', 20.0000000);
    }
    PC = AdvPlayerController(((Instigator.Controller != none) ? Instigator.Controller : ((Instigator.DrivenVehicle != none) ? Instigator.DrivenVehicle.Controller : none)));
    // End:0x3B6
    if((PC != none) && Instigator.IsLocallyControlled())
    {
        // End:0x28B
        if(AdvPostProcessManager(PC.GetPPManager()) != none)
        {
            AdvPostProcessManager(PC.GetPPManager()).EnableColourization(true, PostProcessFadeSpeed, PostProcessPower, PostProcessTint);
            RadialBlur.RadialBlur.SetEnabled(true);
        }
        // End:0x2D6
        if(MagicSoundLoop.IsPlaying())
        {
            MagicSoundLoop.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x321
        if(MagicSoundEnd.IsPlaying())
        {
            MagicSoundEnd.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x36E
        if(!MagicSoundStart.IsPlaying())
        {
            MagicSoundStart.FadeIn(0.1000000, 1.0000000);
        }
        SetTimer(MagicSoundStart.SoundCue.Duration - 0.1000000, false, 'StartMagicLoopSound');
    }
    FlashLightBeamActive = true;
    // End:0x3E1
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetFlashLightBeamActive(true);
    }
    // End:0x505
    if(CurrentWeapon == self)
    {
        DesiredMeshTranslation = ZoomedMeshTranslation;
        DesiredMeshRotation = ZoomedMeshRotation;
        DesiredMeshScale = ZoomedMeshScale;
        DesiredMeshFOV = ZoomedMeshFOV;
        ZoomingTranslationRate = default.ZoomingTranslationRate;
        ZoomingRotationRate = default.ZoomingRotationRate;
        ZoomingScaleRate = default.ZoomingScaleRate;
        WeaponIdleAnims = ZoomedWeaponIdleAnims;
        WeaponFireAnim = ZoomedWeaponFireAnim;
        ArmIdleAnims = ZoomedArmIdleAnims;
        ArmFireAnim = ZoomedArmFireAnim;
        BobDamping = ZoomedBobDamping;
        JumpDamping = ZoomedJumpDamping;
        LagBackSpeed = ZoomedLagBackSpeed;
        RestartIdleAnim();
    }
    //return;    
}

reliable client simulated function ClientDeactivateFlightBeam(optional bool bForce = false)
{
    DeactivateFlightBeam(bForce);
    //return;    
}

reliable server function ServerSetFlashLightBeamActive(bool bState)
{
    FlashLightBeamActive = bState;
    // End:0x30
    if(!bState)
    {
        bBeamWasActive = false;
    }
    //return;    
}

simulated function DeactivateFlightBeam(optional bool bForce = false)
{
    local AdvPlayerController PC;

    // End:0x1E
    if(bBeamWasActive)
    {
        bBeamWasActive = false;
    }
    // End:0x40
    if(!FlashLightBeamActive && !bForce)
    {
        return;
    }
    // End:0xA6
    if(Parts.VolumeMI[0] != none)
    {
        Parts.VolumeMI[0].SetScalarParameterValue('LuminosityScale', 1.5000000);
    }
    // End:0x10C
    if(Parts.VolumeMI[1] != none)
    {
        Parts.VolumeMI[1].SetScalarParameterValue('LuminosityScale', 3.0000000);
    }
    PC = AdvPlayerController(((Instigator.Controller != none) ? Instigator.Controller : ((Instigator.DrivenVehicle != none) ? Instigator.DrivenVehicle.Controller : none)));
    // End:0x34A
    if(PC != none)
    {
        // End:0x244
        if(AdvPostProcessManager(PC.GetPPManager()) != none)
        {
            AdvPostProcessManager(PC.GetPPManager()).EnableColourization(false, PostProcessFadeSpeed);
        }
        // End:0x28F
        if(MagicSoundLoop.IsPlaying())
        {
            MagicSoundLoop.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x2DA
        if(MagicSoundStart.IsPlaying())
        {
            MagicSoundStart.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x336
        if(!MagicSoundEnd.IsPlaying() && IsFlashLightBeamActive())
        {
            MagicSoundEnd.FadeIn(0.1000000, 1.0000000);
        }
        ClearTimer('StartMagicLoopSound');
    }
    FlashLightBeamActive = false;
    // End:0x375
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetFlashLightBeamActive(false);
    }
    // End:0x4EB
    if((CurrentWeapon == self) && int(GetZoomedState()) <= int(1))
    {
        DesiredMeshTranslation = vect(0.0000000, 0.0000000, 0.0000000);
        DesiredMeshRotation = rot(0, 0, 0);
        DesiredMeshScale = Mesh.default.Scale;
        DesiredMeshFOV = UDKSkeletalMeshComponent(Mesh).default.FOV;
        ZoomingTranslationRate = default.ZoomingTranslationRate;
        ZoomingRotationRate = default.ZoomingRotationRate;
        ZoomingScaleRate = default.ZoomingScaleRate;
        WeaponIdleAnims = default.WeaponIdleAnims;
        WeaponFireAnim = default.WeaponFireAnim;
        ArmIdleAnims = default.ArmIdleAnims;
        ArmFireAnim = default.ArmFireAnim;
        BobDamping = default.BobDamping;
        JumpDamping = default.JumpDamping;
        LagBackSpeed = default.LagBackSpeed;
        RestartIdleAnim();
    }
    //return;    
}

simulated function StartMagicLoopSound()
{
    // End:0x4B
    if(MagicSoundStart.IsPlaying())
    {
        MagicSoundStart.FadeOut(0.1000000, 0.0000000);
    }
    // End:0x96
    if(MagicSoundEnd.IsPlaying())
    {
        MagicSoundEnd.FadeOut(0.1000000, 0.0000000);
    }
    // End:0xE3
    if(!MagicSoundLoop.IsPlaying())
    {
        MagicSoundLoop.FadeIn(0.1000000, 1.0000000);
    }
    //return;    
}

simulated function SetMeshLightAcceptance(bool bNewEnabled)
{
    local int I;
    local LightingChannelContainer LCC;

    // End:0x89
    if(Mesh != none)
    {
        LCC = Mesh.LightingChannels;
        LCC.NoFlashlight = !bNewEnabled;
        Mesh.SetLightingChannels(LCC);
    }
    // End:0x112
    if(AttachableMesh != none)
    {
        LCC = AttachableMesh.LightingChannels;
        LCC.NoFlashlight = !bNewEnabled;
        AttachableMesh.SetLightingChannels(LCC);
    }
    // End:0x3A8
    if(AdvPawn(Owner) != none)
    {
        // End:0x27B
        if((AdvPawn(Owner).Weapon != none) && AdvPawn(Owner).Weapon.Mesh != none)
        {
            LCC = AdvPawn(Owner).Weapon.Mesh.LightingChannels;
            LCC.NoFlashlight = !bNewEnabled;
            AdvPawn(Owner).Weapon.Mesh.SetLightingChannels(LCC);
        }
        I = 0;
        J0x286:

        // End:0x3A5 [Loop If]
        if(I < 2)
        {
            // End:0x397
            if(AdvPawn(Owner).ArmsMesh[I] != none)
            {
                LCC = AdvPawn(Owner).ArmsMesh[I].LightingChannels;
                LCC.NoFlashlight = !bNewEnabled;
                AdvPawn(Owner).ArmsMesh[I].SetLightingChannels(LCC);
            }
            ++I;
            // [Loop Continue]
            goto J0x286;
        }        
    }
    else
    {
        // End:0x4A3
        if(AdvTurret_Base(Owner) != none)
        {
            // End:0x4A3
            if(AdvTurret_Base(Owner).Mesh != none)
            {
                LCC = AdvTurret_Base(Owner).Mesh.LightingChannels;
                LCC.NoFlashlight = !bNewEnabled;
                AdvTurret_Base(Owner).Mesh.SetLightingChannels(LCC);
            }
        }
    }
    //return;    
}

reliable server function ServerTurnFlashlight(bool bState)
{
    // End:0x1B
    if(bState)
    {
        TurnFlashlightOn();        
    }
    else
    {
        TurnFlashlightOff();
        ForceClearLightTargets();
    }
    //return;    
}

reliable client simulated function ClientTurnFlashlight(bool On)
{
    // End:0x1B
    if(On)
    {
        TurnFlashlightOn();        
    }
    else
    {
        TurnFlashlightOff();
    }
    //return;    
}

simulated function TurnFlashlightOn(optional bool bViaReplication)
{
    // End:0x58
    if(!bFlashlightOn)
    {
        bFlashlightOn = true;
        // End:0x3B
        if(int(Role) < int(ROLE_Authority))
        {
            ServerTurnFlashlight(true);
        }
        WeaponPlaySound(FlashlightOnSnd3p, FlashlightOnSnd);
    }
    SetMeshLightAcceptance(false);
    UpdateFlashlight(bViaReplication);
    //return;    
}

simulated function TurnFlashlightOff(optional bool bViaReplication)
{
    // End:0x60
    if(bFlashlightOn)
    {
        bFlashlightOn = false;
        ForceClearLightTargets();
        // End:0x43
        if(int(Role) < int(ROLE_Authority))
        {
            ServerTurnFlashlight(false);
        }
        WeaponPlaySound(FlashlightOffSnd3p, FlashlightOffSnd);
    }
    SetMeshLightAcceptance(true);
    UpdateFlashlight(bViaReplication);
    RadialBlur.RadialBlur.SetEnabled(false);
    //return;    
}

reliable client simulated function ClientLightState(bool State)
{
    SetLightState(State);
    //return;    
}

private final simulated function SetLightState(bool bNewVisible)
{
    // End:0x5E
    if(Parts.Flare != none)
    {
        Parts.Flare.SetIsActive(bNewVisible);
    }
    // End:0xBE
    if(Parts.Volume != none)
    {
        Parts.Volume.SetHidden(!bNewVisible);
    }
    // End:0x11C
    if(Parts.SpotLight != none)
    {
        Parts.SpotLight.SetEnabled(bNewVisible);
    }
    // End:0x17A
    if(Parts.PointLightC != none)
    {
        Parts.PointLightC.SetEnabled(bNewVisible);
    }
    // End:0x1D8
    if(Parts.SecondSpotLightC != none)
    {
        Parts.SecondSpotLightC.SetEnabled(bNewVisible);
    }
    //return;    
}

reliable client simulated function ClientUpdateFlashlight()
{
    UpdateFlashlight();
    //return;    
}

simulated function UpdateFlashlight(optional bool bViaReplication)
{
    // End:0x56
    if(Parts.Volume != none)
    {
        Parts.Volume.SetOwnerNoSee(false);
    }
    SetLightState(bFlashlightOn);
    ClientLightState(bFlashlightOn);
    // End:0xBA
    if(bFlashlightOn)
    {
        // End:0xB7
        if(!IsTimerActive('TestLight_T'))
        {
            SetTimer(0.2000000, true, 'TestLight_T');
        }        
    }
    else
    {
        // End:0xE5
        if(IsTimerActive('TestLight_T'))
        {
            ClearTimer('TestLight_T');
        }
        DeactivateFlightBeam();
        ClientDeactivateFlightBeam();
    }
    //return;    
}

private final simulated function InternalAttachToWeapon(Weapon Weapon, UDKSkeletalMeshComponent SkelMesh, optional bool bUseMeshFOV)
{
    local EvilPawn P;
    local AdvTurret_Base T;
    local EvilPlayerController PC;
    local LinearColor LC;
    local AdvEngine Engine;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    CurrentWeapon = Weapon;
    CurrentMesh = SkelMesh;
    // End:0x80
    if(int(Role) < int(ROLE_Authority))
    {
        ServerUpdateCurrentWeapon(CurrentWeapon);
    }
    // End:0xE7D
    if(SkelMesh != none)
    {
        SetupFlashLightBeam(SkelMesh);
        P = EvilPawn(Instigator);
        // End:0x11D
        if(P == none)
        {
            T = AdvTurret_Base(Instigator);
            PC = EvilPlayerController(T.Controller);            
        }
        else
        {
            PC = EvilPlayerController(((P.Controller != none) ? P.Controller : ((P.DrivenVehicle != none) ? P.DrivenVehicle.Controller : none)));
        }
        // End:0x606
        if(!(int(Role) == int(ROLE_Authority)) && !CurrentWeapon.Instigator.IsLocallyControlled() && ((SkelMesh.GetSocketByName('FlashLightSocket') != none) || (P != none) && P.IsFirstPerson()) || T != none)
        {
            // End:0x590
            if((Parts.SpotLight == none) || (Parts.SpotLight != none) && Parts.SpotLight.Function == none)
            {
                Parts.SpotLight = new (Outer) Class'AdvFlashlightSpotlightComponent' (AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent');
                Parts.SpotLight.Radius *= ((Engine == none) ? 1.0000000 : Engine.FlashlightRadiusScale);
                // End:0x558
                if((Engine == none) || Engine.bFlashlightUseMaterialFunction)
                {
                    // End:0x555
                    if(((Parts.SpotLight.Function != none) && Parts.SpotLight.Function.SourceMaterial != none) && Parts.SpotLight.Function.SourceMaterial.GetPackageName() != 'Transient')
                    {
                        Parts.SpotLight.SetLightProperties(,,, Parts.SpotLight.Function.DeriveWithMaterialInstance());
                    }                    
                }
                else
                {
                    Parts.SpotLight.SetLightProperties(,,, none);
                }                
            }
            else
            {
                Parts.SpotLight.DetachFromAny();
            }
            SkelMesh.AttachComponentToSocket(Parts.SpotLight, 'LightVolume');
        }
        // End:0x9E3
        if(((SkelMesh.GetSocketByName('LightVolume') != none) && Parts.SpotLight != none) && P.IsLocallyControlled())
        {
            // End:0x873
            if(Parts.Volume == none)
            {
                Parts.Volume = new (Outer) Class'UDKBase.UDKSkeletalMeshComponent' (UDKSkeletalMeshComponent'ar_FlashLight.ar_FlashLight_Volume');
                Parts.VolumeMI[0] = Parts.Volume.CreateAndSetMaterialInstanceConstant(0);
                Parts.VolumeMI[1] = Parts.Volume.CreateAndSetMaterialInstanceConstant(1);
                LC = ColorToLinearColor(Parts.SpotLight.LightColor);
                LC.A = 1.2000000;
                Parts.VolumeMI[0].SetVectorParameterValue('Color', LC);
                Parts.VolumeMI[1].SetVectorParameterValue('Color', LC);                
            }
            else
            {
                Parts.Volume.DetachFromAny();
            }
            // End:0x905
            if(bUseMeshFOV)
            {
                Parts.Volume.SetFOV(SkelMesh.FOV);                
            }
            else
            {
                // End:0x968
                if(PC != none)
                {
                    Parts.Volume.SetFOV(PC.GetFOVAngle());                    
                }
                else
                {
                    Parts.Volume.SetFOV(0.0000000);
                }
            }
            SkelMesh.AttachComponentToSocket(Parts.Volume, 'LightVolume');
        }
        // End:0xB0B
        if((SkelMesh.GetSocketByName('PointLightSocket') != none) && P.IsLocallyControlled())
        {
            // End:0xA95
            if(Parts.PointLightC == none)
            {
                Parts.PointLightC = new (Outer) Class'Engine.PointLightComponent' (PointLightComponent'ar_FlashLight.ar_PointLightComponent');                
            }
            else
            {
                Parts.PointLightC.DetachFromAny();
            }
            SkelMesh.AttachComponentToSocket(Parts.PointLightC, 'PointLightSocket');
        }
        // End:0xCB7
        if((SkelMesh.GetSocketByName('LightFlare') != none) && P.IsLocallyControlled())
        {
            // End:0xBB5
            if(Parts.Flare == none)
            {
                Parts.Flare = new (Outer) Class'Engine.LensFlareComponent';                
            }
            else
            {
                Parts.Flare.DetachFromAny();
            }
            Parts.Flare.SetDepthPriorityGroup(SkelMesh.DepthPriorityGroup);
            Parts.Flare.SetTemplate(LensFlare'ps_FlashlightAttachment.flares.lf_flashlight');
            SkelMesh.AttachComponentToSocket(Parts.Flare, 'LightFlare');
        }
        // End:0xE3A
        if((RadialBlur == none) && P.IsLocallyControlled())
        {
            RadialBlur = Spawn(Class'Engine.RadialBlurActor', Instigator);
            RadialBlur.RadialBlur.SetEnabled(false);
            RadialBlur.DetachComponent(RadialBlur.RadialBlur);
            RadialBlur.RadialBlur = new (RadialBlur) Class'Engine.RadialBlurComponent' (RadialBlurComponent'ar_FlashLight.ar_RadialBlurComponent');
            RadialBlur.AttachComponent(RadialBlur.RadialBlur);
            RadialBlur.RadialBlur.SetBlurScale(0.0000000);
        }
        RadialBlur.RadialBlur.SetEnabled(false);
        UpdateFlashlight();        
    }
    else
    {
        // End:0xED1
        if(Parts.Volume != none)
        {
            Parts.Volume.DetachFromAny();
        }
        // End:0xF25
        if(Parts.SpotLight != none)
        {
            Parts.SpotLight.DetachFromAny();
        }
        // End:0xF79
        if(Parts.Flare != none)
        {
            Parts.Flare.DetachFromAny();
        }
        // End:0xFCD
        if(Parts.PointLightC != none)
        {
            Parts.PointLightC.DetachFromAny();
        }
    }
    //return;    
}

simulated function SetupFlashLightBeam(UDKSkeletalMeshComponent SkelMesh)
{
    // End:0x193
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        FLBeamEmitter = new (Outer) Class'EvilGame.UTParticleSystemComponent';
        FLBeamEmitter.SetDepthPriorityGroup(2);
        FLBeamEmitter.SetTemplate(((TorchParts != none) ? TorchParts.FLBeamTemplate : ParticleSystem'wp_flashlight_01.Effects.P_WP_FlashLight_Beam'));
        FLBeamEmitter.SetHidden(true);
        FLBeamEmitter.SetTickGroup(3);
        FLBeamEmitter.bUpdateComponentInTick = true;
        FLBeamEmitter.SetIgnoreOwnerHidden(true);
        SkelMesh.AttachComponentToSocket(FLBeamEmitter, FLBeamSocket);
        FLBeamEmitter.DeactivateSystem();
    }
    //return;    
}

simulated function UpdateFlashLighBeamEmitter(Vector InFlashLocation, Vector HitNormal, Actor HA)
{
    // End:0x40
    if(FLBeamEmitter != none)
    {
        FLBeamEmitter.SetVectorParameter(FLEndPointParamName, InFlashLocation);
    }
    //return;    
}

simulated function FLUpdateBeam(float DeltaTime)
{
    local Vector StartTrace, EndTrace, AimDir;
    local ImpactInfo RealImpact, NearImpact;
    local AdvPlayerPawn P;

    P = AdvPlayerPawn(Owner);
    // End:0x179
    if(P != none)
    {
        P.bFlashlightOn = self.bFlashlightOn;
        P.bFlashlightBeamActive = self.FlashLightBeamActive;
        P.PowerDrainRate = self.TorchParts.PowerDrainRate;
        P.PowerRecoveryRate = self.TorchParts.PowerRecoveryRate;
        P.PowerBlinkChance = float(self.TorchParts.PowerBlinkChance);
    }
    // End:0x1BD
    if((((P == none) || !bFlashlightOn) || FLBeamEmitter == none) || !IsFlashLightBeamActive())
    {
        return;
    }
    StartTrace = P.GetWeaponStartTraceLocation();
    AimDir = Vector(P.GetAdjustedAimFor(self, StartTrace));
    EndTrace = StartTrace + (AimDir * float(1000));
    RealImpact = CalcWeaponFire(StartTrace, EndTrace);
    // End:0x2EE
    if(NearImpact.HitActor != none)
    {
        UpdateFlashLighBeamEmitter(NearImpact.HitLocation, NearImpact.HitNormal, NearImpact.HitActor);        
    }
    else
    {
        UpdateFlashLighBeamEmitter(RealImpact.HitLocation, RealImpact.HitNormal, RealImpact.HitActor);
    }
    //return;    
}

function ClearLightTargets()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0xEE [Loop If]
    if(I < OldLightTargets.Length)
    {
        // End:0xE0
        if(LightTargets.Find(OldLightTargets[I]) == )
        {            
            OldLightTargets[I].SetLightAffectionFromFlashLight(false, false);
            // End:0xE0
            if(NotEqual_InterfaceInterface(AdvLightAffection_interface(OldLightTargets[I]), AdvLightAffection_interface(none)))
            {
                AdvLightAffection_interface(OldLightTargets[I]).RemoveFlashlight(self);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function ForceClearLightTargets()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x91 [Loop If]
    if(I < LightTargets.Length)
    {
        LightTargets[I].SetLightAffectionFromFlashLight(false, false);
        AdvLightAffection_interface(LightTargets[I]).RemoveFlashlight(self);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    LightTargets.Length = 0;
    OldLightTargets.Length = 0;
    //return;    
}

simulated function SpawnHitEffect(EvilPawn P, Vector HitLocation, Vector HitNormal, Vector HitTraceOrigin, optional name BoneName = 'None')
{
    local float FrozenAmount;

    HitLocation -= ((Normal(HitTraceOrigin - HitLocation) * P.GetCollisionExtent().X) * 0.2000000);
    // End:0x303
    if(P.HasShield() || P.IsFrozen())
    {
        // End:0x226
        if(HitEffectComp == none)
        {
            HitEffectComp = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(((P.IsFrozen(FrozenAmount) && FrozenAmount > 0.2000000) ? FrozenHitEffect : ShieldedHitEffect));
            P.AttachComponent(HitEffectComp);
            HitEffectComp.SetActorParameter('BoneSocketActor', P);
            HitEffectComp.ActivateSystem(true);
            // End:0x223
            if(FrozenAmount > 0.2000000)
            {
                P.SetUnfreezeEffectComponent(HitEffectComp);
            }            
        }
        else
        {
            // End:0x2CD
            if(HitEffectComp.bIsActive)
            {
                // End:0x288
                if(FrozenAmount <= 0.2000000)
                {
                    HitEffectComp.DeactivateSystem();
                    HitEffectComp = none;                    
                }
                else
                {
                    // End:0x2CA
                    if(HitEffectComp.bWasCompleted)
                    {
                        HitEffectComp.ActivateSystem();
                    }
                }                
            }
            else
            {
                // End:0x300
                if(FrozenAmount > 0.2000000)
                {
                    HitEffectComp.ActivateSystem();
                }
            }
        }        
    }
    else
    {
        // End:0x3D4
        if(BoneName == 'None')
        {
            BoneName = 'Spine';
            // End:0x346
            if(BoneName == 'None')
            {
                return;
            }
            HitLocation = InverseTransformVector(P.Mesh.GetBoneMatrix(P.Mesh.MatchRefBone(BoneName)), HitLocation);
        }
        // End:0x640
        if((BeamHitEffectComp == none) || P.bCanBeAffectedByLight && BeamHitEffectComp.Template != HitEffect)
        {
            // End:0x4AB
            if(BeamHitEffectComp != none)
            {
                BeamHitEffectComp.DeactivateSystem();
                P.Mesh.DetachComponent(BeamHitEffectComp);
                BeamHitEffectComp = none;
            }
            BeamHitEffectComp = new (self) Class'Engine.ParticleSystemComponent';
            // End:0x510
            if(P.bCanBeAffectedByLight)
            {
                BeamHitEffectComp.SetTemplate(HitEffect);                
            }
            else
            {
                BeamHitEffectComp.SetTemplate(HitEffectWhenBurned);
            }
            BeamHitEffectComp.SetAbsolute(false, false, true);
            BeamHitEffectComp.SetRotation(Rotator(Normal(HitTraceOrigin - HitLocation)));
            BeamHitEffectComp.SetScale(BeamAtachedScale);
            P.Mesh.AttachComponent(BeamHitEffectComp, BoneName, HitLocation);
            BeamHitEffectComp.ActivateSystem(true);
            BeamAtachedBoneName = BoneName;            
        }
        else
        {
            P.Mesh.AttachComponent(BeamHitEffectComp, BoneName, HitLocation);
        }
    }
    //return;    
}

simulated function StopBeamHitEffect()
{
    // End:0x39
    if(BeamHitEffectComp != none)
    {
        BeamHitEffectComp.DeactivateSystem();
        BeamHitEffectComp = none;
    }
    //return;    
}

simulated function bool IsPawnInCone(EvilPawn Target, Vector Origin, Vector Axis, float Angle)
{
    local name Bone;
    local Vector BoneLocation;

    // End:0x50
    if(Acos(Axis Dot Normal(Target.Location - Origin)) < Angle)
    {
        return true;
    }
    // End:0x76
    if(Target.Mesh == none)
    {
        return false;
    }
    // End:0x125
    foreach BonesToTest(Bone)
    {
        BoneLocation = Target.Mesh.GetBoneLocation(Bone);
        // End:0xE8
        if(IsZero(BoneLocation))
        {
            continue;            
        }
        else
        {
            // End:0x124
            if(Acos(Axis Dot Normal(BoneLocation - Origin)) < Angle)
            {                
                return true;
            }            
        }
    }    
    return false;
    //return ReturnValue;    
}

simulated function TestLight_T()
{
    local EvilPawn PTarget;
    local Vector SocLoc;
    local Rotator SocRot;
    local Pawn P;
    local Vector HitLocation, HitNormal;
    local Actor HitActor, HitActorZeroExtent;
    local TraceHitInfo HitInfo;
    local float Scale;
    local EvilPawn CoverPTarget;
    local PlayerController PC;
    local Vector projStart;
    local Rotator CameraRot;
    local Actor HitCenterA;

    P = Pawn(Owner);
    LightTargets.Remove(0, LightTargets.Length);    
    Scale = FMin(TorchParts.FocusSizeMultiplier, ConeScale);
    // End:0xEBC
    if(((((P != none) && bFlashlightOn) && IsEquipped()) && Power > 0.0000000) && !bBlinking)
    {
        GetLightSourcePosition(SocLoc, SocRot);
        // End:0x1AD
        if(CurrentWeapon.Instigator.IsLocallyControlled() || int(Role) == int(ROLE_Authority))
        {
            PC = PlayerController(CurrentWeapon.Instigator.Controller);
            // End:0x179
            if(PC == none)
            {
                return;
            }
            PC.GetPlayerViewPoint(projStart, CameraRot);            
        }
        else
        {
            return;
        }
        // End:0x315
        if(((AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).bIsSurvivalGame) && (int(Role) == int(ROLE_Authority)) && !CurrentWeapon.Instigator.IsLocallyControlled())
        {
            projStart += (Vector(CameraRot) * float(200));
            projStart += ((CurrentWeapon.Instigator.Location - projStart) * 0.7500000);
            projStart += (vect(0.0000000, 0.0000000, 1.0000000) * float(20));
            projStart += (Vector(CameraRot) * float(25));
        }
        // End:0x350
        if(bLookForGlowableElements)
        {
            SetAffectionAtGlowableElements(projStart, CameraRot, Scale, TemporaryFixedTotalCols);
        }
        HitCenterA = CurrentWeapon.Trace(HitLocation, HitNormal, projStart + (Normal(Vector(CameraRot)) * 2000.0000000), projStart, true, vect(0.0000000, 0.0000000, 0.0000000),, 1);
        // End:0x464
        if((((EvilPawn(HitCenterA) != none) && HitCenterA != Owner) && EvilPawn(HitCenterA).IsAliveAndWell()) && LightTargets.Find(EvilPawn(HitCenterA)) == )
        {            
            LightTargets.AddItem(EvilPawn(HitCenterA));            
        }
        HitCenterA = CurrentWeapon.Trace(HitLocation, HitNormal, projStart + (Normal(Vector(CameraRot)) * 2000.0000000), projStart, true, vect(10.0000000, 10.0000000, 10.0000000),, 1);
        // End:0x578
        if((((EvilPawn(HitCenterA) != none) && HitCenterA != Owner) && EvilPawn(HitCenterA).IsAliveAndWell()) && LightTargets.Find(EvilPawn(HitCenterA)) == )
        {            
            LightTargets.AddItem(EvilPawn(HitCenterA));            
        }
        // End:0x6DE
        if(((AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).bIsSurvivalGame) && (int(Role) == int(ROLE_Authority)) && !CurrentWeapon.Instigator.IsLocallyControlled())
        {
            SocLoc += (Vector(SocRot) * float(200));
            SocLoc += ((CurrentWeapon.Instigator.Location - SocLoc) * 0.7500000);
            SocLoc += (vect(0.0000000, 0.0000000, 1.0000000) * float(20));
            SocLoc += (Vector(SocRot) * float(25));
        }
        HitActorZeroExtent = CurrentWeapon.Trace(HitLocation, HitNormal, SocLoc + (Normal(Vector(SocRot)) * 2000.0000000), SocLoc, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 1);
        HitActor = CurrentWeapon.Trace(HitLocation, HitNormal, SocLoc + (Normal(Vector(SocRot)) * 2000.0000000), SocLoc, true, vect(10.0000000, 10.0000000, 10.0000000), HitInfo, 1);
        // End:0x8C2
        if((HitActor != none) && !bLookForGlowableElements)
        {
            // End:0x8C1
            foreach HitActor.OverlappingActors(Class'EvilGame.EvilPawn', CoverPTarget, 200.0000000, HitLocation)
            {
                // End:0x8C0
                if((((CoverPTarget != Owner) && CoverPTarget.IsInCover()) && CoverPTarget.IsAliveAndWell()) && LightTargets.Find(CoverPTarget) == )
                {                    
                    LightTargets.AddItem(CoverPTarget);                    
                }                
            }            
        }
        // End:0x9BE
        if((HitActorZeroExtent != none) && !bLookForGlowableElements)
        {
            // End:0x9BD
            foreach HitActorZeroExtent.OverlappingActors(Class'EvilGame.EvilPawn', CoverPTarget, 200.0000000, HitLocation)
            {
                // End:0x9BC
                if((((CoverPTarget != Owner) && CoverPTarget.IsInCover()) && CoverPTarget.IsAliveAndWell()) && LightTargets.Find(CoverPTarget) == )
                {                    
                    LightTargets.AddItem(CoverPTarget);                    
                }                
            }            
        }
        // End:0xB08
        foreach CurrentWeapon.VisibleActors(Class'EvilGame.EvilPawn', PTarget, 2000.0000000, SocLoc)
        {
            // End:0xB07
            if((((PTarget != Owner) && PTarget.IsAliveAndWell()) && (HitActor == PTarget) || IsPawnInCone(PTarget, SocLoc - (Vector(SocRot) * P.CylinderComponent.CollisionRadius), Vector(SocRot), ConeRadAngle * Scale)) && LightTargets.Find(PTarget) == )
            {                
                LightTargets.AddItem(PTarget);                
            }            
        }        
        // End:0xEBC
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0xEBB
            foreach LightTargets(PTarget)
            {
                // End:0xB87
                if(NotEqual_InterfaceInterface(AdvLightAffection_interface(PTarget), AdvLightAffection_interface(none)))
                {
                    AdvLightAffection_interface(PTarget).AddFlashlight(self);
                }
                PTarget.ChangeSizzleSound();
                // End:0xD5F
                if((HitActor == PTarget) || ((HitActorZeroExtent == PTarget) && PTarget.HasShield()) && IsFlashLightBeamActive())
                {
                    PTarget.SetLightAffectionFromFlashLight(true, ((IsFlashLightBeamActive()) ? true : NotEqual_InterfaceInterface(AdvLightAffection_interface(PTarget), AdvLightAffection_interface(none)) && AdvLightAffection_interface(PTarget).IsUnderBeamEffect()), SocLoc);
                    // End:0xD5C
                    if((!PTarget.bStrafing && PTarget.bCanBeAffectedByLight) && FRand() < 0.1000000)
                    {
                        PTarget.TakeDamage(0, P.Controller, HitLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Light', HitInfo, Owner);
                    }                    
                }
                else
                {
                    PTarget.SetLightAffectionFromFlashLight(true, (((IsFlashLightBeamActive()) && (HitActor == PTarget) || HitActorZeroExtent == PTarget) ? true : NotEqual_InterfaceInterface(AdvLightAffection_interface(PTarget), AdvLightAffection_interface(none)) && AdvLightAffection_interface(PTarget).IsUnderBeamEffect()), SocLoc);
                    // End:0xEBA
                    if(((PTarget.MyEvilAI != none) && PTarget.bCanBeAffectedByLight) && !IsFlashLightBeamActive())
                    {
                        PTarget.MyEvilAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
                    }
                }                
            }            
        }
    }
    // End:0x1008
    if((IsFlashLightBeamActive()) && PerBoneHitEffectCounter == 0)
    {
        // End:0xF4D
        if(((EvilPawn(HitActor) == none) && EvilPawn(HitActorZeroExtent) != none) && EvilPawn(HitActorZeroExtent).IsFrozen())
        {
            HitActor = HitActorZeroExtent;
        }
        PTarget = EvilPawn(HitActor);
        // End:0x1008
        if((((PTarget != none) && PTarget.IsAliveAndWell()) && PTarget.bLightInfluenceEnabled) && HitActorZeroExtent == HitActor)
        {
            SpawnHitEffect(PTarget, HitLocation, HitNormal, SocLoc);
        }
    }
    // End:0x103B
    if(!IsFlashLightBeamActive() || EvilPawn(HitActor) == none)
    {
        StopBeamHitEffect();
    }
    ClearLightTargets();
    OldLightTargets = LightTargets;
    PerBoneHitEffectCounter = ++PerBoneHitEffectCounter % PerBoneHitEffectInterval;
    //return;    
}

simulated function SetAffectionAtGlowableElements(Vector SocLoc, Rotator SocRot, float Scale, optional int FixedTotalCols = 0)
{
    local Actor HitSMA;
    local Vector HitLocation, HitNormal, Extent, TraceEnd;
    local int I, TotalCols, Col;
    local Rotator CurrentRotation;
    local Vector projStart;
    local Rotator CameraRot;
    local PlayerController PC;
    local float Degrees;

    PC = PlayerController(CurrentWeapon.Instigator.Controller);
    PC.GetPlayerViewPoint(projStart, CameraRot);
    // End:0x1E2
    if(((AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).bIsSurvivalGame) && (int(Role) == int(ROLE_Authority)) && !CurrentWeapon.Instigator.IsLocallyControlled())
    {
        projStart += (Vector(CameraRot) * float(200));
        projStart += ((CurrentWeapon.Instigator.Location - projStart) * 0.7500000);
        projStart += (vect(0.0000000, 0.0000000, 1.0000000) * float(20));
        projStart += (Vector(CameraRot) * float(25));
    }
    CurrentRotation = CameraRot;
    Extent.X = 12.0000000;
    Extent.Z = 12.0000000;
    Extent.Y = 12.0000000;
    TraceEnd = projStart + (Normal(Vector(CurrentRotation)) * 2000.0000000);
    HitSMA = CurrentWeapon.Trace(HitLocation, HitNormal, TraceEnd, projStart, true, Extent,, 1);
    // End:0x2FB
    if(FixedTotalCols != 0)
    {
        TotalCols = FixedTotalCols;        
    }
    else
    {
        // End:0x32C
        if(VSize(HitLocation - projStart) < float(600))
        {
            TotalCols = 4;            
        }
        else
        {
            // End:0x35D
            if(VSize(HitLocation - projStart) < float(1200))
            {
                TotalCols = 5;                
            }
            else
            {
                TotalCols = 6;
            }
        }
    }
    // End:0x401
    if(AdvFlashlight_GlowableElement_base(HitSMA) != none)
    {
        AdvFlashlight_GlowableElement_base(HitSMA).SetTraceParameters(HitSMA, HitLocation, HitNormal, projStart);
        AdvFlashlight_GlowableElement_base(HitSMA).SetLightAffectionFromFlashLight(true, IsFlashLightBeamActive());
    }
    Degrees = ((ConeRadAngle * Scale) * 1.5000000) * 57.2957800;
    Col = 0;
    CurrentRotation = SocRot;
    CurrentRotation.Yaw += int((float(182) * Degrees) / float(3));
    CurrentRotation.Pitch += int((float(182) * -Degrees) / float(3));
    I = 0;
    J0x4C2:

    // End:0x689 [Loop If]
    if(I < (TotalCols * TotalCols))
    {
        TraceEnd = SocLoc + (Normal(Vector(CurrentRotation)) * 2000.0000000);
        HitSMA = CurrentWeapon.Trace(HitLocation, HitNormal, TraceEnd, SocLoc, true, Extent,, 1);
        // End:0x5A2
        if(AdvFlashlight_GlowableElement_base(HitSMA) != none)
        {
            AdvFlashlight_GlowableElement_base(HitSMA).SetLightAffectionFromFlashLight(true, false);
        }
        CurrentRotation.Yaw += int((float(182) * -Degrees) / float(TotalCols));
        ++Col;
        // End:0x67B
        if((Col % TotalCols) == 0)
        {
            Col = 0;
            CurrentRotation.Yaw += int(float(182) * Degrees);
            CurrentRotation.Pitch += int((float(182) * Degrees) / float(TotalCols));
        }
        ++I;
        // [Loop Continue]
        goto J0x4C2;
    }
    //return;    
}

function ConsumeAmmo_T()
{
    ConsumeAmmo(CurrentFireMode);
    //return;    
}

simulated function GetLightSourcePosition(out Vector LightLoc, out Rotator LightRot, optional bool bWorldCS = true)
{
    local Vector PVLoc, SocLoc, X, Y, Z, Travel,
	    Offset, BaseSpotlightOffset, ZoomedSpotlightOffset;

    local Rotator PVRot, SocRot, BaseSpotlightRotOffset, ZoomedSpotlightRotOffset, FinalRotOffset;

    local PlayerController PC;
    local float AimAlpha;

    // End:0x137
    if((Instigator == none) || (PlayerController(Instigator.Controller) == none) && (Instigator.DrivenVehicle == none) || PlayerController(Instigator.DrivenVehicle.Controller) == none)
    {
        LightLoc = ((bWorldCS) ? CurrentWeapon.Location : vect(0.0000000, 0.0000000, 0.0000000));
        LightRot = ((bWorldCS) ? CurrentWeapon.Rotation : MakeRotator(0, 0, 0));
        return;
    }
    PC = PlayerController(((Instigator.Controller != none) ? Instigator.Controller : ((Instigator.DrivenVehicle != none) ? Instigator.DrivenVehicle.Controller : none)));
    PC.GetPlayerViewPoint(PVLoc, PVRot);
    // End:0x277
    if((CurrentMesh == none) || CurrentMesh.SkeletalMesh == none)
    {
        SocLoc = PVLoc;
        SocRot = PVRot;        
    }
    else
    {
        // End:0x318
        if(!Instigator.IsFirstPerson())
        {
            // End:0x2ED
            if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
            {
                LightLoc = PVLoc;
                LightRot = PVRot;                
            }
            else
            {
                LightLoc = PVLoc;
                LightRot = PVRot;
            }
            return;            
        }
        else
        {
            CurrentMesh.GetSocketWorldLocationAndRotation('FlashLightSocket', SocLoc, SocRot);
        }
    }
    // End:0x43D
    if(CurrentWeapon.IsA('AdvWeap_3PhaseReload_Base'))
    {
        BaseSpotlightOffset = AdvWeap_3PhaseReload_Base(CurrentWeapon).FlashlightBaseSpotlightOffset;
        ZoomedSpotlightOffset = AdvWeap_3PhaseReload_Base(CurrentWeapon).FlashlightAimingSpotlightOffset;
        BaseSpotlightRotOffset = AdvWeap_3PhaseReload_Base(CurrentWeapon).FlashlightBaseSpotlightRotOffset;
        ZoomedSpotlightRotOffset = AdvWeap_3PhaseReload_Base(CurrentWeapon).FlashlightAimingSpotlightRotOffset;        
    }
    else
    {
        // End:0x524
        if(CurrentWeapon.IsA('AdvWeap_Base'))
        {
            BaseSpotlightOffset = AdvWeap_Base(CurrentWeapon).FlashlightBaseSpotlightOffset;
            ZoomedSpotlightOffset = AdvWeap_Base(CurrentWeapon).FlashlightAimingSpotlightOffset;
            BaseSpotlightRotOffset = AdvWeap_Base(CurrentWeapon).FlashlightBaseSpotlightRotOffset;
            ZoomedSpotlightRotOffset = AdvWeap_Base(CurrentWeapon).FlashlightAimingSpotlightRotOffset;
        }
    }
    // End:0x578
    if(PC.GetFOVAngle() ~= PC.DefaultFOV)
    {
        AimAlpha = 0.0000000;        
    }
    else
    {
        // End:0x5CC
        if(PC.GetFOVAngle() ~= PC.DesiredFOV)
        {
            AimAlpha = 1.0000000;            
        }
        else
        {
            // End:0x6B2
            if(PC.DesiredFOV ~= PC.DefaultFOV)
            {
                AimAlpha = 1.0000000 - ((PC.GetFOVAngle() - EvilWeap_Base(CurrentWeapon).ZoomedTargetFOV) / (PC.DesiredFOV - EvilWeap_Base(CurrentWeapon).ZoomedTargetFOV));                
            }
            else
            {
                AimAlpha = (PC.GetFOVAngle() - PC.DefaultFOV) / (PC.DesiredFOV - PC.DefaultFOV);
            }
        }
    }
    GetAxes(PVRot, X, Y, Z);
    Travel = SocLoc - PVLoc;
    Offset = VLerp(BaseSpotlightOffset, ZoomedSpotlightOffset, AimAlpha);
    Offset.Y += (Travel Dot Y);
    Offset.Z += (Travel Dot Z);
    FinalRotOffset = RLerp(BaseSpotlightRotOffset, ZoomedSpotlightRotOffset, AimAlpha, true);
    LightLoc = (PVLoc - Instigator.Location) + Offset;
    LightRot = FinalRotOffset + QuatToRotator(QuatProduct(QuatInvert(QuatFromRotator(CurrentWeapon.Rotation)), QuatFromRotator(SocRot)));
    // End:0x95D
    if((CurrentWeapon != self) && Parts.Volume != none)
    {
        Parts.Volume.SetRotation(FinalRotOffset);
    }
    // End:0x9E8
    if(bWorldCS)
    {
        LightLoc = (LightLoc >> CurrentWeapon.Rotation) + CurrentWeapon.Location;
        LightRot += CurrentWeapon.Rotation;
    }
    //return;    
}

function string RotatorToEulerString(Rotator R)
{
    return (("" $ string(float(R.Pitch) * 0.0054932)) @ string(float(R.Yaw) * 0.0054932)) @ string(float(R.Roll) * 0.0054932);
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    local EvilPawn P;
    local Controller C;
    local Vector SocLoc;
    local Rotator SocRot;
    local float NewBrightnessMult;
    local LinearColor LC;
    local AdvMapInfo MapInfo;

    super(EvilWeap_Base).Tick(DeltaTime);
    MapInfo = AdvMapInfo(WorldInfo.GetMapInfo());
    // End:0x1AA
    if(IsFlashLightBeamActive())
    {
        // End:0x1A7
        if(Power > 0.0000000)
        {
            ClearTimer('ConsumeAmmo_T');
            Power -= (DeltaTime * TorchParts.PowerDrainRate);
            // End:0x1A7
            if(Power <= 0.0000000)
            {
                Power = 0.0000000;
                bDeadBattery = true;
                bIndicateRechargeDone = true;
                bBlinking = false;
                SetLightState(bFlashlightOn);
                ClientLightState(bFlashlightOn);
                WeaponPlaySound(ManaFinishedSnd3p, ManaFinishedSnd);
                DeactivateFlightBeam();
                ClientDeactivateFlightBeam();
                // End:0x1A7
                if(CurrentWeapon.Instigator.IsLocallyControlled() || int(Role) == int(ROLE_Authority))
                {
                    bBeamWasActive = true;
                }
            }
        }        
    }
    else
    {
        // End:0x2A3
        if(Power < 1.0000000)
        {
            Power += (DeltaTime * TorchParts.PowerRecoveryRate);
            // End:0x216
            if(Power > 1.0000000)
            {
                Power = 1.0000000;                
            }
            else
            {
                // End:0x2A3
                if((Power > TorchParts.PowerRiseLevel) && bDeadBattery)
                {
                    ClearTimer('ConsumeAmmo_T');
                    bDeadBattery = false;
                    // End:0x2A3
                    if(bBeamWasActive && !IsFlashLightBeamActive())
                    {
                        ActivateFlightBeam();
                        ClientActivateFlightBeam();
                    }
                }
            }
        }
    }
    // End:0x3C9
    if((Power >= TorchParts.PowerBlinkRange.X) && Power <= TorchParts.PowerBlinkRange.Y)
    {
        bBlinking = Rand(100) < TorchParts.PowerBlinkChance;
        SetLightState(bFlashlightOn && !bBlinking);
        ClientLightState(bFlashlightOn && !bBlinking);
        // End:0x3C6
        if(bBlinking)
        {
            WeaponPlaySound(SparkSnd3p, SparkSnd);
        }        
    }
    else
    {
        // End:0x419
        if(!bDeadBattery)
        {
            // End:0x419
            if(bBlinking)
            {
                bBlinking = false;
                SetLightState(bFlashlightOn);
                ClientLightState(bFlashlightOn);
            }
        }
    }
    // End:0x46E
    if(IsFlashLightBeamActive())
    {
        FocusAlpha = FMin(1.0000000, FocusAlpha + (DeltaTime * TorchParts.FocusSpeed));        
    }
    else
    {
        FocusAlpha = FMax(0.0000000, FocusAlpha - (DeltaTime * TorchParts.FocusSpeed));
    }
    // End:0x1244
    if(bFlashlightOn && !bBlinking)
    {
        // End:0x5C6
        if(TorchParts.PowerDrainRate == float(0))
        {
            ConeScale = Lerp(1.0000000, (((1.0000000 - TorchParts.PowerBlinkRange.Y) * (0.6000000 ** TorchParts.ConeScaleExponent)) + TorchParts.PowerBlinkRange.Y) * TorchParts.FocusSizeMultiplier, FocusAlpha);            
        }
        else
        {
            ConeScale = Lerp(1.0000000, (((1.0000000 - TorchParts.PowerBlinkRange.Y) * (Power ** TorchParts.ConeScaleExponent)) + TorchParts.PowerBlinkRange.Y) * TorchParts.FocusSizeMultiplier, FocusAlpha);
        }
        // End:0x93A
        if(Parts.Volume != none)
        {
            // End:0x715
            if(BoneScaler == none)
            {
                BoneScaler = UDKSkelControl_MassBoneScaling(Parts.Volume.FindSkelControl('BoneScaler'));
            }
            // End:0x93A
            if(BoneScaler != none)
            {
                // End:0x811
                if(TorchParts.PowerDrainRate == float(0))
                {
                    BoneScaler.SetBoneScale('BigLight', Lerp(1.0000000, (((1.0000000 - TorchParts.OuterConeScaleBias) * (0.6000000 ** TorchParts.OuterConeScaleExponent)) + TorchParts.OuterConeScaleBias) * TorchParts.FocusSizeMultiplier, FocusAlpha));                    
                }
                else
                {
                    BoneScaler.SetBoneScale('BigLight', Lerp(1.0000000, (((1.0000000 - TorchParts.OuterConeScaleBias) * (Power ** TorchParts.OuterConeScaleExponent)) + TorchParts.OuterConeScaleBias) * TorchParts.FocusSizeMultiplier, FocusAlpha));
                }
                BoneScaler.SetBoneScale('SmallLight', Lerp(1.0000000, TorchParts.InnerConeFocusScale, FocusAlpha) * ConeScale);
            }
        }
        ConeScale = ((1.0000000 - TorchParts.SpotlightConeSizeBias) * ConeScale) + TorchParts.SpotlightConeSizeBias;
        // End:0xFE6
        if(Parts.SpotLight != none)
        {
            Parts.SpotLight.OuterConeAngle = ConeScale * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.OuterConeAngle;
            Parts.SpotLight.InnerConeAngle = ConeScale * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.InnerConeAngle;
            Parts.SpotLight.Function.Scale = AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.Function.Scale * ConeScale;
            // End:0xC3B
            if(bIndicateRechargeDone && MagazineAmmoCount > 0)
            {
                NewBrightnessMult = FInterpEaseInOut(TorchParts.LowBatteryLightBrightness, 1.0000000, FClamp(FPctByRange(Power, TorchParts.LightFadePowerRange_Recharge.X, TorchParts.LightFadePowerRange_Recharge.Y), 0.0000000, 1.0000000), 2.0000000) + (25.0000000 * (1.0000000 - (FMin(Abs(Power - 0.9250000), 0.0375000) / 0.0375000)));
                // End:0xC38
                if(Power >= 0.9250000)
                {
                    WeaponPlaySound(ManaRegeneratedSnd3p, ManaRegeneratedSnd);
                    bIndicateRechargeDone = false;
                }                
            }
            else
            {
                NewBrightnessMult = FInterpEaseInOut(TorchParts.LowBatteryLightBrightness, 1.0000000, FClamp(FPctByRange(Power, TorchParts.LightFadePowerRange_Discharge.X, TorchParts.LightFadePowerRange_Discharge.Y), 0.0000000, 1.0000000), 2.0000000) * Lerp(1.0000000, TorchParts.FocusLightBrightness, FocusAlpha * Power);
            }
            Parts.SpotLight.SetLightProperties(NewBrightnessMult * ((MapInfo != none) ? MapInfo.FlashLightParams.Brightness : AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.Brightness), LerpColor(TorchParts.LowBatteryLightColour, AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.LightColor, Power));
            CurrentWeapon.ReattachComponent(Parts.SpotLight);
            LC = ColorToLinearColor(Parts.SpotLight.LightColor);
            LC.A = FMin(NewBrightnessMult * 0.5000000, 1.0000000);
            // End:0xF3E
            if(Parts.VolumeMI[0] != none)
            {
                Parts.VolumeMI[0].SetVectorParameterValue('Color', LC);
            }
            LC.A *= (Power * Lerp(1.0000000, 120.0000000, FocusAlpha));
            // End:0xFE6
            if(Parts.VolumeMI[1] != none)
            {
                Parts.VolumeMI[1].SetVectorParameterValue('Color', LC);
            }
        }
        // End:0x117E
        if(Parts.SecondSpotLightC != none)
        {
            Parts.SecondSpotLightC.OuterConeAngle = ConeScale * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent2'.OuterConeAngle;
            Parts.SecondSpotLightC.InnerConeAngle = ConeScale * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent2'.InnerConeAngle;
            Parts.SecondSpotLightC.Function.Scale = AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent2'.Function.Scale * ConeScale;
            CurrentWeapon.ReattachComponent(Parts.SecondSpotLightC);
        }
        // End:0x1244
        if((Parts.Flare != none) && Parts.SpotLight != none)
        {
            LC = ColorToLinearColor(Parts.SpotLight.LightColor);
            Parts.Flare.SetSourceColor(LC);
        }
    }
    P = EvilPawn(Owner);
    // End:0x1765
    if(((P != none) && Instigator.IsLocallyControlled()) && bFlashlightOn)
    {
        C = ((P.Controller != none) ? P.Controller : ((P.DrivenVehicle != none) ? P.DrivenVehicle.Controller : none));
        // End:0x1762
        if(C != none)
        {
            C.GetPlayerViewPoint(SocLoc, SocRot);
            // End:0x14EF
            if(RadialBlur != none)
            {
                // End:0x1426
                if(RadialBlur.RadialBlur.bEnabled != (FocusAlpha > 0.0000000))
                {
                    RadialBlur.RadialBlur.SetEnabled(FocusAlpha > 0.0000000);
                }
                // End:0x14EF
                if(RadialBlur.RadialBlur.bEnabled)
                {
                    RadialBlur.SetLocation(SocLoc + (Vector(SocRot) * 20.0000000));
                    RadialBlur.RadialBlur.SetBlurScale(FocusAlpha * RadialBlurComponent'ar_FlashLight.ar_RadialBlurComponent'.BlurScale);
                }
            }
            // End:0x1762
            if((bFlashlightOn && P.IsFirstPerson()) && Parts.SpotLight != none)
            {
                GetLightSourcePosition(SocLoc, SocRot, false);
                Parts.SpotLight.SetTranslation(SocLoc);
                Parts.SpotLight.SetRotation(SocRot);
                // End:0x1762
                if((C != none) && C.IsInState('FlashlightOffsetEditor'))
                {
                    DrawDebugLine(CurrentWeapon.Location, (CurrentWeapon.Location + SocLoc) >> CurrentWeapon.Rotation, 255, 0, 0);
                    DrawDebugLine(CurrentWeapon.Location + (SocLoc >> CurrentWeapon.Rotation), (CurrentWeapon.Location + (SocLoc >> CurrentWeapon.Rotation)) + (Vector(CurrentWeapon.Rotation + SocRot) * float(8192)), 0, 255, 0);
                }
            }
        }        
    }
    else
    {
        // End:0x1841
        if((AdvTurret_Base(Owner) != none) && bFlashlightOn)
        {
            GetLightSourcePosition(SocLoc, SocRot, false);
            // End:0x1841
            if(Parts.SpotLight != none)
            {
                Parts.SpotLight.SetTranslation(SocLoc);
                Parts.SpotLight.SetRotation(SocRot);
            }
        }
    }
    FLUpdateBeam(DeltaTime);
    //return;    
}

simulated function NotifyWeaponEquipping(EvilWeap_Base NewWeapon, bool bBegin)
{
    // End:0x28B
    if(bBegin)
    {
        // End:0x13C
        if(IsAttachedToAnotherWeapon())
        {
            // End:0xCC
            if(!NewWeapon.BothHandWeapon && !NewWeapon.UsesOffhand)
            {
                TurnFlashlightOff();
                ClientTurnFlashlight(false);
                DetachFromWeapon();
                AdvPawn(Owner).SavedWeaponLeft = NewWeapon.OffHandWeaponClass;
                return;
            }
            // End:0x139
            if(NewWeapon.BothHandWeapon && CanAttachToWeapon(NewWeapon))
            {
                TurnFlashlightOff();
                ClientTurnFlashlight(false);
                DetachFromWeapon();
                AttachToWeapon(NewWeapon);
            }            
        }
        else
        {
            // End:0x23D
            if((AdvPawn(Owner).WeaponLeft == self) && NewWeapon.BothHandWeapon)
            {
                TurnFlashlightOff();
                ClientTurnFlashlight(false);
                AdvPawn(Owner).SavedWeaponLeft = none;
                AdvPawn(Owner).SavedWeapon = none;
                AttachToWeapon(NewWeapon);
                AdvPawn(Owner).SetBlockingInventoryClass(Class'AdvInventoryItem_Torch', true);                
            }
            else
            {
                // End:0x288
                if(AdvPawn(Owner).WeaponLeft == self)
                {
                    InternalAttachToWeapon(self, UDKSkeletalMeshComponent(Mesh), true);
                }
            }
        }        
    }
    else
    {
        // End:0x37C
        if(IsEquipped())
        {
            // End:0x34F
            if(((AdvPawn(Owner).WeaponLeft == self) && !IsAttachedToAnotherWeapon()) || NewWeapon.BothHandWeapon)
            {
                TurnFlashlightOn();
                ClientTurnFlashlight(true);
                AdvPawn(Owner).SetBlockingInventoryClass(self.Class, true);
            }
            // End:0x370
            if(bAutoActiveAfterEquip)
            {
                ActivateFlightBeam();
                ClientActivateFlightBeam();
            }
            bPendingFlashlightOn = false;
        }
    }
    //return;    
}

simulated function NotifyWeaponPuttingDown(EvilWeap_Base OldWeapon, bool bBegin)
{
    // End:0x3F
    if(bBegin)
    {
        // End:0x3F
        if((IsEquipped()) || bFlashlightOn)
        {
            TurnFlashlightOff();
            ClientTurnFlashlight(false);
        }
    }
    //return;    
}

simulated function NotifyQuickHide(bool bBegin)
{
    // End:0x33
    if(bBegin)
    {
        // End:0x30
        if(IsEquipped())
        {
            TurnFlashlightOff();
            ClientTurnFlashlight(false);
        }        
    }
    else
    {
        // End:0x56
        if(IsEquipped())
        {
            TurnFlashlightOn();
            ClientTurnFlashlight(true);
        }
    }
    //return;    
}

simulated event Destroyed()
{
    TorchParts = none;
    ForceClearLightTargets();
    BoneScaler = none;
    DetachFromWeapon();
    // End:0x51
    if(RadialBlur != none)
    {
        RadialBlur.Destroy();
    }
    super(EvilWeap_Base).Destroyed();
    //return;    
}

simulated function StartZoom(EvilPlayerController PC, byte FireModeNum, optional bool bZoomSyncFromOther = false)
{
    super(AdvWeap_Base).StartZoom(PC, FireModeNum);
    //return;    
}

simulated function EndZoom(EvilPlayerController PC, optional bool bZoomSyncFromOther = false)
{
    super(AdvWeap_Base).EndZoom(PC);
    //return;    
}

simulated function EndZoomInstant(EvilPlayerController PC, optional bool bZoomSyncFromOther = false)
{
    super(AdvWeap_Base).EndZoomInstant(PC);
    //return;    
}

simulated function bool CanFocus()
{
    return (bFlashlightOn && !bDeadBattery) && MagazineAmmoCount > 0;
    //return ReturnValue;    
}

simulated function ChangeTorchPowerFromVolume(bool bEntering, optional float InPower, optional float InDrainRate, optional float InRecoveryRate, optional float InBlinkChance, optional bool bInfiniteBattery, optional bool InLookForGlowableElements, optional int InFixedTotalCols)
{
    // End:0x18A
    if(bEntering)
    {
        bLookForGlowableElements = InLookForGlowableElements;
        TemporaryFixedTotalCols = InFixedTotalCols;
        // End:0xC7
        if(bInfiniteBattery)
        {
            Power = InPower;
            TorchParts.PowerDrainRate = 0.0000000;
            TorchParts.PowerRecoveryRate = 0.0000000;
            TorchParts.PowerBlinkChance = 0;            
        }
        else
        {
            Power = InPower;
            // End:0x113
            if(InDrainRate != float(0))
            {
                TorchParts.PowerDrainRate = InDrainRate;
            }
            // End:0x14C
            if(InRecoveryRate != float(0))
            {
                TorchParts.PowerRecoveryRate = InRecoveryRate;
            }
            // End:0x187
            if(InBlinkChance != float(0))
            {
                TorchParts.PowerBlinkChance = int(InBlinkChance);
            }
        }        
    }
    else
    {
        Power = Class'AdvInventoryItem_Torch'.default.Power;
        TorchParts.PowerDrainRate = Class'AdvInventoryTorchParts'.default.PowerDrainRate;
        TorchParts.PowerRecoveryRate = Class'AdvInventoryTorchParts'.default.PowerRecoveryRate;
        TorchParts.PowerBlinkChance = Class'AdvInventoryTorchParts'.default.PowerBlinkChance;
        bLookForGlowableElements = false;
        TemporaryFixedTotalCols = 0;
    }
    // End:0x413
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x35E
        if(AdvAttachment_Weap_Base(AdvPlayerPawn(Instigator).CurrentWeaponAttachment) != none)
        {
            AdvAttachment_Weap_Base(AdvPlayerPawn(Instigator).CurrentWeaponAttachment).ChangeTorchPowerFromVolume(bEntering, InPower, InDrainRate, InRecoveryRate, InBlinkChance, bInfiniteBattery);
        }
        // End:0x413
        if(AdvAttachment_Weap_Base(AdvPlayerPawn(Instigator).CurrentWeaponLeftAttachment) != none)
        {
            AdvAttachment_Weap_Base(AdvPlayerPawn(Instigator).CurrentWeaponLeftAttachment).ChangeTorchPowerFromVolume(bEntering, InPower, InDrainRate, InRecoveryRate, InBlinkChance, bInfiniteBattery);
        }
    }
    //return;    
}

simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList, optional Vector Extent)
{
    local ImpactInfo CurrentImpact;
    local bool bOldBlockActors, bOldCollideActors;
    local EvilPhysicalMaterialPropertyBase PhysMatProp;

    CurrentImpact = super(Weapon).CalcWeaponFire(StartTrace, EndTrace, ImpactList, Extent);
    // End:0x354
    if((((CurrentImpact.HitActor != none) && (ImpactList.Length < 2) || CurrentImpact.HitActor != ImpactList[ImpactList.Length - 2].HitActor) && CurrentImpact.HitLocation != EndTrace) && CurrentImpact.HitInfo.PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialPropertyBase(CurrentImpact.HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'EvilGame.EvilPhysicalMaterialPropertyBase'));
        // End:0x354
        if((PhysMatProp != none) && PhysMatProp.PassThroughDamping < 1.0000000)
        {
            CurrentImpact.HitActor.bProjTarget = false;
            bOldCollideActors = CurrentImpact.HitActor.bCollideActors;
            bOldBlockActors = CurrentImpact.HitActor.bBlockActors;
            CurrentImpact.HitActor.SetCollision(false, false);            
            CalcWeaponFire(CurrentImpact.HitLocation, EndTrace, ImpactList, Extent);
            CurrentImpact.HitActor.bProjTarget = true;
            CurrentImpact.HitActor.SetCollision(bOldCollideActors, bOldBlockActors);
        }
    }
    return CurrentImpact;
    //return ReturnValue;    
}

simulated state QuickHide
{
    simulated function BeginState(name PreviousStateName)
    {
        NotifyQuickHide(true);
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        NotifyQuickHide(false);
        //return;        
    }
    stop;    
}

defaultproperties
{
    FlashlightOnSnd=SoundCue'a_Flashlight.a_FlashlightOn'
    FlashlightOffSnd=SoundCue'a_Flashlight.a_FlashlightOff'
    // Reference: AudioComponent'Default__AdvInventoryItem_Torch.MagicSoundStartComp'
    begin object name=MagicSoundStartComp class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'a_Flashlight.a_FlashlightMagicOn'
        bStopWhenOwnerDestroyed=true
        bAllowSpatialization=false
    end object
    MagicSoundStart=MagicSoundStartComp
    // Reference: AudioComponent'Default__AdvInventoryItem_Torch.MagicSoundLoopComp'
    begin object name=MagicSoundLoopComp class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'a_Flashlight.a_FlashlightMagicLoop'
        bStopWhenOwnerDestroyed=true
        bAllowSpatialization=false
    end object
    MagicSoundLoop=MagicSoundLoopComp
    // Reference: AudioComponent'Default__AdvInventoryItem_Torch.MagicSoundEndComp'
    begin object name=MagicSoundEndComp class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'a_Flashlight.a_FlashlightMagicEnd'
        bStopWhenOwnerDestroyed=true
        bAllowSpatialization=false
    end object
    MagicSoundEnd=MagicSoundEndComp
    ManaFinishedSnd=SoundCue'a_Flashlight.a_FlashlightManaFinished'
    ManaRegeneratedSnd=SoundCue'a_Flashlight.a_FlashlightManaRegenerated'
    SparkSnd=SoundCue'a_Flashlight.a_FlashlightSpark'
    FlashlightOnSnd3p=SoundCue'a_FlashlightTP.a_FlashlightOnTP'
    FlashlightOffSnd3p=SoundCue'a_FlashlightTP.a_FlashlightOffTP'
    ManaFinishedSnd3p=SoundCue'a_FlashlightTP.a_FlashlightManaFinishedTP'
    ManaRegeneratedSnd3p=SoundCue'a_FlashlightTP.a_FlashlightManaRegeneratedTP'
    SparkSnd3p=SoundCue'a_FlashlightTP.a_FlashlightSparkTP'
    PostProcessTint=(R=0.5000000,G=0.2000000,B=0.0000000,A=1.0000000)
    PostProcessPower=0.1500000
    PostProcessFadeSpeed=3.0000000
    Power=1.0000000
    FLEndPointParamName="LinkBeamEnd"
    FLBeamSocket="LightVolume"
    ShieldedHitEffect=ParticleSystem'ps_Mummy.Effects.ps_Flashlight_ShieldSparkles'
    FrozenHitEffect=ParticleSystem'ps_Mummy.Effects.ps_ch_MummyUnFreeze'
    HitEffect=ParticleSystem'ps_Mummy.Effects.ps_LightHitConeConst'
    HitEffectWhenBurned=ParticleSystem'ps_Mummy.Effects.ps_LightHitConeConstTest'
    PerBoneHitEffectInterval=2
    BeamAtachedScale=1.0000000
    BonesToTest[0]="Spine"
    BonesToTest[1]="Head"
    BonesToTest[2]="LeftArm"
    BonesToTest[3]="RightArm"
    BonesToTest[4]="LeftUpLeg"
    BonesToTest[5]="RightUpLeg"
    BonesToTest[6]="LeftForeArm"
    BonesToTest[7]="RightForeArm"
    BonesToTest[8]="LeftLeg"
    BonesToTest[9]="RightLeg"
    BonesToTest[10]="LeftHand"
    BonesToTest[11]="RightHand"
    BonesToTest[12]="LeftFoot"
    BonesToTest[13]="RightFoot"
    FlashlightBaseSpotlightOffset=(X=-45.9853000,Y=16.1519000,Z=-6.2950000)
    FlashlightBaseSpotlightRotOffset=(Pitch=189,Yaw=799,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-35.2771000,Y=13.9304000,Z=-10.5893000)
    FlashlightAimingSpotlightRotOffset=(Pitch=133,Yaw=800,Roll=0)
    bDisplayCrosshair=true
    UsesOffhand=true
    OffHandDoesNotFire=true
    DefaultAmmoCount=500
    MaxAmmoCount=500
    MagazineAmmoCount=500
    MagazineMaxAmmoCount=500
    WeaponDamage=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvInventoryItem_Torch.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    ReloadTime=3.0000000
    bZoomedFireMode=/* Array type was not detected. */
    InventoryGroup=69
    ZoomedRate=45.0000000
    ZoomedMeshTranslation=(X=5.0000000,Y=8.0000000,Z=-4.0000000)
    ZoomedMeshRotation=(Pitch=0,Yaw=-728,Roll=0)
    ZoomedWeaponIdleAnims=/* Array type was not detected. */
    ZoomedWeaponFireAnim=/* Array type was not detected. */
    ZoomedArmIdleAnims=/* Array type was not detected. */
    ZoomedArmFireAnim=/* Array type was not detected. */
    AttachmentClass=Class'AdvInventoryItemAttachment_Torch'
    ArmsAnimSet=AnimSet'wp_flashlight_01.Anim.as_wp_flashlight_hands'
    // Reference: AudioComponent'Default__AdvInventoryItem_Torch.ReloadSound'
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
    // Reference: DynamicLightEnvironmentComponent'Default__AdvInventoryItem_Torch.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Flashlight"
    PlayerViewOffset=(X=43.0000000,Y=14.2000000,Z=-17.5000000)
    PlayerRotationOffset=(Pitch=0,Yaw=910,Roll=0)
    AmmoCount=500
    EquipTime=0.1000000
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvInventoryItem_Torch.FirstPersonMesh'
    begin object name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'wp_flashlight_01.Mesh.sk_wp_flashlight_01'
        AnimTreeTemplate=AnimTree'wp_flashlight_01.Anim.at_wp_flashlight_01'
        AnimSets[0]=AnimSet'wp_flashlight_01.Anim.as_wp_flashlight_01'
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ItemName="Flashlight"
    // Reference: SkeletalMeshComponent'Default__AdvInventoryItem_Torch.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    Components[2]=MagicSoundStartComp
    Components[3]=MagicSoundLoopComp
    Components[4]=MagicSoundEndComp
}