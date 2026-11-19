class R6WeaponAttachments extends Actor
    native
    notplaceable
    hidecategories(lighting);

var export editinline SkeletalMeshComponent m_WeaponMeshFP;
var export editinline SkeletalMeshComponent m_WeaponMeshTP;
var bool m_bReversedHandWeaponFP;
var bool m_bReversedHandWeaponTP;
var bool m_bIsAttachedToCharacter;
var bool m_bFirstPersonAttachments;
var bool m_bMuzzleFlashStarted;
var bool m_bMuzzleFlashAttached;
var bool m_bFPMagAttachedToWeapon;
var bool m_bFPMagAttachedToHand;
var bool m_bTPMagAttachedToWeapon;
var bool m_bTPMagAttachedToHand;
var bool m_bBulletEjectEffectStarted;
var bool m_bBulletCaseEmitterAttached;
var bool m_bIsSoundSuppressorActivated;
var bool m_bEjectBulletCaseWithNotify;
var bool m_bAttachmentShouldCollide;
var bool m_bUpdateFirstPersonEffects;
var name m_RightHandAttachSocketFP;
var name m_LeftHandAttachSocketFP;
var name m_RightHandAttachSocketTP;
var name m_LeftHandAttachSocketTP;
var R6GameEnums.EAttachmentType m_eAttachmentType;
var int m_iFireRate;
var float m_fFireInterval;
var ParticleSystem m_MuzzleFlashParticleSystemFP;
var ParticleSystem m_MuzzleFlashParticleSystemTP;
var export editinline ParticleSystemComponent m_MuzzleFlashEffectFP;
var export editinline ParticleSystemComponent m_MuzzleFlashEffectTP;
var export editinline PointLightComponent m_MuzzleFlashLightFP;
var export editinline PointLightComponent m_MuzzleFlashLightTP;
var ParticleSystem m_SuppressedMuzzleFlashParticleSystemFP;
var ParticleSystem m_SuppressedMuzzleFlashParticleSystemTP;
var export editinline MeshComponent m_MagazineMeshFP;
var export editinline MeshComponent m_MagazineMeshTP;
var export editinline StaticMeshComponent m_ThrownMagazineMesh;
var name m_MagazineSocketName;
var name m_MagazineWeaponHandBoneName;
var name m_MagazinePawnHandSocketName;
var name m_BulletEjectSocketName;
var ParticleSystem m_BulletCaseParticleSystemFP;
var ParticleSystem m_BulletCaseParticleSystemTP;
var export editinline ParticleSystemComponent m_BulletCaseEmitterFP;
var export editinline ParticleSystemComponent m_BulletCaseEmitterTP;
var float m_fBulletEjectInterval;
var class<R6Scope> m_ScopeAttachmentClass;
var R6Scope m_ScopeAttachment;
var class<R6SoundSuppressor> m_SoundSuppressorAttachmentClass;
var R6SoundSuppressor m_SoundSuppressorAttachment;
var name m_SuppressedMuzzleSocketName;
var name m_MuzzleSocketName;
var class<R6WeaponOption> m_UnderbarrelAttachmentClass;
var R6WeaponOption m_UnderbarrelAttachment;
var int m_iTPToggleWeaponHandAttachmentTick;

// Export UR6WeaponAttachments::execInitAttachments(FFrame&, void* const)
native function InitAttachments();

// Export UR6WeaponAttachments::execSetPawn(FFrame&, void* const)
native function SetPawn(R6Pawn pPawn);

// Export UR6WeaponAttachments::execInitialAttach(FFrame&, void* const)
native function InitialAttach();

// Export UR6WeaponAttachments::execDestroyAttachments(FFrame&, void* const)
native function DestroyAttachments();

// Export UR6WeaponAttachments::execAttachTo(FFrame&, void* const)
native function AttachTo(R6Pawn pPawn, R6Weapon pWeapon);

// Export UR6WeaponAttachments::execDetachFrom(FFrame&, void* const)
native function DetachFrom(R6Pawn pPawn, R6Weapon pWeapon, optional bool bToBody);

// Export UR6WeaponAttachments::execCanAttachToSocket(FFrame&, void* const)
native function bool CanAttachToSocket(optional bool bFirstPerson);

// Export UR6WeaponAttachments::execGetAttachName(FFrame&, void* const)
native function name GetAttachName(optional bool bFirstPerson);

// Export UR6WeaponAttachments::execGetAttachRot(FFrame&, void* const)
native function Rotator GetAttachRot();

// Export UR6WeaponAttachments::execGetMuzzleSocketName(FFrame&, void* const)
native function name GetMuzzleSocketName();

// Export UR6WeaponAttachments::execGetPhysicalFireStartLoc(FFrame&, void* const)
native function Vector GetPhysicalFireStartLoc(bool bFirstPerson);

// Export UR6WeaponAttachments::execGetPhysicalFireStartRot(FFrame&, void* const)
native function Rotator GetPhysicalFireStartRot(bool bFirstPerson);

// Export UR6WeaponAttachments::execSoundSuppressorActivated(FFrame&, void* const)
native function SoundSuppressorActivated(bool bActivated);

// Export UR6WeaponAttachments::execToggleWeaponHandAttachment(FFrame&, void* const)
native final function ToggleWeaponHandAttachment(bool bFirstPerson);

// Export UR6WeaponAttachments::execInitMuzzleFlash(FFrame&, void* const)
native function InitMuzzleFlash();

// Export UR6WeaponAttachments::execAttachMuzzleFlash(FFrame&, void* const)
native function AttachMuzzleFlash();

// Export UR6WeaponAttachments::execDetachMuzzleFlash(FFrame&, void* const)
native function DetachMuzzleFlash();

// Export UR6WeaponAttachments::execStartMuzzleFlashEffectNative(FFrame&, void* const)
native function StartMuzzleFlashEffectNative();

// Export UR6WeaponAttachments::execStopMuzzleFlashLight(FFrame&, void* const)
native function StopMuzzleFlashLight();

// Export UR6WeaponAttachments::execInitBulletCaseEject(FFrame&, void* const)
native function InitBulletCaseEject();

// Export UR6WeaponAttachments::execAttachBulletCaseEject(FFrame&, void* const)
native function AttachBulletCaseEject();

// Export UR6WeaponAttachments::execDetachBulletCaseEject(FFrame&, void* const)
native function DetachBulletCaseEject();

// Export UR6WeaponAttachments::execEjectBulletCase(FFrame&, void* const)
native function EjectBulletCase(bool bFirstPerson);

// Export UR6WeaponAttachments::execAttachMagToWeapon(FFrame&, void* const)
native function AttachMagToWeapon(bool bFirstPerson);

// Export UR6WeaponAttachments::execAttachMagToHand(FFrame&, void* const)
native function AttachMagToHand(bool bFirstPerson);

// Export UR6WeaponAttachments::execDetachMag(FFrame&, void* const)
native function DetachMag(bool bFirstPerson);

// Export UR6WeaponAttachments::execAttachSuppressorToWeapon(FFrame&, void* const)
native function AttachSuppressorToWeapon(bool bFirstPerson);

// Export UR6WeaponAttachments::execAttachSuppressorToHand(FFrame&, void* const)
native function AttachSuppressorToHand(bool bFirstPerson);

// Export UR6WeaponAttachments::execAttachSuppressorToCharacter(FFrame&, void* const)
native function AttachSuppressorToCharacter();

// Export UR6WeaponAttachments::execDetachSuppressor(FFrame&, void* const)
native function DetachSuppressor(bool bFirstPerson);

// Export UR6WeaponAttachments::execStartFireEffects(FFrame&, void* const)
native simulated function StartFireEffects(int iFireRate);

// Export UR6WeaponAttachments::execStopFireEffects(FFrame&, void* const)
native simulated function StopFireEffects();

// Export UR6WeaponAttachments::execStartMuzzleFlashEffect(FFrame&, void* const)
native simulated function StartMuzzleFlashEffect();

// Export UR6WeaponAttachments::execDoMuzzleFlash(FFrame&, void* const)
native simulated function DoMuzzleFlash();

// Export UR6WeaponAttachments::execStopMuzzleFlashEffect(FFrame&, void* const)
native simulated function StopMuzzleFlashEffect();

// Export UR6WeaponAttachments::execDisableMuzzleFlashLight(FFrame&, void* const)
native simulated function DisableMuzzleFlashLight();

// Export UR6WeaponAttachments::execStartBulletEjectEffect(FFrame&, void* const)
native simulated function StartBulletEjectEffect();

// Export UR6WeaponAttachments::execEjectBulletCases(FFrame&, void* const)
native simulated function EjectBulletCases();

// Export UR6WeaponAttachments::execStopBulletEjectEffect(FFrame&, void* const)
native simulated function StopBulletEjectEffect();

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6WeaponAttachments.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="FPWeaponSkelMesh" class=Class'Engine.SkeletalMeshComponent'
        AnimTreeTemplate=AnimTree'AnimTreeWeapons.AnimTreeWeapon'
        CollideActors=false
        m_eComponentVisibility=1
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6WeaponAttachments.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="TPWeaponSkelMesh" class=Class'Engine.SkeletalMeshComponent'
        AnimTreeTemplate=AnimTree'AnimTreeWeapons.AnimTreeWeapon'
        m_bWeaponComponent=true
        m_eComponentVisibility=2
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_MG_RHand"
    m_LeftHandAttachSocketFP="R65_MG_LHand"
    m_RightHandAttachSocketTP="R65_MG_RHand"
    m_LeftHandAttachSocketTP="R65_MG_LHand"
    // Reference: ParticleSystemComponent'Default__R6WeaponAttachments.MuzzleFlashParticleComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MuzzleFlashParticleComponentFP" class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
        bResetOnDetach=false
        m_bAutoDeactivate=true
        m_bHeatVisionSeeThroughWall=true
        Rotation=(Pitch=16384,Yaw=0,Roll=0)
        m_eComponentVisibility=1
        m_bIsVisibleInScope=true
    end object
    m_MuzzleFlashEffectFP=MuzzleFlashParticleComponentFP
    // Reference: ParticleSystemComponent'Default__R6WeaponAttachments.MuzzleFlashParticleComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MuzzleFlashParticleComponentTP" class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
        bResetOnDetach=false
        m_bAutoDeactivate=true
        m_bResetOnBecomeRelevant=true
        m_bHeatVisionSeeThroughWall=true
        Rotation=(Pitch=16384,Yaw=0,Roll=0)
        m_eComponentVisibility=2
        m_bIsVisibleInScope=true
    end object
    m_MuzzleFlashEffectTP=MuzzleFlashParticleComponentTP
    m_SuppressedMuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.Silenced_flash_both'
    m_SuppressedMuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.Silenced_flash_both'
    // Reference: StaticMeshComponent'Default__R6WeaponAttachments.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MagazineMeshComponentFP" class=Class'Engine.StaticMeshComponent'
        bAcceptsDecalsDuringGameplay=false
        CollideActors=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6WeaponAttachments.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MagazineMeshComponentTP" class=Class'Engine.StaticMeshComponent'
        m_bWeaponComponent=true
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
    m_MagazineSocketName="R65_AM_Mag"
    m_MagazineWeaponHandBoneName="R65_BA_Attach_01"
    m_MagazinePawnHandSocketName="R65_Magazine_LHand"
    m_BulletEjectSocketName="R65_FXM_Bullet_Eject"
    // Reference: ParticleSystemComponent'Default__R6WeaponAttachments.BulletEjectParticleComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="BulletEjectParticleComponentFP" class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
        bResetOnDetach=false
        m_bAutoDeactivate=true
        m_eComponentVisibility=1
    end object
    m_BulletCaseEmitterFP=BulletEjectParticleComponentFP
    // Reference: ParticleSystemComponent'Default__R6WeaponAttachments.BulletEjectParticleComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="BulletEjectParticleComponentTP" class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
        bResetOnDetach=false
        m_bAutoDeactivate=true
        m_eComponentVisibility=2
        m_bDontSupportNearPlane=true
    end object
    m_BulletCaseEmitterTP=BulletEjectParticleComponentTP
    m_SuppressedMuzzleSocketName="R65_FXM_SuppressedMuzzle"
    m_MuzzleSocketName="R65_FXM_Muzzle"
    bNoSelect=true
    Components=none
    TickGroup=1
    NetUpdateFrequency=10.0000000
}