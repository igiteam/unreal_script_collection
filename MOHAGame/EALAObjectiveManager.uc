class EALAObjectiveManager extends Actor
    native
    notplaceable
    hidecategories(Navigation);

struct native ObjectiveLogbookInfo
{
    var string LogBookString;
    var Color Color;

    structdefaultproperties
    {
        LogBookString=""
        Color=(R=0,G=0,B=0,A=0)
    }
};

var array<EALAObjective> PrimaryObjectives;
var array<EALAObjective> OptionalObjectives;
var class<HUD> HUDClass;

function bool AddToPrimary(EALAObjective Objective)
{
    // End:0x19
    if(PrimaryObjectives.Find(Objective) != -1)
    {
        return false;
    }
    PrimaryObjectives[PrimaryObjectives.Length] = Objective;
    return true;
    //return ReturnValue;    
}

function bool AddToOptional(EALAObjective Objective)
{
    // End:0x19
    if(OptionalObjectives.Find(Objective) != -1)
    {
        return false;
    }
    OptionalObjectives[OptionalObjectives.Length] = Objective;
    return true;
    //return ReturnValue;    
}

function bool AddObjective(EALAObjective Objective, string Message, string Title)
{
    local bool wasAdded;

    wasAdded = false;
    // End:0x87
    if(Objective != none)
    {
        // End:0x45
        if(int(Objective.ObjectiveType) == int(0))
        {
            wasAdded = AddToPrimary(Objective);            
        }
        else
        {
            wasAdded = AddToOptional(Objective);
        }
        // End:0x80
        if(wasAdded == true)
        {
            ObjectiveAdded(Objective, Message, Title);
        }
        return wasAdded;
    }
    return false;
    //return ReturnValue;    
}

function ObjectiveUpdated(EALAObjective Objective, string Message, string Title)
{
    //return;    
}

function ObjectiveAdded(EALAObjective Objective, string Message, string Title)
{
    //return;    
}

function OutputPrompt(string prompt, string Title, optional SoundCue SoundCue = none, optional float mixTime = 0.0000000, optional EALAObjective NewObj = none)
{
    //return;    
}

function Reset()
{
    PrimaryObjectives.Length = 0;
    OptionalObjectives.Length = 0;
    //return;    
}

function GetPrimaryObjectives(out array<ObjectiveLogbookInfo> the_list)
{
    local int I;
    local ObjectiveLogbookInfo Info;

    I = 0;
    J0x07:

    // End:0xFF [Loop If]
    if(I < PrimaryObjectives.Length)
    {
        Info.LogBookString = PrimaryObjectives[I].Prompts.LogBookString;
        switch(PrimaryObjectives[I].ObjectiveStatus)
        {
            // End:0x89
            case 1:
                Info.Color = MakeColor(byte(255), byte(255), byte(255), byte(255));
                // End:0xE3
                break;
            // End:0xB3
            case 2:
                Info.Color = MakeColor(0, byte(255), 0, byte(255));
                // End:0xE3
                break;
            // End:0xDD
            case 3:
                Info.Color = MakeColor(byte(255), 0, 0, byte(255));
                // End:0xE3
                break;
            // End:0xFFFF
            default:
                // End:0xE3
                break;
                break;
        }
        the_list[the_list.Length] = Info;
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function GetOptionalObjectives(out array<ObjectiveLogbookInfo> the_list)
{
    local int I;
    local ObjectiveLogbookInfo Info;

    I = 0;
    J0x07:

    // End:0xFF [Loop If]
    if(I < OptionalObjectives.Length)
    {
        Info.LogBookString = OptionalObjectives[I].Prompts.LogBookString;
        switch(OptionalObjectives[I].ObjectiveStatus)
        {
            // End:0x89
            case 1:
                Info.Color = MakeColor(byte(255), byte(255), byte(255), byte(255));
                // End:0xE3
                break;
            // End:0xB3
            case 2:
                Info.Color = MakeColor(0, byte(255), 0, byte(255));
                // End:0xE3
                break;
            // End:0xDD
            case 3:
                Info.Color = MakeColor(byte(255), 0, 0, byte(255));
                // End:0xE3
                break;
            // End:0xFFFF
            default:
                // End:0xE3
                break;
                break;
        }
        the_list[the_list.Length] = Info;
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function int GetNumTotalObjectives()
{
    return PrimaryObjectives.Length + OptionalObjectives.Length;
    //return ReturnValue;    
}

function int GetNumCompletedPrimaryObjectives()
{
    local int I, Count;

    Count = 0;
    I = 0;
    J0x0E:

    // End:0x4E [Loop If]
    if(I < PrimaryObjectives.Length)
    {
        // End:0x44
        if(int(PrimaryObjectives[I].ObjectiveStatus) == int(2))
        {
            Count++;
        }
        ++I;
        // [Loop Continue]
        goto J0x0E;
    }
    return Count;
    //return ReturnValue;    
}

function ClearSelectionFlags()
{
    //return;    
}

function SetSelectionByName(name ObjName)
{
    //return;    
}

defaultproperties
{
    CollisionType=0
}