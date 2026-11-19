class TurokWeapAttachKnifeNative extends TurokWeaponAttachment
    native
    config(Weapon);

event AttachAnimations()
{
    local editinline @NULL weaponMesh;
    local float alertWeight;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0xF2
    if(weaponMesh != none)
    {
        weaponMesh.AnimSets = mWeaponAnimSets;
        // End:0x46
        if(mbAlertAim)
        {
            alertWeight = 1.0000000;            
        }
        else
        {
            alertWeight = 0.0000000;
        }
        InitBaseSpatialController(m3PAimAsset, true, true);
        InitSpatialController(mRelaxedAimControllerName, m3PRelaxedAimAsset, 'jt_SpineLower_C', 1.0000000, 1.0000000 - alertWeight, true, true);
        InitSpatialController(mFireControllerName, m3PFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        InitSpatialController(mAltFireControllerName, m3PAltFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        InitCannedController(mCannedControllerName, 'jt_SpineUpper_C', 1.0000000, 0.0000000);
    }
    //return;    
}

// Export UTurokWeapAttachKnifeNative::execFirstPersonFireEffects(FFrame&, void* const)
native function FirstPersonFireEffects(@NULL PawnWeapon, @NULL HitLocation);

// Export UTurokWeapAttachKnifeNative::execThirdPersonFireEffects(FFrame&, void* const)
native function ThirdPersonFireEffects(@NULL HitLocation);
