class R6FixedLMG extends R6LightMachineGun
    abstract
    native
    config(WeaponsConfig)
    hidecategories(lighting);

var R6Turret m_pTurret;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_pTurret;
}
