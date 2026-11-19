/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class NanoVehicleSpline_TrafficLightBase extends NanoVehicleSpline
	implements( NanoInterface_Interact )
	native(Inherit)
	placeable
	abstract;
	
/** Static mesh of floating traffic light */	
var()   StaticMeshComponent         TrafficLightMesh;
/** Material instance use to turn lights on and off */
var     MaterialInstanceConstant    TrafficLightMatInst;

/** When a light changes color we play a spiffy sound **/
var SoundCue LightChangingColors;


/** Particles for the Absorb effects **/
var ParticleSystem PS_AbsorbBeam;
var transient ParticleSystemComponent PSC_AbsorbBeam;
var name AbsorbEffectsSocketName;


/** The sound played when the light is hacked **/
var SoundCue LightHackedSound;

/** When a light has been hacked this will play after a bit to alert the player that they are indeed being monitored. **/
var SoundCue TrafficSignalHasBeenHackedSound;


/** The pawn who hacked this light. **/
var transient NanoPawn PawnWhoHackedThisLight;

/** Whether or not this traffic light should spawn a perch point **/
var() bool bSpawnPerchPoint;

/** The perch point that this traffic light owns **/
var protected NanoPerchPoint TrafficPerchPoint;

/** Whether or not we should show a traffic light mesh.  (LDs use these in places where they don't want to have a mesh) **/
var() bool bShowTrafficLightMesh;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	// create matinst
	TrafficLightMatInst = TrafficLightMesh.CreateAndSetMaterialInstanceConstant(1);
	UpdateMatInst();


	if( bShowTrafficLightMesh == TRUE )
	{
		CreatePerchPoint();
	}
	// remove the traffic mesh
	else
	{
		CollisionComponent = none;
		DetachComponent( TrafficLightMesh );
	}
}


/** This will create a perch point on the traffic light mesh. **/
simulated function CreatePerchPoint()
{
	local Vector PerchLoc;

	// bail out if we are not spawning a perch point here
	if( bSpawnPerchPoint == FALSE )
	{
		return;
	}


	PerchLoc = TrafficLightMesh.GetPosition() + vect(0,0,164);

	TrafficPerchPoint = Spawn( class'NanoPerchPoint_Spawnable', self,, PerchLoc );
	TrafficPerchPoint.SetBase( self );
}

/** Adding support for toggling to save the LD's some time */
simulated function OnToggle(SeqAct_Toggle Action)
{
	Super.OnToggle(Action);	

	UpdateMatInst();
}

/** Update material instance on the light mesh to match the current  */
simulated function UpdateMatInst()
{
	PlaySound( LightChangingColors );

	if(CurrentState == ETLS_Red)
	{
		TrafficLightMatInst.SetScalarParameterValue('RedLight', 1.0);
		TrafficLightMatInst.SetScalarParameterValue('GreenLight', 0.0);
	}
	else if(CurrentState == ETLS_Green)
	{
		TrafficLightMatInst.SetScalarParameterValue('RedLight', 0.0);
		TrafficLightMatInst.SetScalarParameterValue('GreenLight', 1.0);
	}
}


/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return None;
}

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();


/** See if this object can be interacted with by this Pawn */
simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	if( ( CurrentState == ETLS_Red ) && ( bShowTrafficLightMesh == TRUE ) )
	{
		return TRUE;
	}

	return FALSE;
}


/** Get tooltip for interacting */
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';
	return "to turn light green";
}


/** Perform the interaction */
simulated function DoInteract(NanoPawn NPP, ENanoInteractType Type)
{
	// we just do one on and one off  no need to hold for a time
	if( Type == ENIT_AbsorbEnd )
	{
		return;
	}

	PawnWhoHackedThisLight = NPP;

	CurrentState = ETLS_Green;	
	UpdateMatInst();

	PSC_AbsorbBeam = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_AbsorbBeam, NPP.Mesh, AbsorbEffectsSocketName, TRUE );
	PSC_AbsorbBeam.SetActorParameter( 'Endpoint', TrafficPerchPoint != none ? TrafficPerchPoint : self );  // the perch point is on the traffic light mesh so it works out pretty close to the location we want the beam end to be (probably need to spawn another actor here)

	PlaySound( LightHackedSound );

	SetTimer( 2.0f, FALSE, nameof(TurnOffBeam) );
	SetTimer( 2.0f, FALSE, nameof(PlayLightHasBeenHackedWarning) );
}


simulated protected function TurnOffBeam()
{
	PSC_AbsorbBeam.DeactivateSystem();
	PSC_AbsorbBeam = none;
}


simulated protected function PlayLightHasBeenHackedWarning()
{
	PawnWhoHackedThisLight.PlaySound( TrafficSignalHasBeenHackedSound );
}



defaultproperties
{
}