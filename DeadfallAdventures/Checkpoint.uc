class Checkpoint extends Object
    native;

struct native EvilHeaderData
{
    var() int GameplayTime;
    var() int LastSaveTime;
    var() int CompletedLevelsMaskA;
    var() int CompletedLevelsMaskB;
    var() int CompletedLevelsMaskC;
    var() array<string> UniqueCollectedTreasures;
    var() byte ChapterNum;
    var() byte Difficulty;
    var() byte DifficultyOther;
    var() int TreasuresCollectedInfoA;
    var() int TreasuresCollectedInfoB;
    var() int UpgradesInfoA;
    var() int UpgradesInfoB;
    var() int CollectedTreasuresMaps;
    var() array<string> LevelInitialUniqueCollectedTreasures;
    var() int LevelInitialTreasuresCollectedInfoA;
    var() int LevelInitialTreasuresCollectedInfoB;
    var() int LevelInitialUpgradesInfoA;
    var() int LevelInitialUpgradesInfoB;
    var() array<string> Inventory;
    var() array<int> InventoryAmmo;

    structdefaultproperties
    {
        GameplayTime=0
        LastSaveTime=0
        CompletedLevelsMaskA=0
        CompletedLevelsMaskB=0
        CompletedLevelsMaskC=0
        UniqueCollectedTreasures=none
        ChapterNum=0
        Difficulty=0
        DifficultyOther=0
        TreasuresCollectedInfoA=0
        TreasuresCollectedInfoB=0
        UpgradesInfoA=0
        UpgradesInfoB=0
        CollectedTreasuresMaps=0
        LevelInitialUniqueCollectedTreasures=none
        LevelInitialTreasuresCollectedInfoA=0
        LevelInitialTreasuresCollectedInfoB=0
        LevelInitialUpgradesInfoA=0
        LevelInitialUpgradesInfoB=0
        Inventory=none
        InventoryAmmo=none
    }
};

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

var() EvilHeaderData HeaderData;
var int SlotIndex;
var string BaseLevelName;
var Guid BaseLevelGuid;
var byte bIsLevelStart;
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

event SaveWasSkipped()
{
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

static function StaticInvalidateCheckpointData(out EvilHeaderData OutHeaderData)
{
    OutHeaderData.CompletedLevelsMaskA = 0;
    OutHeaderData.CompletedLevelsMaskB = 0;
    OutHeaderData.CompletedLevelsMaskC = 0;
    OutHeaderData.ChapterNum = 0;
    OutHeaderData.GameplayTime = 0;
    OutHeaderData.Inventory.Length = 0;
    OutHeaderData.InventoryAmmo.Length = 0;
    OutHeaderData.LastSaveTime = 0;
    OutHeaderData.TreasuresCollectedInfoA = 0;
    OutHeaderData.TreasuresCollectedInfoB = 0;
    OutHeaderData.UniqueCollectedTreasures.Length = 0;
    OutHeaderData.UpgradesInfoA = 0;
    OutHeaderData.UpgradesInfoB = 0;
    OutHeaderData.LevelInitialUniqueCollectedTreasures.Length = 0;
    OutHeaderData.LevelInitialTreasuresCollectedInfoA = 0;
    OutHeaderData.LevelInitialTreasuresCollectedInfoB = 0;
    OutHeaderData.LevelInitialUpgradesInfoA = 0;
    OutHeaderData.LevelInitialUpgradesInfoB = 0;
    OutHeaderData.CollectedTreasuresMaps = 0;
    //return;    
}

function InvalidateCheckpointData()
{
    StaticInvalidateCheckpointData(HeaderData);
    //return;    
}

function SetLevelCompleted(int LevelID)
{
    // End:0x5A
    if(LevelID < 32)
    {
        HeaderData.CompletedLevelsMaskA = HeaderData.CompletedLevelsMaskA | (1 << LevelID);        
    }
    else
    {
        HeaderData.CompletedLevelsMaskB = HeaderData.CompletedLevelsMaskB | (1 << (LevelID % 32));
    }
    //return;    
}

function bool IsLevelCompleted(int LevelID)
{
    // End:0x41
    if(LevelID < 32)
    {
        return (HeaderData.CompletedLevelsMaskA & (1 << LevelID)) != 0;        
    }
    else
    {
        return (HeaderData.CompletedLevelsMaskB & (1 << (LevelID % 32))) != 0;
    }
    //return ReturnValue;    
}

event FillCheckpointWithAdditionalData()
{
    //return;    
}
