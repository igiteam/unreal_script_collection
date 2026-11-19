class PKGFxUI_Menu_Footer extends PKGfxMoviePlayer
    config(UI);

const FOOTER_MAX_ITEMS = 8;

var GFxObject RootMC;
var GFxObject FooterMC;
var array<GFxObject> FooterTF;
var array<GFxClikWidget> FooterBtn;
var array<name> LocalButtonAliases;
var transient bool bHasGuestLoginOption;
var PKFrontEnd FrontEnd;

function bool Start(optional bool StartPaused = false)
{
    local int I;

    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    FooterMC = RootMC.GetObject("footer");
    I = 0;
    J0x81:

    // End:0x149 [Loop If]
    if(I < 8)
    {
        FooterTF[I] = FooterMC.GetObject("textField" $ string(I + 1));
        FooterBtn[I] = GFxClikWidget(FooterMC.GetObject("foot" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        I++;
        // [Loop Continue]
        goto J0x81;
    }
    return true;
    //return ReturnValue;    
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

    LocalButtonAliases = ButtonAliases;
    I = 0;
    J0x1E:

    // End:0x9C [Loop If]
    if(I < 8)
    {
        FooterTF[I].SetText(" ");
        FooterBtn[I].SetBool("visible", false);
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    I = 0;
    J0xA7:

    // End:0x191 [Loop If]
    if(I < ButtonAliases.Length)
    {
        // End:0x183
        if(I < 8)
        {
            FooterTF[I].SetBool("html", true);
            FooterTF[I].SetString("htmlText", GetStringForFooterUpdate(ButtonAliases[I]));
            FooterBtn[I].SetBool("visible", true);
        }
        I++;
        // [Loop Continue]
        goto J0xA7;
    }
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
    if((((FrontEnd != none) && FrontEnd.bAllowGuestLogin) && !FrontEnd.bOnMPScreens) && !FrontEnd.CurrentScene.bDisableGuestLogin)
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

defaultproperties
{
    MovieInfo=SwfMovie'PKHD_UI.PKFooter'
    bAllowFocus=false
    Priority=3
}