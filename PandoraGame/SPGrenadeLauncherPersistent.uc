class SPGrenadeLauncherPersistent extends SPWeapon
    abstract
    native
    config(Game);

var Vector projectileSpeedScaler;
var SPGrenadePersistent CurrentExplosiveGrenade;
var class<SPGrenadePersistent> BulletFlareClass;
var class<SPGrenadePersistent> BulletGrenadeClass;
var class<SPGrenadePersistent> BulletMolotovClass;
var class<SPGrenadePersistent> BulletTaserGrenadeClass;
var ParticleSystem FlareParticleSystem;
var ParticleSystem MolotovParticleSystem;
var SoundCue GrenadeSwitchSound;
var SoundCue MolotovSwitchSound;

simulated function GetSPWeaponGamePadParams(out SPWeaponGamePadParams Params)
{
    Params.bTargetAdhesionEnabled = false;
    Params.bTargetFrictionEnabled = false;
    //return;    
}

simulated function class<SPGrenadePersistent> GetGrenadePersistentClass()
{
    return BulletGrenadePersistentClass;
    //return ReturnValue;    
}

simulated function bool IsEquippable()
{
    return false;
    //return ReturnValue;    
}

simulated function DestroyCurrentGrenade()
{
    CurrentExplosiveGrenade = none;
    //return;    
}

simulated function bool CanFireGrenade()
{
    // End:0x47
    if((CurrentExplosiveGrenade != none) && (CurrentExplosiveGrenade.IsA('GrenadeExplosive') == true) || CurrentExplosiveGrenade.IsA('TaserGrenade') == true)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool TriggerGrenadeExplosion()
{
    // End:0x36
    if(!CanFireGrenade())
    {
        CurrentExplosiveGrenade.Explode(Location, Location);
        CurrentExplosiveGrenade = none;
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function AttachFireToFlare(SPGrenadePersistent Proj, bool bSpinForward)
{
    local SPFlareFireObject FireObject;
    local Vector fireloc;
    local Rotator fireRot, projRot;

    fireloc = vect(0.0000000, -35.0000000, 0.0000000);
    fireRot.Pitch = 0;
    fireRot.Roll = 49152;
    fireRot.Yaw = 0;
    FireObject = Spawn(Class'SPFlareFireObject');
    // End:0x180
    if(FireObject != none)
    {
        FireObject.BurnTime = FireObject.flareBurnTime;
        FireObject.PSLevels[0] = FlareParticleSystem;
        FireObject.FireStrength = 100.0000000;
        FireObject.FireSpreadSpeed = 5.0000000;
        FireObject.ScaleMe(FireObject.ScaleFactor);
        FireObject.SetOwner(self);
        FireObject.SetBase(Proj);
        FireObject.SetHardAttach();
        FireObject.SetRelativeLocation(fireloc);
        FireObject.SetRelativeRotation(fireRot);
        FireObject.AddLight();
        FireObject.bKillDuringLevelTransition = true;
    }
    projRot.Pitch = -8192;
    projRot.Roll = 16384;
    projRot.Yaw = 0;
    Proj.SetRotation(projRot);
    Proj.FlareRandSpin(25000.0000000, bSpinForward);
    //return;    
}

simulated function AttachFireToMolotov(SPGrenadePersistent Proj, bool bSpinForward)
{
    local Vector fireloc;
    local Rotator fireRot, projRot;

    fireloc = vect(0.0000000, 0.0000000, 65.0000000);
    fireRot.Pitch = 0;
    fireRot.Roll = 0;
    fireRot.Yaw = 0;
    Proj.MolotovFireObject = Spawn(Class'SPFlareFireObject');
    // End:0x202
    if(Proj.MolotovFireObject != none)
    {
        Proj.MolotovFireObject.BurnTime = Proj.MolotovFireObject.flareBurnTime;
        Proj.MolotovFireObject.PSLevels[0] = MolotovParticleSystem;
        Proj.MolotovFireObject.FireStrength = 10000.0000000;
        Proj.MolotovFireObject.FireSpreadSpeed = 100.0000000;
        Proj.MolotovFireObject.ScaleMe(Proj.MolotovFireObject.ScaleFactor);
        Proj.MolotovFireObject.SetOwner(Proj);
        Proj.MolotovFireObject.SetBase(Proj);
        Proj.MolotovFireObject.SetHardAttach();
        Proj.MolotovFireObject.SetRelativeLocation(fireloc);
        Proj.MolotovFireObject.SetRelativeRotation(fireRot);
        Proj.MolotovFireObject.bKillDuringLevelTransition = true;
    }
    projRot.Pitch = 8000;
    projRot.Roll = 8000;
    projRot.Yaw = 0;
    Proj.SetRotation(projRot);
    Proj.FlareRandSpin(25000.0000000, bSpinForward);
    //return;    
}

simulated function int AmmoCountForType(int GrenadeType)
{
    local SPInventoryManager spInvManager;

    spInvManager = SPInventoryManager(InvManager);
    // End:0x1D
    if(spInvManager == none)
    {
        return 0;
    }
    return spInvManager.GetGrenadeAmmo(GrenadeType);
    //return ReturnValue;    
}

simulated function int curGrenadeType()
{
    local SPInventoryManager spInvManager;

    spInvManager = SPInventoryManager(InvManager);
    // End:0x1E
    if(spInvManager == none)
    {
        return 4;
    }
    return int(spInvManager.curGrenadeType);
    //return ReturnValue;    
}

simulated function bool AnyGrenadeTypeAvailable()
{
    local SPInventoryManager spInvManager;

    spInvManager = SPInventoryManager(InvManager);
    // End:0x1D
    if(spInvManager == none)
    {
        return false;
    }
    // End:0x93
    if((((spInvManager.GetGrenadeAmmo(0) == 0) && spInvManager.GetGrenadeAmmo(1) == 0) && spInvManager.GetGrenadeAmmo(2) == 0) && spInvManager.GetGrenadeAmmo(3) == 0)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function class<SPGrenadePersistent> GetGrenadeClass(int Type)
{
    switch(Type)
    {
        // End:0x15
        case 0:
            return BulletFlareClass;
            // End:0x41
            break;
        // End:0x22
        case 1:
            return BulletGrenadeClass;
            // End:0x41
            break;
        // End:0x30
        case 2:
            return BulletMolotovClass;
            // End:0x41
            break;
        // End:0x3E
        case 3:
            return BulletTaserGrenadeClass;
            // End:0x41
            break;
        // End:0xFFFF
        default:
            break;
    }
    return none;
    //return ReturnValue;    
}

simulated function PlayFireSound(SPGrenadePersistent Grenade)
{
    // End:0x0D
    if(Grenade == none)
    {
        return;
    }
    // End:0x2E
    if(bIsNPCWeapon)
    {
        Sound_Fire = Grenade.SpawnSoundNPC;        
    }
    else
    {
        Sound_Fire = Grenade.SpawnSound;
    }
    // End:0x58
    if(Sound_Fire != none)
    {
        PlayFiringSound();
    }
    //return;    
}

simulated function SPGrenadePersistent GrenadeFire(optional bool bUnderHand = true)
{
    local SPInventoryManager spInvManager;
    local Vector SocketLocation;
    local Rotator SocketRotation;
    local float projSpeedScaler;
    local PandoraPlayerController PPC;

    spInvManager = SPInventoryManager(InvManager);
    // End:0x42
    if(spInvManager.GetGrenadeAmmo(int(spInvManager.curGrenadeType)) <= 0)
    {
        return none;
    }
    spInvManager.SetGrenadeAmmo(int(spInvManager.curGrenadeType), spInvManager.GetGrenadeAmmo(int(spInvManager.curGrenadeType)) - 1);
    AmmoCount--;
    BulletGrenadePersistentClass = GetGrenadeClass(int(spInvManager.curGrenadeType));
    // End:0x158
    if(WorldInfo.GRI.bIsArbitrated)
    {
        // End:0x158
        if((!bWeaponHasBeenFired && int(Role) == int(ROLE_Authority)) && int(spInvManager.curGrenadeType) == int(1))
        {
            bWeaponHasBeenFired = true;
            PPC = PandoraPlayerController(Pawn(Owner).Controller);
            // End:0x158
            if(PPC != none)
            {
                PPC.ClientNewWeaponFiredAchievement(WeaponType);
            }
        }
    }
    // End:0x1E8
    if((((spInvManager.GetGrenadeAmmo(0) == 0) && spInvManager.GetGrenadeAmmo(1) == 0) && spInvManager.GetGrenadeAmmo(2) == 0) && spInvManager.GetGrenadeAmmo(3) == 0)
    {
        spInvManager.curGrenadeType = spInvManager.4;
    }
    // End:0x231
    if(bUnderHand)
    {
        SPPawn(Owner).Mesh.GetSocketWorldLocationAndRotation('UnderhandThrow', SocketLocation, SocketRotation);
        projSpeedScaler = 0.7500000;        
    }
    else
    {
        SPPawn(Owner).Mesh.GetSocketWorldLocationAndRotation('ThrowWeapon', SocketLocation, SocketRotation);
        projSpeedScaler = 1.5000000;
    }
    projectileSpeedScaler.X = projSpeedScaler;
    projectileSpeedScaler.Y = projSpeedScaler;
    projectileSpeedScaler.Z = projSpeedScaler;
    CurrentExplosiveGrenade = FireGrenadePersistent(SocketLocation, projectileSpeedScaler);
    // End:0x2EB
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        CurrentExplosiveGrenade = none;
    }
    // End:0x31A
    if(CurrentExplosiveGrenade != none)
    {
        CurrentExplosiveGrenade.SetGrenadeLauncherParent(self);
        PlayFireSound(CurrentExplosiveGrenade);
    }
    return CurrentExplosiveGrenade;
    //return ReturnValue;    
}

simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
    return Instigator.GetWeaponStartTraceLocation();
    //return ReturnValue;    
}

simulated function SPGrenadePersistent FireGrenadePersistent(optional Vector SocketLocation, optional Vector InProjectileSpeedScaler)
{
    local SPGrenadePersistent SpawnedProjectile;
    local class<SPGrenadePersistent> GrenadePersistentClass;
    local Vector StartLoc, AimDir;
    local PlayerPawn myPawn;
    local bool bUnderHandThrow;

    myPawn = PlayerPawn(Instigator);
    // End:0x189
    if(int(Role) == int(ROLE_Authority))
    {
        GetProjectileFirePosition(StartLoc, AimDir);
        // End:0x4E
        if(!IsZero(SocketLocation))
        {
            StartLoc = SocketLocation;
        }
        GrenadePersistentClass = GetGrenadePersistentClass();
        // End:0xFF
        if(GrenadePersistentClass != none)
        {
            SpawnedProjectile = Spawn(GrenadePersistentClass, self,, StartLoc);
            // End:0xFF
            if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
            {
                // End:0xC2
                if(!IsZero(InProjectileSpeedScaler))
                {
                    AimDir *= InProjectileSpeedScaler;
                }
                SpawnedProjectile.Init(AimDir);
                SpawnedProjectile.SetOwner(Owner);
                SpawnedProjectile.bKillDuringLevelTransition = true;
            }
        }
        LastShotTime = WorldInfo.TimeSeconds;
        // End:0x13D
        if(myPawn != none)
        {
            bUnderHandThrow = int(myPawn.m_eGrenadeState) == int(3);
        }
        // End:0x163
        if(BulletGrenadePersistentClass == BulletFlareClass)
        {
            AttachFireToFlare(SpawnedProjectile, !bUnderHandThrow);
        }
        // End:0x189
        if(BulletGrenadePersistentClass == BulletMolotovClass)
        {
            AttachFireToMolotov(SpawnedProjectile, !bUnderHandThrow);
        }
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

simulated function PlayGrenadeSwitchSound()
{
    local SPInventoryManager spInvManager;

    spInvManager = SPInventoryManager(InvManager);
    // End:0x1D
    if(spInvManager == none)
    {
        return;
    }
    switch(spInvManager.curGrenadeType)
    {
        // End:0x51
        case spInvManager.0:
            PlaySound(GrenadeSwitchSound);
            // End:0xBA
            break;
        // End:0x73
        case spInvManager.1:
            PlaySound(GrenadeSwitchSound);
            // End:0xBA
            break;
        // End:0x95
        case spInvManager.2:
            PlaySound(MolotovSwitchSound);
            // End:0xBA
            break;
        // End:0xB7
        case spInvManager.3:
            PlaySound(GrenadeSwitchSound);
            // End:0xBA
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}
