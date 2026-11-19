class PKWeap_SMG_Base extends PainWeap_Base
    config(Weapon)
    hidecategories(Navigation);

var() int BurstNo;
var() float BurstBlockTime;
var transient bool BlockFire;
var transient bool HeatBlock;
var() float FlamerDamageInterval;
var() name FlamerSocket;
var export editinline UTParticleSystemComponent FlamerEffectComp;
var() ParticleSystem FlamerEffect;
var export editinline EvilDynamicLight_Base FlamerLight;
var() class<EvilDynamicLight_Base> FlamerLightClass;
var() int BurningLightInterval;
var export editinline AudioComponent FlamerSoundLoopComp;
var SoundCue FlamerSoundLoopCue1p;
var export editinline AudioComponent FlamerSoundStartComp;
var SoundCue FlamerSoundStartCue1p;
var export editinline AudioComponent FlamerSoundEndComp;
var SoundCue FlamerSoundEndCue1p;
var float HeatAmount;

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    super.AttachWeaponTo(MeshCpnt, SocketName);
    // End:0x11D
    if(Instigator.IsFirstPerson())
    {
        FlamerSoundLoopComp.SoundCue = FlamerSoundLoopCue1p;
        FlamerSoundLoopComp.bAllowSpatialization = false;
        FlamerSoundStartComp.SoundCue = FlamerSoundStartCue1p;
        FlamerSoundStartComp.bAllowSpatialization = false;
        FlamerSoundEndComp.SoundCue = FlamerSoundEndCue1p;
        FlamerSoundEndComp.bAllowSpatialization = false;        
    }
    else
    {
        // End:0x1F2
        if(Instigator.PlayerReplicationInfo == none)
        {
            DetachComponent(FlamerSoundLoopComp);
            Instigator.AttachComponent(FlamerSoundLoopComp);
            DetachComponent(FlamerSoundStartComp);
            Instigator.AttachComponent(FlamerSoundStartComp);
            DetachComponent(FlamerSoundEndComp);
            Instigator.AttachComponent(FlamerSoundEndComp);
        }
    }
    //return;    
}

simulated function HeatFlamer(optional float Amount = 0.0100000)
{
    HeatAmount = FMin(HeatAmount + Amount, 1.0000000);
    // End:0x59
    if(IsTimerActive('CoolDownFlamer'))
    {
        ClearTimer('CoolDownFlamer');
    }
    //return;    
}

simulated function CoolDownFlamer(optional float Amount = 0.0100000)
{
    // End:0x2B
    if(Amount ~= 0.0000000)
    {
        Amount = 0.0100000;
    }
    HeatAmount = FMax(HeatAmount - Amount, 0.0000000);
    // End:0x90
    if((HeatAmount == 0.0000000) && IsTimerActive('CoolDownFlamer'))
    {
        ClearTimer('CoolDownFlamer');
    }
    //return;    
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local float SavedDamage;

    SavedDamage = InstantHitDamage[0];
    // End:0x4B
    if((int(FiringMode) == int(0)) && HasWeaponModifier())
    {
        InstantHitDamage[0] *= 1.5000000;
    }
    super(EvilWeap_Base).ProcessInstantHit(FiringMode, Impact, NumHits);
    InstantHitDamage[0] = SavedDamage;
    //return;    
}

simulated function CustomFire()
{
    MakeNoise(1.0000000);
    PlayFireEffects(CurrentFireMode);
    IncrementFlashCount();
    // End:0x74
    if(HeatAmount == float(1))
    {
        HeatBlock = true;
        SetTimer(2.0000000, false, 'ReleaseHeatBlock');
        StopFire(CurrentFireMode);
        HandleFinishedFiring();
    }
    //return;    
}

simulated function ReleaseHeatBlock()
{
    HeatBlock = false;
    //return;    
}

simulated function CauseFlamerDamage()
{
    local Vector RealStartLoc;
    local Projectile SpawnedProjectile;

    BurningLightInterval++;
    // End:0x2D
    if(BurningLightInterval > default.BurningLightInterval)
    {
        BurningLightInterval = 0;
    }
    // End:0x188
    if(int(Role) == int(ROLE_Authority))
    {
        RealStartLoc = GetPhysicalFireStartLoc();
        SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
        // End:0x188
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(Vector(GetAdjustedAim(RealStartLoc)));
            SpawnedProjectile.Damage = WeaponDamage[1];
            // End:0x147
            if(HasWeaponModifier())
            {
                SpawnedProjectile.LifeSpan *= 1.2500000;
            }
            // End:0x188
            if(BurningLightInterval == default.BurningLightInterval)
            {
                PKProjectile_Flamer_Base(SpawnedProjectile).SpawnLight = true;
            }
        }
    }
    //return;    
}

simulated function RestartLight(UDKExplosionLight Light)
{
    Light.ResetLight();
    //return;    
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    // End:0x33
    if(int(FireModeNum) == int(0))
    {
        super(EvilWeap_Base).PlayFireEffects(FireModeNum, HitLocation);
        return;
    }
    // End:0xDF
    if((int(FireModeNum) < WeaponFireAnim.Length) && WeaponFireAnim[int(FireModeNum)] != 'None')
    {
        PlayWeaponAnim(WeaponFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
    }
    // End:0x19C
    if(((int(FireModeNum) < ArmFireAnim.Length) && ArmFireAnim[int(FireModeNum)] != 'None') && ArmsAnimSet != none)
    {
        PlayArmAnim(ArmFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
    }
    ShakeView();
    //return;    
}

simulated function StartFlamerLoopSound()
{
    // End:0x4B
    if(FlamerSoundStartComp.IsPlaying())
    {
        FlamerSoundStartComp.FadeOut(0.1000000, 0.0000000);
    }
    // End:0x96
    if(FlamerSoundEndComp.IsPlaying())
    {
        FlamerSoundEndComp.FadeOut(0.1000000, 0.0000000);
    }
    // End:0xE3
    if(!FlamerSoundLoopComp.IsPlaying())
    {
        FlamerSoundLoopComp.FadeIn(0.1000000, 1.0000000);
    }
    //return;    
}

simulated function StartFire(byte FireModeNum)
{
    // End:0x25
    if((int(FireModeNum) == int(1)) && HeatBlock)
    {
        return;
    }
    super(EvilWeap_Base).StartFire(FireModeNum);
    //return;    
}

simulated function UnblockFire()
{
    BlockFire = false;
    //return;    
}

simulated function bool ShouldRefire()
{
    // End:0x63
    if(((int(CurrentFireMode) == int(0)) && CurrentShotCount >= BurstNo) && !HasWeaponModifier())
    {
        BlockFire = true;
        SetTimer(BurstBlockTime, false, 'UnblockFire');
        return false;
    }
    return super(EvilWeap_Base).ShouldRefire();
    //return ReturnValue;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x70
        if(((int(FireModeNum) == int(0)) && int(CurrentFireMode) == int(1)) && HasAmmo(2))
        {
            FireModeNum = 2;
            super.BeginFire(FireModeNum);
            StopFire(CurrentFireMode);
            return;
        }
        super.BeginFire(FireModeNum);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPawn P;
        local PKAttachment_Weap_SMG_Base att;

        // End:0x610
        if(int(CurrentFireMode) == int(1))
        {
            BlockFire = false;
            RecoilMax = 0.0000000;
            P = EvilPawn(Owner);
            // End:0x96
            if(FlamerSoundLoopComp.IsPlaying())
            {
                FlamerSoundLoopComp.FadeOut(0.1000000, 0.0000000);
            }
            // End:0xE1
            if(FlamerSoundEndComp.IsPlaying())
            {
                FlamerSoundEndComp.FadeOut(0.1000000, 0.0000000);
            }
            // End:0x12E
            if(!FlamerSoundStartComp.IsPlaying())
            {
                FlamerSoundStartComp.FadeIn(0.1000000, 1.0000000);
            }
            SetTimer(0.2000000, false, 'StartFlamerLoopSound');
            // End:0x23C
            if(FlamerEffectComp == none)
            {
                FlamerEffectComp = new (P) Class'EvilGame.UTParticleSystemComponent';
                FlamerEffectComp.SetTemplate(FlamerEffect);
                FlamerEffectComp.SetDepthPriorityGroup(2);
                FlamerEffectComp.SetFOV(UDKSkeletalMeshComponent(Mesh).FOV);
                UDKSkeletalMeshComponent(Mesh).AttachComponentToSocket(FlamerEffectComp, FlamerSocket);                
            }
            else
            {
                FlamerEffectComp.ActivateSystem();
            }
            // End:0x2A1
            if((FlamerEffectComp != none) && HasWeaponModifier())
            {
                FlamerEffectComp.SetScale(1.2500000);                
            }
            else
            {
                // End:0x2D4
                if(FlamerEffectComp != none)
                {
                    FlamerEffectComp.SetScale(1.0000000);
                }
            }
            // End:0x370
            if(FlamerLight == none)
            {
                FlamerLight = new (P) FlamerLightClass;
                FlamerLight.__OnLightFinished__Delegate = RestartLight;
                UDKSkeletalMeshComponent(Mesh).AttachComponentToSocket(FlamerLight, FlamerSocket);                
            }
            else
            {
                FlamerLight.ResetLight();
            }
            att = PKAttachment_Weap_SMG_Base(UTPawn(Instigator).CurrentWeaponAttachment);
            // End:0x5EB
            if(att != none)
            {
                // End:0x5B6
                if(att.FlamerPSC == none)
                {
                    att.FlamerPSC = new (att) Class'EvilGame.UTParticleSystemComponent';
                    att.FlamerPSC.SetOwnerNoSee(true);
                    att.FlamerPSC.SetTemplate(FlamerEffect);
                    // End:0x543
                    if(att.Mesh == none)
                    {
                        UTPawn(Instigator).Mesh.AttachComponentToSocket(att.FlamerPSC, att.FlamerSocket);                        
                    }
                    else
                    {
                        att.Mesh.AttachComponentToSocket(att.FlamerPSC, att.FlamerSocket);
                    }                    
                }
                else
                {
                    att.FlamerPSC.ActivateSystem();
                }
            }
            BurningLightInterval = 0;
            SetTimer(FlamerDamageInterval, true, 'CauseFlamerDamage');            
        }
        else
        {
            // End:0x61F
            if(BlockFire)
            {
                return;
            }
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        local PKAttachment_Weap_SMG_Base att;

        RecoilMax = default.RecoilMax;
        SetTimer(0.0500000, true, 'CoolDownFlamer');
        ClearTimer('CauseFlamerDamage');
        ClearTimer('StartFlamerLoopSound');
        // End:0x99
        if(FlamerSoundLoopComp.IsPlaying())
        {
            FlamerSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0xE4
        if(FlamerSoundStartComp.IsPlaying())
        {
            FlamerSoundStartComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x12F
        if(FlamerSoundEndComp.IsPlaying())
        {
            FlamerSoundEndComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x190
        if(int(CurrentFireMode) == int(1))
        {
            // End:0x190
            if(!FlamerSoundEndComp.IsPlaying())
            {
                FlamerSoundEndComp.FadeIn(0.1000000, 1.0000000);
            }
        }
        // End:0x1BE
        if(FlamerEffectComp != none)
        {
            FlamerEffectComp.DeactivateSystem();
        }
        // End:0x1ED
        if(FlamerLight != none)
        {
            FlamerLight.SetEnabled(false);
        }
        att = PKAttachment_Weap_SMG_Base(UTPawn(Instigator).CurrentWeaponAttachment);
        // End:0x28E
        if(att != none)
        {
            // End:0x28E
            if(att.FlamerPSC != none)
            {
                att.FlamerPSC.DeactivateSystem();
            }
        }
        super.EndState(NextStateName);
        //return;        
    }

    simulated function UnblockFire()
    {
        global.UnblockFire();
        // End:0x56
        if(int(CurrentFireMode) == int(0))
        {
            // End:0x4C
            if(PendingFire(0))
            {
                FireAmmunition();
                TimeWeaponFiring(CurrentFireMode);                
            }
            else
            {
                HandleFinishedFiring();
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    BurstNo=8
    BurstBlockTime=0.3300000
    FlamerDamageInterval=0.1000000
    FlamerLightClass=Class'PKLight_Flamer'
    BurningLightInterval=3
    // Reference: AudioComponent'Default__PKWeap_SMG_Base.FlamerSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'FlamerSoundLoop'
    begin object name="FlamerSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    FlamerSoundLoopComp=FlamerSoundLoop
    // Reference: AudioComponent'Default__PKWeap_SMG_Base.FlamerSoundStart'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'FlamerSoundStart'
    begin object name="FlamerSoundStart" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    FlamerSoundStartComp=FlamerSoundStart
    // Reference: AudioComponent'Default__PKWeap_SMG_Base.FlamerSoundEnd'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'FlamerSoundEnd'
    begin object name="FlamerSoundEnd" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    FlamerSoundEndComp=FlamerSoundEnd
    bPurchasedWeaponDLC=true
    MaxAmmoAltCount=500
    LowAmmoCountWarningThreshold=30
    bFastRepeater=true
    MaxAmmoCount=250
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_SMG_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=6
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_SMG_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_SMG_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="SMG"
    CurrentRating=0.8000000
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    bInstantHit=true
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_SMG_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_SMG_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__PainWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    Components[2]=FlamerSoundEnd
    Components[3]=FlamerSoundStart
    Components[4]=FlamerSoundLoop
}