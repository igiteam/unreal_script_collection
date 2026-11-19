/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_JackLaser extends GDT_Ballistic
	abstract;

var ParticleSystem ElectricityEffect;

static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	local GearPawn VictimGP;

	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);

	// If this is a GearPawn and it can cringe, do so and only apply 1 damage (so effects are played)
	VictimGP = GearPawn(Victim);
	if( VictimGP != None && VictimGP.SpecialMoveClasses.length > SM_CoverHead && VictimGP.SpecialMoveClasses[SM_CoverHead] != None )
	{
		VictimGP.Cringe();
		Damage = 1;
	}
}

static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local rotator RelRotation;

	Super.HandleDamageFX(DamagedPawn, HitInfo);

	RelRotation = MakeRotator(16384, 0, 0);

	DamagedPawn.AttachDamageFX(default.ElectricityEffect, DamagedPawn.RightFootBoneName, 1.0,,RelRotation);
	DamagedPawn.AttachDamageFX(default.ElectricityEffect, DamagedPawn.LeftFootBoneName, 1.0,,RelRotation);
	DamagedPawn.AttachDamageFX(default.ElectricityEffect, DamagedPawn.RightKneeBoneName, 1.0,,RelRotation);
	DamagedPawn.AttachDamageFX(default.ElectricityEffect, DamagedPawn.LeftKneeBoneName, 1.0,,RelRotation);
	DamagedPawn.AttachDamageFX(default.ElectricityEffect, 'b_MF_ForeTwist2_L', 1.0,,RelRotation);
	DamagedPawn.AttachDamageFX(default.ElectricityEffect, 'b_MF_ForeTwist2_R', 1.0,,RelRotation);
}

defaultproperties
{
	ElectricityEffect=ParticleSystem'Locust_Serapede.Effects.P_Player_Zap'
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=120,UL=77,VL=29)
}
