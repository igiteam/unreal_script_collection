/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_Rebels_ShopKeeper extends NanoPawn_RebelsBase
	implements( NanoInterface_Interact )
	config(Pawn);


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	AimNodes.length = 0;
}

/////// NanoInterface_Targetable
/** Can't target these guys */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return FALSE;
}
/////// end NanoInterface_Targetable


//////// NanoInterface_PowerAffect
/** Can't dust */
simulated function bool CanBeDusted()
{
	return TRUE;
}
/////// ene NanoInterface_PowerAffect

/** Can't dense */
simulated function bool CanBeDensed()
{
	return TRUE;
}

/////// NanoInterface_Interact

/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return None;
}

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();

/** See if we have a speak event */
simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	local bool bInRange;
	
	bInRange = (VSize(NP.Location - Location) < 128.0);
	
	// If in range and not already showing screen
	return (bInRange && (Type == ENIT_Default) && !NanoInventoryManager(NP.InvManager).bShowUpgradesScreen);
}

/** Get tooltip for interacting */
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';
	return "to Shop";
}

/** Perform the interaction */
simulated function DoInteract(NanoPawn NP, ENanoInteractType Type)
{
	if(Type == ENIT_Default)
	{
		NanoInventoryManager(NP.InvManager).SetFirstAvailItemInList();
		NanoInventoryManager(NP.InvManager).bShowUpgradesScreen = TRUE;
	}
}
/////// End NanoInterface_Interact

defaultproperties
{
	bPawnInvulnerable=TRUE

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'COG_Gus.COG_Gus'
		PhysicsAsset=PhysicsAsset'COG_Gus.COG_Gus_Physics'
		AnimTreeTemplate=None
		Translation=(Z=-88.0)
		Materials(0)=Material'COG_Gus.BasicBlueMat'
	End Object

	Begin Object Name=CollisionCylinder
	    CollideActors=TRUE
		BlockZeroExtent=FALSE
	End Object

	bKillDuringLevelTransition=FALSE

	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=TRUE,DistancesToDrawIcon=(X=0,Y=20000),Icon=Texture2D'UI_HUD.MiniMap.ShopKeeper',IconScale=0.125f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=TRUE,AboveBelowIconScale=0.100f,TextName="",TextDescription="",TextVerticalOffset=0.0f)
	End Object


}