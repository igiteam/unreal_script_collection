class AdvGFxUI_Menu_PlayerstatsMP extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject RowsMC;
var GFxObject TitleTF;
var GFxObject GeneralLabelTF;
var GFxObject CollectedLabelTF;
var GFxObject ActionsLabelTF;
var GFxClikWidget BackBtn;
var GFxObject GeneralMC[5];
var GFxObject CollectedMC[6];
var GFxObject ActionsMC[13];
var GFxObject GeneralTF[5];
var GFxObject CollectedTF[6];
var GFxObject ActionsTF[13];
var GFxObject GeneralScore[5];
var GFxObject CollectedScore[6];
var GFxObject ActionsScore[13];
var const localized string TitleString;
var const localized string GeneralString;
var const localized string CollectedString;
var const localized string ActionsString;
var const localized string GeneralStat[5];
var const localized string CollectedStat[5];
var const localized string ActionsStat[13];
var string RatioColorMap[10];

function bool Start(optional bool StartPaused = false)
{
    local int I;

    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = ButtonsMC.GetObject("title");
    RowsMC = ButtonsMC.GetObject("rows");
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x1C2
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF = TitleMC.GetObject("textField");
    GeneralLabelTF = RowsMC.GetObject("generalTF");
    CollectedLabelTF = RowsMC.GetObject("collectedTF");
    ActionsLabelTF = RowsMC.GetObject("actionsTF");
    I = 0;
    J0x2A3:

    // End:0x408 [Loop If]
    if(I < 5)
    {
        GeneralMC[I] = RowsMC.GetObject("general" $ string(I + 1));
        GeneralTF[I] = GeneralMC[I].GetObject("nameTF");
        GeneralScore[I] = GeneralMC[I].GetObject("scoreTF");
        GeneralScore[I].SetBool("html", true);
        GeneralTF[I].SetText(GeneralStat[I]);
        I++;
        // [Loop Continue]
        goto J0x2A3;
    }
    I = 0;
    J0x413:

    // End:0x57A [Loop If]
    if(I < 5)
    {
        CollectedMC[I] = RowsMC.GetObject("collected" $ string(I + 1));
        CollectedTF[I] = CollectedMC[I].GetObject("nameTF");
        CollectedScore[I] = CollectedMC[I].GetObject("scoreTF");
        CollectedScore[I].SetBool("html", true);
        CollectedTF[I].SetText(CollectedStat[I]);
        I++;
        // [Loop Continue]
        goto J0x413;
    }
    I = 0;
    J0x585:

    // End:0x6EA [Loop If]
    if(I < 13)
    {
        ActionsMC[I] = RowsMC.GetObject("actions" $ string(I + 1));
        ActionsTF[I] = ActionsMC[I].GetObject("nameTF");
        ActionsScore[I] = ActionsMC[I].GetObject("scoreTF");
        ActionsScore[I].SetBool("html", true);
        ActionsTF[I].SetText(ActionsStat[I]);
        I++;
        // [Loop Continue]
        goto J0x585;
    }
    TitleTF.SetText(TitleString);
    GeneralLabelTF.SetText(ActionsString);
    CollectedLabelTF.SetText(CollectedString);
    ActionsLabelTF.SetText(GeneralString);
    UpdateStats();
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericBack');    
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function UpdateStats()
{
    local AdvPlayerController PKPC;

    PKPC = AdvPlayerController(GetPC());
    GeneralScore[0].SetText("" $ string(PKPC.GetGlobalStat(115)));
    GeneralScore[1].SetText("" $ string(PKPC.GetGlobalStat(116)));
    GeneralScore[2].SetText("" $ string(PKPC.GetGlobalStat(117)));
    GeneralScore[3].SetText("" $ string(PKPC.GetGlobalStat(118)));
    GeneralScore[4].SetText("" $ string(PKPC.GetGlobalStat(121)));
    CollectedScore[0].SetText("" $ string(PKPC.GetGlobalStat(119)));
    CollectedScore[1].SetText("" $ string(PKPC.GetGlobalStat(120)));
    CollectedScore[2].SetText("" $ string(PKPC.GetGlobalStat(122)));
    CollectedScore[3].SetText("" $ string(PKPC.GetGlobalStat(123)));
    CollectedScore[4].SetText("" $ string(PKPC.GetGlobalStat(124)));
    ActionsScore[0].SetText("" $ Class'AdvGFxUI_Stats'.static.ConvertSecondsToTimeString(PKPC.GetGlobalStat(152)));
    ActionsScore[1].SetText("" $ string(PKPC.GetGlobalStat(125)));
    ActionsScore[2].SetText("" $ string(PKPC.GetGlobalStat(126)));
    ActionsScore[3].SetText("" $ string(PKPC.GetGlobalStat(127)));
    ActionsScore[4].SetText("" $ string(PKPC.GetGlobalStat(128)));
    ActionsScore[5].SetText("" $ string(PKPC.GetGlobalStat(129)));
    ActionsScore[6].SetText("" $ string(PKPC.GetGlobalStat(130)));
    ActionsScore[7].SetText("" $ string(PKPC.GetGlobalStat(131)));
    ActionsScore[8].SetText("" $ string(PKPC.GetGlobalStat(132)));
    ActionsScore[9].SetText("" $ string(PKPC.GetGlobalStat(133)));
    ActionsScore[10].SetText("" $ string(PKPC.GetGlobalStat(134)));
    ActionsScore[11].SetText("" $ string(PKPC.GetGlobalStat(135)));
    ActionsScore[12].SetText("" $ string(PKPC.GetGlobalStat(136)));
    //return;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnCloseAnimationComplete()
{
    switch(Action)
    {
        // End:0x60
        case "back":
            // End:0x5D
            if(Frontend.OpenLeaderStatsScreen())
            {
                Frontend.ClosePlayerStatsMPScreen();
            }
            // End:0x66
            break;
        // End:0xFFFF
        default:
            // End:0x66
            break;
            break;
    }
    Action = "";
    //return;    
}

static function string InjectStatToColorString(float stat)
{
    local int Index, Value;

    Value = int(stat * float(100));
    // End:0x39
    if(Value > 90)
    {
        Index = 0;        
    }
    else
    {
        // End:0x57
        if(Value > 80)
        {
            Index = 1;            
        }
        else
        {
            // End:0x76
            if(Value > 70)
            {
                Index = 2;                
            }
            else
            {
                // End:0x95
                if(Value > 60)
                {
                    Index = 3;                    
                }
                else
                {
                    // End:0xB4
                    if(Value > 50)
                    {
                        Index = 4;                        
                    }
                    else
                    {
                        // End:0xD3
                        if(Value > 40)
                        {
                            Index = 5;                            
                        }
                        else
                        {
                            // End:0xF2
                            if(Value > 30)
                            {
                                Index = 6;                                
                            }
                            else
                            {
                                // End:0x111
                                if(Value > 20)
                                {
                                    Index = 7;                                    
                                }
                                else
                                {
                                    // End:0x130
                                    if(Value > 10)
                                    {
                                        Index = 8;                                        
                                    }
                                    else
                                    {
                                        Index = 9;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return Repl(default.RatioColorMap[Index], "*p", "" $ string(Value));
    //return ReturnValue;    
}

defaultproperties
{
    TitleString="Multiplayer Stats"
    GeneralString="General"
    CollectedString="Collected"
    ActionsString="Actions"
    GeneralStat[0]="Kills"
    GeneralStat[1]="Deaths"
    GeneralStat[2]="Assists"
    GeneralStat[3]="Trap Kills"
    GeneralStat[4]="Rescues"
    CollectedStat[0]="Artifacts Captured"
    CollectedStat[1]="Artifacts Returned"
    CollectedStat[2]="Gold Statues Collected"
    CollectedStat[3]="Silver Statues Collected"
    CollectedStat[4]="Blessings Obtained"
    ActionsStat[0]="Playing time"
    ActionsStat[1]="Deathmatch Score"
    ActionsStat[2]="Team Deathmatch Score"
    ActionsStat[3]="Capture The Artifact Score"
    ActionsStat[4]="Last Man Standing Score"
    ActionsStat[5]="Treasure Hunt Score"
    ActionsStat[6]="Team Treasure Hunt Score"
    ActionsStat[7]="Deathmatch Matches Won"
    ActionsStat[8]="Team Deathmatch Matches Won"
    ActionsStat[9]="Capture The Artifact Matches Won"
    ActionsStat[10]="Last Man Standing Matches Won"
    ActionsStat[11]="Treasure Hunt Matches Won"
    ActionsStat[12]="Team Treasure Hunt Matches Won"
    RatioColorMap[0]="<font color='#7fff00'>*p %</font>"
    RatioColorMap[1]="<font color='#C0ff3e'>*p %</font>"
    RatioColorMap[2]="<font color='#ffEC8B'>*p %</font>"
    RatioColorMap[3]="<font color='#ffC125'>*p %</font>"
    RatioColorMap[4]="<font color='#eead0e'>*p %</font>"
    RatioColorMap[5]="<font color='#ee7600'>*p %</font>"
    RatioColorMap[6]="<font color='#CD6600'>*p %</font>"
    RatioColorMap[7]="<font color='#eea2ad'>*p %</font>"
    RatioColorMap[8]="<font color='#ff3030'>*p %</font>"
    RatioColorMap[9]="<font color='#CD2626'>*p %</font>"
    MovieInfoPath="UI_AdvUI.AdvPlayerStatsMulti"
}