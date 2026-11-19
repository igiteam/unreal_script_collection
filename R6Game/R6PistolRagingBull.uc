class R6PistolRagingBull extends R6Pistol
    native
    config(WeaponsConfig)
    hidecategories(lighting);

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        R6AttachmentsPistolRagingBull(m_pAttachments).m_eReloadSteps = 0;
        return;
    }
    stop;
}

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Pistol.Pistol_RagingBull_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsPistolRagingBull'
    m_damageType=Class'R6DmgTypePistolRagingBull'
    m_ConfigClass=Class'ConfigR6PistolRagingBull'
    m_AnimConfigClass=Class'R6WeaponAnimConfigPistolRagingBull'
    ItemName="RAGING BULL"
}