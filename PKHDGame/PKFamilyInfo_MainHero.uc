class PKFamilyInfo_MainHero extends PKFamilyInfoBase;

defaultproperties
{
    CharacterMesh=SkeletalMesh'ch_Daniel.sk_ch_Daniel_01'
    ArmMeshPackageName="wp_all_hands"
    ArmSkinPackageName="wp_all_hands"
    PhysAsset=PhysicsAsset'ch_Daniel_Physics.Physics.sk_ch_Daniel_01_Physics'
    AnimSets[0]=AnimSet'ch_Daniel.Anim.AS_MainHero_Daniel'
    AnimSets[1]=AnimSet'ch_Daniel.Anim.AS_MainHero_Daniel_AimOffsets'
    AnimSets[2]=AnimSet'ch_Daniel.Anim.AS_AimOffsets_Common'
    SoundGroupClass=Class'PKPlayerSoundGroup'
    BaseTranslationOffset=-5.0000000
}