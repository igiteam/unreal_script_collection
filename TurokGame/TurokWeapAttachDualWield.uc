class TurokWeapAttachDualWield extends TurokWeaponAttachment
    native
    config(Weapon);

var(Animations) array mDualLeftWeaponAnimSets;
var(Animations) @NULL m3PDualRightAimAsset;
var(Animations) @NULL m3PDualRightFireAsset;
var(Animations) @NULL m3PDualLeftAimAsset;
var(Animations) @NULL m3PDualLeftFireAsset;
var(Animations) name m3PDualReloadAnim;
var(Animations) name m3PDualPutDownAnim;
var(Animations) name m3PDualEquipAnim;
var protected name mEquipBoneLeftName;
var protected name mFireControllerLeftName;
var protected name mAimControllerLeftName;
var protected name mCannedControllerLeftName;

event AttachAnimations()
{
    local editinline @NULL weaponMesh;

    // End:0x10F
    if(mbIsDualWielded)
    {
        weaponMesh = SkeletalMeshComponent(mAttachMesh);
        // End:0x90
        if(int(mEquippedInHand) == int(0))
        {
            weaponMesh.AnimSets = mWeaponAnimSets;
            InitBaseSpatialController(m3PDualRightAimAsset, true, true);
            InitSpatialController(mFireControllerName, m3PDualRightFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
            InitCannedController(mCannedControllerName, 'jt_SpineUpper_C', 1.0000000, 0.0000000);            
        }
        else
        {
            weaponMesh.AnimSets = mDualLeftWeaponAnimSets;
            InitSpatialController(mAimControllerLeftName, m3PDualLeftAimAsset, 'jt_Clavicle_L', 1.0000000, 1.0000000, true, true);
            InitSpatialController(mFireControllerLeftName, m3PDualLeftFireAsset, 'jt_Clavicle_L', 1.0000000, 0.0000000, false, true);
            InitCannedController(mCannedControllerLeftName, 'jt_Clavicle_L', 1.0000000, 0.0000000);
        }        
    }
    else
    {
        super.AttachAnimations();
    }
    //return;    
}

simulated event bool AttachMesh(@NULL OwnerMesh)
{
    // End:0x24
    if(int(mEquippedInHand) == int(0))
    {
        return Attach3rdPersonWeapon(mEquipBoneName, OwnerMesh);        
    }
    else
    {
        return Attach3rdPersonWeapon(mEquipBoneLeftName, OwnerMesh);
    }
    //return ReturnValue;    
}

// Export UTurokWeapAttachDualWield::execPlaySpatialFireAnim(FFrame&, void* const)
native function PlaySpatialFireAnim(int FireMode, float fireTime);

simulated event ThirdPersonDoEquip()
{
    local float EquipTime;

    // End:0x10
    if(SkipThirdPersonDoEquip())
    {
        return;
    }
    EquipTime = WeaponClass.default.EquipTime;
    // End:0x91
    if(mbIsDualWielded)
    {
        // End:0x67
        if(int(mEquippedInHand) == int(0))
        {
            Play3PCannedAnimation(mCannedControllerName, m3PDualEquipAnim, EquipTime, 0.0000000, EquipTime * 0.1000000, false);            
        }
        else
        {
            Play3PCannedAnimation(mCannedControllerLeftName, m3PDualEquipAnim, EquipTime, 0.0000000, EquipTime * 0.1000000, false);
        }        
    }
    else
    {
        Play3PCannedAnimation(mCannedControllerName, m3PEquipAnim, EquipTime, 0.0000000, EquipTime * 0.1000000, false);
    }
    PlayLimitedWeaponSound(mEquipSndCue, false);
    //return;    
}

simulated function ThirdPersonDoReload()
{
    local float ReloadTime;

    ReloadTime = WeaponClass.default.mReloadStartTime;
    // End:0x81
    if(mbIsDualWielded)
    {
        // End:0x57
        if(int(mEquippedInHand) == int(0))
        {
            Play3PCannedAnimation(mCannedControllerName, m3PDualReloadAnim, ReloadTime, ReloadTime * 0.1000000, 0.0000000, false);            
        }
        else
        {
            Play3PCannedAnimation(mCannedControllerLeftName, m3PDualReloadAnim, ReloadTime, ReloadTime * 0.1000000, 0.0000000, false);
        }        
    }
    else
    {
        Play3PCannedAnimation(mCannedControllerName, m3PReloadAnim, ReloadTime, ReloadTime * 0.1000000, ReloadTime * 0.1000000, false);
    }
    //return;    
}

defaultproperties
{
    mEquipBoneLeftName="jt_Wrist_L"
    mFireControllerLeftName="FIRECONTROLLERLEFT"
    mAimControllerLeftName="AIMCONTROLLERLEFT"
    mCannedControllerLeftName="CANNEDCONTROLLERLEFT"
}