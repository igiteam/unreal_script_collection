//===============================================================================
//  [WeapHEGrenade]  
//===============================================================================

#exec ANIM IMPORT ANIM=GrenadeAnims ANIMFILE=..\Animations\PSA\pv_grenade_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=GrenadeAnims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=GrenadeAnims SEQ=shoot_throw FRAME=3.0 FUNCTION=SpawnProjectile

#exec ANIM IMPORT ANIM=GrenadeWeapAnims ANIMFILE=..\Animations\PSA\pv_grenade_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=GrenadeWeapAnims USERAWINFO VERBOSE

class WeapHEGrenade extends ABSTRACT_WeapGrenade;

/*
function PreBeginPlay()
{
	ThirdPersonStaticMesh = StaticMesh(DynamicLoadObject("CBS_DYN_Weapon.ThirdPerson.hh_hegrenade", class'StaticMesh'));
}
*/
/*
function Reskin(Material Skin0, Material Skin1)
{
	ReskinWeapon(Skin1, Skin0); 
}
*/

// Decompiled with UE Explorer.
defaultproperties
{
    xSingleFireThrow="shoot_throw"
    PinPullSound=Sound'CBW_DYN_weapons.Grenade.grenade_pin'
    ThrowSound=Sound'CBW_DYN_weapons.Grenade.grenade_fire'
    xNoHandsAnim="nohands_pose"
    PVMeshName="CBA_PV_Weapons.pv_hands"
    bIsSingleShot=true
    HandsSkinIndex=1
    xSubtleIdle="Idle"
    xNonSubtleIdle="Idle"
    xSingleFire="shoot_pull"
    xReloadAnim="Reload"
    xHolsterAnim="holster"
    xSelectAnim="load"
    DEBUG_WeapAttachment=true
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.pv_grenade"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    UseAttachAnims=true
    AttachFireAnim="shoot_pull"
    AttachReloadAnim="load"
    WeapAnimSet="Weapons.GrenadeAnims"
    WeapAttachAnimSet="Weapons.GrenadeWeapAnims"
    WeapAttTexName="CBT_DYN_Weapons.Grenade.pv_grenade"
    hudProps=(WeaponIconIdx=17,AmmoIconIdx=35,ItemsPerTex=1)
    ReloadSound=Sound'CBW_DYN_weapons.Grenade.grenade_select'
    AmmoName=Class'HEGrenadeAmmo'
    PickupAmmoCount=1
    InventoryGroup=111
    PickupClass=Class'PickupHEGrenade'
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_hegrenade'
    ThirdPersonScale=0.7000000
    ThirdPersonRelativeLocation=(X=12.0000000,Y=-5.0000000,Z=-5.0000000)
    ThirdPersonRelativeRotation=(Pitch=0,Yaw=-16353,Roll=0)
    AttachmentClass=Class'HEGrenadeAttach'
    ItemName="HE Grenade"
}