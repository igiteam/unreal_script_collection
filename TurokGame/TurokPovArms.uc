class TurokPovArms extends ActorComponent
    native;

var export editinline @NULL mPovArmsMesh;
var transient @NULL mPovArmsController;
var transient @NULL mAttachedWeapon;
var transient @NULL mAttachedWeaponLeft;
var private transient bool mbQueueWeaponBringUp;
var private transient float mBringUpWeaponsDelay;

// Export UTurokPovArms::execSetMeshHidden(FFrame&, void* const)
native function SetMeshHidden(bool bNewHidden);

// Export UTurokPovArms::execPurgeAnimations(FFrame&, void* const)
native function PurgeAnimations();

// Export UTurokPovArms::execPlayPOVAnimation(FFrame&, void* const)
native function PlayPOVAnimation(@NULL Weapon, @NULL Anim, float Duration, float blendIn, float blendOut, bool bTransient, bool bLoop);

// Export UTurokPovArms::execPlayPOVCannedAnimationWithAnimSets(FFrame&, void* const)
native function PlayPOVCannedAnimationWithAnimSets(@NULL Weapon, @NULL Anim, float Duration, float blendIn, bool bLoop, array weaponAnimSet, array armsAnimSet);

// Export UTurokPovArms::execPlayPOVCannedAnimation(FFrame&, void* const)
native function PlayPOVCannedAnimation(@NULL Weapon, @NULL Anim, float Duration, float blendIn, bool bLoop);

// Export UTurokPovArms::execStopPOVTransientAnimation(FFrame&, void* const)
native function StopPOVTransientAnimation(@NULL Weapon, float blendTime);

// Export UTurokPovArms::execAttachPovWeapon(FFrame&, void* const)
native function AttachPovWeapon(@NULL Weapon, name BoneName);

// Export UTurokPovArms::execDetachPovWeapon(FFrame&, void* const)
native function DetachPovWeapon(@NULL Weapon);

// Export UTurokPovArms::execAttachPovMeshComponent(FFrame&, void* const)
native function AttachPovMeshComponent(@NULL meshItem, name BoneName);

// Export UTurokPovArms::execDetachPovMeshComponent(FFrame&, void* const)
native function DetachPovMeshComponent(@NULL meshItem);

// Export UTurokPovArms::execPlayCannedAnimOnMeshItem(FFrame&, void* const)
native function PlayCannedAnimOnMeshItem(@NULL meshItem, name AnimName, float Duration, float blendIn, bool bLoop, array locAnimSet);

// Export UTurokPovArms::execUpdatePovTransform(FFrame&, void* const)
native function UpdatePovTransform();

// Export UTurokPovArms::execPutDownWeapons(FFrame&, void* const)
native function PutDownWeapons(float timeToFinish, float blendTime);

// Export UTurokPovArms::execBringUpWeapons(FFrame&, void* const)
native function BringUpWeapons(float timeToFinish, float blendTime);
