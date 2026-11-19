/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class ActorFactoryNanoMissionGiver extends ActorFactory
	native(AI);

/** Class of pawn to spawn */
var()   class<NanoPawn_Rebels_QuestGiverBase>   PawnClass;

/** Distance from the mission giver at which the pawn will be forced to put away their weapons and walk */
var()   float PawnDisarmRadius;

/** Distance the pawn can travel away from the mission giver before they get reset */
var()   float PawnResetDistance;
/** Distance in front of this pawn to reset the player too when they stray too far */
var()   float ResetPawnOffset;
/** Camera that the pawn should view from when reseting the pawn */
var()   CameraAnim PawnResetCameraAnim;

/** Whether or not this way point is interactable during chaos. **/
var() bool bInteractableDuringChaos;


/** Sprite above head for showing ready to be talked to */
var()   Texture2D       ExclamationSpriteTex;
var()   Texture2D       QuestionSpriteTex;


cpptext
{
	virtual AActor* CreateActor( const FVector* const Location, const FRotator* const Rotation, const class USeqAct_ActorFactory* const ActorFactoryData );

	virtual AActor* GetDefaultActor();
};

defaultproperties
{
	bPlaceable=FALSE
	bInteractableDuringChaos=FALSE

	ExclamationSpriteTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_Exclamation'
	QuestionSpriteTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_Question'

	PawnResetCameraAnim=CameraAnim'Nano_Proto_Camera_Animations.MissionBriefingTest01'
	PawnDisarmRadius=768.f
	PawnResetDistance=768.f
	ResetPawnOffset=64.f
}