class R6LightMachineGun extends R6Weapon
    abstract
    native
    config(WeaponsConfig)
    hidecategories(lighting);

var bool m_bSupportStrap;
var bool m_bStrap;
var int m_iGrabCounter;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_bStrap;
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        // End:0x23
        if(int(Role) == int(ROLE_Authority))
        {
            m_iGrabCounter = 0;
        }
        return;
    }
    stop;
}

defaultproperties
{
    m_bStrap=true
    m_damageType=Class'R6DmgTypeLMG'
    m_AnimConfigClass=Class'R6WeaponAnimConfigLMG'
    ItemName="LIGHT MACHINE GUN"
}