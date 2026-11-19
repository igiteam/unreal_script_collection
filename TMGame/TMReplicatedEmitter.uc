/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMReplicatedEmitter extends TMEmitter
	native
	notplaceable
	abstract;

/** The Template to use for this emitter */
var ParticleSystem EmitterTemplate;

/** How long this actor lives on a dedicated server */
var float ServerLifeSpan;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		LifeSpan = ServerLifeSpan;
	}
	else
	{
		SetTemplate(EmitterTemplate,true);
	}
}

