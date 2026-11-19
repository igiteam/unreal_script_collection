class AdvGFxUI_Menu_Playerstats extends AdvGFxUI_Menu_Base
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
var GFxObject ActionsMC[10];
var GFxObject GeneralTF[5];
var GFxObject CollectedTF[6];
var GFxObject ActionsTF[10];
var GFxObject GeneralScore[5];
var GFxObject CollectedScore[6];
var GFxObject ActionsScore[10];
var const localized string TitleString;
var const localized string GeneralString;
var const localized string CollectedString;
var const localized string ActionsString;
var const localized string GeneralStat[5];
var const localized string CollectedStat[6];
var const localized string ActionsStat[10];
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
    if(I < 6)
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
    if(I < 10)
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
    GeneralLabelTF.SetText(GeneralString);
    CollectedLabelTF.SetText(CollectedString);
    ActionsLabelTF.SetText(ActionsString);
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
                Frontend.ClosePlayerStatsScreen();
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
    TitleString="Campaign Stats"
    GeneralString="General"
    CollectedString="Collected"
    ActionsString="Actions"
    GeneralStat[0]="Campaign maps completed"
    GeneralStat[1]="Multiplayer matches played"
    GeneralStat[2]="Multiplayer matches won"
    GeneralStat[3]="Artifacts captured"
    GeneralStat[4]="Gold spent on Tarrot cards"
    CollectedStat[0]="Souls"
    CollectedStat[1]="Gold"
    CollectedStat[2]="Ammo"
    CollectedStat[3]="Secrets"
    CollectedStat[4]="Holy items"
    CollectedStat[5]="Armors"
    ActionsStat[0]="Shots fired"
    ActionsStat[1]="Kills"
    ActionsStat[2]="Gibs"
    ActionsStat[3]="Hit ratio"
    ActionsStat[4]="Gib ratio"
    ActionsStat[5]="Bunny ratio"
    ActionsStat[6]="Demon ratio"
    ActionsStat[7]="Barrels exploded"
    ActionsStat[8]="Explosive kills"
    ActionsStat[9]="Kills in Survival"
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
    MovieInfoPath="UI_AdvUI.AdvPlayerStats"
}