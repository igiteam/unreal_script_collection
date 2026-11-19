class SeqAct_PKAIFactoryFromSpawnPoint extends SeqAct_PKAIFactory
    native(Sequence)
    hidecategories(Object,AIFactory);

event CopyParmaetersFromSpawnpoint()
{
    local PKSpawnPoint PKSP;
    local PlayerController PC;

    // End:0x205
    if(SpawnPoints.Length > 0)
    {
        PKSP = PKSpawnPoint(SpawnPoints[0]);
        // End:0xB7
        if(PKSP == none)
        {
            // End:0xB3
            foreach GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
            {
                PC.ClientMessage("BAD Spawnpoint in PKAIFactory");                
            }                        
        }
        else
        {
            PKAIType = PKSP.MonsterType;
            bNotCountable = PKSP.NotCountable;
            SpawnDelay = PKSP.EachDelay;
            GroupSpawnDelay = PKSP.GroupDelay;
            SpawnCount = PKSP.GroupSize;
            SpawnGroupCount = PKSP.GroupCount;
            SpawnStartDelay = PKSP.StartDelay;
            WalkArea = PKSP.WalkArea;
            SeriesFromSameSpawn = true;
        }
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return super.GetObjClassVersion() + 2;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: SpawnMethod_JumpAndFx'Default__SeqAct_PKAIFactoryFromSpawnPoint.SpawnMethod_JumpAndFx0'
    // Archetype: SpawnMethod_JumpAndFx'Default__SeqAct_PKAIFactory.SpawnMethod_JumpAndFx0'
    begin object name="SpawnMethod_JumpAndFx0"
    end object
    SpawnMethod=SpawnMethod_JumpAndFx0
    ObjName="PKAI Factory From SpawnPoint"
}