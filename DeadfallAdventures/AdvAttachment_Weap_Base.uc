class AdvAttachment_Weap_Base extends EvilAttachment_Weap_Base
    abstract
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

var() repnotify PartComponents Parts;
var repnotify export editinline ParticleSystemComponent FLBeamEmitter;
var repnotify bool bFlashlightOn;
var repnotify bool bFlashlightBeamActive;
var bool bCheckForFlashlight;
var bool bAttachFlashlightToWeapon;
var() transient bool bBlinking;
var() transient bool bIndicateRechargeDone;
var() float Power;
var transient float FocusAlpha;
var transient UDKSkelControl_MassBoneScaling BoneScaler;
var transient float ConeScale;
var AdvInventoryTorchParts TorchParts;
var export editinline UDKSkeletalMeshComponent AttachableMesh;
var() StaticMesh DroppedMagazineMesh;
var transient AdvSkelControl_Magazine MagSkelControl;

replication
{
    // Pos:0x000
    if(bNetDirty
        FLBeamEmitter, Parts, 
        bFlashlightBeamActive, bFlashlightOn;
}

simulated event PostBeginPlay()
{
    TorchParts = new (Outer) Class'AdvInventoryTorchParts';
    SetLightState(false);
    DeactivateFlashlightBeam();
    super.PostBeginPlay();
    SetTimer(0.1000000, false, 'TestTorch_T');
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local AdvMapInfo MapInfo;

    super(Actor).PostInitAnimTree(SkelComp);
    MagSkelControl = AdvSkelControl_Magazine(SkelComp.FindSkelControl('Magazine'));
    MapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0x100
    if((MapInfo != none) && MapInfo.WeaponMaterialLight_3rd != 1.0000000)
    {
        SetWeaponMaterialLight(MapInfo.WeaponMaterialLight_3rd, Mesh);
    }
    //return;    
}

simulated function TestTorch_T()
{
    local AdvPlayerPawn PP;

    bCheckForFlashlight = false;
    PP = AdvPlayerPawn(Owner);
    // End:0x1B5
    if((((PP != none) && !PP.IsLocallyControlled()) && AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).bIsSurvivalGame)
    {
        // End:0x1B5
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            // End:0x140
            if(self.Class == Class'AdvInventoryItemAttachment_Torch')
            {
                bAttachFlashlightToWeapon = false;
                InternalAttach();
                bCheckForFlashlight = true;                
            }
            else
            {
                // End:0x1B5
                if(self.Class != Class'AdvInventoryItemAttachment_Base')
                {
                    // End:0x1B5
                    if(PP.CurrentWeaponLeftAttachment == none)
                    {
                        bAttachFlashlightToWeapon = true;
                        AttachToWeapon(self);
                        InternalAttach();
                        bCheckForFlashlight = true;
                    }
                }
            }
        }
    }
    //return;    
}

simulated function UpdateFlashlight()
{
    SetLightState(bFlashlightOn);
    // End:0x3D
    if(bFlashlightOn && bFlashlightBeamActive)
    {
        ActivateFlashlightBeam();        
    }
    else
    {
        DeactivateFlashlightBeam();
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(Pawn(Owner).Controller);
    super(Actor).Tick(DeltaTime);
    // End:0xEE
    if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && (PC == none) || !PC.Pawn.IsLocallyControlled()) && bCheckForFlashlight)
    {
        UpdateFlashlight();
        LightBehaviour(DeltaTime);
    }
    //return;    
}

simulated function SetupFlashLightBeam(SkeletalMeshComponent SkelMesh)
{
    // End:0x179
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        FLBeamEmitter = new (Outer) Class'EvilGame.UTParticleSystemComponent';
        FLBeamEmitter.SetDepthPriorityGroup(2);
        FLBeamEmitter.SetTemplate(TorchParts.FLBeamTemplate);
        FLBeamEmitter.SetHidden(true);
        FLBeamEmitter.SetTickGroup(3);
        FLBeamEmitter.bUpdateComponentInTick = true;
        FLBeamEmitter.SetIgnoreOwnerHidden(true);
        SkelMesh.AttachComponentToSocket(FLBeamEmitter, 'LightVolume');
        FLBeamEmitter.DeactivateSystem();
    }
    //return;    
}

simulated function ActivateFlashlightBeam()
{
    // End:0x66
    if(Parts.VolumeMI[0] != none)
    {
        Parts.VolumeMI[0].SetScalarParameterValue('LuminosityScale', 2.0000000);
    }
    // End:0xCC
    if(Parts.VolumeMI[1] != none)
    {
        Parts.VolumeMI[1].SetScalarParameterValue('LuminosityScale', 20.0000000);
    }
    //return;    
}

simulated function DeactivateFlashlightBeam()
{
    // End:0x66
    if(Parts.VolumeMI[0] != none)
    {
        Parts.VolumeMI[0].SetScalarParameterValue('LuminosityScale', 1.5000000);
    }
    // End:0xCC
    if(Parts.VolumeMI[1] != none)
    {
        Parts.VolumeMI[1].SetScalarParameterValue('LuminosityScale', 3.0000000);
    }
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

simulated function AttachToWeapon(EvilAttachment_Weap_Base Attachment_Weap)
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
        if((MapInfo != none) && MapInfo.WeaponMaterialLight_3rd != 1.0000000)
        {
            SetWeaponMaterialLight(MapInfo.WeaponMaterialLight_3rd, AttachableMesh);
        }
    }
    TargetMesh = Attachment_Weap.Mesh;
    TargetMesh.AttachComponentToSocket(AttachableMesh, 'FlashLightSocket');
    // End:0x1C4
    if(TargetMesh.IsA('UDKSkeletalMeshComponent'))
    {
        AttachableMesh.SetFOV(UDKSkeletalMeshComponent(TargetMesh).FOV);
    }
    AttachableMesh.SetLightEnvironment(Attachment_Weap.Mesh.LightEnvironment);
    AttachableMesh.SetDepthPriorityGroup(TargetMesh.DepthPriorityGroup);
    //return;    
}

simulated function InternalAttach()
{
    local LinearColor LC;
    local AdvEngine Engine;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    SetupFlashLightBeam(Mesh);
    // End:0x430
    if(Mesh.GetSocketByName('FlashLightSocket') != none)
    {
        // End:0x344
        if(Parts.SpotLight == none)
        {
            // End:0x341
            if((Engine == none) || Engine.bFlashlight3rdPersonSpotlight)
            {
                Parts.SpotLight = new (Outer) Class'AdvFlashlightSpotlightComponent' (AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent');
                Parts.SpotLight.Radius *= ((Engine == none) ? 1.0000000 : Engine.FlashlightRadiusScale);
                // End:0x30C
                if((Engine == none) || Engine.bFlashlightUseMaterialFunction)
                {
                    // End:0x309
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
        }
        else
        {
            Parts.SpotLight.DetachFromAny();
        }
        // End:0x430
        if(Parts.SpotLight != none)
        {
            // End:0x3EC
            if(bAttachFlashlightToWeapon)
            {
                AttachableMesh.AttachComponentToSocket(Parts.SpotLight, 'FlashLightSocket');                
            }
            else
            {
                Mesh.AttachComponentToSocket(Parts.SpotLight, 'LightVolume');
            }
        }
    }
    // End:0x7B4
    if((Parts.SpotLight != none) && ((bAttachFlashlightToWeapon) ? Mesh.GetSocketByName('FlashLightSocket') != none : Mesh.GetSocketByName('LightVolume') != none))
    {
        // End:0x6B3
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
        Parts.Volume.SetFOV(0.0000000);
        // End:0x770
        if(bAttachFlashlightToWeapon)
        {
            AttachableMesh.AttachComponentToSocket(Parts.Volume, 'FlashLightSocket');            
        }
        else
        {
            Mesh.AttachComponentToSocket(Parts.Volume, 'LightVolume');
        }
    }
    // End:0xA38
    if(((bAttachFlashlightToWeapon) ? Mesh.GetSocketByName('FlashLightSocket') != none : Mesh.GetSocketByName('LightFlare') != none))
    {
        // End:0x874
        if(Parts.Flare == none)
        {
            Parts.Flare = new (Outer) Class'Engine.LensFlareComponent';            
        }
        else
        {
            Parts.Flare.DetachFromAny();
        }
        Parts.Flare.SetDepthPriorityGroup(Mesh.DepthPriorityGroup);
        Parts.Flare.SetTemplate(LensFlare'ps_FlashlightAttachment.flares.lf_flashlight');
        // End:0x9BD
        if(bAttachFlashlightToWeapon)
        {
            Parts.Flare.SetScale(0.0100000);
            AttachableMesh.AttachComponentToSocket(Parts.Flare, 'FlashLightSocket');            
        }
        else
        {
            Parts.Flare.SetScale(0.0100000);
            Mesh.AttachComponentToSocket(Parts.Flare, 'LightFlare');
        }
    }
    //return;    
}

simulated function DetachFromWeapon()
{
    // End:0x2E
    if(AttachableMesh != none)
    {
        AttachableMesh.DetachFromAny();
    }
    //return;    
}

simulated function LightBehaviour(float DeltaTime)
{
    local float NewBrightnessMult;
    local LinearColor LC;

    // End:0xA5
    if(bFlashlightBeamActive)
    {
        // End:0xA2
        if(Power > 0.0000000)
        {
            Power -= (DeltaTime * TorchParts.PowerDrainRate);
            // End:0xA2
            if(Power <= 0.0000000)
            {
                Power = 0.0000000;
                bIndicateRechargeDone = true;
                bBlinking = false;
                SetLightState(bFlashlightOn);
            }
        }        
    }
    else
    {
        // End:0x10E
        if(Power < 1.0000000)
        {
            Power += (DeltaTime * TorchParts.PowerRecoveryRate);
            // End:0x10E
            if(Power > 1.0000000)
            {
                Power = 1.0000000;
            }
        }
    }
    // End:0x163
    if(bFlashlightBeamActive)
    {
        FocusAlpha = FMin(1.0000000, FocusAlpha + (DeltaTime * TorchParts.FocusSpeed));        
    }
    else
    {
        FocusAlpha = FMax(0.0000000, FocusAlpha - (DeltaTime * TorchParts.FocusSpeed));
    }
    // End:0xFE9
    if(bFlashlightOn)
    {
        // End:0x2AA
        if(TorchParts.PowerDrainRate == float(0))
        {
            ConeScale = Lerp(1.0000000, (((1.0000000 - TorchParts.PowerBlinkRange.Y) * (0.6000000 ** TorchParts.ConeScaleExponent)) + TorchParts.PowerBlinkRange.Y) * TorchParts.FocusSizeMultiplier, FocusAlpha);            
        }
        else
        {
            ConeScale = Lerp(1.0000000, (((1.0000000 - TorchParts.PowerBlinkRange.Y) * (Power ** TorchParts.ConeScaleExponent)) + TorchParts.PowerBlinkRange.Y) * TorchParts.FocusSizeMultiplier, FocusAlpha);
        }
        // End:0x61E
        if(Parts.Volume != none)
        {
            // End:0x3F9
            if(BoneScaler == none)
            {
                BoneScaler = UDKSkelControl_MassBoneScaling(Parts.Volume.FindSkelControl('BoneScaler'));
            }
            // End:0x61E
            if(BoneScaler != none)
            {
                // End:0x4F5
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
        // End:0xCFC
        if(Parts.SpotLight != none)
        {
            Parts.SpotLight.OuterConeAngle = ConeScale * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.OuterConeAngle;
            Parts.SpotLight.InnerConeAngle = ConeScale * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.InnerConeAngle;
            Parts.SpotLight.Function.Scale = AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.Function.Scale * ConeScale;
            // End:0x904
            if(bIndicateRechargeDone && Power > float(0))
            {
                NewBrightnessMult = FInterpEaseInOut(TorchParts.LowBatteryLightBrightness, 1.0000000, FClamp(FPctByRange(Power, TorchParts.LightFadePowerRange_Recharge.X, TorchParts.LightFadePowerRange_Recharge.Y), 0.0000000, 1.0000000), 2.0000000) + (25.0000000 * (1.0000000 - (FMin(Abs(Power - 0.9250000), 0.0375000) / 0.0375000)));
                // End:0x901
                if(Power >= 0.9250000)
                {
                    bIndicateRechargeDone = false;
                }                
            }
            else
            {
                NewBrightnessMult = FInterpEaseInOut(TorchParts.LowBatteryLightBrightness, 1.0000000, FClamp(FPctByRange(Power, TorchParts.LightFadePowerRange_Discharge.X, TorchParts.LightFadePowerRange_Discharge.Y), 0.0000000, 1.0000000), 2.0000000) * Lerp(1.0000000, TorchParts.FocusLightBrightness, FocusAlpha * Power);
            }
            Parts.SpotLight.SetLightProperties(NewBrightnessMult * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.Brightness, LerpColor(TorchParts.LowBatteryLightColour, AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.LightColor, Power));
            Parts.SpotLight.DetachFromAny();
            // End:0xB2D
            if(bAttachFlashlightToWeapon)
            {
                AttachableMesh.AttachComponentToSocket(Parts.SpotLight, 'FlashLightSocket');                
            }
            else
            {
                Mesh.AttachComponentToSocket(Parts.SpotLight, 'LightVolume');
            }
            LC = ColorToLinearColor(Parts.SpotLight.LightColor);
            LC.A = FMin(NewBrightnessMult * 0.5000000, 1.0000000);
            // End:0xC54
            if(Parts.VolumeMI[0] != none)
            {
                Parts.VolumeMI[0].SetVectorParameterValue('Color', LC);
            }
            LC.A *= (Power * Lerp(1.0000000, 120.0000000, FocusAlpha));
            // End:0xCFC
            if(Parts.VolumeMI[1] != none)
            {
                Parts.VolumeMI[1].SetVectorParameterValue('Color', LC);
            }
        }
        // End:0xF23
        if(Parts.SecondSpotLightC != none)
        {
            Parts.SecondSpotLightC.OuterConeAngle = ConeScale * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent2'.OuterConeAngle;
            Parts.SecondSpotLightC.InnerConeAngle = ConeScale * AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent2'.InnerConeAngle;
            Parts.SecondSpotLightC.Function.Scale = AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent2'.Function.Scale * ConeScale;
            Parts.SecondSpotLightC.DetachFromAny();
            // End:0xEDF
            if(bAttachFlashlightToWeapon)
            {
                AttachableMesh.AttachComponentToSocket(Parts.SecondSpotLightC, 'FlashLightSocket');                
            }
            else
            {
                Mesh.AttachComponentToSocket(Parts.SecondSpotLightC, 'LightVolume');
            }
        }
        // End:0xFE9
        if((Parts.Flare != none) && Parts.SpotLight != none)
        {
            LC = ColorToLinearColor(Parts.SpotLight.LightColor);
            Parts.Flare.SetSourceColor(LC);
        }
    }
    //return;    
}

simulated event Destroyed()
{
    DetachFromWeapon();
    TorchParts = none;
    MagSkelControl = none;
    super(Actor).Destroyed();
    //return;    
}

simulated function ChangeTorchPowerFromVolume(bool bEntering, optional float InPower, optional float InDrainRate, optional float InRecoveryRate, optional float InBlinkChance, optional bool bInfiniteBattery, optional bool InLookForGlowableElements)
{
    // End:0x161
    if(bEntering)
    {
        // End:0x9E
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
            // End:0xEA
            if(InDrainRate != float(0))
            {
                TorchParts.PowerDrainRate = InDrainRate;
            }
            // End:0x123
            if(InRecoveryRate != float(0))
            {
                TorchParts.PowerRecoveryRate = InRecoveryRate;
            }
            // End:0x15E
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
    }
    //return;    
}

simulated function ThirdPersonFireEffects(Vector HitLocation)
{
    local AdvPawn P;
    local AdvSkelControl_HandIK IKNode;

    super.ThirdPersonFireEffects(HitLocation);
    P = AdvPawn(Instigator);
    // End:0xE3
    if(P != none)
    {
        IKNode = AdvSkelControl_HandIK(((P.CurrentWeaponLeftAttachment == self) ? P.LeftHandIK : P.RightHandIK));
        // End:0xE3
        if(IKNode != none)
        {
            IKNode.bPlayRecoil = true;
        }
    }
    //return;    
}

simulated function SetWeaponMaterialLight(float WeaponMaterialLight, SkeletalMeshComponent onMesh)
{
    local int I, NumElements;
    local MaterialInstanceConstant MIC;

    // End:0xCB
    if(onMesh != none)
    {
        NumElements = onMesh.GetNumElements();
        I = 0;
        J0x43:

        // End:0xCB [Loop If]
        if(I < NumElements)
        {
            MIC = onMesh.CreateAndSetMaterialInstanceConstant(I);
            MIC.SetScalarParameterValue('LevelMultiply', WeaponMaterialLight);
            ++I;
            // [Loop Continue]
            goto J0x43;
        }
    }
    //return;    
}

function SetSkin(Material NewMaterial)
{
    //return;    
}

defaultproperties
{
    Power=1.0000000
    // Reference: SkeletalMeshComponent'Default__AdvAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        AnimTreeTemplate=AnimTree'an_human.AnimTree.AT_WeaponAttachmentMagazine'
        Animations=none
        bUpdateSkelWhenNotRendered=true
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    TracerClass=Class'AdvProjectile_Tracer'
}