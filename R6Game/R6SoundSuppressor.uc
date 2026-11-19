class R6SoundSuppressor extends R6WeaponOption
    native
    notplaceable
    hidecategories(lighting);

var export editinline StaticMeshComponent m_SoundSuppressorMeshFP;
var export editinline StaticMeshComponent m_SoundSuppressorMeshTP;
var name m_SoundSuppressorSocketName;
var name m_SoundSuppressorAnimBoneName;
var name m_SoundSuppressorCharacterSocketName;
var bool m_bFPSuppressorAttachedToWeapon;
var bool m_bFPSuppressorAttachedToHand;
var bool m_bTPSuppressorAttachedToWeapon;
var bool m_bTPSuppressorAttachedToHand;
var bool m_bTPSuppressorAttachedToCharacter;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6SoundSuppressor.SoundSuppressorMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SoundSuppressorMeshComponentFP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_SilencerPistol'
        bAcceptsDecalsDuringGameplay=false
        CollideActors=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_SoundSuppressorMeshFP=SoundSuppressorMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6SoundSuppressor.SoundSuppressorMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SoundSuppressorMeshComponentTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_SilencerPistol'
        m_bWeaponComponent=true
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
    end object
    m_SoundSuppressorMeshTP=SoundSuppressorMeshComponentTP
    m_SoundSuppressorSocketName="R65_AM_Muzzle"
    m_SoundSuppressorAnimBoneName="R65_BA_Attach_01"
    m_SoundSuppressorCharacterSocketName="R65_Suppressor_LHand"
    m_szDescription="SOUND SUPPRESSOR"
}