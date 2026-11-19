class TurokWeapAttachRpgNative extends TurokWeaponAttachment
    native
    config(Weapon);

var(Animations) name m3PRocketEquipAnim;
var(Animations) name m3PRocketUnEquipAnim;
var export editinline @NULL m3PRocketMesh;
var private bool mbRocket;
var(Sound) @NULL mLockAcquiredSndCue;

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

// Export UTurokWeapAttachRpgNative::execSetAttachmentMeshVisibility(FFrame&, void* const)
native function SetAttachmentMeshVisibility(bool bIs3rdPerson, bool bVisibleIn3rdPerson);

private final simulated function Show3PRocket()
{
    local name RocketBoneName;

    m3PRocketMesh.SetHidden(false);
    m3PRocketMesh.SetOwnerNoSee(SkeletalMeshComponent(mAttachMesh).bOwnerNoSee);
    m3PRocketMesh.SetLightEnvironment(mAttachMesh.LightEnvironment);
    RocketBoneName = class<TurokWeapRpgNative>(WeaponClass).default.mRocketBoneName;
    SkeletalMeshComponent(mAttachMesh).AttachComponent(m3PRocketMesh, RocketBoneName);
    mbRocket = true;
    mFireMode3PFxOverride = 1;
    //return;    
}

private final simulated function Hide3PRocket()
{
    m3PRocketMesh.SetHidden(true);
    m3PRocketMesh.SetOwnerNoSee(SkeletalMeshComponent(mAttachMesh).bOwnerNoSee);
    m3PRocketMesh.SetLightEnvironment(none);
    SkeletalMeshComponent(mAttachMesh).DetachComponent(m3PRocketMesh);
    mbRocket = false;
    mFireMode3PFxOverride = -1;
    //return;    
}

simulated function OnReplicatedStateChanged(int State)
{
    // End:0x18
    if((State & (1 << 7)) > 0)
    {
        Show3PRocket();
    }
    // End:0x30
    if((State & (1 << 8)) > 0)
    {
        Hide3PRocket();
    }
    super.OnReplicatedStateChanged(State);
    //return;    
}
