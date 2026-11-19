class UIScene_Objectives extends UIScene_MOHABase
    native
    hidecategories(Object,UIRoot,Object);

struct native ObjectiveData
{
    var name ObjectiveName;
    var UILabelButton Label;
    var UICheckbox Checkbox;
    var UICheckbox IndentedCheckbox;

    structdefaultproperties
    {
        ObjectiveName="None"
        Label=none
        Checkbox=none
        IndentedCheckbox=none
    }
};

var ObjectiveData LabelArray[14];
var array<name> WidgetNameArray;
var array<name> CheckboxNameArray;
var array<name> IndentedCheckboxNameArray;
var int m_DisplayIndex;
var int MAXOBJECTIVECOUNT;
var Material CompletedMaterial;

// Export UUIScene_Objectives::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

event SetupLabels()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x7A [Loop If]
    if(I < MAXOBJECTIVECOUNT)
    {
        LabelArray[I].Label = UILabelButton(FindChild(WidgetNameArray[I], true));
        LabelArray[I].Checkbox = UICheckbox(FindChild(CheckboxNameArray[I], true));
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x81:

    // End:0xCB [Loop If]
    if(I < IndentedCheckboxNameArray.Length)
    {
        LabelArray[I + 1].IndentedCheckbox = UICheckbox(FindChild(IndentedCheckboxNameArray[I], true));
        I++;
        // [Loop Continue]
        goto J0x81;
    }
    //return;    
}

function SetFocusedObjective(UILabelButton labelObj)
{
    local int I;
    local MOHAGameInfo GameInfo;
    local MOHAObjectiveManager objManager;

    GameInfo = MOHAGameInfo(GetWorldInfo().Game);
    objManager = GameInfo.GlobalObjectiveManager;
    // End:0xC7
    if((labelObj != none) && objManager != none)
    {
        objManager.ClearSelectionFlags();
        I = 0;
        J0x64:

        // End:0xC7 [Loop If]
        if(I < MAXOBJECTIVECOUNT)
        {
            // End:0xBD
            if(LabelArray[I].Label == labelObj)
            {
                objManager.SetSelectionByName(LabelArray[I].ObjectiveName);
                // [Explicit Break]
                goto J0xC7;
            }
            I++;
            // [Loop Continue]
            goto J0x64;
        }
    }
    J0xC7:

    //return;    
}

defaultproperties
{
    WidgetNameArray[0]="Objective0"
    WidgetNameArray[1]="Objective1"
    WidgetNameArray[2]="Objective2"
    WidgetNameArray[3]="Objective3"
    WidgetNameArray[4]="Objective4"
    WidgetNameArray[5]="Objective5"
    WidgetNameArray[6]="Objective6"
    WidgetNameArray[7]="Objective7"
    WidgetNameArray[8]="Objective8"
    WidgetNameArray[9]="Objective9"
    WidgetNameArray[10]="Objective10"
    WidgetNameArray[11]="Objective11"
    WidgetNameArray[12]="Objective12"
    WidgetNameArray[13]="Objective13"
    CheckboxNameArray[0]="CkbObjective0"
    CheckboxNameArray[1]="CkbObjective1"
    CheckboxNameArray[2]="CkbObjective2"
    CheckboxNameArray[3]="CkbObjective3"
    CheckboxNameArray[4]="CkbObjective4"
    CheckboxNameArray[5]="CkbObjective5"
    CheckboxNameArray[6]="CkbObjective6"
    CheckboxNameArray[7]="CkbObjective7"
    CheckboxNameArray[8]="CkbObjective8"
    CheckboxNameArray[9]="CkbObjective9"
    CheckboxNameArray[10]="CkbObjective10"
    CheckboxNameArray[11]="CkbObjective11"
    CheckboxNameArray[12]="CkbObjective12"
    CheckboxNameArray[13]="CkbObjective13"
    IndentedCheckboxNameArray[0]="CkbObjective1b"
    IndentedCheckboxNameArray[1]="CkbObjective2b"
    IndentedCheckboxNameArray[2]="CkbObjective3b"
    IndentedCheckboxNameArray[3]="CkbObjective4b"
    IndentedCheckboxNameArray[4]="CkbObjective5b"
    IndentedCheckboxNameArray[5]="CkbObjective6b"
    IndentedCheckboxNameArray[6]="CkbObjective7b"
    IndentedCheckboxNameArray[7]="CkbObjective8b"
    IndentedCheckboxNameArray[8]="CkbObjective9b"
    IndentedCheckboxNameArray[9]="CkbObjective10b"
    IndentedCheckboxNameArray[10]="CkbObjective11b"
    IndentedCheckboxNameArray[11]="CkbObjective12b"
    IndentedCheckboxNameArray[12]="CkbObjective13b"
    MAXOBJECTIVECOUNT=14
    CompletedMaterial=Material'UI_CommonResources.Textures.UI_TX_Map_Obj_Complete_Mat'
    bSaveSceneValuesOnClose=false
    // Reference: UIComp_Event'Default__UIScene_Objectives.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}