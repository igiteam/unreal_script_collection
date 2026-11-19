class R6SoundSuppressorSMG extends R6SoundSuppressor
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6SoundSuppressorSMG.SoundSuppressorMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6SoundSuppressor.SoundSuppressorMeshComponentFP'
    begin object name="SoundSuppressorMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_SilencerSMG'
    end object
    m_SoundSuppressorMeshFP=SoundSuppressorMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6SoundSuppressorSMG.SoundSuppressorMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6SoundSuppressor.SoundSuppressorMeshComponentTP'
    begin object name="SoundSuppressorMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_SilencerSMG'
    end object
    m_SoundSuppressorMeshTP=SoundSuppressorMeshComponentTP
}