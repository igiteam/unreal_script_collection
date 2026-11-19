class MOHAPropState extends ActorComponent
    editinlinenew
    hidecategories(Object);

var(MeshAndFX) StaticMesh SwapMesh;
var(MeshAndFX) ParticleSystem SpawnFX;
var(MeshAndFX) Vector FXOffset;
var(MeshAndFX) SoundCue SpawnSound;
var(MeshAndFX) bool bRemoveMesh;
var(MeshAndFX) bool bRemoveFX;
var(MeshAndFX) bool bRemoveSound;
var(MeshAndFX) bool bChangeScale;
var(State) bool DoPhysics;
var(State) bool bApplyForce;
var(State) bool bExplode;
var(State) bool bFinalState;
var(State) bool bPathGenState;
var(Collision) bool bNewCollideActors;
var(Collision) bool bNewBlockActors;
var(Collision) bool bNewIgnoreEncroachers;
var bool bTimerState;
var bool bHealthState;
var bool bDeathState;
var(MeshAndFX) float Scale;
var(Physics) Vector Direction;
var(Physics) float Force;
var(Physics) float Offset;
var(Physics) float RandomSpin;
var(Explode) float Damage;
var(Explode) float DamageRadius;
var(Explode) float Impulse;

function bool IsDeathState()
{
    return bDeathState;
    //return ReturnValue;    
}

function bool IsTimerState()
{
    return bTimerState;
    //return ReturnValue;    
}

function bool IsHealthState()
{
    return bHealthState;
    //return ReturnValue;    
}

function float GetStateTime()
{
    return 0.0000000;
    //return ReturnValue;    
}

function bool NeedHealthChange(float Health, float MaxHealth)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    bNewCollideActors=true
    bNewBlockActors=true
    bNewIgnoreEncroachers=true
}