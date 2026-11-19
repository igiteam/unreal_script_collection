/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NDT_TeslaCoil extends NDT_Environment
	abstract;


defaultproperties
{
    ExtraSoundToPlayWhenDamaged=SoundCue'Weapon_Tesla.Stick.Tesla_Shock_StereoCue'
    // Weapon_Tesla.Stick.Tesla_ShockCue // Tesla Stick shocks NPC.

	//Nano_PostProcess.PPMI_Electrical_GenericDamageOverlay
	MI_DamageOverlay=MaterialInterface'Nano_PostProcess.PPMI_ElectricalDamageOverlay'
}


