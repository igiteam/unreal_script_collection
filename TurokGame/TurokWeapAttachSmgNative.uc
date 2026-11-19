class TurokWeapAttachSmgNative extends TurokWeapAttachDualWield
    native
    config(WeapSmg);

var(Animations) name m3PSilencerEquipAnim;
var(Animations) name m3PSilencerUnEquipAnim;
var(Animations) name m3PSilencerEquipAnimDW;
var(Animations) name m3PSilencerUnEquipAnimDW;
var export editinline @NULL m3PSilencerMesh;
var private bool mbSilenced;
var config float mUnSilencedFiredNoiseLevel;
var config float mUnSilencedImpactNoiseLevel;
var config float mSilencedFiredNoiseLevel;
var config float mSilencedImpactNoiseLevel;

// Export UTurokWeapAttachSmgNative::execSetAttachmentMeshVisibility(FFrame&, void* const)
native function SetAttachmentMeshVisibility(bool bIs3rdPerson, bool bVisibleIn3rdPerson);

simulated function SMGAttachmentSetSilencerVisibility(bool visible)
{
    // End:0x16
    if(visible)
    {
        Show3PSilencer();        
    }
    else
    {
        Hide3PSilencer();
    }
    //return;    
}

simulated function Show3PSilencer()
{
    local name silencerBoneName;

    m3PSilencerMesh.SetHidden(false);
    m3PSilencerMesh.SetOwnerNoSee(SkeletalMeshComponent(mAttachMesh).bOwnerNoSee);
    m3PSilencerMesh.SetLightEnvironment(mAttachMesh.LightEnvironment);
    silencerBoneName = class<TurokWeapSmgNative>(WeaponClass).default.mSilencerBoneName;
    SkeletalMeshComponent(mAttachMesh).AttachComponent(m3PSilencerMesh, silencerBoneName);
    mbSilenced = true;
    mbHasTracers = false;
    mFireMode3PFxOverride = 1;
    //return;    
}

simulated function Hide3PSilencer()
{
    m3PSilencerMesh.SetHidden(true);
    m3PSilencerMesh.SetOwnerNoSee(SkeletalMeshComponent(mAttachMesh).bOwnerNoSee);
    m3PSilencerMesh.SetLightEnvironment(none);
    SkeletalMeshComponent(mAttachMesh).DetachComponent(m3PSilencerMesh);
    mbSilenced = false;
    mbHasTracers = true;
    mFireMode3PFxOverride = -1;
    //return;    
}

simulated function SMGAttachmentThirdPersonDoEquipSilencer(bool equip)
{
    // End:0x16
    if(equip)
    {
        ThirdPersonDoEquipSilencer();        
    }
    else
    {
        ThirdPersonDoUnEquipSilencer();
    }
    //return;    
}

simulated function ThirdPersonDoEquipSilencer()
{
    local float equipSilencerTime;
    local name equipAnim, NodeName;

    mbSilenced = true;
    // End:0x1F
    if(mbIsDualWielded)
    {
        equipAnim = m3PSilencerEquipAnimDW;        
    }
    else
    {
        equipAnim = m3PSilencerEquipAnim;
    }
    NodeName = mCannedControllerName;
    // End:0x50
    if(int(mEquippedInHand) == int(1))
    {
        NodeName = mCannedControllerLeftName;
    }
    equipSilencerTime = class<TurokWeapSmgNative>(WeaponClass).default.mEnableSilencerTime;
    Play3PCannedAnimation(NodeName, equipAnim, equipSilencerTime, equipSilencerTime * 0.1000000, equipSilencerTime * 0.1000000, false);
    //return;    
}

simulated function ThirdPersonDoUnEquipSilencer()
{
    local float unequipSilencerTime;
    local name unequipAnim, NodeName;

    mbSilenced = false;
    // End:0x1F
    if(mbIsDualWielded)
    {
        unequipAnim = m3PSilencerUnEquipAnimDW;        
    }
    else
    {
        unequipAnim = m3PSilencerUnEquipAnim;
    }
    NodeName = mCannedControllerName;
    // End:0x50
    if(int(mEquippedInHand) == int(1))
    {
        NodeName = mCannedControllerLeftName;
    }
    unequipSilencerTime = class<TurokWeapSmgNative>(WeaponClass).default.mDisableSilencerTime;
    Play3PCannedAnimation(NodeName, unequipAnim, unequipSilencerTime, unequipSilencerTime * 0.1000000, unequipSilencerTime * 0.1000000, false);
    //return;    
}

// Export UTurokWeapAttachSmgNative::execPlayFiringSound(FFrame&, void* const)
native function PlayFiringSound(byte FireModeNum);

simulated function SetNoiseLevel(bool silenced)
{
    // End:0x40
    if(silenced)
    {
        mFiredNoiseLevel[0] = mSilencedFiredNoiseLevel;
        mImpactNoiseLevel[0] = mSilencedImpactNoiseLevel;
        mFiredNoiseLevel[1] = mSilencedFiredNoiseLevel;
        mImpactNoiseLevel[1] = mSilencedImpactNoiseLevel;        
    }
    else
    {
        mFiredNoiseLevel[0] = mUnSilencedFiredNoiseLevel;
        mImpactNoiseLevel[0] = mUnSilencedImpactNoiseLevel;
        mFiredNoiseLevel[1] = mUnSilencedFiredNoiseLevel;
        mImpactNoiseLevel[1] = mUnSilencedImpactNoiseLevel;
    }
    //return;    
}

simulated function OnReplicatedStateChanged(int State)
{
    // End:0x1C
    if((State & (1 << 5)) > 0)
    {
        ThirdPersonDoEquipSilencer();
    }
    // End:0x38
    if((State & (1 << 6)) > 0)
    {
        ThirdPersonDoUnEquipSilencer();
    }
    // End:0x54
    if((State & (1 << 7)) > 0)
    {
        Show3PSilencer();
    }
    // End:0x70
    if((State & (1 << 8)) > 0)
    {
        Hide3PSilencer();
    }
    super(TurokWeaponAttachment).OnReplicatedStateChanged(State);
    //return;    
}
