/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearSpawner_LambentHumanCrawl extends GearSpawner
	placeable;

/** Number of times the crawl anim should be looped before standing up */
var() int NumCrawlLoops;

event HandleSpawn(GearPawn NewSpawn, int SlotIdx)
{
	local GearAI AI;
	local GearPawn_LambentHumanBase LambentHuman;

	super.HandleSpawn( NewSpawn, SlotIdx );

	// Turn off physics. It will get restored by GSM_LambentHuman_Emerge
	NewSpawn.SetPhysics(PHYS_None);
	NewSpawn.SetHidden(true);

	AI = GearAI(NewSpawn.Controller);
	if( AI != None )
	{
		// Play GSM_LambentHuman_Emerge
		AI.DoEmerge(SM_Emerge_Type1);
	}

	LambentHuman = GearPawn_LambentHumanBase(NewSpawn);
	if( LambentHuman != None )
	{
		LambentHuman.NumCrawlLoops = NumCrawlLoops;
	}
}

defaultproperties
{
	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor=(R=150,G=200,B=255)
		ArrowSize=0.5
		bTreatAsASprite=True
		HiddenGame=true
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Arrow)

	bCollideWhenPlacing=true

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0050.000000
		CollisionHeight=+0080.000000
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'GearsIcons.QuickEHoleIcon'
		HiddenGame=TRUE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
		Scale=0.5
	End Object
	Components.Add(Sprite)
	
	bStatic=true
	bHidden=true
	bNoDelete=true
	bMovable=false
}
