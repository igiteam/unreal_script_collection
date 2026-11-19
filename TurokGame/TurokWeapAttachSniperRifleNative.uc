class TurokWeapAttachSniperRifleNative extends TurokWeaponAttachment
    native
    config(WeapSniperRifle);

var(SniperRifle) @NULL mZoomMuzzleOffset;

// Export UTurokWeapAttachSniperRifleNative::execGetWeaponMuzzleLocation(FFrame&, void* const)
native simulated function @NULL GetWeaponMuzzleLocation(int FiringMode, optional @NULL MeshComponent);

event AttachAnimations()
{
    local editinline @NULL weaponMesh;
    local float alertWeight;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0xCD
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
        InitSpatialController(mRelaxedAimControllerName, m3PRelaxedAimAsset, 'jt_SpineLower_C', 0.3300000, 1.0000000 - alertWeight, true, true);
        InitSpatialController(mFireControllerName, m3PFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        InitCannedController(mCannedControllerName, 'jt_SpineUpper_C', 1.0000000, 0.0000000);
    }
    //return;    
}

defaultproperties
{
    mZoomMuzzleOffset=(X=0.0000000,Y=0.0000000,Z=-6.7500000)
}