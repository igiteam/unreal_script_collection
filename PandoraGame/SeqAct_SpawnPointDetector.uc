class SeqAct_SpawnPointDetector extends SequenceAction
    native;

struct native PointData
{
    var array<SeqOpOutputInputLink> Links;
    var() SPSpawnPoint SpawnPoint;

    structdefaultproperties
    {
        Links=none
        SpawnPoint=none
    }
};

var() array<PointData> PointList;
var array<SeqOpOutputInputLink> NotInListLinks;
