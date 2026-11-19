class TurokWeapAttachRocketTurretNative extends TurokWeaponAttachment
    native
    config(Weapon);

var(Animations) name m3PRocketEquipAnim;
var(Animations) name m3PRocketUnEquipAnim;
var export editinline @NULL m3PRocketMesh;
var private bool mbRocket;
var(Sound) @NULL mLockAcquiredSndCue;

simulated event AttachAnimations()
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
        InitSpatialController(mRelaxedAimControllerName, m3PRelaxedAimAsset, 'None', 1.0000000, 1.0000000 - alertWeight, true, true);
        InitSpatialController(mFireControllerName, m3PFireAsset, 'None', 1.0000000, 0.0000000, false, true);
        InitSpatialController(mAltFireControllerName, m3PAltFireAsset, 'None', 1.0000000, 0.0000000, false, true);
        InitCannedController(mCannedControllerName, 'None', 1.0000000, 0.0000000);
    }
    //return;    
}

simulated function RPGAttachmentThirdPersonDoRocketVisible(bool bVisible)
{
    // End:0x12
    if(bVisible)
    {
        Show3PRocket();        
    }
    else
    {
        Hide3PRocket();
    }
    //return;    
}

// Export UTurokWeapAttachRocketTurretNative::execSetAttachmentMeshVisibility(FFrame&, void* const)
native function SetAttachmentMeshVisibility(bool bIs3rdPerson, bool bVisibleIn3rdPerson);

private final simulated function Hide3PRocket()
{
    //return;    
}

private final simulated function Show3PRocket()
{
    //return;    
}
