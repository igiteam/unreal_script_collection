/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Defines an arbitrary point for AI to emerge from
 */
class GearSpawner_SpecialSpawnPoint extends GearSpawner
	DependsOn(GearPawn)
	placeable;

enum ESpecialEmergeType
{
	SpecEmergeType_Emerge,
	SpecEmergeType_Emerge_Burst,
	SpecEmergeType_Emerge_QuickJump,
	SpecEmergeType_Emerge_Pod,
	SpecEmergeType_Emerge_PodJump,
};
var() ESpecialEmergeType EmergeType; 

event HandleSpawn(GearPawn NewSpawn, int SlotIdx)
{
	local GearAI AI;

	super.HandleSpawn( NewSpawn, SlotIdx );

	AI = GearAI(NewSpawn.Controller);
	if( AI != None )
	{
		switch( EmergeType )
		{
			case SpecEmergeType_Emerge:
				AI.DoEmerge(SM_Emerge_Type1);
				break;
			case SpecEmergeType_Emerge_Burst:
				AI.DoEmerge(SM_Emerge_Type2);
				break;
			case SpecEmergeType_Emerge_QuickJump:
				AI.DoEmerge(SM_Emerge_Type3);
				break;
			case SpecEmergeType_Emerge_Pod:
				AI.DoEmerge(SM_Emerge_Pod);
				break;
			case SpecEmergeType_Emerge_PodJump:
				AI.DoEmerge(SM_Emerge_PodJump);
				break;
		}
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

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Note'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)
	
	bHidden=true
	bNoDelete=true
	bStatic=FALSE
	bMovable=TRUE
}
