class BulletImpactEffects extends Actor
	native;

//RDN - DLO + DVD == Bad We need to load these classes upfront.
var array<class<Emitter> > EmitterClasses;

native static simulated function Actor SpawnImpactEffect(Actor Other, Actor ObjectOwner, vector HitLocation, vector HitNormal, byte MaterialType, optional float ImpactScaleFactor );


// Decompiled with UE Explorer.
defaultproperties
{
    EmitterClasses[0]=none
    EmitterClasses[1]=Class'ZombieEffects.impact_generic'
    EmitterClasses[2]=Class'ZombieEffects.impact_dirt'
    EmitterClasses[3]=Class'ZombieEffects.impact_metal'
    EmitterClasses[4]=Class'ZombieEffects.impact_generic'
    EmitterClasses[5]=Class'ZombieEffects.impact_generic'
    EmitterClasses[6]=Class'ZombieEffects.impact_generic'
    EmitterClasses[7]=Class'ZombieEffects.impact_dirt'
    EmitterClasses[8]=Class'ZombieEffects.impact_generic'
    EmitterClasses[9]=Class'ZombieEffects.impact_dirt'
    EmitterClasses[10]=Class'ZombieEffects.impact_dirt'
    EmitterClasses[11]=Class'ZombieEffects.impact_dirt'
    EmitterClasses[12]=Class'ZombieEffects.impact_generic'
}