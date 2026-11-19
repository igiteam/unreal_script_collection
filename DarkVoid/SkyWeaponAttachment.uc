class SkyWeaponAttachment extends Actor
    abstract
    native
    notplaceable;

struct native IKAttachControl
{
    var name SkelControl;
    var name Socket;

    structdefaultproperties
    {
        SkelControl="None"
        Socket="None"
    }
};

var class<Actor> SplashEffect;
var export editinline MeshComponent Mesh;
var name AttachSocketName;
var protected export editinline MeshComponent OverlayMesh;
var name MuzzleFlashSocket;
var export editinline StaticMeshComponent MuzzleFlashMesh;
var export editinline transient SkyParticleSystemComponent MuzzleFlashPSC;
var ParticleSystem MuzzleFlashPSCTemplate;
var deprecated Color MuzzleFlashColor;
var bool bMuzzleFlashPSCLoops;
var bool bChargeUpPSCLoops;
var deprecated bool bProlongedFiringPSCLoops;
var bool bAlignToSurfaceNormal;
var transient bool bUseSingleShotRumble;
var transient bool bIsStopRumble;
var deprecated bool bShouldPlayProlongedFiringEffect;
var bool bHeatingEffectStarted;
var name ChargeUpSocket;
var export editinline ParticleSystemComponent ChargeUpPSC;
var ParticleSystem ChargeUpPSCTemplate;
var deprecated name ProlongedFiringSocket;
var export editinline deprecated ParticleSystemComponent ProlongedFiringPSC;
var deprecated ParticleSystem ProlongedFiringPSCTemplate;
var deprecated class<SkyExplosionLight> MuzzleFlashLightClass;
var export editinline deprecated SkyExplosionLight MuzzleFlashLight;
var float MuzzleFlashDuration;
var export editinline SkeletalMeshComponent OwnerMesh;
var name AttachmentBoneName;
var array<MaterialImpactEffect> ImpactEffects;
var array<MaterialImpactEffect> AltImpactEffects;
var MaterialImpactEffect DefaultImpactEffect;
var SkyEmitter CachedImpactEffect;
var export editinline AudioComponent CachedImpactSound;
var float MaxImpactEffectDistance;
var float MaxFireEffectDistance;
var float MaxImpactDecalDistance;
var deprecated class<SkyWeapon> WeaponClass;
var SkyWeapon WeaponArchetype;
var ForceFeedbackWaveform WeaponRumble;
var ForceFeedbackWaveform WeaponSingleShotRumble;
var float SingleShotRumbleDelay;
var ViewShakeInfo WeaponViewShake;
var array<IKAttachControl> IKControls;
var MaterialInstanceConstant WeaponMaterialInst;

simulated event PostBeginPlay()
{
    local editinline SkeletalMeshComponent SkelMesh;

    super.PostBeginPlay();
    SkelMesh = SkeletalMeshComponent(Mesh);
    // End:0x57
    if(SkelMesh != none)
    {
        SkelMesh.bUpdateSkelWhenNotRendered = false;
        SkelMesh.bIgnoreControllersWhenNotRendered = true;
        SkelMesh.bOverrideAttachmentOwnerVisibility = true;
    }
    WeaponMaterialInst = new (Outer) Class'Engine.MaterialInstanceConstant';
    //return;    
}

simulated function UpdateChargeUpInfo()
{
    local SkyWeapon SW;

    SW = GetSkyWeapon();
    // End:0xCC
    if(SW != none)
    {
        // End:0xCC
        if((SW.CurrChargeUpStage >= 0) && SW.CurrChargeUpStage < WeaponArchetype.ChargeUpParams.Length)
        {
            ChargeUpPSCTemplate = WeaponArchetype.ChargeUpParams[SW.CurrChargeUpStage].Effect.Template;
            ChargeUpSocket = WeaponArchetype.ChargeUpParams[SW.CurrChargeUpStage].Effect.Socket;
        }
    }
    //return;    
}

simulated function SetWeaponArchetype(SkyWeapon WA)
{
    WeaponArchetype = WA;
    // End:0x109
    if(WeaponArchetype != none)
    {
        ImpactEffects = WeaponArchetype.ImpactEffects;
        DefaultImpactEffect = WeaponArchetype.DefaultImpactEffect;
        MuzzleFlashPSCTemplate = WeaponArchetype.MuzzleFlashPSCTemplate;
        MaxImpactEffectDistance = WeaponArchetype.MaxImpactEffectDistance;
        MaxFireEffectDistance = WeaponArchetype.MaxFireEffectDistance;
        MaxImpactDecalDistance = WeaponArchetype.MaxImpactDecalDistance;
        WeaponRumble = WeaponArchetype.WeaponRumble;
        WeaponSingleShotRumble = WeaponArchetype.WeaponSingleShotRumble;
        SingleShotRumbleDelay = WeaponArchetype.SingleShotRumbleDelay;
        WeaponViewShake = WeaponArchetype.WeaponViewShake;
        bMuzzleFlashPSCLoops = WeaponArchetype.bMuzzleFlashPSCLoops;
        UpdateChargeUpInfo();
    }
    //return;    
}

simulated function CreateOverlayMesh()
{
    local editinline SkeletalMeshComponent SKM_Source, SKM_Target;
    local editinline StaticMeshComponent STM;

    // End:0x233
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        OverlayMesh = new (self) Mesh.Class;
        // End:0x233
        if(OverlayMesh != none)
        {
            // End:0x154
            if(SkeletalMeshComponent(OverlayMesh) != none)
            {
                OverlayMesh.SetScale(1.1000000);
                SKM_Target = SkeletalMeshComponent(OverlayMesh);
                SKM_Source = SkeletalMeshComponent(Mesh);
                SKM_Target.SetSkeletalMesh(SKM_Source.SkeletalMesh);
                SKM_Target.AnimSets = SKM_Source.AnimSets;
                SKM_Target.SetAnimTreeTemplate(SKM_Source.AnimTreeTemplate);
                SKM_Target.SetParentAnimComponent(SKM_Source);
                SKM_Target.bUpdateSkelWhenNotRendered = false;
                SKM_Target.bIgnoreControllersWhenNotRendered = true;
                SKM_Target.bOverrideAttachmentOwnerVisibility = true;
                SKM_Target.MotionBlurMovementTolerance = SKM_Source.MotionBlurMovementTolerance;                
            }
            else
            {
                // End:0x230
                if(StaticMeshComponent(OverlayMesh) != none)
                {
                    STM = StaticMeshComponent(OverlayMesh);
                    STM.SetStaticMesh(StaticMeshComponent(Mesh).StaticMesh);
                    STM.SetScale3D(Mesh.Scale3D);
                    STM.SetTranslation(Mesh.Translation);
                    STM.SetRotation(Mesh.Rotation);
                    STM.SetScale(Mesh.Scale * 1.1000000);
                }
            }            
        }
    }
    //return;    
}

function SetSkin(Material NewMaterial)
{
    local int I, Cnt;

    // End:0xF5
    if(NewMaterial == none)
    {
        // End:0x8C
        if(default.Mesh.Materials.Length > 0)
        {
            Cnt = default.Mesh.Materials.Length;
            I = 0;
            J0x3E:

            // End:0x89 [Loop If]
            if(I < Cnt)
            {
                Mesh.SetMaterial(I, default.Mesh.GetMaterial(I));
                I++;
                // [Loop Continue]
                goto J0x3E;
            }            
        }
        else
        {
            // End:0xF2
            if(Mesh.Materials.Length > 0)
            {
                Cnt = Mesh.Materials.Length;
                I = 0;
                J0xBF:

                // End:0xF2 [Loop If]
                if(I < Cnt)
                {
                    Mesh.SetMaterial(I, none);
                    I++;
                    // [Loop Continue]
                    goto J0xBF;
                }
            }
        }        
    }
    else
    {
        // End:0x1A7
        if((default.Mesh.Materials.Length > 0) || Mesh.GetNumElements() > 0)
        {
            Cnt = ((default.Mesh.Materials.Length > 0) ? default.Mesh.Materials.Length : Mesh.GetNumElements());
            I = 0;
            J0x170:

            // End:0x1A7 [Loop If]
            if(I < Cnt)
            {
                Mesh.SetMaterial(I, NewMaterial);
                I++;
                // [Loop Continue]
                goto J0x170;
            }
        }
    }
    //return;    
}

simulated function SkySkelControl_SocketIK GetIKControl(name ControlName)
{
    // End:0x26
    if(OwnerMesh != none)
    {
        return SkySkelControl_SocketIK(OwnerMesh.FindSkelControl(ControlName));
    }
    return none;
    //return ReturnValue;    
}

simulated function SetupIK(optional name ControlName)
{
    local SkySkelControl_SocketIK Control;
    local editinline SkeletalMeshComponent SkelMesh;
    local int I;

    SkelMesh = SkeletalMeshComponent(Mesh);
    // End:0x1E
    if(OwnerMesh == none)
    {
        return;
    }
    I = 0;
    J0x25:

    // End:0xE8 [Loop If]
    if(I < IKControls.Length)
    {
        // End:0xDE
        if((ControlName == 'None') || IKControls[I].SkelControl == ControlName)
        {
            Control = GetIKControl(IKControls[I].SkelControl);
            // End:0xDE
            if(Control != none)
            {
                Control.SetAttached(SkelMesh, IKControls[I].Socket);
                Control.SetSkelControlActive(true);
                // [Explicit Break]
                goto J0xE8;
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x25;
    }
    J0xE8:

    // End:0xF8
    if(I == IKControls.Length)
    {
    }
    //return;    
}

simulated function CleanupIK(optional name ControlName)
{
    local SkySkelControl_SocketIK Control;
    local int I;

    // End:0x0E
    if(OwnerMesh == none)
    {
        return;
    }
    I = 0;
    J0x15:

    // End:0xA6 [Loop If]
    if(I < IKControls.Length)
    {
        // End:0x9C
        if((ControlName == 'None') || IKControls[I].SkelControl == ControlName)
        {
            Control = GetIKControl(IKControls[I].SkelControl);
            // End:0x9C
            if(Control != none)
            {
                Control.SetSkelControlActive(false);
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

simulated event AttachTo(SkyPawn OwnerPawn)
{
    local name SocketOrBoneName;
    local MaterialInstanceConstant mic;

    SocketOrBoneName = OwnerPawn.WeaponBone;
    // End:0x62
    if(ClassIsChildOf(WeaponArchetype.Class, Class'SkyWeapon'))
    {
        // End:0x62
        if(WeaponArchetype.bIsSecondaryWeapon)
        {
            // End:0x62
            if(OwnerPawn != none)
            {
                SocketOrBoneName = OwnerPawn.SecondaryWeaponBone;
            }
        }
    }
    mic = MaterialInstanceConstant(Mesh.GetMaterial(WeaponArchetype.GlimmerMaterialIndex));
    // End:0xD2
    if(mic != none)
    {
        mic.SetVectorParameterValue('itemflash', MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 1.0000000));
    }
    AttachToSocketOrBone(OwnerPawn, SocketOrBoneName);
    //return;    
}

simulated function AttachToSocketOrBone(SkyPawn OwnerPawn, name SocketOrBoneName)
{
    local editinline SkeletalMeshComponent SKMesh;
    local SkeletalMeshSocket SKSocket;

    // End:0x318
    if(OwnerPawn.Mesh != none)
    {
        OwnerMesh = OwnerPawn.Mesh;
        AttachmentBoneName = SocketOrBoneName;
        SetWeaponOverlayFlags(SkyPawn(Instigator));
        // End:0x1E4
        if((Mesh != none) || OverlayMesh != none)
        {
            SKSocket = OwnerMesh.GetSocketByName(AttachmentBoneName);
            // End:0x180
            if(Mesh != none)
            {
                // End:0xAF
                if(SKSocket != none)
                {
                    OwnerMesh.AttachComponentToSocket(Mesh, AttachmentBoneName);                    
                }
                else
                {
                    OwnerPawn.Mesh.AttachComponent(Mesh, AttachmentBoneName);
                }
                // End:0x100
                if(OwnerPawn != none)
                {
                    Mesh.SetLightEnvironment(OwnerPawn.LightEnvironment);
                }
                Mesh.SetShadowParent(OwnerPawn.Mesh);
                // End:0x152
                if(OwnerPawn.IsLocallyControlled())
                {
                    ChangeVisibility(!OwnerPawn.IsFirstPerson());
                }
                // End:0x180
                if(OwnerPawn.ReplicatedBodyMaterial != none)
                {
                    SetSkin(OwnerPawn.ReplicatedBodyMaterial);
                }
            }
            // End:0x1E4
            if(OverlayMesh != none)
            {
                // End:0x1BD
                if(SKSocket != none)
                {
                    OwnerPawn.Mesh.AttachComponentToSocket(OverlayMesh, AttachmentBoneName);                    
                }
                else
                {
                    OwnerPawn.Mesh.AttachComponent(OverlayMesh, AttachmentBoneName);
                }
            }
        }
        SKMesh = SkeletalMeshComponent(Mesh);
        // End:0x300
        if((SKMesh != none) && MuzzleFlashSocket != 'None')
        {
            // End:0x239
            if(MuzzleFlashMesh != none)
            {
                SKMesh.AttachComponentToSocket(MuzzleFlashMesh, MuzzleFlashSocket);
            }
            // End:0x300
            if(MuzzleFlashPSCTemplate != none)
            {
                // End:0x25F
                if(MuzzleFlashPSC != none)
                {
                    MuzzleFlashPSC.DeactivateSystem();
                }
                MuzzleFlashPSC = new (Outer) Class'SkyParticleSystemComponent';
                MuzzleFlashPSC.bSkyPoolActive = false;
                MuzzleFlashPSC.bPersistDynamicLight = true;
                SKMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
                MuzzleFlashPSC.DynamicLightSKMesh = SKMesh;
                MuzzleFlashPSC.DynamicLightSocket = MuzzleFlashSocket;
                MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplate);
                MuzzleFlashPSC.DeactivateSystem();
            }
        }
        InitChargeUpEffect();
        GotoState('CurrentlyAttached');
    }
    //return;    
}

simulated function CopyDroppedPickupToAttachment()
{
    local int I, NumMaterials, NumNewMaterials, Count;
    local editinline SkeletalMeshComponent DropMesh, AttachMesh;
    local SkyPawn SP;
    local SkyWeaponBase SkyWeap;

    SP = SkyPawn(Owner);
    DropMesh = SkeletalMeshComponent(WeaponArchetype.DroppedPickupMesh);
    AttachMesh = SkeletalMeshComponent(Mesh);
    AttachMesh.SkeletalMesh = DropMesh.SkeletalMesh;
    AttachMesh.AnimSets = DropMesh.AnimSets;
    AttachMesh.SetAnimTreeTemplate(DropMesh.AnimTreeTemplate);
    AttachMesh.SetPhysicsAsset(DropMesh.PhysicsAsset);
    // End:0xF9
    if(SP != none)
    {
        AttachMesh.SetScale(DropMesh.Scale * SP.WeaponScale);        
    }
    else
    {
        AttachMesh.SetScale(DropMesh.Scale);
    }
    NumNewMaterials = DropMesh.Materials.Length;
    NumMaterials = AttachMesh.GetNumElements();
    Count = Min(NumNewMaterials, NumMaterials);
    I = 0;
    J0x165:

    // End:0x1B0 [Loop If]
    if(I < Count)
    {
        AttachMesh.SetMaterial(I, DropMesh.GetMaterial(I));
        ++I;
        // [Loop Continue]
        goto J0x165;
    }
    SkyWeap = GetSkyWeaponBase();
    // End:0x302
    if(((WeaponMaterialInst != none) && SkyWeap != none) && AttachMesh != none)
    {
        WeaponMaterialInst.SetParent(AttachMesh.GetMaterial(SkyWeap.WeaponMaterialIndex));
        AttachMesh.SetMaterial(SkyWeap.WeaponMaterialIndex, WeaponMaterialInst);
        // End:0x302
        if(SkyWeap.MaterialEffectManager != none)
        {
            SkyWeap.MaterialEffectManager.MaterialInstances.Remove(0, SkyWeap.MaterialEffectManager.MaterialInstances.Length);
            SkyWeap.MaterialEffectManager.MaterialInterpolation.Remove(0, SkyWeap.MaterialEffectManager.MaterialInterpolation.Length);
            SkyWeap.MaterialEffectManager.MaterialInstances.AddItem(WeaponMaterialInst);
            SkyWeap.MaterialEffectManager.Initialize();
        }
    }
    WeaponArchetype.SetUpgradeSkelControls(WeaponArchetype.UpgradeSkelControls, AttachMesh);
    //return;    
}

simulated function DetachFrom(SkeletalMeshComponent MeshCpnt)
{
    local editinline SkeletalMeshComponent SKMesh;

    // End:0x20
    if(!WeaponArchetype.bIsSecondaryWeapon)
    {
        CleanupIK();
    }
    SetSkin(none);
    // End:0x71
    if(Mesh != none)
    {
        Mesh.SetShadowParent(none);
        Mesh.SetLightEnvironment(WeaponArchetype.LightEnvironment);
        CleanupIK();
    }
    // End:0xBC
    if(MeshCpnt != none)
    {
        // End:0x9C
        if(Mesh != none)
        {
            MeshCpnt.DetachComponent(Mesh);
        }
        // End:0xBC
        if(OverlayMesh != none)
        {
            MeshCpnt.DetachComponent(OverlayMesh);
        }
    }
    SKMesh = SkeletalMeshComponent(Mesh);
    // End:0x137
    if(SKMesh != none)
    {
        // End:0xF7
        if(MuzzleFlashMesh != none)
        {
            SKMesh.DetachComponent(MuzzleFlashMesh);
        }
        // End:0x117
        if(MuzzleFlashPSC != none)
        {
            SKMesh.DetachComponent(MuzzleFlashPSC);
        }
        // End:0x137
        if(ChargeUpPSC != none)
        {
            SKMesh.DetachComponent(ChargeUpPSC);
        }
    }
    GotoState('None');
    //return;    
}

// Export USkyWeaponAttachment::execMuzzleFlashTimer(FFrame&, void* const)
native simulated function MuzzleFlashTimer();

// Export USkyWeaponAttachment::execCauseMuzzleFlash(FFrame&, void* const)
native simulated function CauseMuzzleFlash(optional int NumMuzzleFlashes);

// Export USkyWeaponAttachment::execStopMuzzleFlash(FFrame&, void* const)
native simulated function StopMuzzleFlash();

simulated function SkyWeapon GetSkyWeapon()
{
    local int I;
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0xA2
    if(SP != none)
    {
        I = 0;
        J0x22:

        // End:0x8D [Loop If]
        if(I < SP.AuxWeapons.Length)
        {
            // End:0x83
            if(SP.AuxWeapons[I].Attachment == self)
            {
                return SP.AuxWeapons[I].Instance;
            }
            ++I;
            // [Loop Continue]
            goto J0x22;
        }
        return SkyWeapon(SP.Weapon);
    }
    return none;
    //return ReturnValue;    
}

simulated function SkyWeaponBase GetSkyWeaponBase()
{
    return GetSkyWeapon();
    //return ReturnValue;    
}

simulated function InitEffect(name Socket, ParticleSystem PSCTemplate, out ParticleSystemComponent PSC)
{
    local editinline SkeletalMeshComponent SKMesh;

    SKMesh = SkeletalMeshComponent(Mesh);
    // End:0x134
    if((SKMesh != none) && Socket != 'None')
    {
        // End:0x8D
        if(((SKMesh.SkeletalMesh == none) && Pawn(Owner) != none) && Pawn(Owner).Mesh != none)
        {
            SKMesh = Pawn(Owner).Mesh;
        }
        // End:0x134
        if(PSCTemplate != none)
        {
            // End:0xCE
            if(PSC == none)
            {
                PSC = new (Outer) Class'SkyParticleSystemComponent';
                SkyParticleSystemComponent(PSC).bSkyPoolActive = true;
            }
            PSC.bPersistDynamicLight = true;
            SKMesh.AttachComponentToSocket(PSC, Socket);
            PSC.DynamicLightSKMesh = SKMesh;
            PSC.DynamicLightSocket = Socket;
            PSC.DeactivateSystem();
        }
    }
    //return;    
}

simulated function InitChargeUpEffect()
{
    UpdateChargeUpInfo();
    InitEffect(ChargeUpSocket, ChargeUpPSCTemplate, ChargeUpPSC);
    //return;    
}

simulated event ParticleSystemComponent CauseEffect(name Socket, ParticleSystem PSCTemplate, ParticleSystemComponent PSC, bool bLoops)
{
    InitEffect(Socket, PSCTemplate, PSC);
    // End:0x81
    if(PSC != none)
    {
        // End:0x81
        if(PSC.bWasDeactivated || !bLoops)
        {
            SkyParticleSystemComponent(PSC).bSkyPoolActive = true;
            PSC.SetTemplate(PSCTemplate);
            PSC.ActivateSystem();
        }
    }
    return PSC;
    //return ReturnValue;    
}

simulated event CauseChargeUp()
{
    ChargeUpPSC = CauseEffect(ChargeUpSocket, ChargeUpPSCTemplate, ChargeUpPSC, bChargeUpPSCLoops);
    //return;    
}

simulated function CauseHeatingEffect()
{
    local SkyWeaponBase SkyWeap;

    SkyWeap = GetSkyWeaponBase();
    // End:0x5A
    if((SkyWeap != none) && SkyWeap.MaterialEffectManager != none)
    {
        bHeatingEffectStarted = true;
        SkyWeap.MaterialEffectManager.ActivateEffect(13);
    }
    //return;    
}

simulated function StopEffect(ParticleSystemComponent PSC, bool Loops)
{
    // End:0x28
    if((PSC != none) && !Loops)
    {
        PSC.DeactivateSystem();
    }
    //return;    
}

function StartHeatingTimer(float delay)
{
    SetTimer(delay, false, 'CauseHeatingEffect');
    bHeatingEffectStarted = false;
    //return;    
}

simulated function StopAllEffects()
{
    StopChargeUp();
    StopHeatingEffect();
    ClearTimer('CauseHeatingEffect');
    //return;    
}

simulated event StopChargeUp()
{
    StopEffect(ChargeUpPSC, bChargeUpPSCLoops);
    //return;    
}

simulated event StopHeatingEffect()
{
    local SkyWeaponBase SkyWeap;

    // End:0x5B
    if(bHeatingEffectStarted)
    {
        SkyWeap = GetSkyWeaponBase();
        // End:0x5B
        if((SkyWeap != none) && SkyWeap.MaterialEffectManager != none)
        {
            SkyWeap.MaterialEffectManager.ActivateEffect(14);
        }
    }
    //return;    
}

simulated event StartRumble()
{
    bUseSingleShotRumble = false;
    bIsStopRumble = false;
    SetTimer(SingleShotRumbleDelay, false, 'WeaponRumbleTimer');
    //return;    
}

simulated event WeaponRumbleTimer()
{
    // End:0x23
    if(bIsStopRumble)
    {
        CauseSingleShotRumble(WeaponSingleShotRumble);
        bUseSingleShotRumble = true;        
    }
    else
    {
        CauseNormalRumble(WeaponRumble);
        bUseSingleShotRumble = false;
    }
    ClearTimer('WeaponRumbleTimer');
    //return;    
}

simulated event StopRumble()
{
    bIsStopRumble = true;
    //return;    
}

simulated event CauseRumble(ForceFeedbackWaveform Rumble)
{
    // End:0x31
    if(!IsTimerActive('WeaponRumbleTimer') && !bUseSingleShotRumble)
    {
        CauseNormalRumble(Rumble);
    }
    //return;    
}

simulated event CauseNormalRumble(ForceFeedbackWaveform Rumble)
{
    // End:0x73
    if((((Instigator != none) && Instigator.Controller != none) && PlayerController(Instigator.Controller) != none) && Rumble != none)
    {
        PlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(Rumble);
    }
    //return;    
}

simulated event CauseSingleShotRumble(ForceFeedbackWaveform Rumble)
{
    // End:0x73
    if((((Instigator != none) && Instigator.Controller != none) && PlayerController(Instigator.Controller) != none) && Rumble != none)
    {
        PlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(Rumble);
    }
    //return;    
}

simulated event CauseViewShake()
{
    // End:0x66
    if(((Instigator != none) && Instigator.Controller != none) && SkyPlayerController(Instigator.Controller) != none)
    {
        SkyPlayerController(Instigator.Controller).ShakeView(WeaponViewShake);
    }
    //return;    
}

// Export USkyWeaponAttachment::execFirstPersonFireEffects(FFrame&, void* const)
native simulated function FirstPersonFireEffects(Weapon PawnWeapon, Vector HitLocation);

// Export USkyWeaponAttachment::execStopFirstPersonFireEffects(FFrame&, void* const)
native simulated function StopFirstPersonFireEffects(Weapon PawnWeapon);

simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float CullDistance)
{
    // End:0x55
    if(Instigator != none)
    {
        // End:0x30
        if(SpawnLocation == Location)
        {
            SpawnLocation = Instigator.Location;
        }
        return Instigator.EffectIsRelevant(SpawnLocation, bForceDedicated, CullDistance);
    }
    return super.EffectIsRelevant(SpawnLocation, bForceDedicated, CullDistance);
    //return ReturnValue;    
}

// Export USkyWeaponAttachment::execThirdPersonFireEffects(FFrame&, void* const)
native simulated function ThirdPersonFireEffects();

// Export USkyWeaponAttachment::execStopThirdPersonFireEffects(FFrame&, void* const)
native simulated function StopThirdPersonFireEffects();

// Export USkyWeaponAttachment::execGetImpactEffect(FFrame&, void* const)
native simulated function MaterialImpactEffect GetImpactEffect(PhysicalMaterial HitMaterial);

// Export USkyWeaponAttachment::execAllowImpactEffects(FFrame&, void* const)
native simulated function bool AllowImpactEffects(Actor HitActor, Vector HitLocation, Vector HitNormal);

// Export USkyWeaponAttachment::execPlayImpactEffects(FFrame&, void* const)
native simulated function PlayImpactEffects(ImpactInfo HitInfo, optional bool bExitEffect, optional SkyWeapon WeaponInstance);

// Export USkyWeaponAttachment::execPlayImpactEffectsRetrace(FFrame&, void* const)
native simulated function PlayImpactEffectsRetrace(Vector HitLocation, optional bool bExitEffect, optional SkyWeapon WeaponInstance);

// Export USkyWeaponAttachment::execCheckMaxEffectDistance(FFrame&, void* const)
native simulated function bool CheckMaxEffectDistance(PlayerController P, Vector SpawnLocation, optional float CullDistance);

simulated function SetWeaponOverlayFlags(SkyPawn OwnerPawn)
{
    //return;    
}

simulated function ChangeVisibility(bool bIsVisible)
{
    // End:0x23
    if(Mesh != none)
    {
        Mesh.SetHidden(!bIsVisible);
    }
    // End:0x46
    if(OverlayMesh != none)
    {
        OverlayMesh.SetHidden(!bIsVisible);
    }
    //return;    
}

// Export USkyWeaponAttachment::execSpawnImpactEffects(FFrame&, void* const)
native simulated function SpawnImpactEffects(Vector HitLocation, Vector HitNormal, MaterialImpactEffect ImpactEffect, optional Actor Other);

state CurrentlyAttached
{    stop;    
}
