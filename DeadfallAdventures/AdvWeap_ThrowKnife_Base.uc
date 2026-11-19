class AdvWeap_ThrowKnife_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

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

simulated function Projectile SpawnProjectile()
{
    local Vector RealStartLoc;
    local Projectile SpawnedProjectile;

    // End:0x130
    if(int(Role) == int(ROLE_Authority))
    {
        RealStartLoc = GetPhysicalFireStartLoc();
        SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
        // End:0x126
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(Vector(GetAdjustedAim(RealStartLoc)));
            SpawnedProjectile.Damage = WeaponDamage[int(CurrentFireMode)];
            SpawnedProjectile.MomentumTransfer = WeaponMomentum[int(CurrentFireMode)];
        }
        return SpawnedProjectile;
    }
    //return ReturnValue;    
}

simulated function Projectile ProjectileFire()
{
    IncrementFlashCount();
    return none;
    //return ReturnValue;    
}

simulated function bool ShouldRefire()
{
    return false;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x31
        if((int(CurrentFireMode) != int(0)) && CheckZoom(FireModeNum))
        {
            return;            
        }
        else
        {
            // End:0x8F
            if((int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
            {
                // End:0x8D
                if(int(ZoomedFireModeNum) < int(255))
                {
                    ZoomedFireModeNum = 255;
                }
                return;
            }
        }
        global.BeginFire(FireModeNum);
        // End:0xE4
        if(!HasAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
        {
            WeaponEmpty();
            return;
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xB1
        if(((int(CurrentFireMode) == int(0)) && PC != none) && int(GetZoomedState()) == int(3))
        {
            EndZoom(PC);
            // End:0xB1
            if(int(Role) < int(ROLE_Authority))
            {
                ServerEndZoom(PC);
            }
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xD3
        if((((int(CurrentFireMode) == int(0)) && MagazineAmmoCount > 0) && PC != none) && int(ZoomedFireModeNum) < int(255))
        {
            StartZoom(PC, ZoomedFireModeNum);
            // End:0xD3
            if(int(Role) < int(ROLE_Authority))
            {
                ServerStartZoom(PC, ZoomedFireModeNum);
            }
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    ZoomedCrosshair=true
    DefaultAmmoCount=10
    MaxAmmoCount=10
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_ThrowKnife_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    ZoomedMeshTranslation=(X=-13.0000000,Y=-20.5000000,Z=-3.3000000)
    ZoomedMeshRotation=(Pitch=0,Yaw=546,Roll=455)
    ZoomedMeshScale=2.0000000
    // Reference: AudioComponent'Default__AdvWeap_ThrowKnife_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_ThrowKnife_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    PlayerViewOffset=(X=6.0000000,Y=0.0000000,Z=-10.0000000)
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_ThrowKnife_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ItemName="Knife"
    // Reference: SkeletalMeshComponent'Default__AdvWeap_ThrowKnife_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}