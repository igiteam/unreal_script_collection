/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_RiotCop_Agent_Dragos extends NanoPawn_MetaCorp_RiotCop_Agent;


	event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// no damage
	Super.TakeDamage(0,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}

/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.DragosKilled;
}


defaultproperties
{
	Begin Object Name=NanoPawnMesh
		Materials(0)=MaterialInstanceConstant'MET_ShockTrooper.M_ShieldTrooper_Body_Dragos'
		Scale=1.6f
	End Object


	Begin Object Name=UIIconComponent0
	    MiniMap=(Icon=Texture2D'UI_HUD.Minimap.EnemyBoss',bAlternateAboveBelowIcon=TRUE,IconScale=0.1f,AboveBelowIconScale=0.08f)
	End Object
	UIComponent=UIIconComponent0
}