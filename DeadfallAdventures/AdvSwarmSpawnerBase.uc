class AdvSwarmSpawnerBase extends ADVDestructibleObject
    hidecategories(Navigation);

var int spidersAlive;

function DecrementSpidersCount()
{
    spidersAlive--;
    //return;    
}

function bool AnySpidersAlive()
{
    return spidersAlive > 0;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    super(EvilDestructibleObject).Destroyed();
    //return;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__AdvSwarmSpawnerBase.AmbientSoundComponent0'
    begin object name=AmbientSoundComponent0
    end object
    AmbientSoundComponent=AmbientSoundComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvSwarmSpawnerBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: DynamicLightEnvironmentComponent'Default__AdvSwarmSpawnerBase.MyLightEnvironment2'
    begin object name=MyLightEnvironment2
    end object
    LightEnvironmentToUseForActorSpawnParams=MyLightEnvironment2
    Parameters=EvilGoreToDmgTypeSettings'ar_DamageSettings.destroypacks.Generic'
    SubObjectHealths=/* Array type was not detected. */
    SpawnChunkRate=8
    GlobalOverrideLifespanChunks=10.0000000
    Components[0]=none
    // Reference: StaticMeshComponent'Default__AdvSwarmSpawnerBase.StaticMeshComponent_1'
    begin object name=StaticMeshComponent_1 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvSwarmSpawnerBase.MyLightEnvironment'
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bUsePrecomputedShadows=true
        LightingChannels=(bInitialized=true,Static=true,CompositeDynamic=true)
    end object
    Components[1]=StaticMeshComponent_1
}