class SPDAction_SpawnFireObject extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var() ParticleSystem PSLevels[3];
/** In Damage per second; */
var() float DamageAmount;
var() float BurnTime;
var() float FireStrength;
var() float FireSpreadSpeed;
var() float scaleVal;
var() bool bEnabled;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPFireObject FireObject;

    FireObject = SPFireObject(CreateActor(Manager, Actor, DamageInfo));
    // End:0xFC
    if(FireObject != none)
    {
        FireObject.PSLevels[0] = PSLevels[0];
        FireObject.PSLevels[1] = PSLevels[1];
        FireObject.PSLevels[2] = PSLevels[2];
        FireObject.DamageAmount = DamageAmount;
        FireObject.BurnTime = BurnTime;
        FireObject.FireStrength = FireStrength;
        FireObject.FireSpreadSpeed = FireSpreadSpeed;
        FireObject.scaleVal = scaleVal;
        FireObject.bEnabled = bEnabled;
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    scaleVal=1.0000000
    bEnabled=true
    bCheckForSpawnCollision=false
    NewActorClass=Class'SPFireObject'
    Action="Spawn Fire Object"
}