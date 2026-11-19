class SPHurtRadius extends Actor
    native
    notplaceable;

var class<PandoraDamageType> DamageType;
var float BaseDamage;
var float DamageRadius;

// Export USPHurtRadius::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

static function SPHurtRadius CreateSPHurtRadius(class<PandoraDamageType> theDamageType, float theBaseDamage, float theDamageRadius)
{
    local SPHurtRadius theSPHurtRadius;

    theSPHurtRadius = SPHurtRadius(SPSpawn(Class'SPHurtRadius'));
    theSPHurtRadius.DamageType = theDamageType;
    theSPHurtRadius.BaseDamage = theBaseDamage;
    theSPHurtRadius.DamageRadius = theDamageRadius;
    return theSPHurtRadius;
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    //return;    
}
