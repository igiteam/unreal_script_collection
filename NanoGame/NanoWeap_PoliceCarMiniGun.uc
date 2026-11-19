/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_PoliceCarMiniGun extends NanoWeap_SentryTurret;


var transient NanoPawn_MetaCorp_PoliceCarBase MyPoliceCar;

simulated event PostBeginPlay()
{
	MyPoliceCar = NanoPawn_MetaCorp_PoliceCarBase(Instigator);

	if( MyPoliceCar != None )
	{
		// poliec car's mesh is also the weapon's mesh
		Mesh = MyPoliceCar.Mesh;
		AttachMuzzleEffectsComponents(MyPoliceCar.Mesh);
		AttachMuzzleEffectsComponents_Right(MyPoliceCar.Mesh);
	}

	Super.PostBeginPlay();
}





defaultproperties
{
	WeaponUIName="Police Car MiniGun"

	WeaponFireTypes(0)=EWFT_InstantHit
	InstantHitDamageTypes(0)=class'NDT_PoliceCarMiniGun'


	Spread(0)=0.01

	MuzzleSocketName="Searchlight"
	MuzzleSocketName_Right="Searchlight"

	FireSoundLoop=SoundCue'Weapon_HeavyMiniGun.Gatling.GatlingFireSquadLoopCue'
	FireSound=SoundCue'Weapon_Pistol.Pistol.Pistol_FireEnemy_Cue'
	FireSound_Player=SoundCue'Weapon_Pistol.Pistol.Pistol_FirePlayer_Cue'

	MinTimeBetweenBulletWhips=0.5f
	WeaponWhipSound=SoundCue'Weapon_Shared.Bullet_Whips.Bullet_Whips_Cue'


	CrosshairIcon=Texture2d'Nano_ProtoHUD_Ingame.Crosshairs.MP7'

}
