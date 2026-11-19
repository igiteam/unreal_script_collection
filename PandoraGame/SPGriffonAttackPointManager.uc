class SPGriffonAttackPointManager extends Actor
    native
    notplaceable;

var array<SPGriffonAttackPoint> m_AttackPoints;

// Export USPGriffonAttackPointManager::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPGriffonAttackPointManager::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

static function SPGriffonAttackPointManager Get()
{
    local PandoraGameInfo spGameInfo;
    local SPGriffonAttackPointManager Manager;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x28
    if(spGameInfo == none)
    {
        return none;
    }
    // End:0x4D
    if(spGameInfo.ActiveAttackPointManager != none)
    {
        return spGameInfo.ActiveAttackPointManager;
    }
    Manager = SPGriffonAttackPointManager(SPSpawn(Class'SPGriffonAttackPointManager'));
    // End:0x85
    if(Manager != none)
    {
        Manager.bKillDuringLevelTransition = true;
    }
    spGameInfo.ActiveAttackPointManager = Manager;
    return Manager;
    //return ReturnValue;    
}
