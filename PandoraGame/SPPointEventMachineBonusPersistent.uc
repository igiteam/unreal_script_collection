class SPPointEventMachineBonusPersistent extends SPPointEvent;

struct PointsPerLevelInfo
{
    var int FillPercent;
    var int Points;
    var SoundCue TeamSound[2];

    structdefaultproperties
    {
        FillPercent=0
        Points=0
        TeamSound[0]=none
        TeamSound[1]=none
    }
};

var private PointsPerLevelInfo PointsPerLevelData[4];
var private int CurrLevel;

function ApplyPoints()
{
    //return;    
}

function SetLevel(int Level)
{
    CurrLevel = Level;
    //return;    
}

function int GetLevel()
{
    return CurrLevel;
    //return ReturnValue;    
}

static function int GetLevelForFillPercent(int Percent)
{
    local int Count;

    Count = 0;
    J0x07:

    // End:0x46 [Loop If]
    if(Count < 4)
    {
        // End:0x3C
        if(Percent < default.PointsPerLevelData[Count].FillPercent)
        {
            return Count - 1;
        }
        Count++;
        // [Loop Continue]
        goto J0x07;
    }
    return 4 - 1;
    //return ReturnValue;    
}

static function SoundCue GetSoundCueForLevelAndTeam(int Level, int Team)
{
    // End:0x0D
    if(Level < 0)
    {
        return none;
    }
    return default.PointsPerLevelData[Level].TeamSound[Team - 1];
    //return ReturnValue;    
}

static function int GetPointsForLevel(int Level)
{
    // End:0x1F
    if((Level == -1) || Level >= 4)
    {
        return 0;
    }
    return default.PointsPerLevelData[Level].Points;
    //return ReturnValue;    
}

defaultproperties
{
    CurrLevel=-1
}