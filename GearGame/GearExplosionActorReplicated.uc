/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearExplosionActorReplicated extends GearExplosionActor
	notplaceable
	native(Weapon);

/** Should be a serializable object, like in the level or something (as is the case for kismet actions). */
var transient private repnotify GameExplosion					ExploTemplateRef;

/** Which type of projectile explosion we will emulate. */
var transient private repnotify class<GearProj_ExplosiveBase>	ProjExploToEmulate;

replication
{
	if (bNetDirty)
		ExploTemplateRef, ProjExploToEmulate;
}

simulated event ReplicatedEvent(Name VarName)
{
	if (VarName == 'ExploTemplateRef')
	{
		if (GearExplosion(ExploTemplateRef) != None)
		{
			GearExplosion(ExploTemplateRef).InitFromContentTemplate();
		}
		Explode(ExploTemplateRef, ExplosionDirection);
	}
	else if (VarName == 'ProjExploToEmulate')
	{
		EmulateProjectileExplosion(ProjExploToEmulate);
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}

simulated function Explode(GameExplosion NewExplosionTemplate, optional vector ExploDirection)
{
	if (Role == ROLE_Authority)
	{
		ExploTemplateRef = NewExplosionTemplate;
	}

	super.Explode(NewExplosionTemplate, ExploDirection);

	LifeSpan = FMax(LifeSpan, 1.0);
}

/** Special functionality for Kismet. */
simulated function EmulateProjectileExplosion(class<GearProj_ExplosiveBase> ProjToEmulate)
{
	local GearExplosion ExploTemplate;		// hmm, cannot do this...  something for next week

	ExploTemplate = new(self) class'GearExplosion' (ProjToEmulate.default.ExplosionTemplate);

	ProjToEmulate.static.PrepareDefaultExplosionTemplate(ExploTemplate);
	Explode(ExploTemplate);

	ExploTemplateRef = None; // so it doesn't try to replicate the generated template

	if (Role == ROLE_Authority)
	{
		ProjExploToEmulate = ProjToEmulate;
	}
}

defaultproperties
{
	bNetTemporary=true
	bAlwaysRelevant=TRUE
	RemoteRole=ROLE_SimulatedProxy
	bNetInitialRotation=TRUE
}
