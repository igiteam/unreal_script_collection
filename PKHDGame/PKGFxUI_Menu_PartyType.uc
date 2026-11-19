class PKGFxUI_Menu_PartyType extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject DescriptionTF;
var GFxObject AcceptTF;
var GFxObject CancelTF;
var array<GFxClikWidget> PartyTypeBtn;
var const localized string TitleString;
var const localized array<localized string> PartyTypeString;
var const localized array<localized string> PartyDescriptionString;

function bool Start(optional bool StartPaused = false)
{
    local int I;
    local DataStoreClient DSClient;
    local UIDataStore_InputAlias InputAliasDS;

    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x79
    if(DSClient != none)
    {
        InputAliasDS = UIDataStore_InputAlias(DSClient.FindDataStore('ButtonCallouts'));
    }
    // End:0x88
    if(InputAliasDS == none)
    {
    }
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    DescriptionTF = ButtonsMC.GetObject("poleInfo").GetObject("textField");
    AcceptTF = MenuMC.GetObject("batons").GetObject("textField1");
    CancelTF = MenuMC.GetObject("batons").GetObject("textField2");
    I = 0;
    J0x24F:

    // End:0x314 [Loop If]
    if(I < 3)
    {
        PartyTypeBtn[I] = GFxClikWidget(ButtonsMC.GetObject(("type" $ string(I + 1)) $ "_btn", Class'GFxUI.GFxClikWidget'));
        PartyTypeBtn[I].SetString("label", PartyTypeString[I]);
        I++;
        // [Loop Continue]
        goto J0x24F;
    }
    TitleTF.SetText(TitleString);
    // End:0x43E
    if(InputAliasDS != none)
    {
        AcceptTF.SetBool("html", true);
        AcceptTF.SetString("htmlText", InputAliasDS.GetAliasFontMarkup('GenericSelect'));
        CancelTF.SetBool("html", true);
        CancelTF.SetString("htmlText", InputAliasDS.GetAliasFontMarkup('GenericBack'));
    }
    UpdatePartyTypePanel();
    return true;
    //return ReturnValue;    
}

function UpdatePartyTypePanel()
{
    local PKTypes.EPKPartyType PartyType;
    local bool bOnlinePartyAvailable;
    local int I;

    bOnlinePartyAvailable = GetPC().CanAllPlayersPlayOnline() && Class'Engine.Engine'.static.GetEngine().GamePlayers.Length < 2;
    I = 0;
    J0x74:

    // End:0xD1 [Loop If]
    if(I < 2)
    {
        PartyTypeBtn[I].SetBool("disabled", !bOnlinePartyAvailable);
        I++;
        // [Loop Continue]
        goto J0x74;
    }
    PartyType = GetMenuGRI().CurrentPartyType;
    // End:0x146
    if(int(PartyType) < int(2))
    {
        PartyTypeBtn[int(PartyType)].SetBool("focused", true);        
    }
    else
    {
        PartyTypeBtn[0].SetBool("focused", true);
    }
    DescriptionTF.SetText(PartyDescriptionString[int(PartyType)]);
    //return;    
}

function ChangePartyType(PKTypes.EPKPartyType NewPartyType)
{
    local PKTypes.EPKPartyType BackupPartyType;
    local bool bWasSuccessful;

    BackupPartyType = GetMenuGRI().CurrentPartyType;
    GetMenuGRI().CurrentPartyType = NewPartyType;
    bWasSuccessful = (int(NewPartyType) == int(2)) || FrontEnd.AttemptNetworkedMatchTransition(int(GetMenuGame().MultiGameModeSelected) == int(5));
    // End:0xD4
    if(bWasSuccessful)
    {
        PlayCloseAnimation();        
    }
    else
    {
        GetMenuGRI().CurrentPartyType = BackupPartyType;
        UpdatePartyTypePanel();
    }
    //return;    
}

function OnBack(int ControllerIdx)
{
    PlayCloseAnimation();
    //return;    
}

function Callback_FocusChange(int TypeIndex)
{
    DescriptionTF.SetText(PartyDescriptionString[TypeIndex]);
    //return;    
}

function Callback_TypeChange(int TypeIndex, int ControllerIdx)
{
    ChangePartyType(byte(TypeIndex));
    //return;    
}

function OnCloseAnimationComplete()
{
    FrontEnd.ClosePartyTypeWindow();
    //return;    
}

defaultproperties
{
    TitleString="Party Type"
    PartyTypeString[0]="Private session"
    PartyTypeString[1]="Public"
    PartyTypeString[2]="Local"
    PartyDescriptionString[0]="Only invited players can join"
    PartyDescriptionString[1]="All players can join"
    PartyDescriptionString[2]="Only local connected Controllers can play"
    MovieInfo=SwfMovie'PKHD_UI.PKPartyType'
    bHideLesserMovies=true
}