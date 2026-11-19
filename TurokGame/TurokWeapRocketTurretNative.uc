class TurokWeapRocketTurretNative extends TurokVehicleWeapon
    native
    config(WeapRocketTurret)
    hidecategories(Navigation);

// Export UTurokWeapRocketTurretNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated function bool HasAnyAmmo()
{
    return true;
    //return ReturnValue;    
}

simulated event @NULL ProjectileFire()
{
    local @NULL AimDir, RealStartLoc, StartTrace, EndTrace, TestImpact, SpawnedRocket;

    // End:0x130
    if(int(Role) == int(ROLE_Authority))
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        RealStartLoc = GetPhysicalFireStartLoc();
        // End:0xCC
        if(StartTrace != RealStartLoc)
        {
            EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
            StartTrace += (Normal(EndTrace - StartTrace) * 50.0000000);
            TestImpact = CalcWeaponFire(StartTrace, EndTrace);
            AimDir = Normal(TestImpact.HitLocation - RealStartLoc);            
        }
        else
        {
            AimDir = Vector(GetAdjustedAim(RealStartLoc));
        }
        SpawnedRocket = TurokProjRocketNative(__NFUN_278__(GetProjectileClass(), self, 'rocket', RealStartLoc,,, true));
        // End:0x130
        if(SpawnedRocket != none)
        {
            SpawnedRocket.Init(AimDir);
        }
    }
    IncrementFlashCount();
    return SpawnedRocket;
    //return ReturnValue;    
}

simulated state WeaponFiring
{
    simulated function bool TryPutDown()
    {
        PutDownWeapon();
        return true;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapRocketTurretNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}