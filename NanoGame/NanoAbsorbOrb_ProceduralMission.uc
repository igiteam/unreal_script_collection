/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAbsorbOrb_ProceduralMission extends NanoAbsorbOrb;



simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	if(InteractableComp.BeingAbsorbedBy != None)
	{
		return "Dealing with Proc Mission";
	}

	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';

	if(InteractableComp.bCanAbsorb)
	{
		return "to complete Proc Mission";
	}
	else
	{
		return "Cannot interact";
	}	

}

simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	// If too far, or already gone - can't interact
	if(InteractableComp.bHasBeenAbsorbed || VSize(NP.Location - Location) > InteractableComp.InteractDistance)
	{
		return FALSE;
	}


	return TRUE;
}


simulated function DoDestroy()
{
	local NanoCausingChaosValueDatum Chaos;
	local int Amount;

	Super.DoDestroy();

	Amount = 100;

	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;

	Chaos.ChaosDesc = "Proc Mission";

	NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().ModifyChaosLevel( NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn, Chaos );
}




defaultproperties
{
	Begin Object Name=InteractableComponent0
		AbsorbTime=10.0f
		DelayDestructionOfInteractionObjectByTime=0.1f
	End Object


	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,Icon=Texture2D'UI_HUD.Minimap.MissionProc',IconScale=0.05f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=1)
	End Object


}

