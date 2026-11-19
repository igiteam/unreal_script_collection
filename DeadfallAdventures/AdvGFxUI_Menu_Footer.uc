class AdvGFxUI_Menu_Footer extends AdvGfxMoviePlayer
    config(UI);

const FOOTER_MAX_ITEMS = 4;

var GFxObject RootMC;
var GFxObject FooterMC;
var GFxObject HintMC;
var GFxObject DayMsgMC;
var GFxObject DayMC;
var GFxObject HintTF;
var GFxObject FooterTF;
var GFxObject FooterBottomTF;
var array<name> LocalButtonAliases;
var transient bool bHasGuestLoginOption;
var AdvFrontEnd Frontend;
var AdvNewsReader NewsReader;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    FooterMC = RootMC.GetObject("footer");
    HintMC = RootMC.GetObject("DayMsgMainMC");
    DayMsgMC = HintMC.GetObject("dayMsgMC");
    DayMC = DayMsgMC.GetObject("dayMC");
    HintTF = DayMC.GetObject("daymsgTF");
    FooterTF = FooterMC.GetObject("textField1");
    FooterBottomTF = FooterMC.GetObject("textField5");
    return true;
    //return ReturnValue;    
}

function InitializeMOTD()
{
    local bool bInitialize;

    bInitialize = true;
    // End:0x1DB
    if(bInitialize)
    {
        // End:0x1DB
        if(NewsReader == none)
        {
            NewsReader = AdvNewsReader(Class'Engine.GameEngine'.static.GetOnlineSubsystem().GetNamedInterface('NewsReader'));
            // End:0xE7
            if(NewsReader == none)
            {
                NewsReader = new Class'AdvNewsReader';
                Class'Engine.GameEngine'.static.GetOnlineSubsystem().SetNamedInterface('NewsReader', NewsReader);
            }
            // End:0x135
            if(NewsReader.HasDownloadedMOTD())
            {
                UpdateMOTD(NewsReader.GetMOTD());                
            }
            else
            {
                // End:0x1AB
                if(!NewsReader.IsDownloading())
                {
                    NewsReader.AddMOTDUpdatedDelegate(NewMOTD);
                    NewsReader.DownloadMOTD();                    
                }
                else
                {
                    NewsReader.AddMOTDUpdatedDelegate(NewMOTD);
                }
            }
        }
    }
    //return;    
}

function CloseMOTD()
{
    // End:0x69
    if(NewsReader != none)
    {
        NewsReader.ClearMOTDUpdatedDelegate(NewMOTD);
        NewsReader.Cleanup();
        NewsReader = none;
    }
    ClearHint();
    //return;    
}

function SetHintText(string Text)
{
    HintTF.SetBool("html", true);
    HintTF.SetString("htmlText", Text);
    //return;    
}

function ClearHint()
{
    HintTF.SetText(" ");
    //return;    
}

function FooterUpdate(array<name> ButtonAliases)
{
    FooterUpdateInternal(ButtonAliases);
    bHasGuestLoginOption = false;
    //return;    
}

function FooterUpdateInternal(array<name> ButtonAliases)
{
    local int I;
    local array<name> TempButtonAliases, TempButtonAliasesBottom;

    LocalButtonAliases = ButtonAliases;
    FooterTF.SetText(" ");
    FooterBottomTF.SetText(" ");
    I = 0;
    J0x64:

    // End:0xDD [Loop If]
    if(I < ButtonAliases.Length)
    {
        // End:0xAF
        if(I < 4)
        {
            TempButtonAliases.AddItem(ButtonAliases[I]);                        
        }
        else
        {
            TempButtonAliasesBottom.AddItem(ButtonAliases[I]);            
        }
        I++;
        // [Loop Continue]
        goto J0x64;
    }
    FooterTF.SetBool("html", true);
    FooterTF.SetString("htmlText", GetStringForFooterUpdateFromArray(TempButtonAliases));
    FooterBottomTF.SetBool("html", true);
    FooterBottomTF.SetString("htmlText", GetStringForFooterUpdateFromArray(TempButtonAliasesBottom));
    //return;    
}

static function string GetStringForFooterUpdate(name ButtonAlias)
{
    local DataStoreClient DSClient;
    local UIDataStore_InputAlias InputAliasDS;
    local string FooterString;

    FooterString = "";
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x80
    if(DSClient != none)
    {
        InputAliasDS = UIDataStore_InputAlias(DSClient.FindDataStore('ButtonCallouts'));
    }
    // End:0x99
    if(InputAliasDS == none)
    {
        return FooterString;
    }
    FooterString = InputAliasDS.GetAliasFontMarkup(ButtonAlias);
    return FooterString;
    //return ReturnValue;    
}

static function string GetStringForFooterUpdateFromArray(array<name> ButtonAliases)
{
    local DataStoreClient DSClient;
    local UIDataStore_InputAlias InputAliasDS;
    local int I;
    local string ButtonAliasString, FooterString;

    FooterString = "";
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x80
    if(DSClient != none)
    {
        InputAliasDS = UIDataStore_InputAlias(DSClient.FindDataStore('ButtonCallouts'));
    }
    // End:0x99
    if(InputAliasDS == none)
    {
        return FooterString;
    }
    // End:0xF1
    if(ButtonAliases.Length > 0)
    {
        ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[0]);
        FooterString = ButtonAliasString;
    }
    // End:0x19D
    if(ButtonAliases.Length > 1)
    {
        I = 1;
        J0x10C:

        // End:0x19D [Loop If]
        if(I < ButtonAliases.Length)
        {
            ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[I]);
            FooterString = (FooterString $ "            ") $ ButtonAliasString;
            I++;
            // [Loop Continue]
            goto J0x10C;
        }
    }
    return FooterString;
    //return ReturnValue;    
}

function OnFooter(int Index)
{
    //return;    
}

function Tick(float DeltaTime)
{
    super(UTGFxTweenableMoviePlayer).Tick(DeltaTime);
    // End:0x100
    if((((Frontend != none) && Frontend.bAllowGuestLogin) && !Frontend.bOnMPScreens) && !Frontend.CurrentScene.bDisableGuestLogin)
    {
        // End:0xFD
        if(!bHasGuestLoginOption && LocalButtonAliases.Length > 0)
        {
            LocalButtonAliases.AddItem('GuestLogin');            
            bHasGuestLoginOption = true;
            FooterUpdateInternal(LocalButtonAliases);
        }        
    }
    else
    {
        // End:0x142
        if(bHasGuestLoginOption)
        {
            LocalButtonAliases.RemoveItem('GuestLogin');            
            bHasGuestLoginOption = false;
            FooterUpdateInternal(LocalButtonAliases);
        }
    }
    //return;    
}

event OnCleanup()
{
    super(GFxMoviePlayer).OnCleanup();
    CloseMOTD();
    //return;    
}

function NewMOTD()
{
    NewsReader.ClearMOTDUpdatedDelegate(NewMOTD);
    UpdateMOTD(NewsReader.GetMOTD());
    //return;    
}

function UpdateMOTD(string MOTD)
{
    SetHintText(MOTD);
    //return;    
}

defaultproperties
{
    MovieInfo=SwfMovie'UI_AdvCommon.AdvFooter'
    bAllowFocus=false
    Priority=11
}