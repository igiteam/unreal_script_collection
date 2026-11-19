class SeqAct_SpBarphFactory extends SeqAct_ActorFactory
    native;

/** If TRUE will not reset the SpawnedCount on Enable */
var() bool bRestoreSpawnedCountOnEnable;
var() bool bAllowSpawnedToAll;
/** Spawn controlling parametsrs, such as actor class, rate of spawn, etc. */
var() export editinline array<export editinline SPActorFactoryAI> Factories;
/** Set of points where Objects will be spawned */
var() array<SPSpawnPoint> SpPoints;
var int CurFactorIdx;
var int NewSpawnCount;
var array<SPSpawnPoint> ValidSpawnPoint;
