class EvilWeap_Throw_Base extends EvilWeap_Melee_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var(Sounds) SoundCue WeaponPrepareSnd;
var(Sounds) SoundCue WeaponThrowSnd;
var transient bool bReleaseGrenade;
var() config float MaxHoldTime;
var float HoldTime;

reliable server function ServerDoThrow()
{
    DoThrow();
    //return;    
}

simulated function DoThrow()
{
    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerDoThrow();
    }
    SpawnProjectile();
    //return;    
}

simulated function DoRelease()
{
    bReleaseGrenade = true;
    //return;    
}

simulated function Projectile SpawnProjectile()
{
    local Vector RealStartLoc;
    local Projectile SpawnedProjectile;

    IncrementFlashCountEvil(true);
    // End:0x1D9
    if(int(Role) == int(ROLE_Authority))
    {
        RealStartLoc = GetPhysicalFireStartLoc();
        SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
        // End:0x1CF
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(Vector(GetAdjustedAim(RealStartLoc)));
            SpawnedProjectile.Damage = WeaponDamage[int(CurrentFireMode)];
            SpawnedProjectile.MomentumTransfer = WeaponMomentum[int(CurrentFireMode)];
            // End:0x1CF
            if((EvilProjectile_Base(SpawnedProjectile) != none) && MaxHoldTime > float(0))
            {
                EvilProjectile_Base(SpawnedProjectile).TimeToExplode = EvilProjectile_Base(SpawnedProjectile).default.TimeToExplode * FMax(1.0000000 - (HoldTime / MaxHoldTime), 0.0500000);
            }
        }
        return SpawnedProjectile;
    }
    //return ReturnValue;    
}

simulated state WeaponFiring
{
    ignores ConsumeAmmo;

    simulated event BeginState(name PreviousStateName)
    {
        HoldTime = 0.0000000;
        PlayWeaponAnim('WeaponPrepare', 0.0000000, FireAnimBlendTimes.BlendIn, -1.0000000,, true);
        PlayArmAnim('WeaponPrepare', 0.0000000, FireAnimBlendTimes.BlendIn, -1.0000000,, true);
        WeaponPlaySound(WeaponPrepareSnd);
        //return;        
    }

    simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        // End:0x66
        if(SeqNode.AnimSeqName == 'WeaponPrepare')
        {
            // End:0x46
            if(bReleaseGrenade)
            {
                HandleFinishedFiring();                
            }
            else
            {
                FireAmmunition();
                TimeWeaponFiring(CurrentFireMode);
            }            
        }
        else
        {
            // End:0x9C
            if(SeqNode.AnimSeqName == 'WeaponThrow')
            {
                HandleFinishedFiring();
            }
        }
        //return;        
    }

    simulated function bool ShouldRefire()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function DoRelease()
    {
        // End:0x21
        if(IsTimerActive('RefireCheckTimer'))
        {
            HandleFinishedFiring();
        }
        bReleaseGrenade = true;
        //return;        
    }

    simulated function HandleFinishedFiring()
    {
        ClearTimer('RefireCheckTimer');
        PlayWeaponAnim('WeaponThrow', 0.0000000, 0.0000000, FireAnimBlendTimes.BlendOut,, true);
        PlayArmAnim('WeaponThrow', 0.0000000, 0.0000000, FireAnimBlendTimes.BlendOut,, true);
        WeaponPlaySound(WeaponThrowSnd);
        AddAmmoForFireMode(CurrentFireMode, -ShotCost[int(CurrentFireMode)]);
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        bReleaseGrenade = false;
        EvilPawn(Instigator).EndGrenadeThrow();
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        super.Tick(DeltaTime);
        // End:0x6A
        if((MaxHoldTime > float(0)) && !bReleaseGrenade)
        {
            HoldTime += DeltaTime;
            // End:0x6A
            if(HoldTime >= MaxHoldTime)
            {
                DoRelease();
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bIsSwitchableAsThrow=true
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_Throw_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__EvilWeap_Melee_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__EvilWeap_Throw_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__EvilWeap_Melee_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_Throw_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilWeap_Melee_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    bCanThrow=true
    // Reference: UDKSkeletalMeshComponent'Default__EvilWeap_Throw_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__EvilWeap_Melee_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__EvilWeap_Throw_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__EvilWeap_Melee_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}