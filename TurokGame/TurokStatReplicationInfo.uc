class TurokStatReplicationInfo extends ReplicationInfo
    abstract
    native
    hidecategories(Navigation,Movement,Collision);

var const class<Class> StatsClass;
var @NULL mAchievementTracker;

defaultproperties
{
    bOnlyRelevantToOwner=true
    bAlwaysRelevant=false
    bMovable=false
    TickGroup=1
    NetUpdateFrequency=1.0000000
    NetPriority=1.4000000
}