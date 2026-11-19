class R6Sniper extends R6Weapon
    abstract
    native
    config(WeaponsConfig)
    hidecategories(lighting);

var int m_iScopeBeforeShoot;

// Export UR6Sniper::execResetScopeAfterShoot(FFrame&, void* const)
native final function ResetScopeAfterShoot();

simulated function RemoveScope()
{
    ResetScope();
    return;
}

simulated function ShootSequenceTimer()
{
    ShootSequenceTimer();
    ResetScopeAfterShoot();
    return;
}

simulated function bool CanChangeScope()
{
    // End:0x32
    if((GetConfigVals().m_bShootBoltsWeapon && m_iScopeBeforeShoot != -1) && IsInShootSequence())
    {
        return false;
    }
    return CanChangeScope();
    return;
}

defaultproperties
{
    m_iScopeBeforeShoot=-1
    m_eWeaponAnimType=5
    m_damageType=Class'R6DmgTypeSniper'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSniper'
    ItemName="SNIPER RIFLE"
}