class AdvGFxUI_Menu_MultiStartingScreen extends AdvGFxUI_Menu_MultiClassSelection
    config(UI);

var GFxObject TimeToStartTF;
var transient float DelayToStart;
var transient float LastSecondsTimer;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    TimeToStartTF = ButtonsMC.GetObject("timetostartTF");
    BackBtn.SetVisible(false);
    return true;
    //return ReturnValue;    
}

function OnCloseAnimationComplete()
{
    super.OnCloseAnimationComplete();
    AdvGFxHudWrapper(GetPC().myHUD).AdvMultiStartingScreenMovie = none;
    AdvPlayerControllerMP(GetPC()).SetReadyStatus();
    //return;    
}

function SetNextSpawnInventory(int NextSpawnClassIndex)
{
    super.SetNextSpawnInventory(NextSpawnClassIndex);
    bShouldDisplayClassChangedInfo = false;
    //return;    
}

function OnBack(EventData ev)
{
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    footer.FooterUpdate(ButtonAliases);
    //return;    
}

function Tick(float DeltaTime)
{
    local EventData ev;

    // End:0x1DE
    if(bMovieIsOpen)
    {
        DelayToStart -= GetPC().WorldInfo.DeltaSeconds;
        // End:0xBC
        if(DelayToStart > float(0))
        {
            // End:0xB9
            if((DelayToStart + LastSecondsTimer) > float(1))
            {
                TimeToStartTF.SetText(string(int(DelayToStart)));
                LastSecondsTimer = DelayToStart;
            }            
        }
        else
        {
            switch(CurrentViewedClassIndex)
            {
                // End:0xE9
                case 0:
                    OnClass1(ev);
                    // End:0x1DE
                    break;
                // End:0x103
                case 1:
                    OnClass2(ev);
                    // End:0x1DE
                    break;
                // End:0x11E
                case 2:
                    OnClass3(ev);
                    // End:0x1DE
                    break;
                // End:0x139
                case 3:
                    OnClass4(ev);
                    // End:0x1DE
                    break;
                // End:0x154
                case 4:
                    OnClass5(ev);
                    // End:0x1DE
                    break;
                // End:0x16F
                case 5:
                    OnClass6(ev);
                    // End:0x1DE
                    break;
                // End:0x18A
                case 6:
                    OnClass7(ev);
                    // End:0x1DE
                    break;
                // End:0x1A5
                case 7:
                    OnClass8(ev);
                    // End:0x1DE
                    break;
                // End:0x1C0
                case 8:
                    OnClass9(ev);
                    // End:0x1DE
                    break;
                // End:0x1DB
                case 9:
                    OnClass10(ev);
                    // End:0x1DE
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
    }
    else
    {
        //return;        
    }
}

defaultproperties
{
    DelayToStart=20.0000000
}