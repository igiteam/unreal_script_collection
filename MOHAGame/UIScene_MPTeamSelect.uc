class UIScene_MPTeamSelect extends UIScene_MPBase
    native
    hidecategories(Object,UIRoot,Object);

struct native PlayerTeamInfo
{
    var UILabelButton PlayerName;
    var UILabel PlayerNamePC;
    var MOHAPlayerReplicationInfo PRI;
    var bool IsLocalPlayer;

    structdefaultproperties
    {
        PlayerName=none
        PlayerNamePC=none
        PRI=none
        IsLocalPlayer=false
    }
};

var int TEAMSIZE;
var PlayerTeamInfo AllyTeam[7];
var PlayerTeamInfo AxisTeam[7];
var UIPanel AxisPanel;
var UIPanel AllyPanel;
var UILabel SelectAxis;
var UILabel SelectAllies;
var name SelectAxisWidgetName;
var name SelectAlliesWidgetName;
var name AllyTeamWidgetName[7];
var name AxisTeamWidgetName[7];
var name AxisPanelWidgetName;
var name AllyPanelWidgetName;

// Export UUIScene_MPTeamSelect::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

// Export UUIScene_MPTeamSelect::execUpdateTeamInfo(FFrame&, void* const)
native function UpdateTeamInfo();

// Export UUIScene_MPTeamSelect::execInitialTeamSelection(FFrame&, void* const)
native function InitialTeamSelection();

event SetupLabels()
{
    local int I;

    super.SetupLabels();
    AxisPanel = UIPanel(FindChild(AxisPanelWidgetName, true));
    AllyPanel = UIPanel(FindChild(AllyPanelWidgetName, true));
    SelectAxis = UILabel(FindChild(SelectAxisWidgetName, true));
    SelectAllies = UILabel(FindChild(SelectAlliesWidgetName, true));
    I = 0;
    J0x69:

    // End:0x136 [Loop If]
    if(I < TEAMSIZE)
    {
        AllyTeam[I].PlayerName = UILabelButton(FindChild(AllyTeamWidgetName[I], true));
        AllyTeam[I].PlayerNamePC = UILabel(FindChild(AllyTeamWidgetName[I], true));
        AxisTeam[I].PlayerName = UILabelButton(FindChild(AxisTeamWidgetName[I], true));
        AxisTeam[I].PlayerNamePC = UILabel(FindChild(AxisTeamWidgetName[I], true));
        I++;
        // [Loop Continue]
        goto J0x69;
    }
    //return;    
}

defaultproperties
{
    TEAMSIZE=7
    SelectAxisWidgetName="Select_Axis"
    SelectAlliesWidgetName="Select_Allies"
    AllyTeamWidgetName[0]="Allies1"
    AllyTeamWidgetName[1]="Allies2"
    AllyTeamWidgetName[2]="Allies3"
    AllyTeamWidgetName[3]="Allies4"
    AllyTeamWidgetName[4]="Allies5"
    AllyTeamWidgetName[5]="Allies6"
    AllyTeamWidgetName[6]="Allies7"
    AxisTeamWidgetName[0]="Axis1"
    AxisTeamWidgetName[1]="Axis2"
    AxisTeamWidgetName[2]="Axis3"
    AxisTeamWidgetName[3]="Axis4"
    AxisTeamWidgetName[4]="Axis5"
    AxisTeamWidgetName[5]="Axis6"
    AxisTeamWidgetName[6]="Axis7"
    AxisPanelWidgetName="AxisOff"
    AllyPanelWidgetName="AlliesOff"
    m_RemainingTimeWidgetName="Time"
    m_RemainingTimeTextWidgetName="TimeLeft"
    // Reference: UIComp_Event'Default__UIScene_MPTeamSelect.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}