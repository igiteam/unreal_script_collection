class SPWeaponAttachmentRapidFire extends SPWeaponAttachment
    abstract
    native
    notplaceable;

var SPWeaponRapidFirePersistantState m_rapidFireControl;
var class<SPWeaponRapidFirePersistant> m_weaponRapidFireClass;

// Export USPWeaponAttachmentRapidFire::execIsRapidFireMode(FFrame&, void* const)
native simulated function bool IsRapidFireMode();

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x13
    if(WeaponClass == none)
    {
        return;
    }
    m_weaponRapidFireClass = class<SPWeaponRapidFirePersistant>(WeaponClass);
    // End:0x30
    if(m_weaponRapidFireClass == none)
    {
        return;
    }
    m_weaponRapidFireClass.static.InitRapidFireData(self, m_rapidFireControl);
    //return;    
}

simulated function SPRF_StartFire(out SPWeaponRapidFirePersistantState rapidFireControl)
{
    // End:0x3E
    if(IsRapidFireMode())
    {
        m_weaponRapidFireClass.static.SPRF_StartFire(rapidFireControl, 30000);
        rapidFireControl.m_bInfiniteAmmo = true;
    }
    //return;    
}

simulated function SPRF_StopFire(out SPWeaponRapidFirePersistantState rapidFireControl)
{
    // End:0x26
    if(IsRapidFireMode())
    {
        m_weaponRapidFireClass.static.SPRF_StopFire(rapidFireControl);
    }
    //return;    
}

simulated function bool SPRF_CanGenerateBullet(out SPWeaponRapidFirePersistantState rapidFireControl)
{
    // End:0x27
    if(IsRapidFireMode())
    {
        return m_weaponRapidFireClass.static.SPRF_CanGenerateBullet(rapidFireControl);
    }
    return true;
    //return ReturnValue;    
}

simulated function SPRF_GetShotInfo(out SPWeaponRapidFirePersistantState rapidFireControl, out int accumulatedAmmo, out int bShowTracer, out int bSuppress)
{
    // End:0x35
    if(IsRapidFireMode())
    {
        m_weaponRapidFireClass.static.SPRF_GetShotInfo(rapidFireControl, accumulatedAmmo, bShowTracer, bSuppress);
    }
    //return;    
}

simulated function float SPRF_GetTickInterval(out SPWeaponRapidFirePersistantState rapidFireControl)
{
    // End:0x27
    if(IsRapidFireMode())
    {
        return m_weaponRapidFireClass.static.SPRF_GetTickInterval(rapidFireControl);
    }
    return 0.3333300;
    //return ReturnValue;    
}

simulated function StartFiring()
{
    super.StartFiring();
    SPRF_StartFire(m_rapidFireControl);
    //return;    
}

simulated function StopFiring()
{
    super.StopFiring();
    SPRF_StopFire(m_rapidFireControl);
    StopFireEffects();
    //return;    
}

simulated event Projectile SpawnProjectile(Vector ProjLoc, Rotator projRot)
{
    local Projectile Projectile;
    local SPBulletPersistent SPBullet;
    local int accumulatedAmmo, bSupress, bShowTracer;

    // End:0x20
    if(!IsRapidFireMode())
    {
        return super.SpawnProjectile(ProjLoc, projRot);
    }
    // End:0xD7
    if(SPRF_CanGenerateBullet(m_rapidFireControl))
    {
        Projectile = super.SpawnProjectile(ProjLoc, projRot);
        // End:0x55
        if(Projectile == none)
        {
            return none;
        }
        SPRF_GetShotInfo(m_rapidFireControl, accumulatedAmmo, bShowTracer, bSupress);
        Projectile.Damage = float(accumulatedAmmo) * WeaponClass.static.StaticGetProjectileClass().default.Damage;
        SPBullet = SPBulletPersistent(Projectile);
        // End:0xD7
        if(SPBullet != none)
        {
            SPBullet.bNonSuppressing = true;
        }
    }
    return none;
    //return ReturnValue;    
}

simulated function SpawnMuzzleFlash(Vector pos, Rotator Rot)
{
    // End:0x21
    if(!IsRapidFireMode())
    {
        super.SpawnMuzzleFlash(pos, Rot);
        return;
    }
    // End:0x32
    if(!IsFiring())
    {
        return;
    }
    ClearTimer('DestroyMuzzleFlashEmitter');
    // End:0x61
    if(!HasMuzzleFlashEmitter())
    {
        super.SpawnMuzzleFlash(pos, Rot);
    }
    HideMuzzleFlashEmitter(false);
    //return;    
}

simulated function StopFireEffects()
{
    // End:0x11
    if(!IsRapidFireMode())
    {
        return;
    }
    // End:0x3C
    if(HasMuzzleFlashEmitter())
    {
        HideMuzzleFlashEmitter(true);
        SetTimer(5.0000000, false, 'DestroyMuzzleFlashEmitter');
    }
    //return;    
}
