class SkyStimulusMgr extends Object
    native;

enum StimulusType
{
    StimulusType_Grenade,           // 0
    StimulusType_Mine,              // 1
    StimulusType_Unknown,           // 2
    StimulusType_MAX                // 3
};

struct native StimulusData
{
    var int StimulusID;
    var SkyStimulusMgr.StimulusType Type;
    var Actor StimulusActor;

    structdefaultproperties
    {
        StimulusID=0
        Type=StimulusType_Unknown
        StimulusActor=none
    }
};

var protected transient int NextStimulusID;
var protected transient array<StimulusData> StimuliList;

// Export USkyStimulusMgr::execAddStimulus(FFrame&, void* const)
native final function int AddStimulus(SkyStimulusMgr.StimulusType Type, Actor StimulusActor);

// Export USkyStimulusMgr::execRemoveStimulus(FFrame&, void* const)
native final function bool RemoveStimulus(int StimulusID);

// Export USkyStimulusMgr::execRemoveAllStimuli(FFrame&, void* const)
native final function bool RemoveAllStimuli();

// Export USkyStimulusMgr::execFindClosestStimulus(FFrame&, void* const)
native final function int FindClosestStimulus(Vector SearchPosition, float Radius, out Actor StimulusActor);

// Export USkyStimulusMgr::execTickStimuli(FFrame&, void* const)
native final function bool TickStimuli(float DeltaTime);
