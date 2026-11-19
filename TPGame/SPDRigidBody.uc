//***********************************************************************
// Class:		SPDRigidBody
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDRigidBody extends KynapseKActor
	native
	placeable;

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************


var(DestructComponent) const editconst SPActorDestructComponent	DestructComponent;
var	DrawSphereComponent	RenderComponent;
var	DrawSphereComponent	PreviewSphere;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event Landed(vector HitNormal, Actor FloorActor)
{
	TakeFallingDamage();
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function TakeFallingDamage()
{
	local int damage;

	// kill ourselves
	damage = DestructComponent.SpeedToDamage( Velocity.Z );
	if (damage > 0)
		TakeDamage( damage, None, Location, vect(0,0,0), class'DmgType_Fell');
}

// Override DynamicSMActor behavior
simulated function bool CanBasePawn( Pawn P )
{
    return TRUE;
}

// Override DynamicSMActor behavior
function Attach( Actor Other )
{
    // Do nothing
}

// Override DynamicSMActor behavior
function Detach( Actor Other )
{
    // Do nothing
}



/* problem? not needed, Pandora specific
event bool UsedBy(Pawn User, optional bool bInquiry)
{
	if ( User.IsA('PlayerPawn') && PandoraPlayerController(User.Controller) != None )
	{
		// This player is trying to pickup this object
		return PandoraPlayerController(User.Controller).AttemptPickup(self,bInquiry);
	}
}
*/

//***********************************************************************
// Default Properties
//***********************************************************************

