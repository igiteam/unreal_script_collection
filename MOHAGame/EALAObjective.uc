class EALAObjective extends Actor
    native
    notplaceable
    hidecategories(Navigation);

enum EObjectiveType
{
    OBJECTIVETYPE_PRIMARY,          // 0
    OBJECTIVETYPE_OPTIONAL,         // 1
    OBJECTIVETYPE_MAX               // 2
};

enum EObjectiveStatus
{
    OBJECTIVESTATUS_DISABLED,       // 0
    OBJECTIVESTATUS_PENDING,        // 1
    OBJECTIVESTATUS_SUCCESS,        // 2
    OBJECTIVESTATUS_FAIL,           // 3
    OBJECTIVESTATUS_ERROR,          // 4
    OBJECTIVESTATUS_MAX             // 5
};

enum EBeadMode
{
    BEAD_STEADY,                    // 0
    BEAD_BLINK,                     // 1
    BEAD_MAX                        // 2
};

struct native PromptStrings
{
    var() string LogBookString;
    var() string ActivateString;
    var() string SuccessString;
    var() string FailureString;
    var() array<string> MiscString;
    var() string DiscoverString;

    structdefaultproperties
    {
        LogBookString=""
        ActivateString=""
        SuccessString=""
        FailureString=""
        MiscString=none
        DiscoverString=""
    }
};

struct native PromptStringTitles
{
    var const localized string ActivateTitle;
    var const localized string SuccessTitle;
    var const localized string FailureTitle;
    var const localized string MiscTitle;
    var const localized string DiscTitle;
    var const localized string ActivateTitle_Optional;
    var const localized string SuccessTitle_Optional;
    var const localized string FailureTitle_Optional;
    var const localized string MiscTitle_Optional;
    var const localized string DiscTitle_Optional;

    structdefaultproperties
    {
        ActivateTitle=""
        SuccessTitle=""
        FailureTitle=""
        MiscTitle=""
        DiscTitle=""
        ActivateTitle_Optional=""
        SuccessTitle_Optional=""
        FailureTitle_Optional=""
        MiscTitle_Optional=""
        DiscTitle_Optional=""
    }
};

struct native ObjectiveActorInfo
{
    var Actor ObjActor;
    var EALAObjective Objective;

    structdefaultproperties
    {
        ObjActor=none
        Objective=none
    }
};

var(Objective) EALAObjective.EObjectiveType ObjectiveType;
var EALAObjective.EObjectiveStatus ObjectiveStatus;
var(Objective) PromptStrings Prompts;
var(Objective) editconst PromptStringTitles PromptTitles;
var(Objective) name ObjectiveName;
var(Objective) array<Actor> BeadList;
var(Objective) array<Actor> BeadListCompleted;
var(Objective) bool bStartActive;
var bool CurrentUISelection;
var string LogDisplayString;
var MOHAObjectiveGroup ParentObjective;

function EALAObjectiveManager GetObjectiveManager()
{
    //return ReturnValue;    
}

function LoadLocalizedStrings()
{
    local int I;
    local string origMiscInfo, miscInfo;

    Prompts.LogBookString = GetLocalizedStr(Prompts.LogBookString, string(ObjectiveName), "Prompts.LogBookString", "Objectives");
    Prompts.ActivateString = GetLocalizedStr(Prompts.ActivateString, string(ObjectiveName), "Prompts.ActivateString", "Objectives");
    Prompts.SuccessString = GetLocalizedStr(Prompts.SuccessString, string(ObjectiveName), "Prompts.SuccessString", "Objectives");
    Prompts.FailureString = GetLocalizedStr(Prompts.FailureString, string(ObjectiveName), "Prompts.FailureString", "Objectives");
    Prompts.DiscoverString = GetLocalizedStr(Prompts.DiscoverString, string(ObjectiveName), "Prompts.DiscoverString", "Objectives");
    I = 0;
    // End:0x1C9
    if(Prompts.MiscString.Length > I)
    {
        origMiscInfo = Prompts.MiscString[I];
    }
    miscInfo = GetLocalizedStr(origMiscInfo, string(ObjectiveName), ("Prompts.MiscString[" $ string(I)) $ "]", "Objectives");
    J0x210:

    // End:0x2C9 [Loop If]
    if(miscInfo != "")
    {
        Prompts.MiscString[I] = miscInfo;
        I += 1;
        // End:0x277
        if(Prompts.MiscString.Length > I)
        {
            origMiscInfo = Prompts.MiscString[I];            
        }
        else
        {
            origMiscInfo = "";
        }
        miscInfo = GetLocalizedStr(origMiscInfo, string(ObjectiveName), ("Prompts.MiscString[" $ string(I)) $ "]", "Objectives");
        // [Loop Continue]
        goto J0x210;
    }
    //return;    
}

function string GetNewObjectiveTitle()
{
    return ((int(ObjectiveType) == int(0)) ? PromptTitles.ActivateTitle : PromptTitles.ActivateTitle_Optional);
    //return ReturnValue;    
}

function string GetObjectiveSuccessTitle()
{
    return ((int(ObjectiveType) == int(0)) ? PromptTitles.SuccessTitle : PromptTitles.SuccessTitle_Optional);
    //return ReturnValue;    
}

function string GetObjectiveFailureTitle()
{
    return ((int(ObjectiveType) == int(0)) ? PromptTitles.FailureTitle : PromptTitles.FailureTitle_Optional);
    //return ReturnValue;    
}

function string GetObjectiveUpdatedTitle()
{
    return ((int(ObjectiveType) == int(0)) ? PromptTitles.MiscTitle : PromptTitles.MiscTitle_Optional);
    //return ReturnValue;    
}

function string GetObjectiveDiscTitle()
{
    return ((int(ObjectiveType) == int(0)) ? PromptTitles.DiscTitle : PromptTitles.DiscTitle_Optional);
    //return ReturnValue;    
}

function SoundCue GetObjectiveDiscRadioSoundCue()
{
    //return ReturnValue;    
}

function float GetObjectiveDiscRadioMixTime()
{
    //return ReturnValue;    
}

function SoundCue GetNewObjectiveRadioSoundCue()
{
    //return ReturnValue;    
}

function float GetNewObjectiveRadioMixTime()
{
    //return ReturnValue;    
}

function SoundCue GetDefaultSoundCue()
{
    //return ReturnValue;    
}

function SoundCue GetSuccessSoundCue()
{
    //return ReturnValue;    
}

function float GetDefaultMixTime()
{
    //return ReturnValue;    
}

function FireObjectiveChanged()
{
    switch(ObjectiveStatus)
    {
        // End:0x69
        case 2:
            TriggerEventClass(Class'SeqEvent_ObjectiveChanged', self, 1);
            Class'Engine.JuiceSubsystem'.static.LevelEventD(2, 0, 5, "Gameplay", "Objective", string(ObjectiveName), 0, 0.0000000, "Success", Location);
            // End:0xD1
            break;
        // End:0xCB
        case 3:
            TriggerEventClass(Class'SeqEvent_ObjectiveChanged', self, 2);
            Class'Engine.JuiceSubsystem'.static.LevelEventD(2, 0, 5, "Gameplay", "Objective", string(ObjectiveName), 0, 0.0000000, "Failed", Location);
            // End:0xD1
            break;
        // End:0xFFFF
        default:
            // End:0xD1
            break;
            break;
    }
    //return;    
}

function FireObjectiveAdded()
{
    TriggerEventClass(Class'SeqEvent_ObjectiveChanged', self, 0);
    //return;    
}

function ChangeStatus(EALAObjective.EObjectiveStatus newStatus, string Message, string Title)
{
    local EALAObjectiveManager ObjectiveManager;

    // End:0x12
    if(int(ObjectiveStatus) != int(1))
    {
        return;
    }
    ObjectiveStatus = newStatus;
    FireObjectiveChanged();
    ObjectiveManager = GetObjectiveManager();
    // End:0x60
    if(ObjectiveManager != none)
    {
        ObjectiveManager.ObjectiveUpdated(self, Message, Title);
    }
    // End:0x83
    if(ParentObjective != none)
    {
        ParentObjective.SubObjectiveChangedStatus(newStatus);
    }
    //return;    
}

function AddToManager(string Message, string Title)
{
    local EALAObjectiveManager ObjectiveManager;

    // End:0x12
    if(int(ObjectiveStatus) != int(0))
    {
        return;
    }
    ObjectiveManager = GetObjectiveManager();
    // End:0x2F
    if(ObjectiveManager == none)
    {
        return;
    }
    // End:0x4D
    if(ParentObjective != none)
    {
        ParentObjective.SubObjectiveAdded();
    }
    ObjectiveStatus = 1;
    ObjectiveManager.AddObjective(self, Message, Title);
    FireObjectiveAdded();
    //return;    
}

function OutputPrompt(string Message, string Title, optional SoundCue SoundCue = none, optional float mixTime = 0.0000000, optional EALAObjective.EBeadMode beadMode = 0)
{
    local EALAObjectiveManager ObjectiveManager;

    ObjectiveManager = GetObjectiveManager();
    // End:0x31
    if(ObjectiveManager == none)
    {
        return;
    }
    ObjectiveManager.OutputPrompt(Message, Title, SoundCue, mixTime, ((int(beadMode) == int(1)) ? self : none));
    //return;    
}

function string ParsePrompt(string Message, SeqAct_UpdateMissionObjective Action)
{
    local string Temp, tmp2;
    local int I;

    I = 1;
    J0x07:

    // End:0x1AB [Loop If]
    if(I < Action.VariableLinks.Length)
    {
        Temp = Action.VariableLinks[I].LinkDesc;
        // End:0xB3
        if(Action.VariableLinks[I].LinkedVariables[0].IsA('SeqVar_Int'))
        {
            tmp2 = "" $ string(SeqVar_Int(Action.VariableLinks[I].LinkedVariables[0]).IntValue);            
        }
        else
        {
            // End:0x11C
            if(Action.VariableLinks[I].LinkedVariables[0].IsA('SeqVar_String'))
            {
                tmp2 = SeqVar_String(Action.VariableLinks[I].LinkedVariables[0]).StrValue;                
            }
            else
            {
                // End:0x188
                if(Action.VariableLinks[I].LinkedVariables[0].IsA('SeqVar_Float'))
                {
                    tmp2 = "" $ string(SeqVar_Float(Action.VariableLinks[I].LinkedVariables[0]).FloatValue);
                }
            }
        }
        ReplaceText(Message, Temp, tmp2);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return Message;
    //return ReturnValue;    
}

function OnObjectiveSetBead(SeqAct_ObjectiveSetBead Action)
{
    local int Index, actor_index;
    local Actor theActor;
    local EALAObjectiveManager ObjectiveManager;

    // End:0x12D
    if(Action.InputLinks[0].bHasImpulse)
    {
        actor_index = 0;
        J0x25:

        // End:0x12A [Loop If]
        if(actor_index < Action.VariableLinks[1].LinkedVariables.Length)
        {
            theActor = Actor(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[actor_index]).GetObjectValue());
            // End:0x96
            if(theActor == none)
            {
                // [Explicit Continue]
                goto J0x120;
            }
            // End:0xF2
            if(BeadList.Find(theActor) == -1)
            {
                ObjectiveManager = GetObjectiveManager();
                // End:0xE0
                if(ObjectiveManager != none)
                {
                    ObjectiveManager.ObjectiveUpdated(self, "", "");
                }
                BeadList[BeadList.Length] = theActor;
            }
            Index = BeadListCompleted.Find(theActor);
            // End:0x120
            if(Index != -1)
            {
                BeadListCompleted.Remove(Index, 1);
            }
            J0x120:

            actor_index++;
            // [Loop Continue]
            goto J0x25;
        }        
    }
    else
    {
        // End:0x257
        if(Action.InputLinks[1].bHasImpulse)
        {
            actor_index = 0;
            J0x152:

            // End:0x257 [Loop If]
            if(actor_index < Action.VariableLinks[1].LinkedVariables.Length)
            {
                theActor = Actor(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[actor_index]).GetObjectValue());
                // End:0x1C3
                if(theActor == none)
                {
                    // [Explicit Continue]
                    goto J0x24D;
                }
                Index = BeadList.Find(theActor);
                // End:0x224
                if(Index != -1)
                {
                    ObjectiveManager = GetObjectiveManager();
                    // End:0x218
                    if(ObjectiveManager != none)
                    {
                        ObjectiveManager.ObjectiveUpdated(self, "", "");
                    }
                    BeadList.Remove(Index, 1);
                }
                // End:0x24D
                if(BeadListCompleted.Find(theActor) == -1)
                {
                    BeadListCompleted[BeadListCompleted.Length] = theActor;
                }
                J0x24D:

                actor_index++;
                // [Loop Continue]
                goto J0x152;
            }
        }
    }
    //return;    
}

function OnUpdateMissionObjective(SeqAct_UpdateMissionObjective Action)
{
    local int input_link;
    local string Message;

    // End:0xCC
    if(Action.InputLinks[0].bHasImpulse)
    {
        Message = ParsePrompt(Prompts.ActivateString, Action);
        LogDisplayString = ParsePrompt(Prompts.LogBookString, Action);
        AddToManager(Message, GetNewObjectiveTitle());
        Class'Engine.JuiceSubsystem'.static.LevelEventD(2, 0, 5, "Gameplay", "Objective", string(ObjectiveName), 0, 0.0000000, "Activated", Location);        
    }
    else
    {
        // End:0x198
        if(Action.InputLinks[1].bHasImpulse)
        {
            Message = ParsePrompt(Prompts.SuccessString, Action);
            LogDisplayString = ParsePrompt(Prompts.LogBookString, Action);
            ChangeStatus(2, Message, GetObjectiveSuccessTitle());
            Class'Engine.JuiceSubsystem'.static.LevelEventD(2, 0, 5, "Gameplay", "Objective", string(ObjectiveName), 0, 0.0000000, "Success", Location);            
        }
        else
        {
            // End:0x240
            if(Action.InputLinks[2].bHasImpulse)
            {
                Message = ParsePrompt(Prompts.FailureString, Action);
                ChangeStatus(3, Message, GetObjectiveFailureTitle());
                Class'Engine.JuiceSubsystem'.static.LevelEventD(2, 0, 5, "Gameplay", "Objective", string(ObjectiveName), 0, 0.0000000, "Failed", Location);                
            }
            else
            {
                // End:0x2EB
                if(Action.InputLinks[3].bHasImpulse)
                {
                    // End:0x271
                    if(int(ObjectiveStatus) != int(1))
                    {
                        return;
                    }
                    Message = ParsePrompt(Prompts.DiscoverString, Action);
                    LogDisplayString = ParsePrompt(Prompts.LogBookString, Action);
                    OutputPrompt(Message, GetObjectiveDiscTitle(), GetObjectiveDiscRadioSoundCue(), GetObjectiveDiscRadioMixTime(), 1);                    
                }
                else
                {
                    // End:0x2FD
                    if(int(ObjectiveStatus) != int(1))
                    {
                        return;
                    }
                    input_link = Class'SeqAct_UpdateMissionObjective'.default.numNonMiscPromptLinks;
                    J0x311:

                    // End:0x3E2 [Loop If]
                    if(input_link < Action.InputLinks.Length)
                    {
                        // End:0x3D8
                        if(Action.InputLinks[input_link].bHasImpulse)
                        {
                            Message = ParsePrompt(Prompts.MiscString[input_link - Class'SeqAct_UpdateMissionObjective'.default.numNonMiscPromptLinks], Action);
                            LogDisplayString = ParsePrompt(Prompts.LogBookString, Action);
                            OutputPrompt(Message, GetObjectiveUpdatedTitle(), GetDefaultSoundCue(), GetDefaultMixTime());
                        }
                        input_link++;
                        // [Loop Continue]
                        goto J0x311;
                    }
                }
            }
        }
    }
    //return;    
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    LoadLocalizedStrings();
    ObjectiveStatus = 0;
    // End:0x35
    if(bStartActive)
    {
        SetTimer(0.2000000, false, 'AddToManager');
    }
    //return;    
}

function VerifyRespawnCleanup()
{
    PrintRespawnWarning();
    //return;    
}

defaultproperties
{
    PromptTitles=(ActivateTitle="New Objective",SuccessTitle="Objective Achieved",FailureTitle="Objective Failed",MiscTitle="Objective Update",DiscTitle="Objective Discovered",ActivateTitle_Optional="",SuccessTitle_Optional="",FailureTitle_Optional="",MiscTitle_Optional="",DiscTitle_Optional="")
    // Reference: SpriteComponent'Default__EALAObjective.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale=0.4000000
    end object
    Components[0]=Sprite
    TickGroup=1
    SupportedEvents=/* Array type was not detected. */
}