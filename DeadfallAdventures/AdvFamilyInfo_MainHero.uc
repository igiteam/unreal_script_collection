class AdvFamilyInfo_MainHero extends EvilFamilyInfoBase;

var() SkeletalMesh TorsoMesh;

defaultproperties
{
    FamilyID="LIAM"
    Faction="Liandri"
    CharacterMesh=SkeletalMesh'ch_Quatermain_001.Mesh.sk_ch_Quatermain_Multiplayer_01'
    ArmMeshPackageName="wp_all_hands"
    ArmMesh=SkeletalMesh'wp_all_hands.Mesh.sk_wp_all_hands_02'
    ArmSkinPackageName="wp_all_hands"
    PhysAsset=PhysicsAsset'ch_nazi_soldier_01_Physics.Physics.sk_ch_nazi_soldier_01_Physics2'
    AnimSets[0]=AnimSet'an_MainHero.AS_MainHero_01'
    AnimSets[1]=AnimSet'an_MainHero.Anims.AS_MainHero_AimOffsets'
    AnimSets[2]=AnimSet'an_MainHero.AS_MainHero_PST'
    AnimSets[3]=AnimSet'an_Common.AS_AimOffsets'
    AnimSets[4]=AnimSet'an_Common.AS_Character_Death'
    AnimSets[5]=AnimSet'an_marshall.Anim.an_Marshall_01'
    SoundGroupClass=Class'EvilGame.EvilPlayerSoundGroup'
    BaseTranslationOffset=-10.0000000
}