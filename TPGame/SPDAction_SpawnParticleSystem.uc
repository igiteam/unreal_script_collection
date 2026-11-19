//***********************************************************************
// Class:		SPDAction_SpawnParticleSystem
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDAction_SpawnParticleSystem extends SPDAction_SpawnActor
	editinlinenew
	NotPlaceable;

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction) ParticleSystem	ParticleSystem;
var (SPDAction) bool			DestroyOnFinish;
var (SPDAction) bool			CastShadows;
var (SPDAction) bool			CollideActors;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local Emitter emitter;
	local ParticleSystemComponent psComp;

	emitter = Emitter( CreateActor( manager, actor, DamageInfo ) );
	psComp = emitter.ParticleSystemComponent;
	psComp.SetScale(scale);
	psComp.CastShadow = CastShadows;
	if( emitter != none )
	{
		emitter.SetCollision(CollideActors, false);
		emitter.SetTemplate( ParticleSystem, DestroyOnFinish );
		emitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0f;
		emitter.ParticleSystemComponent.ActivateSystem();

		FindBestSpotForSpawnLocation(emitter);
		/* problem? not needed, life force
		if (SPLifeForceHolder(Actor) != None)
		{
			SPLifeForceHolder(Actor).NotifyParentOfCreation(emitter);
		}	
		*/
	}
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

