class PKGFxUI_TarotPopUp extends PKGfxMoviePlayer
    config(UI);

var GFxObject RootMC;
var GFxObject MenuMC;
var GFxObject InfoMC;
var GFxObject CardMC;
var GFxObject TitleMC;
var GFxObject ContinueMC;
var GFxObject ContinueTF;
var GFxObject TitleTF;
var GFxObject CardNameTF;
var GFxObject CardDescTF;
var GFxObject CardCostTF;
var GFxClikWidget CardUIL;
var GFxObject KursorMC;
var transient bool bContinueBlock;
var transient bool bIsMenuPPOverrideOn;
var array<Texture2D> GoldenCardsTextures;
var array<Texture2D> SilverCardsTextures;
//var delegate<OnCloseComplete> __OnCloseComplete__Delegate;

simulated function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    TitleMC = MenuMC.GetObject("title");
    CardMC = MenuMC.GetObject("card");
    InfoMC = MenuMC.GetObject("info");
    ContinueMC = MenuMC.GetObject("clicker");
    TitleTF = TitleMC.GetObject("textField");
    CardNameTF = InfoMC.GetObject("name_tf");
    CardDescTF = InfoMC.GetObject("info_tf");
    CardCostTF = InfoMC.GetObject("gold_tf");
    ContinueTF = ContinueMC.GetObject("clicker_mc").GetObject("click_tf");
    CardUIL = GFxClikWidget(CardMC.GetObject("UIL", Class'GFxUI.GFxClikWidget'));
    KursorMC = RootMC.GetObject("kursor");
    KursorMC.SetVisible(false);
    TitleTF.SetText(Localize("PKGFxUI_Stats", "CardUnlockedString", "PKHDGame"));
    ContinueTF.SetText(Localize("PKGFxUI_Stats", "ContinueLabel", "PKHDGame"));
    return true;
    //return ReturnValue;    
}

function SetGoldenCardAndPlay(PKTarotManager.EGoldenTarrotCard GoldCard)
{
    CardUIL.SetString("source", "img://" $ PathName(GoldenCardsTextures[int(GoldCard)]));
    CardNameTF.SetText(Class'PKTarotManager'.default.GoldenCardsList[int(GoldCard)].CardName);
    CardDescTF.SetText(Class'PKTarotManager'.default.GoldenCardsList[int(GoldCard)].CardDesc);
    CardCostTF.SetText(((Localize("PKGFxUI_TarotCards", "CostText", "PKHDGame")) $ ": ") $ string(Class'PKTarotManager'.default.GoldenCardsList[int(GoldCard)].Cost));
    bContinueBlock = true;
    PlayOpenAnimation();
    //return;    
}

function SetSilverCardAndPlay(PKTarotManager.ESilverTarrotCard SilverCard)
{
    CardUIL.SetString("source", "img://" $ PathName(SilverCardsTextures[int(SilverCard)]));
    CardNameTF.SetText(Class'PKTarotManager'.default.SilverCardsList[int(SilverCard)].CardName);
    CardDescTF.SetText(Class'PKTarotManager'.default.SilverCardsList[int(SilverCard)].CardDesc);
    CardCostTF.SetText(((Localize("PKGFxUI_TarotCards", "CostText", "PKHDGame")) $ ": ") $ string(Class'PKTarotManager'.default.SilverCardsList[int(SilverCard)].Cost));
    bContinueBlock = true;
    PlayOpenAnimation();
    //return;    
}

function PlayOpenAnimation()
{
    local PKPostProcessManager PP;

    MenuMC.GotoAndPlay("open");
    PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
    // End:0xA2
    if(PP != none)
    {
        PP.SetMenuOverride(true, 0.4000000);
        bIsMenuPPOverrideOn = true;
    }
    //return;    
}

function PlayCloseAnimation()
{
    local PKPostProcessManager PP;

    MenuMC.GotoAndPlay("close");
    // End:0xB0
    if(bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        // End:0xB0
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.4000000);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function OnOpenAnimationComplete()
{
    bContinueBlock = false;
    //return;    
}

function OnCloseAnimationComplete()
{
    OnCloseComplete();
    //return;    
}

delegate OnCloseComplete()
{
    //return;    
}

function OnContinue()
{
    // End:0x25
    if(!bContinueBlock)
    {
        bContinueBlock = true;
        PlayCloseAnimation();
    }
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x2F
    if(int(InputEvent) == int(0))
    {
        // End:0x2D
        if(!bContinueBlock)
        {
            OnContinue();
        }
        return true;
    }
    return super(GFxMoviePlayer).FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

event OnClose()
{
    local PKPostProcessManager PP;

    super(GFxMoviePlayer).OnClose();
    // End:0x94
    if(bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        // End:0x94
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.0000000, false);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

defaultproperties
{
    bContinueBlock=true
    GoldenCardsTextures[0]=none
    GoldenCardsTextures[1]=Texture2D'PKHD_UI.TC_Endurance'
    GoldenCardsTextures[2]=Texture2D'PKHD_UI.TC_Haste'
    GoldenCardsTextures[3]=Texture2D'PKHD_UI.TC_Time_Bonus'
    GoldenCardsTextures[4]=Texture2D'PKHD_UI.TC_Speed'
    GoldenCardsTextures[5]=Texture2D'PKHD_UI.TC_Fury'
    GoldenCardsTextures[6]=Texture2D'PKHD_UI.TC_Double_Haste'
    GoldenCardsTextures[7]=Texture2D'PKHD_UI.TC_Dexterity'
    GoldenCardsTextures[8]=Texture2D'PKHD_UI.TC_Immunity'
    GoldenCardsTextures[9]=Texture2D'PKHD_UI.TC_Rage'
    GoldenCardsTextures[10]=Texture2D'PKHD_UI.TC_Double_Time_Bonus'
    GoldenCardsTextures[11]=Texture2D'PKHD_UI.TC_Triple_Haste'
    GoldenCardsTextures[12]=Texture2D'PKHD_UI.TC_Confusion'
    GoldenCardsTextures[13]=none
    GoldenCardsTextures[14]=none
    GoldenCardsTextures[15]=none
    GoldenCardsTextures[16]=none
    GoldenCardsTextures[17]=none
    SilverCardsTextures[0]=none
    SilverCardsTextures[1]=Texture2D'PKHD_UI.PC_Soul_Keeper'
    SilverCardsTextures[2]=Texture2D'PKHD_UI.PC_Blessing'
    SilverCardsTextures[3]=Texture2D'PKHD_UI.PC_Health_Regeneration'
    SilverCardsTextures[4]=Texture2D'PKHD_UI.PC_Dark_Soul'
    SilverCardsTextures[5]=Texture2D'PKHD_UI.PC_Soul_Catcher'
    SilverCardsTextures[6]=Texture2D'PKHD_UI.PC_Forgiveness'
    SilverCardsTextures[7]=Texture2D'PKHD_UI.PC_Double_Treasure'
    SilverCardsTextures[8]=Texture2D'PKHD_UI.PC_Vitality'
    SilverCardsTextures[9]=Texture2D'PKHD_UI.PC_Divine_Intervention'
    SilverCardsTextures[10]=Texture2D'PKHD_UI.PC_Last_Breath'
    SilverCardsTextures[11]=Texture2D'PKHD_UI.PC_Armor_Regeneration'
    SilverCardsTextures[12]=Texture2D'PKHD_UI.PC_Mercy'
    SilverCardsTextures[13]=Texture2D'PKHD_UI.DLC_Fear'
    SilverCardsTextures[14]=Texture2D'PKHD_UI.DLC_Healt_Stealer'
    SilverCardsTextures[15]=Texture2D'PKHD_UI.DLC_Armor_Regeneration'
    SilverCardsTextures[16]=Texture2D'PKHD_UI.DLC_666_Ammo'
    SilverCardsTextures[17]=Texture2D'PKHD_UI.DLC_Health_Regeneration'
    MovieInfo=SwfMovie'PKHD_UI.PKTarrotAdd'
    bCaptureInput=true
    bHideLesserMovies=true
    Priority=80
}