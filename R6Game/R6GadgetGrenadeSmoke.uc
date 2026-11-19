class R6GadgetGrenadeSmoke extends R6GadgetGrenade
    native
    config(GadgetsConfig)
    hidecategories(lighting);

simulated function name GetGadgetAttachSocket(bool bFPMesh)
{
    // End:0x12
    if(bFPMesh)
    {
        return 'R65_SmokeGrenade_LHand';        
    }
    else
    {
        return GetGadgetAttachSocket(bFPMesh);
    }
    return;
}

defaultproperties
{
    m_GrenadeProjectileClass=Class'R6ProjectileSmokeGrenade'
    m_iMaxAmmoNormal=6
    m_iMaxAmmoVeteran=3
    m_iMaxAmmoElite=2
    m_iMaxAmmoMP=3
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_smokegrenade"
    // Reference: StaticMeshComponent'Default__R6GadgetGrenadeSmoke.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetGrenade.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.smoke_grenade'
    end object
    m_MeshTP=GadgetMeshTP
    ItemName="SMOKE"
    // Reference: StaticMeshComponent'Default__R6GadgetGrenadeSmoke.GadgetMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetGrenade.GadgetMesh'
    begin object name="GadgetMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.smoke_grenade'
    end object
    m_Mesh=GadgetMesh
}