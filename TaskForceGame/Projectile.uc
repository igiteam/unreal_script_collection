//=============================================================================
// Projectile.
//
// A delayed-hit projectile that moves around for some time after it is created.
//=============================================================================
class Projectile extends Actor
	abstract
	native;

//-----------------------------------------------------------------------------
// Projectile variables.

// Motion information.
var		float   Speed;               // Initial speed of projectile.
var		float   MaxSpeed;            // Limit on speed of projectile (0 means no limit)
var		float	TossZ;
var		bool	bSwitchToZeroCollision; // if collisionextent nonzero, and hit actor with bBlockNonZeroExtents=0, switch to zero extent collision

// Damage attributes.
var   float    Damage; 
var   float    BotDamage; // Amount of damage done if this is launched by a bot (not the player)
var	  float	   DamageRadius;        
var	  float	   InnerDamageRadius;  // Damage not blocked by obstacles within this radius
var	  float	   FringeDamageRadius; // Damage is at minimal value (e.g. 1.0) between DamageRadius and FringeDamageRadius
var   float	   MomentumTransfer; // Momentum magnitude imparted by impacting projectile.
var   class<DamageType>	   MyDamageType;

// Projectile sound effects
var   sound    SpawnSound;		// Sound made when projectile is spawned.
var   sound	   ImpactSound;		// Sound made when projectile hits something.

// explosion effects
var   class<Projector> ExplosionDecal;
var   float		ExploWallOut;	// distance to move explosions out from wall

var   controller InstigatorController;  // controller of damage instigator (should be set by code if projectile might explode after instigator dies)


//==============
// Encroachment
function bool EncroachingOn( actor Other )
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
		return true;
		
	return false;
}

//==============
// Touching
simulated singular function Touch(Actor Other)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, VelDir;
	local bool bBeyondOther;
	local float BackDist, DirZ;

	if ( Other == None ) // Other just got destroyed in its touch?
		return;
	if ( Other.bProjTarget || (Other.bBlockActors && Other.bBlockPlayers) )
	{
		if ( Velocity == vect(0,0,0) || Other.IsA('Mover') ) 
		{
			ProcessTouch(Other,Location);
			return;
		}
		
		//get exact hitlocation - trace back along velocity vector
		bBeyondOther = ( (Velocity Dot (Location - Other.Location)) > 0 );
		VelDir = Normal(Velocity);
		DirZ = sqrt(abs(VelDir.Z));
		BackDist = Other.CollisionRadius * (1 - DirZ) + Other.CollisionHeight * DirZ;
		if ( bBeyondOther )
			BackDist += VSize(Location - Other.Location);
		else
			BackDist -= VSize(Location - Other.Location);

	 	HitActor = Trace(HitLocation, HitNormal, Location, Location - 1.1 * BackDist * VelDir, true);
		if (HitActor == Other)
			ProcessTouch(Other, HitLocation); 
		else if ( bBeyondOther )
			ProcessTouch(Other, Other.Location - Other.CollisionRadius * VelDir);
		else
			ProcessTouch(Other, Location);
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
		Explode(HitLocation,Normal(HitLocation-Other.Location));
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	if ( Role == ROLE_Authority )
	{
		if ( Mover(Wall) != None )
			Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);

		//MakeNoise(1.0);
	}
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
}

simulated function BlowUp(vector HitLocation)
{
	HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation, InnerDamageRadius, FringeDamageRadius, InstigatorController );
	if ( Role == ROLE_Authority )
		MakeNoise(2.5);
}

simulated event Explode(vector HitLocation, vector HitNormal)
{
//	Destroy();
	GotoState('Destroying');  // MAT 7/1/04
}

// MAT: added state Destroying 7/1/04
simulated state Destroying
{
	ignores HitWall, Explode;
Begin:
//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  Projectile.Destroying.Begin ");
	if( Role == ROLE_Authority && Level.NetMode != NM_Standalone )
		Sleep(0.05);
	Destroy();
}

simulated final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}

static function vector GetTossVelocity(Pawn P, Rotator R)
{
	local vector V;

	V = Vector(R);
	V *= ((P.Velocity Dot V)*0.4 + Default.Speed);
	V.Z += Default.TossZ;
	return V;
}
function Sound GetProjectileFireSound();

// Decompiled with UE Explorer.
defaultproperties
{
    MaxSpeed=2000.0000000
    TossZ=100.0000000
    DamageRadius=220.0000000
    MyDamageType=Class'DamageType'
    Physics=6
    DrawType=2
    bAcceptsProjectors=false
    bNetTemporary=true
    bReplicateInstigator=true
    bNetInitialRotation=true
    RemoteRole=2
    NetPriority=2.5000000
    LifeSpan=14.0000000
    Texture=Texture'S_Camera'
    bUnlit=true
    bGameRelevant=true
    bDisturbFluidSurface=true
    SoundVolume=0
    CollisionRadius=0.0000000
    CollisionHeight=0.0000000
    bCollideActors=true
    bCollideWorld=true
    bCollideSkeletalBoxes=true
    bUseCylinderCollision=true
}