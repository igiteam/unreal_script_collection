class R6GroupGadget extends R6Gadget
    abstract
    native
    config(GadgetsConfig)
    hidecategories(lighting);

var int m_iAmmo;
var config int m_iMaxAmmoNormal;
var config int m_iMaxAmmoVeteran;
var config int m_iMaxAmmoElite;
var config int m_iMaxAmmoMP;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_iAmmo;
}

function bool Replenish(float fReplenishPercentage)
{
    local int iMaxAmmo;

    iMaxAmmo = GetDifficultyConfig().GetGadgetMaxAmmo(self);
    // End:0x28
    if(m_iAmmo == iMaxAmmo)
    {
        return false;
    }
    m_iAmmo = Min(iMaxAmmo, int(float(m_iAmmo) + (float(iMaxAmmo) * fReplenishPercentage)));
    return true;
    return;
}
