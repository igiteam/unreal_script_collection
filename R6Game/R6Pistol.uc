class R6Pistol extends R6Weapon
    abstract
    native
    config(WeaponsConfig)
    hidecategories(lighting);

simulated function bool NeedsToPutDown()
{
    local R6Pawn pPawn;

    pPawn = R6Pawn(Instigator);
    // End:0x5A
    if(((pPawn != none) && pPawn.m_R6InvManager != none) && R6Shield(pPawn.m_R6InvManager.PendingWeapon) != none)
    {
        return false;        
    }
    else
    {
        return true;
    }
    return;
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        R6Pawn(Instigator).m_bPreviousWasShield = false;
        WeaponEquipped();
        return;
    }
    stop;
}

defaultproperties
{
    m_eWeaponSlotType=1
    m_eWeaponAnimType=1
    m_damageType=Class'R6DmgTypePistol'
    m_AnimConfigClass=Class'R6WeaponAnimConfigPistol'
    ItemName="PISTOL"
}