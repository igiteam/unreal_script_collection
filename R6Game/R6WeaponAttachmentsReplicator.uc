class R6WeaponAttachmentsReplicator extends ReplicationInfo
    native
    nativereplication
    hidecategories(lighting,Movement,Collision);

var R6Pawn m_R6Pawn;
var repnotify class<R6WeaponAttachments> m_HandWeaponAttachmentClass;
var repnotify class<R6Scope> m_HandScopeAttachmentClass;
var repnotify class<R6WeaponOption> m_HandUnderbarrelAttachmentClass;
var repnotify class<R6SoundSuppressor> m_HandSoundSuppressorAttachmentClass;
var repnotify bool m_bHandSoundSuppressorOn;
var repnotify bool m_bHandComplementarySoundSuppressorOn;
var repnotify bool m_bChestSoundSuppressorOn;
var repnotify bool m_bPrimarySoundSuppressorOn;
var repnotify bool m_bPistolSoundSuppressorOn;
var R6WeaponAttachments m_HandWeaponAttachments;
var repnotify class<R6WeaponAttachments> m_HandComplementaryWeaponAttachmentClass;
var repnotify class<R6Scope> m_HandComplementaryScopeAttachmentClass;
var repnotify class<R6WeaponOption> m_HandComplementaryUnderbarrelAttachmentClass;
var repnotify class<R6SoundSuppressor> m_HandComplementarySoundSuppressorAttachmentClass;
var R6WeaponAttachments m_HandComplementaryWeaponAttachments;
var repnotify class<R6WeaponAttachments> m_ChestWeaponAttachmentClass;
var repnotify class<R6Scope> m_ChestScopeAttachmentClass;
var repnotify class<R6WeaponOption> m_ChestUnderbarrelAttachmentClass;
var repnotify class<R6SoundSuppressor> m_ChestSoundSuppressorAttachmentClass;
var R6WeaponAttachments m_ChestWeaponAttachments;
var repnotify class<R6WeaponAttachments> m_PrimaryWeaponAttachmentClass;
var repnotify class<R6Scope> m_PrimaryScopeAttachmentClass;
var repnotify class<R6WeaponOption> m_PrimaryUnderbarrelAttachmentClass;
var repnotify class<R6SoundSuppressor> m_PrimarySoundSuppressorAttachmentClass;
var R6WeaponAttachments m_PrimaryWeaponAttachments;
var repnotify class<R6WeaponAttachments> m_PistolWeaponAttachmentClass;
var repnotify class<R6Scope> m_PistolScopeAttachmentClass;
var repnotify class<R6WeaponOption> m_PistolUnderbarrelAttachmentClass;
var repnotify class<R6SoundSuppressor> m_PistolSoundSuppressorAttachmentClass;
var R6WeaponAttachments m_PistolWeaponAttachments;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_ChestScopeAttachmentClass, m_ChestSoundSuppressorAttachmentClass, 
        m_ChestUnderbarrelAttachmentClass, m_ChestWeaponAttachmentClass, 
        m_HandComplementaryScopeAttachmentClass, m_HandComplementarySoundSuppressorAttachmentClass, 
        m_HandComplementaryUnderbarrelAttachmentClass, m_HandComplementaryWeaponAttachmentClass, 
        m_HandScopeAttachmentClass, m_HandSoundSuppressorAttachmentClass, 
        m_HandUnderbarrelAttachmentClass, m_HandWeaponAttachmentClass, 
        m_PistolScopeAttachmentClass, m_PistolSoundSuppressorAttachmentClass, 
        m_PistolUnderbarrelAttachmentClass, m_PistolWeaponAttachmentClass, 
        m_PrimaryScopeAttachmentClass, m_PrimarySoundSuppressorAttachmentClass, 
        m_PrimaryUnderbarrelAttachmentClass, m_PrimaryWeaponAttachmentClass, 
        m_bChestSoundSuppressorOn, m_bHandComplementarySoundSuppressorOn, 
        m_bHandSoundSuppressorOn, m_bPistolSoundSuppressorOn, 
        m_bPrimarySoundSuppressorOn;
}

// Export UR6WeaponAttachmentsReplicator::execUpdateWeaponAttachments(FFrame&, void* const)
native function UpdateWeaponAttachments();

// Export UR6WeaponAttachmentsReplicator::execSetPawn(FFrame&, void* const)
native function SetPawn(R6Pawn pPawn);

// Export UR6WeaponAttachmentsReplicator::execActivateUnderbarrelAttachment(FFrame&, void* const)
native function ActivateUnderbarrelAttachment(bool bActivated);

defaultproperties
{
    bAlwaysRelevant=false
    bOnlyDirtyReplication=false
}