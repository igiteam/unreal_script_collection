class EvilSpawnPoint extends Actor
    native(Sequence)
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force)
    implements(SpawnPointInterface);

var() Actor SpawnObject;
var() bool OnlySpawnWhenInvisible;
var bool bSpawnDisabled;
var() int MaxSpawnedNumber;
var export editinline CylinderComponent CylinderComponent;
var SpawnPointInterface SpawnObjectInterface;

function PostBeginPlay()
{
    SpawnObjectInterface = SpawnPointInterface(SpawnObject);
    super.PostBeginPlay();
    //return;    
}

function EnableSpawn()
{
    // End:0x40
    if(NotEqual_InterfaceInterface(SpawnObjectInterface, SpawnPointInterface(none)))
    {
        SpawnObjectInterface.EnableSpawn();
    }
    bSpawnDisabled = false;
    //return;    
}

function DisableSpawn()
{
    // End:0x40
    if(NotEqual_InterfaceInterface(SpawnObjectInterface, SpawnPointInterface(none)))
    {
        SpawnObjectInterface.DisableSpawn();
    }
    bSpawnDisabled = true;
    //return;    
}

function bool IsSpawnEnabled()
{
    // End:0x40
    if(NotEqual_InterfaceInterface(SpawnObjectInterface, SpawnPointInterface(none)))
    {
        SpawnObjectInterface.IsSpawnEnabled();
    }
    return true;
    //return ReturnValue;    
}

function ActivateSpawn()
{
    // End:0x40
    if(NotEqual_InterfaceInterface(SpawnObjectInterface, SpawnPointInterface(none)))
    {
        SpawnObjectInterface.ActivateSpawn();
    }
    // End:0x6C
    if(MaxSpawnedNumber >= 0)
    {
        // End:0x6C
        if(--MaxSpawnedNumber == 0)
        {
            bSpawnDisabled = true;
        }
    }
    //return;    
}

function DeactivateSpawn(optional float Time)
{
    // End:0x4A
    if(NotEqual_InterfaceInterface(SpawnObjectInterface, SpawnPointInterface(none)))
    {
        SpawnObjectInterface.DeactivateSpawn(Time);
    }
    //return;    
}

function bool IsSpawnActive()
{
    // End:0x41
    if(NotEqual_InterfaceInterface(SpawnObjectInterface, SpawnPointInterface(none)))
    {
        return SpawnObjectInterface.IsSpawnActive();
    }
    return true;
    //return ReturnValue;    
}

function bool DeactivateAfterEachSpawn()
{
    // End:0x41
    if(NotEqual_InterfaceInterface(SpawnObjectInterface, SpawnPointInterface(none)))
    {
        return SpawnObjectInterface.DeactivateAfterEachSpawn();
    }
    return false;
    //return ReturnValue;    
}

function bool CanSpawn()
{
    // End:0x41
    if(NotEqual_InterfaceInterface(SpawnObjectInterface, SpawnPointInterface(none)))
    {
        return SpawnObjectInterface.CanSpawn();
    }
    return !bSpawnDisabled;
    //return ReturnValue;    
}

function bool CanOnlySpawnWhenInvisible()
{
    return OnlySpawnWhenInvisible;
    //return ReturnValue;    
}

defaultproperties
{
    MaxSpawnedNumber=-1
    // Reference: CylinderComponent'Default__EvilSpawnPoint.CollisionCylinder'
    begin object name=CollisionCylinder class=Class'Engine.CylinderComponent'
        CollisionHeight=50.0000000
        CollisionRadius=50.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=none
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    bStatic=true
    bNoDelete=true
    bCollideWhenPlacing=true
    bForceAllowKismetModification=true
    CollisionComponent=CollisionCylinder
}