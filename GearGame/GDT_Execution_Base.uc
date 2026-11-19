/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_Execution_Base extends GearDamageType;

//var() float PhysicsCameraMomentumScale;

// 
// static function HandleDeathFX(GearPawn DeadPawn)
// {
// 	if (DeadPawn.ControllerBeforeDeath != None && DeadPawn.ControllerBeforeDeath.IsLocalPlayerController())
// 	{
// 		DeadPawn.SetupPhysicsDeathCamera(DeadPawn.TearOffMomentum * default.PhysicsCameraMomentumScale);
// 	}
// }

defaultproperties
{
//	PhysicsCameraMomentumScale=20.f

	KDamageImpulse=1.0
	bForceRagdollDeath=TRUE
	KillGUDEvent=GUDEvent_KilledEnemyExecution
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=30,UL=77,VL=29)  // think this is the curb stomp icon
}

