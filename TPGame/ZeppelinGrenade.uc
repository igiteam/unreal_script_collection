class ZeppelinGrenade extends KAsset;
	
simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SkeletalMeshComponent.WakeRigidBody();
}

simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
					const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	//TakeFallingDamage();
	BlowUp();
	Destroy();
}

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
	// kill ourselves
	
	TakeDamage( 500, None, Location, vect(0,0,0), class'DmgType_Fell');
}

function BlowUp()
{
	// Temp for now
	local TankShellSplashZone SZ;
	SZ = Spawn(class'TankShellSplashZone',,,Location, rot(0,0,0));
	SZ.ImpactNearbyObjects();
}

