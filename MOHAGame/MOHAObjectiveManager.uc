class MOHAObjectiveManager extends EALAObjectiveManager
    native
    notplaceable
    hidecategories(Navigation);

var(HUD) float fHUDFadeInTime;
var(HUD) float fHUDMaxAlphaTime;
var(HUD) float fHUDFadeOutTime;
var array<ObjectiveLogbookInfo> LogBookDataPrimary;
var array<ObjectiveLogbookInfo> LogBookDataTOO;
var bool bUpdateBeads;
var int iNumObjectivesAdded;
var EALAObjective LastObjective;
var EALAObjective RadioCallObjective;

function ObjectiveUpdated(EALAObjective Objective, string Message, string Title)
{
    UpdateLogBook();
    // End:0xB6
    if((Message != "") || Title != "")
    {
        // End:0x7B
        if(int(Objective.ObjectiveStatus) == int(2))
        {
            OutputPrompt(Message, Title, Objective.GetSuccessSoundCue(), Objective.GetDefaultMixTime());            
        }
        else
        {
            OutputPrompt(Message, Title, Objective.GetDefaultSoundCue(), Objective.GetDefaultMixTime());
        }
    }
    //return;    
}

function bool SkippedITP()
{
    local MOHAPlayerPawn PlayerPawn;

    // End:0x2D
    foreach AllActors(Class'MOHAPlayerPawn', PlayerPawn)
    {
        // End:0x2C
        if(PlayerPawn != none)
        {            
            return PlayerPawn.bSkippedITP;
        }        
    }    
    return false;
    //return ReturnValue;    
}

function ObjectiveAdded(EALAObjective Objective, string Message, string Title)
{
    LastObjective = Objective;
    UpdateLogBook();
    // End:0x70
    if((Len(Message) > 0) && Len(Title) > 0)
    {
        OutputPrompt(Message, Title, Objective.GetNewObjectiveRadioSoundCue(), Objective.GetNewObjectiveRadioMixTime(), Objective);
    }
    iNumObjectivesAdded++;
    //return;    
}

function SortObjectivesList(out array<EALAObjective> List)
{
    local bool swapped;
    local int I;
    local EALAObjective Temp;

    J0x00:
    swapped = false;
    I = 0;
    J0x0F:

    // End:0xAD [Loop If]
    if(I < (List.Length - 1))
    {
        // End:0xA3
        if(MOHAObjective(List[I]).SavedOrder > MOHAObjective(List[I + 1]).SavedOrder)
        {
            Temp = List[I];
            List[I] = List[I + 1];
            List[I + 1] = Temp;
            swapped = true;
        }
        ++I;
        // [Loop Continue]
        goto J0x0F;
    }
    // End:0x00
    if(!(!swapped))
        goto J0x00;
    //return;    
}

function bool AddObjectiveQuiet(MOHAObjective Objective)
{
    local bool wasAdded;

    wasAdded = false;
    // End:0x96
    if(Objective != none)
    {
        // End:0x54
        if(int(Objective.ObjectiveType) == int(0))
        {
            wasAdded = AddToPrimary(Objective);
            SortObjectivesList(PrimaryObjectives);            
        }
        else
        {
            wasAdded = AddToOptional(Objective);
            SortObjectivesList(OptionalObjectives);
        }
        // End:0x96
        if(wasAdded == true)
        {
            UpdateLogBook();
            iNumObjectivesAdded++;
        }
    }
    return wasAdded;
    //return ReturnValue;    
}

function OutputPrompt(string prompt, string Title, optional SoundCue SoundCue = none, optional float mixTime = 0.0000000, optional EALAObjective NewObj = none)
{
    local MOHAPlayerController PC;

    // End:0x83
    foreach LocalPlayerControllers(PC)
    {
        // End:0x82
        if(PC != none)
        {
            MOHAHUD(PC.myHUD).SetObjectiveText(prompt, Title, fHUDFadeInTime, ((SoundCue != none) ? mixTime : fHUDMaxAlphaTime), fHUDFadeOutTime, SoundCue, NewObj);
        }        
    }    
    //return;    
}

function UpdateLogBook()
{
    bUpdateBeads = true;
    LogBookDataPrimary.Length = 0;
    GetPrimaryObjectives(LogBookDataPrimary);
    LogBookDataTOO.Length = 0;
    GetOptionalObjectives(LogBookDataTOO);
    //return;    
}

simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector ViewPoint, Vector ViewDir)
{
    local int I;

    Canvas.SetPos(10.0000000, 260.0000000);
    Canvas.DrawColor = MakeColor(0, 50, byte(255), byte(255));
    Canvas.__NFUN_465__("Primary Objectives: ", true);
    I = 0;
    J0x65:

    // End:0xC6 [Loop If]
    if(I < LogBookDataPrimary.Length)
    {
        Canvas.DrawColor = LogBookDataPrimary[I].Color;
        Canvas.__NFUN_465__(LogBookDataPrimary[I].LogBookString, true);
        I++;
        // [Loop Continue]
        goto J0x65;
    }
    Canvas.DrawColor = MakeColor(234, 242, 12, byte(255));
    Canvas.__NFUN_465__("Targets of Opportunity: ", true);
    I = 0;
    J0x114:

    // End:0x175 [Loop If]
    if(I < LogBookDataTOO.Length)
    {
        Canvas.DrawColor = LogBookDataTOO[I].Color;
        Canvas.__NFUN_465__(LogBookDataTOO[I].LogBookString, true);
        I++;
        // [Loop Continue]
        goto J0x114;
    }
    //return;    
}

function ClearSelectionFlags()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < PrimaryObjectives.Length)
    {
        PrimaryObjectives[I].CurrentUISelection = false;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SetSelectionByName(name ObjName)
{
    local int I, J;
    local MOHAObjectiveGroup objGroup;
    local EALAObjective obj;

    I = 0;
    J0x07:

    // End:0x53 [Loop If]
    if(I < PrimaryObjectives.Length)
    {
        // End:0x49
        if(PrimaryObjectives[I].Name == ObjName)
        {
            obj = PrimaryObjectives[I];
            // [Explicit Break]
            goto J0x53;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x53:

    // End:0xD7
    if(obj != none)
    {
        objGroup = MOHAObjectiveGroup(obj);
        // End:0xC6
        if(objGroup != none)
        {
            J = 0;
            J0x80:

            // End:0xC3 [Loop If]
            if(J < objGroup.SubObjectives.Length)
            {
                objGroup.SubObjectives[J].CurrentUISelection = true;
                J++;
                // [Loop Continue]
                goto J0x80;
            }            
        }
        else
        {
            obj.CurrentUISelection = true;
        }
    }
    //return;    
}

defaultproperties
{
    fHUDFadeInTime=0.5000000
    fHUDMaxAlphaTime=4.0000000
    fHUDFadeOutTime=0.5000000
}