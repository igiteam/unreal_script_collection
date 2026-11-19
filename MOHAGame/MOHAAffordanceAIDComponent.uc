class MOHAAffordanceAIDComponent extends AffordanceAIDComponentBase
    editinlinenew
    hidecategories(Object);

enum EAffAIDSpokenRange
{
    AffAID_Nearby,                  // 0
    AffAID_Earshot,                 // 1
    AffAID_MAX                      // 2
};

struct ScriptedAID
{
    var() CCStimulusType StimulusType;
    var() float PlayerFightTime;
    var() int NumAxisKills;
    var() MOHAAffordanceAIDComponent.EAffAIDSpokenRange Range;

    structdefaultproperties
    {
        StimulusType=none
        PlayerFightTime=0.0000000
        NumAxisKills=0
        Range=0
    }
};

var() editinline array<editinline ScriptedAID> ScriptedAIDList;
var array<ScriptedAID> OriginalScriptedAIDList;

function Init(AffordanceNodeVolume aff)
{
    super.Init(aff);
    SortScriptedAIDList();
    OriginalScriptedAIDList = ScriptedAIDList;
    //return;    
}

function CCStimulusType GetNextSpokenNearby()
{
    return GetNextSpoken(0);
    //return ReturnValue;    
}

function CCStimulusType GetNextSpokenEarshot()
{
    return GetNextSpoken(1);
    //return ReturnValue;    
}

function CCStimulusType GetNextSpoken(MOHAAffordanceAIDComponent.EAffAIDSpokenRange Range)
{
    local int I;
    local float fPlayerTime;

    // End:0x34
    if(!ParentVolume.IsPlayerPresent() || !ParentVolume.DoesArmlockExist())
    {
        return none;
    }
    fPlayerTime = ParentVolume.GetPlayerTime();
    I = 0;
    J0x54:

    // End:0xF3 [Loop If]
    if(I < ScriptedAIDList.Length)
    {
        // End:0x86
        if(ScriptedAIDList[I].PlayerFightTime > fPlayerTime)
        {
            // [Explicit Break]
            goto J0xF3;
        }
        // End:0xE9
        if((int(ScriptedAIDList[I].Range) == int(Range)) && ScriptedAIDList[I].NumAxisKills <= ParentVolume.iNumAssignedAxisDeaths)
        {
            return ScriptedAIDList[I].StimulusType;
        }
        I++;
        // [Loop Continue]
        goto J0x54;
    }
    J0xF3:

    return none;
    //return ReturnValue;    
}

function AddAIDFromAction(SeqAct_AddAffordanceAIDBase Action)
{
    local SeqAct_AddMOHAAffordanceAID act;
    local ScriptedAID addMe;

    act = SeqAct_AddMOHAAffordanceAID(Action);
    // End:0x9F
    if((act != none) && act.AddScriptedAID.StimulusType != none)
    {
        addMe = act.AddScriptedAID;
        addMe.PlayerFightTime = addMe.PlayerFightTime + ParentVolume.GetPlayerTime();
        ScriptedAIDList[ScriptedAIDList.Length] = addMe;
        SortScriptedAIDList();
    }
    //return;    
}

function RemoveAIDFromAction(SeqAct_RemoveAffordanceAIDBase Action)
{
    local SeqAct_RemoveMOHAAffordanceAID act;

    act = SeqAct_RemoveMOHAAffordanceAID(Action);
    // End:0x49
    if((act != none) && act.StimulusType != none)
    {
        RemoveByStimulusType(act.StimulusType);
    }
    //return;    
}

function ResetAIDFromAction(SeqAct_ResetAffordanceAIDBase Action)
{
    ScriptedAIDList.Length = 0;
    //return;    
}

function bool RemoveByStimulusType(CCStimulusType StimulusType)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4E [Loop If]
    if(I < ScriptedAIDList.Length)
    {
        // End:0x44
        if(ScriptedAIDList[I].StimulusType == StimulusType)
        {
            ScriptedAIDList.Remove(I, 1);
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function OnCCPerformanceStarted(CCPerformance2 Performance, float performanceDuration)
{
    local float fSubtractedPlayerTime, fIntendedPerformanceTime;

    // End:0x82
    if(RemoveByStimulusType(Performance.StimulusType))
    {
        fSubtractedPlayerTime = 0.0000000;
        // End:0x40
        if(performanceDuration != -1.0000000)
        {
            fSubtractedPlayerTime = performanceDuration;
        }
        // End:0x63
        if(ScriptedAIDList.Length > 0)
        {
            fIntendedPerformanceTime = ScriptedAIDList[0].PlayerFightTime;
        }
        ParentVolume.SetPlayerTime(fIntendedPerformanceTime - fSubtractedPlayerTime);
    }
    //return;    
}

function SortScriptedAIDList()
{
    local int I, J, Min;
    local ScriptedAID swapAID;

    // End:0x0E
    if(ScriptedAIDList.Length <= 1)
    {
        return;
    }
    I = 0;
    J0x15:

    // End:0xD8 [Loop If]
    if(I < (ScriptedAIDList.Length - 1))
    {
        Min = I;
        J = I + 1;
        J0x41:

        // End:0x95 [Loop If]
        if(J < ScriptedAIDList.Length)
        {
            // End:0x8B
            if(ScriptedAIDList[J].PlayerFightTime < ScriptedAIDList[Min].PlayerFightTime)
            {
                Min = J;
            }
            J++;
            // [Loop Continue]
            goto J0x41;
        }
        swapAID = ScriptedAIDList[I];
        ScriptedAIDList[I] = ScriptedAIDList[Min];
        ScriptedAIDList[Min] = swapAID;
        I++;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

function DrawAffordanceAID(Canvas Canvas)
{
    local string drawMe;
    local int I;

    Canvas.__NFUN_465__((((((("Arm Lock Present: " $ string(ParentVolume.DoesArmlockExist())) $ "  CurrentPlayerTime: ") $ string(ParentVolume.GetPlayerTime())) $ "  IsPlayerPresent: ") $ string(ParentVolume.IsPlayerPresent())) $ "  NumAxisDeaths: ") $ string(ParentVolume.iNumAssignedAxisDeaths));
    I = 0;
    J0xC5:

    // End:0x22C [Loop If]
    if(I < ScriptedAIDList.Length)
    {
        drawMe = "  " $ string(ScriptedAIDList[I].StimulusType);
        drawMe = (((((drawMe $ " --- ") $ string(ScriptedAIDList[I].PlayerFightTime)) $ " --- ") $ string(ScriptedAIDList[I].NumAxisKills)) $ " --- ") $ string(ScriptedAIDList[I].Range);
        // End:0x1F3
        if((ParentVolume.DoesArmlockExist() && ParentVolume.GetPlayerTime() >= ScriptedAIDList[I].PlayerFightTime) && ParentVolume.iNumAssignedAxisDeaths >= ScriptedAIDList[I].NumAxisKills)
        {
            Canvas.SetDrawColor(0, byte(255), 0);            
        }
        else
        {
            Canvas.SetDrawColor(byte(255), byte(255), byte(255));
        }
        Canvas.__NFUN_465__(drawMe);
        I++;
        // [Loop Continue]
        goto J0xC5;
    }
    //return;    
}

function OnRespawn()
{
    ScriptedAIDList = OriginalScriptedAIDList;
    //return;    
}
