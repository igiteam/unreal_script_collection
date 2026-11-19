class Checkpoint extends Object
    native;

struct native LevelRecord
{
    var() name LevelName;
    var() bool bShouldBeLoaded;
    var() bool bShouldBeVisible;

    structdefaultproperties
    {
        LevelName="None"
        bShouldBeLoaded=false
        bShouldBeVisible=false
    }
};

struct native ActorRecord
{
    var string actorName;
    var string ActorClassPath;
    var array<byte> RecordData;

    structdefaultproperties
    {
        actorName=""
        ActorClassPath=""
        RecordData=none
    }
};

var int SlotIndex;
var string BaseLevelName;
var Guid BaseLevelGuid;
var byte bIsLevelStart;
var byte Difficulty;
var int ChapterNum;
var CheckpointTime SaveTime;
var Vector CheckpointLocation;
var array<LevelRecord> LevelRecords;
var array<ActorRecord> ActorRecords;
var array<byte> KismetData;
var const array< class<Actor> > ActorClassesToRecord;
var const array< class<Actor> > ActorClassesToDestroy;
var const array< class<Actor> > ActorClassesNotToDestroy;
var const localized string DisplayName;

final event bool CheckpointIsEmpty()
{
    // End:0x90
    if((((SaveTime.SecondsSinceMidnight == 0) && SaveTime.Day == 0) && SaveTime.Month == 0) && SaveTime.Year == 0)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static final function bool CheckpointTimeIsNewer(const out CheckpointTime CheckpointTime, const out CheckpointTime OtherCheckpointTime)
{
    local bool bResult;

    // End:0x4C
    if(CheckpointTime.Year > OtherCheckpointTime.Year)
    {
        bResult = true;        
    }
    else
    {
        // End:0x98
        if(CheckpointTime.Year < OtherCheckpointTime.Year)
        {
            bResult = false;            
        }
        else
        {
            // End:0xE4
            if(CheckpointTime.Month > OtherCheckpointTime.Month)
            {
                bResult = true;                
            }
            else
            {
                // End:0x130
                if(CheckpointTime.Month < OtherCheckpointTime.Month)
                {
                    bResult = false;                    
                }
                else
                {
                    // End:0x17C
                    if(CheckpointTime.Day > OtherCheckpointTime.Day)
                    {
                        bResult = true;                        
                    }
                    else
                    {
                        // End:0x1C8
                        if(CheckpointTime.Day < OtherCheckpointTime.Day)
                        {
                            bResult = false;                            
                        }
                        else
                        {
                            // End:0x214
                            if(CheckpointTime.SecondsSinceMidnight > OtherCheckpointTime.SecondsSinceMidnight)
                            {
                                bResult = true;                                
                            }
                            else
                            {
                                // End:0x25D
                                if(CheckpointTime.SecondsSinceMidnight < OtherCheckpointTime.SecondsSinceMidnight)
                                {
                                    bResult = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

final function bool CheckpointIsNewer(Checkpoint OtherCheckpoint)
{
    local bool bResult;

    bResult = true;
    // End:0x57
    if(OtherCheckpoint != none)
    {
        bResult = CheckpointTimeIsNewer(SaveTime, OtherCheckpoint.SaveTime);
    }
    return bResult;
    //return ReturnValue;    
}

event PreLoadCheckpoint()
{
    //return;    
}

event PostLoadCheckpoint()
{
    local WorldInfo WI;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x8A
    if(WI != none)
    {
        WI.Game.SetGameSpeed(WI.default.TimeDilation);
    }
    //return;    
}

event PreSaveCheckpoint()
{
    //return;    
}

event PostSaveCheckpoint()
{
    Class.static.HideSavingContentWarning();
    //return;    
}

static function ShowSavingContentWarning(optional float MinDisplayTime = 3.0000000)
{
    //return;    
}

static function HideSavingContentWarning()
{
    //return;    
}

defaultproperties
{
    DisplayName="Saved Campaign"
}