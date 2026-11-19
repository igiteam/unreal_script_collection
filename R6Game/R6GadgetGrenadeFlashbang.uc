class R6GadgetGrenadeFlashbang extends R6GadgetGrenade
    native
    config(GadgetsConfig)
    hidecategories(lighting);

simulated function name GetGadgetAttachSocket(bool bFPMesh)
{
    // End:0x12
    if(bFPMesh)
    {
        return 'R65_FlashGrenade_LHand';        
    }
    else
    {
        return GetGadgetAttachSocket(bFPMesh);
    }
    return;
}

defaultproperties
{
    m_GrenadeProjectileClass=Class'R6ProjectileFlashbangGrenade'
    m_iMaxAmmoNormal=6
    m_iMaxAmmoVeteran=3
    m_iMaxAmmoElite=2
    m_iMaxAmmoMP=3
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_flashgrenade_M84_"
    // Reference: StaticMeshComponent'Default__R6GadgetGrenadeFlashbang.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetGrenade.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Flashbang_Grenade'
    end object
    m_MeshTP=GadgetMeshTP
    ItemName="FLASHBANG"
    // Reference: StaticMeshComponent'Default__R6GadgetGrenadeFlashbang.GadgetMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetGrenade.GadgetMesh'
    begin object name="GadgetMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Flashbang_Grenade'
    end object
    m_Mesh=GadgetMesh
}