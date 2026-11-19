//=============================================================================
// ZombieKActor.
//
// Class extended from KActor to added timeout, damage and destructible, 
// functionality to Karma Actors.
//=============================================================================

class ZombieKActor extends KActor
	placeable;

// Destructible vars
struct DestructibleStruct {
	var() bool				bDestructible;
	var() staticmesh			DestroyedMesh;
	var() sound				DestroyedSound;
	var() class<DamageType> 		DamageType;
	var() float 				DamageRadius;
	var() int 				CausedDamageAmount;
	var() int 				MomentumTransfer;
	var() int 				HitPoints;
	var() float				ConstraintRatio;
	var() bool				bApplyLocalImpulse;
};

struct DestructibleEffectsStruct {
	var() class<emitter>			EmitterClass;
	var() vector				EmitterOffset;
};

var() DestructibleStruct			Destructible;
var() array<DestructibleEffectsStruct>		DestructibleEffects;

var()	bool			bRecycle;
var()	float			RecycleDelay;

var() class<DamageType>		ImpactDamageType;
var() float			ImpactDamageAmount;

var bool			bActive;
var bool			bIsDestroyed;

var array<KConstraint>		KConstraints;
var array<Emitter>		Emitters;

function PostBeginPlay(){

	local KarmaParams myParams;
	
	Super.PostBeginPlay();

	myParams = KarmaParams ( KParams );

	if ( myParams != None ) {
		if ( myParams.KStartEnabled && bRecycle && !Destructible.bDestructible)
			SetTimer ( RecycleDelay, true );
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType, optional Controller KillerController)
{
	local vector ApplyImpulse;
	
	Destructible.HitPoints -= Damage;

	if(Destructible.bDestructible && Destructible.HitPoints < 0 && !bIsDestroyed){
		PlayDestruction();
	}

	// play sound
	PlayMySound ( );		

	// play effect
	PlayMyEffect ( hitlocation, momentum );
							
	if( Physics == PHYS_Karma ){

		if( bKTakeShot && damageType.default.KDamageImpulse > 0 )
		{
			if(VSize(momentum) < 0.001)
			{
				return;
			}
		
			ApplyImpulse = Normal(momentum) * damageType.default.KDamageImpulse;
			KAddImpulse(ApplyImpulse, hitlocation);
			
			// start the timer for karma recycling
			if ( bRecycle && !Destructible.bDestructible )
				SetTimer ( RecycleDelay, true );
		}
	}
}

function Trigger( actor Other, pawn EventInstigator )
{
	if( Physics == PHYS_Karma ){
	
		KWake ( );
		
		// start timer if needed
		if ( bRecycle )
			SetTimer ( RecycleDelay, true );
	}
}

function Timer()
{
	if(!PlayerCanSeeMe())
	{
		DestroyKBaggage();	
		Destroy();
	}
	else
	{
		SetTimer(1.0,true);
	}
}

function DestroyKBaggage()
{
	local int i,j;

	for(i=0;i<KConstraints.Length;++i){
		KConstraints[i].Destroy();
		KConstraints[i] = None;
	}

	for(j=0;j<Emitters.Length;++j){
		Emitters[j].Destroy();
		Emitters[j] = None;
	}

}

event KImpact( actor other, vector pos, vector impactVel, vector impactNorm ) {

	if ( Level.TimeSeconds > ( LastImpactTime + ImpactInterval ) ) {

		// play sound
		PlayMySound ( );

		// play effect
		PlayMyEffect ( pos, impactVel );

		// if it's karma, we need to apply velocity
		if ( Physics == PHYS_Karma ) {
					
			KAddImpulse( impactVel, pos );
			
			// start timer for recycling
			if ( bRecycle && !Destructible.bDestructible )
				SetTimer ( RecycleDelay, true );
		}
		LastImpactTime = Level.TimeSeconds;
	}
}

// If a damage amount is set inflict it.
function bool EncroachingOn( actor Other )
{
	local vector	HitNorm;

	HitNorm = Normal(Location - Other.Location);

	if( ImpactDamageAmount != 0 ){
		Other.TakeDamage( ImpactDamageAmount, Instigator, HitNorm, Velocity*ImpactDamageAmount, ImpactDamageType );
	}

	return false;
}

// Plays a random sound from the sound list for this KActor
function PlayMySound ( ) {

	local int numSounds, soundNum;
	
	// If we have some sounds, play a random one.
	numSounds = ImpactSounds.Length;
	
	if ( numSounds > 0 ) {
	
		soundNum = Rand(numSounds);
		//Log("Play Sound:"$soundNum);
		PlaySound(ImpactSounds[soundNum], SLOT_Misc, ImpactVolume);
	}
}

// Plays the Impact Effect for this KActor
function PlayMyEffect ( vector pos, vector impactVel ) {
	
	// If we have an effect class (and its relevant), spawn it.
	if ( ( ImpactEffect != None ) && EffectIsRelevant ( pos, false ) ) {
	
		if(bOrientImpactEffect)
			spawn(ImpactEffect, self, , pos, rotator(impactVel));
		else
			spawn(ImpactEffect, self, , pos);
	}
}

// Plays a random sound from the sound list for this KActor
function PlayDestruction ( ) {

	local int	i, j, e;
	local emitter	myEmitter;
	local kactor	impactKActor;

	for(i=0;i<KConstraints.Length;++i){
		if( FRand() < Destructible.ConstraintRatio){
			KConstraints[i].Destroy();
		}
	}

	if(Destructible.DestroyedMesh != None){
		SetStaticMesh(Destructible.DestroyedMesh);
	}

	if(Destructible.DestroyedSound != None){
		PlaySound(Destructible.DestroyedSound, SLOT_Misc, ImpactVolume);
	}

	if(DestructibleEffects.Length > 0)
	{
		for(j = 0; j < DestructibleEffects.Length; j++)
		{
			e = Emitters.Length;

			if( DestructibleEffects[j].EmitterClass != None ){

				if( VSize(DestructibleEffects[j].EmitterOffset) == 0 ){
					myEmitter = spawn(DestructibleEffects[j].EmitterClass,self,,Location + ( DestructibleEffects[j].EmitterOffset >> Rotation ), Rotation);
				}else{
					myEmitter = spawn(DestructibleEffects[j].EmitterClass,self,,Location,Rotation);
				}

				myEmitter.SetBase(self);
				Emitters[e++] = myEmitter;
			}
		}
	}

	if(Destructible.CausedDamageAmount > 0)
	{
		HurtRadius(Destructible.CausedDamageAmount,Destructible.DamageRadius,Destructible.DamageType,Destructible.MomentumTransfer,Location);
	}

	if( Destructible.MomentumTransfer > 0 && Destructible.bApplyLocalImpulse )
	{
		foreach RadiusActors( class'KActor', impactKActor, Destructible.DamageRadius ){	
			impactKActor.KAddImpulse( Normal(impactKActor.Location - Location)*Destructible.MomentumTransfer, Location );
		}
	}

	bIsDestroyed = true;

	if ( bRecycle )
		SetTimer ( RecycleDelay, true );

}


// Decompiled with UE Explorer.
defaultproperties
{
    bRecycle=true
    RecycleDelay=10.0000000
    bActive=true
    bKTakeShot=false
    bNoDelete=false
}