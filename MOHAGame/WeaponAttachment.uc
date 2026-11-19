class WeaponAttachment extends Actor
    abstract
    native
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

var export editinline MeshComponent Mesh;
var export editinline MeshComponent ThirdPersonMesh;
var(DynamicLight) export editinline WeaponFlashDLight MuzzleFlashDLight;
var(DynamicLight) Color MuzzleFlashLightColor;
var(WeaponSockets) name BarrelSocket;
var(WeaponSockets) name BarrelSocket_Player;
var(WeaponSockets) name BarrelSocket_NPC;
var(WeaponSockets) name BarrelSocket_AltFire;
var(WeaponSockets) name BarrelSocket_Ironsights;
var export editinline array<export editinline AudioComponent> ImpactSoundComponents;
var(Tuning_Sounds) const int MaxImpactSoundCount;
var const int NextImpactSoundIndex;
var(Tuning_Sounds) array<SoundCue> WeaponFireSnd;
var(Tuning_Sounds) SoundCue WeaponDryFireSnd;
var(Tuning_Sounds) SoundCue WeaponDryFireSnd_NPC;
var(Tuning_Sounds) export editinline AudioComponent WeaponDryFireSound;
var(Tuning_Sounds) export editinline AudioComponent WeaponEquipSnd;
var(Tuning_Sounds) export editinline AudioComponent WeaponReloadSnd;
var(Tuning_Sounds) int TotalSoundSets;
var int SoundSetIndex;
var export editinline AudioComponent WeaponFireAudio;
var SoundCue HitPlayerSoundCue;
var float MaxAllowedEffectDistanceBehindPlayer;
var(Tuning_VFX) config float MuzzleFlashCullDistance;
var(Tuning_Tracer) config bool bTracerForceTargetPoint;
var(Tuning_Tracer) config bool bTracerForceBarrel;
var class<EALAWeapon> WeaponClass;
var export editinline WhizSenderComponent MPWhizSender;

simulated function UpdateVFXAttachments()
{
    //return;    
}

simulated function Rechamber()
{
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    ImpactSoundComponents.Length = MaxImpactSoundCount;
    WeaponFireSnd.Length = TotalSoundSets + 1;
    //return;    
}

simulated function CleanUpAudioComponents()
{
    local int I;
    local editinline AudioComponent AudioComp;

    I = 0;
    J0x07:

    // End:0x6F [Loop If]
    if(I < ImpactSoundComponents.Length)
    {
        AudioComp = ImpactSoundComponents[I];
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
    ImpactSoundComponents.Length = 0;
    //return;    
}

simulated event Destroyed()
{
    CleanUpAudioComponents();
    super.Destroyed();
    //return;    
}

simulated event StreamOutCleanup()
{
    CleanUpAudioComponents();
    super.StreamOutCleanup();
    //return;    
}

simulated event bool OwnerIsLocalPlayer()
{
    return ((Instigator != none) && PlayerController(Instigator.Controller) != none) && Instigator.IsLocallyControlled();
    //return ReturnValue;    
}

simulated function bool OwnerIsSniper()
{
    return (Instigator != none) && MOHAControllerInterface(Instigator.Controller).IsSniperController();
    //return ReturnValue;    
}

simulated function AssignSoundSetIndex()
{
    local name SocketName;

    // End:0x17
    if(OwnerIsLocalPlayer())
    {
        SoundSetIndex = 0;        
    }
    else
    {
        SoundSetIndex = Rand(TotalSoundSets) + 1;
    }
    // End:0x59
    if(WeaponFireAudio == none)
    {
        WeaponFireAudio = WorldInfo.CreateAudioComponent(WeaponFireSnd[SoundSetIndex], false, false);        
    }
    else
    {
        WeaponFireAudio.SoundCue = WeaponFireSnd[SoundSetIndex];
    }
    SocketName = GetBarrelSocketName(SkeletalMeshComponent(Mesh));
    // End:0xD9
    if((SocketName != 'None') && Mesh != none)
    {
        // End:0xD6
        if(WeaponFireAudio != none)
        {
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(WeaponFireAudio, SocketName);
        }        
    }
    else
    {
        // End:0xEF
        if(WeaponFireAudio != none)
        {
            AttachComponent(WeaponFireAudio);
        }
    }
    //return;    
}

simulated function AttachTo(MOHAPawn OwnerPawn)
{
    local editinline SkeletalMeshComponent SkelMesh;
    local bool bPawnIsLocalPlayer;
    local int I, UpgradeStatus;

    bPawnIsLocalPlayer = ((OwnerPawn != none) && PlayerController(OwnerPawn.Controller) != none) && OwnerPawn.IsLocallyControlled();
    // End:0x11F
    if((!bPawnIsLocalPlayer && OwnerPawn != none) && OwnerPawn.Mesh != none)
    {
        // End:0xC1
        if((OwnerPawn.Weapon != none) && OwnerPawn.Weapon.Mesh != none)
        {
            OwnerPawn.Weapon.Mesh.SetHidden(true);
        }
        Mesh = ThirdPersonMesh;
        // End:0x11F
        if(Mesh != none)
        {
            OwnerPawn.Mesh.AttachComponentToSocket(Mesh, OwnerPawn.WeaponSocket);
            Mesh.SetShadowParent(OwnerPawn.Mesh);
        }
    }
    SkelMesh = SkeletalMeshComponent(Mesh);
    // End:0x163
    if(SkelMesh != none)
    {
        SkelMesh.bUpdateSkelWhenNotRendered = false;
        SkelMesh.bIgnoreControllersWhenNotRendered = !bPawnIsLocalPlayer;
    }
    AttachVisualEffects();
    AssignSoundSetIndex();
    // End:0x1C6
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x1C3
        if(MOHAPlayerPawn(OwnerPawn) != none)
        {
            MOHAPlayerPawn(OwnerPawn).WeaponUpgradeManager.InitUpgradesOnWeaponAttachmentInstance(self, true);
        }        
    }
    else
    {
        MOHAPlayerPawn(OwnerPawn).WeaponUpgradeManager.InitUpgradesOnWeaponAttachmentInstance(self);
        // End:0x21A
        if(WeaponClass.default.AutoUpgradeClass != none)
        {
            WeaponClass.default.AutoUpgradeClass.StaticInitWeaponAttachmentUpgrade(self);
        }
        UpgradeStatus = OwnerPawn.GetUpgradeStatus(int(WeaponClass.default.WeaponClass));
        I = UpgradeStatus;
        J0x24E:

        // End:0x28A [Loop If]
        if(I >= 0)
        {
            MOHAPlayerPawn(OwnerPawn).WeaponUpgradeManager.UpgradeAttachment(self, I);
            I--;
            // [Loop Continue]
            goto J0x24E;
        }
    }
    Mesh.SetLightEnvironment(OwnerPawn.Mesh.LightEnvironment);
    Mesh.SetShadowParent(OwnerPawn.Mesh);
    GotoState('CurrentlyAttached');
    //return;    
}

simulated function AttachVisualEffects()
{
    AttachDynamicLight();
    //return;    
}

simulated function DetachFrom(SkeletalMeshComponent MeshCpnt)
{
    Mesh = ThirdPersonMesh;
    // End:0x36
    if(Mesh != none)
    {
        Mesh.SetLightEnvironment(none);
        Mesh.SetShadowParent(none);
    }
    // End:0x60
    if(MeshCpnt != none)
    {
        // End:0x60
        if(Mesh != none)
        {
            MeshCpnt.DetachComponent(Mesh);
        }
    }
    GotoState('None');
    //return;    
}

simulated function Hide(bool bHide)
{
    // End:0x20
    if(ThirdPersonMesh != none)
    {
        ThirdPersonMesh.SetHidden(bHide);
    }
    //return;    
}

simulated function WeaponFired()
{
    PlayOneShotFireSound();
    PlayAttachmentEffects();
    //return;    
}

simulated function WeaponBeingEquiped()
{
    // End:0x44
    if((none != WeaponEquipSnd) && (int(WorldInfo.NetMode) == int(NM_Standalone)) || OwnerIsLocalPlayer())
    {
        WeaponEquipSnd.Play();
    }
    //return;    
}

simulated function WeaponBeingReloaded()
{
    // End:0x44
    if((none != WeaponReloadSnd) && (int(WorldInfo.NetMode) == int(NM_Standalone)) || OwnerIsLocalPlayer())
    {
        WeaponReloadSnd.Play();
    }
    //return;    
}

simulated function PlayRemoteEffects(Vector HitLocation)
{
    WeaponFired();
    PlayImpactEffects(HitLocation);
    //return;    
}

simulated function PlayAttachmentEffects()
{
    local bool bFlashIsRelevant, bShellEjectIsRelevant;
    local editinline ParticleSystemComponent MuzzleFlashPSC, ShellEjectPSC;
    local Vector Loc;
    local Rotator Rot;

    bFlashIsRelevant = false;
    MuzzleFlashPSC = GetMuzzleFlashPSC();
    // End:0x65
    if(MuzzleFlashPSC != none)
    {
        // End:0x65
        if(GetBarrelLocation(Loc, Rot))
        {
            bFlashIsRelevant = EffectIsRelevant(Loc, false, MuzzleFlashCullDistance, MuzzleFlashPSC.Template);
        }
    }
    bShellEjectIsRelevant = false;
    ShellEjectPSC = GetShellEjectPSC();
    // End:0xCA
    if(ShellEjectPSC != none)
    {
        // End:0xCA
        if(GetShellEjectionLocation(Loc, Rot))
        {
            bShellEjectIsRelevant = EffectIsRelevant(Loc, false, MuzzleFlashCullDistance, ShellEjectPSC.Template);
        }
    }
    // End:0xE7
    if(bFlashIsRelevant)
    {
        StartDynamicLight();
        StartMuzzleFlash();
    }
    // End:0xFA
    if(bShellEjectIsRelevant)
    {
        EjectShell();
    }
    //return;    
}

// Export UWeaponAttachment::execEffectIsRelevant(FFrame&, void* const)
native simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float CullDistance, optional ParticleSystem ParticleSys);

// Export UWeaponAttachment::execCheckMaxEffectDistance(FFrame&, void* const)
native simulated function bool CheckMaxEffectDistance(PlayerController P, Vector SpawnLocation, optional float CullDistance, optional ParticleSystem ParticleSys);

simulated function StopFiring(bool bIsBurstMode)
{
    //return;    
}

simulated function StartFiring(bool bIsBurstMode)
{
    //return;    
}

simulated function WeaponIsEmpty()
{
    //return;    
}

simulated function bool UseIronsightingEffect()
{
    // End:0x3A
    if(((OwnerIsLocalPlayer()) && MOHAPlayerPawn(Instigator) != none) && MOHAPlayerPawn(Instigator).bIronsightsActive)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool UseAlternateFireEffect()
{
    local EALASmallArms Weap;

    // End:0x46
    if(OwnerIsLocalPlayer())
    {
        Weap = EALASmallArms(Instigator.Weapon);
        return (Weap != none) && Weap.bAlternateFireMode;        
    }
    else
    {
        // End:0x72
        if(MOHAMultiplayerPawn(Instigator) != none)
        {
            return MOHAMultiplayerPawn(Instigator).GetWeaponMode() == 1;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool UseIronsightsBarrelSocket()
{
    local EALAWeapon Weap;

    Weap = EALAWeapon(Instigator.Weapon);
    return ((OwnerIsLocalPlayer()) && Weap != none) && int(Weap.IronsightsState) == int(3);
    //return ReturnValue;    
}

simulated function bool DestroyWhenDetatched()
{
    return true;
    //return ReturnValue;    
}

simulated function StartMuzzleFlash()
{
    //return;    
}

simulated function EjectShell()
{
    //return;    
}

simulated function ParticleSystemComponent GetMuzzleFlashPSC()
{
    return none;
    //return ReturnValue;    
}

simulated function ParticleSystemComponent GetShellEjectPSC()
{
    return none;
    //return ReturnValue;    
}

simulated function bool GetBarrelLocation(out Vector pos, out Rotator Rot, optional name name_of_socket)
{
    return false;
    //return ReturnValue;    
}

simulated function bool GetShellEjectionLocation(out Vector pos, out Rotator Rot, optional name name_of_socket)
{
    return false;
    //return ReturnValue;    
}

simulated function name GetBarrelSocketName(SkeletalMeshComponent SMC_Mesh)
{
    local bool bPawnIsPlayer;

    // End:0x12C
    if(none != SMC_Mesh)
    {
        bPawnIsPlayer = OwnerIsLocalPlayer();
        // End:0x60
        if(((UseAlternateFireEffect()) && BarrelSocket_AltFire != 'None') && SMC_Mesh.GetSocketByName(BarrelSocket_AltFire) != none)
        {
            return BarrelSocket_AltFire;
        }
        // End:0xA4
        if(((UseIronsightsBarrelSocket()) && BarrelSocket_Ironsights != 'None') && SMC_Mesh.GetSocketByName(BarrelSocket_Ironsights) != none)
        {
            return BarrelSocket_Ironsights;
        }
        // End:0xE4
        if((bPawnIsPlayer && BarrelSocket_Player != 'None') && SMC_Mesh.GetSocketByName(BarrelSocket_Player) != none)
        {
            return BarrelSocket_Player;
        }
        // End:0x126
        if((!bPawnIsPlayer && BarrelSocket_NPC != 'None') && SMC_Mesh.GetSocketByName(BarrelSocket_NPC) != none)
        {
            return BarrelSocket_NPC;
        }
        return BarrelSocket;
    }
    return 'None';
    //return ReturnValue;    
}

simulated function StartDynamicLight()
{
    local float fDelta;

    // End:0xF7
    if(none != MuzzleFlashDLight)
    {
        fDelta = MuzzleFlashDLight.MuzzleFlashDLightSize * (2.0000000 * MuzzleFlashDLight.MuzzleFlashDLightSizeVariability);
        MuzzleFlashDLight.Radius = (MuzzleFlashDLight.MuzzleFlashDLightSize * (1.0000000 - MuzzleFlashDLight.MuzzleFlashDLightSizeVariability)) + (fDelta * FRand());
        MuzzleFlashDLight.SetLightProperties(, MuzzleFlashLightColor);
        // End:0xBA
        if(MOHAPawn(Instigator) != none)
        {
            MOHAPawn(Instigator).LightEnvComponent.bForceLightEnvUpdate = true;
        }
        MuzzleFlashDLight.SetEnabled(true);
        ClearTimer('StopMuzzleFlashDLight');
        SetTimer(MuzzleFlashDLight.MuzzleFlashDLightLifeTime, false, 'StopMuzzleFlashDLight');
    }
    //return;    
}

simulated function StopMuzzleFlashDLight()
{
    // End:0x4A
    if(none != MuzzleFlashDLight)
    {
        // End:0x3A
        if(MOHAPawn(Instigator) != none)
        {
            MOHAPawn(Instigator).LightEnvComponent.bForceLightEnvUpdate = true;
        }
        MuzzleFlashDLight.SetEnabled(false);
    }
    //return;    
}

simulated function AttachDynamicLight()
{
    local editinline SkeletalMeshComponent SKMesh;
    local name SocketName;

    SKMesh = SkeletalMeshComponent(Mesh);
    SocketName = GetBarrelSocketName(SKMesh);
    // End:0x7B
    if((none != SKMesh) && 'None' != SocketName)
    {
        // End:0x7B
        if(none != MuzzleFlashDLight)
        {
            SKMesh.AttachComponentToSocket(MuzzleFlashDLight, SocketName);
            MuzzleFlashDLight.SetEnabled(false);
            return;
        }
    }
    //return;    
}

simulated function PlayImpactEffects(Vector EndShot)
{
    local Vector StartTrace, TraceEnd;
    local ImpactInfo RealImpact;

    StartTrace = Instigator.GetWeaponStartTraceLocation();
    TraceEnd = EndShot + (Normal(EndShot - StartTrace) * float(10));
    RealImpact = Class'EALAWeapon'.static.CalcWeaponFireNative(self, StartTrace, TraceEnd, vect(0.0000000, 0.0000000, 0.0000000));
    // End:0xBE
    if((MOHAMultiplayerPawn(RealImpact.HitActor) == none) || MOHAMultiplayerPawn(RealImpact.HitActor).IsLocallyControlled() == false)
    {
        PlayImpactEffectsWithImpactInfo(RealImpact);
    }
    // End:0xF1
    if(MPWhizSender != none)
    {
        MPWhizSender.SendWhizEvent(StartTrace, RealImpact.HitLocation, 1);
    }
    //return;    
}

event SoundCue GetImpactSoundCue(PhysicalMaterial PhysMaterial, int ImpactType, bool bHitActorIsPlayer, bool bInstigatedByPlayer)
{
    // End:0x12
    if(bHitActorIsPlayer)
    {
        return HitPlayerSoundCue;        
    }
    else
    {
        return Class'MOHAPhysicalMaterialProperty'.static.GetImpactSound(PhysMaterial, byte(ImpactType), ((bInstigatedByPlayer) ? 0 : 2));
    }
    //return ReturnValue;    
}

event ImpartMomentum(ImpactInfo Impact, class<DamageType> DamageType)
{
    local MOHAPawn HitPawn;
    local float fHitReactionMomentumScalar;

    HitPawn = MOHAPawn(Impact.HitActor);
    // End:0x9C
    if(none != HitPawn)
    {
        fHitReactionMomentumScalar = 6000.0000000;
        HitPawn.PreDamage_ImpartHitMomentum(Impact.HitLocation, Impact.RayDir * fHitReactionMomentumScalar, ((none == DamageType) ? Class'MOHABulletDamageType' : DamageType), Impact.HitInfo, Instigator.Controller);
    }
    //return;    
}

event CreateDecal(bool bInstigatorIsPlayer, ImpactInfo Impact, int ImpactType)
{
    local float DecalWidth, DecalHeight;
    local MaterialInstance DecalMaterial;
    local DecalLifetimeData LifetimeData;

    // End:0x113
    if(bInstigatorIsPlayer)
    {
        DecalMaterial = Class'MOHAPhysicalMaterialProperty'.static.GetDecal(Impact.HitInfo.PhysMaterial, byte(ImpactType), 0, DecalWidth, DecalHeight);
        // End:0x113
        if(DecalMaterial != none)
        {
            LifetimeData = new (Impact.HitActor.Outer) Class'Engine.DecalLifetimeDataAge';
            Impact.HitActor.AddDecal(DecalMaterial, Impact.HitLocation, Rotator(-Impact.HitNormal), 0.0000000, DecalWidth, DecalHeight, 10.0000000, false, Impact.HitInfo.HitComponent, LifetimeData, true, false, Impact.HitInfo.BoneName);
        }
    }
    //return;    
}

// Export UWeaponAttachment::execPlayImpactEffectsWithImpactInfo(FFrame&, void* const)
native simulated function PlayImpactEffectsWithImpactInfo(ImpactInfo Impact, optional int ImpactType, optional class<DamageType> DamageType);

simulated function PlayOneShotFireSound()
{
    // End:0x1A
    if(none != WeaponFireAudio)
    {
        WeaponFireAudio.Play();
    }
    //return;    
}

function Vector GetLeftHandPosition()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x37
    if(SkeletalMeshComponent(ThirdPersonMesh) != none)
    {
        SkeletalMeshComponent(ThirdPersonMesh).GetSocketWorldLocationAndRotation('LeftHold', pos, Rot);
    }
    return pos;
    //return ReturnValue;    
}

function NPCPreReload()
{
    //return;    
}

state CurrentlyAttached
{    stop;    
}

defaultproperties
{
    // Reference: MOHASkeletalMeshComponent'Default__WeaponAttachment.WeaponMeshComponent'
    begin object name=WeaponMeshComponent class=Class'MOHASkeletalMeshComponent'
        iMinLODLevel=1
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    BarrelSocket="Barrel"
    BarrelSocket_Player="Barrel_Player"
    BarrelSocket_NPC="Barrel_NPC"
    BarrelSocket_AltFire="Barrel_Upgrade"
    BarrelSocket_Ironsights="Barrel_Ironsights"
    MaxImpactSoundCount=10
    TotalSoundSets=1
    SoundSetIndex=1
    HitPlayerSoundCue=SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Flesh_NPC'
    MaxAllowedEffectDistanceBehindPlayer=750.0000000
    MuzzleFlashCullDistance=5000.0000000
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__WeaponAttachment.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[1]=Sprite
    ActorType=13
    bStasis=true
    bReplicateInstigator=true
    NetUpdateFrequency=10.0000000
    CollisionType=0
}