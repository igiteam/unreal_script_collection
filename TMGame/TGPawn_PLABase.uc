/**
 * Marcus Fenix
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class TGPawn_PLABase extends TGPawn_COGGear
	config(TGPawn);


// marcus is always played IN SP so set his textures to always be resident
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}

simulated function InitHod()
{
	//hod.animTree = '';
	hod.team = 'allies';
	hod.type = 'human';
	hod.accuracy = 0.3;
	hod.health = 150;
	hod.weapon = 'mp5';
	//hod.secondaryweapon = 'usp';
	//hod.sidearm = 'usp';
	hod.grenadeWeapon = 'fraggrenade';
	//hod.grenadeAmmo = 0;

	setEngagementMinDist( 256.000000, 0.000000 );
	setEngagementMaxDist( 768.000000, 1024.000000 );
}

simulated event Destroyed()
{
	CharacterTexturesForceMipsNonResident();

	Super.Destroyed();
}

simulated function ClientRestart()
{
	Super.ClientRestart();

	if( TGPC(Controller) != None )
	{
		// for all human controlled pawns we want to make certain their textures are streamed in
		CharacterTexturesForceMipsResident();
	}
}


simulated function ChainSawGore()
{
}


simulated function PlayKickSound()
{
	//PlaySound(SoundCue'Foley_BodyMoves.BodyMoves.CogLegKick_Cue');
}


