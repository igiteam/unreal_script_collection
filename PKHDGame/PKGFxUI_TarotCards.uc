class PKGFxUI_TarotCards extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject CardsGoldMC;
var GFxObject CardsSilverMC;
var GFxObject SelectedGoldMC;
var GFxObject SelectedSilverMC;
var array<GFxObject> OwnageGoldMC;
var array<GFxObject> OwnageSilverMC;
var array<GFxObject> CardGold_g;
var array<GFxObject> CardSilver_g;
var array<GFxObject> SelectedGold_g;
var array<GFxObject> SelectedSilver_g;
var array<GFxClikWidget> CardGoldBtn;
var array<GFxClikWidget> CardSilverBtn;
var array<GFxClikWidget> SelectedGoldBtn;
var array<GFxClikWidget> SelectedSilverBtn;
var GFxObject DLCBG;
var GFxObject DLCCard_g;
var GFxClikWidget DLCCardBtn;
var GFxObject GoldMC;
var GFxObject BackMC;
var GFxObject GoldTF;
var GFxObject GoldDescTF;
var GFxObject BackTF;
var GFxClikWidget BackBtn;
var GFxObject DescriptionMC;
var GFxObject NameTF;
var GFxObject DescTF;
var GFxObject CostTF;
var GFxObject CostDescTF;
var array<byte> AvailableCardsGold;
var array<byte> AvailableCardsSilver;
var PKTarotManager.EGoldenTarrotCard SelectedCardGold;
var PKTarotManager.ESilverTarrotCard SelectedCardSilver;
var PKTarotManager.EGoldenTarrotCard MyGoldMPCard[2];
var PKTarotManager.ESilverTarrotCard MySilverMPCard[2];
var bool CardsCostNoMoney;
var bool bIsCoop;
var bool bIsMPClient;
var bool bShowStartText;
var transient bool bIsMenuPPOverrideOn;
var const localized string BackText;
var const localized string StartText;
var const localized string ExitText;
var const localized string DeselectText;
var const localized string GoldText;
var const localized string CostText;
var const localized string WaitingText;
var PKGFxUI_Menu_Footer footer;
var int CurrentMoney;
var SoundCue DenyRemoveCard;

function bool Start(optional bool StartPaused = false)
{
    local int I;
    local PainGRI GRI;
    local PKPlayerController PC;
    local PKPostProcessManager PP;
    local bool bHasAnyDLC;

    PC = PKPlayerController(GetPC());
    GRI = PainGRI(PC.WorldInfo.GRI);
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    KursorMC = RootMC.GetObject("cursor");
    CardsGoldMC = RootMC.GetObject("CardsGoldMC");
    CardsSilverMC = RootMC.GetObject("CardsSilverMC");
    SelectedGoldMC = RootMC.GetObject("SelectedGoldMC");
    SelectedSilverMC = RootMC.GetObject("SelectedSilverMC");
    DLCBG = RootMC.GetObject("DLCBG");
    GoldMC = RootMC.GetObject("GoldMC");
    BackMC = GoldMC.GetObject("BackMC");
    GoldDescTF = GoldMC.GetObject("costam");
    GoldTF = GoldMC.GetObject("GoldTextMC").GetObject("textField");
    BackTF = GoldMC.GetObject("startback");
    BackBtn = GFxClikWidget(BackMC.GetObject("BackBtn", Class'GFxUI.GFxClikWidget'));
    DescriptionMC = RootMC.GetObject("DescriptionMC");
    NameTF = DescriptionMC.GetObject("NameTF");
    DescTF = DescriptionMC.GetObject("DescTF");
    CostTF = DescriptionMC.GetObject("CostTF");
    CostDescTF = DescriptionMC.GetObject("CostDescTF");
    CurrentMoney = PC.ProfileSettings.GetGold();
    PC.UpdateCardsAndGoldStatus(GRI);
    I = 0;
    J0x4CD:

    // End:0x66A [Loop If]
    if(I < 12)
    {
        CardGold_g[I] = CardsGoldMC.GetObject(("CardGold" $ string(I + 1)) $ "MC").GetObject(("CardGold" $ string(I + 1)) $ "_g");
        CardGold_g[I].SetVisible(false);
        CardGoldBtn[I] = GFxClikWidget(CardsGoldMC.GetObject(("CardGold" $ string(I + 1)) $ "MC").GetObject("CardGold" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        CardGoldBtn[I].SetString("label", " ");
        I++;
        // [Loop Continue]
        goto J0x4CD;
    }
    I = 0;
    J0x675:

    // End:0x8C3 [Loop If]
    if(I < 3)
    {
        SelectedGold_g[I] = SelectedGoldMC.GetObject(("GoldSelected" $ string(I + 1)) $ "MC").GetObject(("GoldSelected" $ string(I + 1)) $ "_g");
        SelectedGold_g[I].SetVisible(false);
        OwnageGoldMC[I] = SelectedGoldMC.GetObject(("GoldSelected" $ string(I + 1)) $ "MC").GetObject("ownage");
        OwnageGoldMC[I].GotoAndStopI(1);
        SelectedGoldBtn[I] = GFxClikWidget(SelectedGoldMC.GetObject(("GoldSelected" $ string(I + 1)) $ "MC").GetObject("GoldSelected" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        SelectedGoldBtn[I].SetString("label", " ");
        I++;
        // [Loop Continue]
        goto J0x675;
    }
    I = 0;
    J0x8CE:

    // End:0xA73 [Loop If]
    if(I < 17)
    {
        CardSilver_g[I] = CardsSilverMC.GetObject(("CardSilver" $ string(I + 1)) $ "MC").GetObject(("CardSilver" $ string(I + 1)) $ "_g");
        CardSilver_g[I].SetVisible(false);
        CardSilverBtn[I] = GFxClikWidget(CardsSilverMC.GetObject(("CardSilver" $ string(I + 1)) $ "MC").GetObject("CardSilver" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        CardSilverBtn[I].SetString("label", " ");
        I++;
        // [Loop Continue]
        goto J0x8CE;
    }
    I = 0;
    J0xA7E:

    // End:0xCD6 [Loop If]
    if(I < 2)
    {
        SelectedSilver_g[I] = SelectedSilverMC.GetObject(("SelectedSilver" $ string(I + 1)) $ "MC").GetObject(("SelectedSilver" $ string(I + 1)) $ "_g");
        SelectedSilver_g[I].SetVisible(false);
        OwnageSilverMC[I] = SelectedSilverMC.GetObject(("SelectedSilver" $ string(I + 1)) $ "MC").GetObject("ownage");
        OwnageSilverMC[I].GotoAndStopI(1);
        SelectedSilverBtn[I] = GFxClikWidget(SelectedSilverMC.GetObject(("SelectedSilver" $ string(I + 1)) $ "MC").GetObject("SelectedSilver" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        SelectedSilverBtn[I].SetString("label", " ");
        I++;
        // [Loop Continue]
        goto J0xA7E;
    }
    DLCCardBtn = GFxClikWidget(SelectedSilverMC.GetObject("SelectedSilver3MC").GetObject("SelectedSilver3", Class'GFxUI.GFxClikWidget'));
    DLCCardBtn.SetString("label", " ");
    DLCCardBtn.SetBool("visible", false);
    DLCCard_g = SelectedSilverMC.GetObject("SelectedSilver3MC");
    DLCCard_g.SetVisible(false);
    bHasAnyDLC = false;
    I = 8;
    J0xE14:

    // End:0xE80 [Loop If]
    if(I <= 12)
    {
        // End:0xE72
        if(int(PKPlayerController(GetPC()).IsDLCInstalled(byte(I))) == int(1))
        {
            bHasAnyDLC = true;
            // [Explicit Break]
            goto J0xE80;
        }
        I++;
        // [Loop Continue]
        goto J0xE14;
    }
    J0xE80:

    // End:0xF81
    if(!bHasAnyDLC)
    {
        RootMC.SetFloat("_x", RootMC.GetFloat("_x") - float(90));
        I = 13 - 1;
        J0xEEA:

        // End:0xF81 [Loop If]
        if(I < 17)
        {
            DLCBG.SetVisible(false);
            CardsSilverMC.GetObject(("CardSilver" $ string(I + 1)) $ "MC").SetVisible(false);
            I++;
            // [Loop Continue]
            goto J0xEEA;
        }
    }
    bIsCoop = false;
    // End:0xFDB
    if(int(GetPC().WorldInfo.NetMode) == int(NM_Client))
    {
        bIsMPClient = true;        
    }
    else
    {
        bIsMPClient = false;
    }
    GoldTF.SetText(" ");
    NameTF.SetText(" ");
    DescTF.SetText(" ");
    CostTF.SetText(" ");
    CostDescTF.SetText(" ");
    // End:0x10CF
    if(bIsMPClient)
    {
        GoldDescTF.SetText(WaitingText);        
    }
    else
    {
        GoldDescTF.SetText(GoldText);
    }
    UpdateLocalCopyOfAvailableCards();
    UpdateCards();
    // End:0x1145
    if(bIsMPClient)
    {
        BackTF.SetText(ExitText);        
    }
    else
    {
        // End:0x117E
        if(bShowStartText)
        {
            BackTF.SetText(StartText);            
        }
        else
        {
            BackTF.SetText(BackText);
        }
    }
    // End:0x1204
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        KursorMC.SetVisible(false);        
    }
    else
    {
        KursorMC.SetVisible(EvilGFxHudWrapper(GetPC().myHUD).bShowCursor);
    }
    // End:0x1327
    if(GetPC().WorldInfo.IsConsoleBuild(0) && FrontEnd == none)
    {
        // End:0x131D
        if(footer == none)
        {
            footer = new Class'PKGFxUI_Menu_Footer';
            footer.SetPriority(67);
            footer.Init(GetLP());
        }
        UpdateFooter();
    }
    PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
    // End:0x13A4
    if(PP != none)
    {
        PP.SetMenuOverride(true, 0.4000000);
        bIsMenuPPOverrideOn = true;
    }
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    // End:0x3E
    if(FrontEnd != none)
    {
        ButtonAliases.AddItem('GenericBack');        
    }
    else
    {
        ButtonAliases.AddItem('MainMenu');
    }
    // End:0xEF
    if(!bIsMPClient && GetPC().WorldInfo.IsConsoleBuild(0) || GetPC().PlayerInput.bUsingGamepad)
    {
        ButtonAliases.AddItem('TarotDiscard');
    }
    // End:0x13E
    if(FrontEnd != none)
    {
        FrontEnd.footer.FooterUpdate(ButtonAliases);        
    }
    else
    {
        // End:0x175
        if(footer != none)
        {
            footer.FooterUpdate(ButtonAliases);
        }
    }
    //return;    
}

function UpdateLocalCopyOfAvailableCards()
{
    local int I;
    local PainGRI GRI;
    local PKPlayerController PC;

    PC = PKPlayerController(GetPC());
    GRI = PainGRI(PC.WorldInfo.GRI);
    I = 0;
    J0x6E:

    // End:0xC8 [Loop If]
    if(I < 18)
    {
        AvailableCardsGold[I] = GRI.AvailableCardsGold[I];
        I++;
        // [Loop Continue]
        goto J0x6E;
    }
    I = 0;
    J0xD3:

    // End:0x12D [Loop If]
    if(I < 18)
    {
        AvailableCardsSilver[I] = GRI.AvailableCardsSilver[I];
        I++;
        // [Loop Continue]
        goto J0xD3;
    }
    I = 0;
    J0x138:

    // End:0x1C0 [Loop If]
    if(I < 3)
    {
        // End:0x1B2
        if(int(GRI.SelectedGoldCards[I]) != int(0))
        {
            AvailableCardsGold[int(GRI.SelectedGoldCards[I])] = 0;
        }
        I++;
        // [Loop Continue]
        goto J0x138;
    }
    I = 0;
    J0x1CB:

    // End:0x253 [Loop If]
    if(I < 2)
    {
        // End:0x245
        if(int(GRI.SelectedSilverCards[I]) != int(0))
        {
            AvailableCardsSilver[int(GRI.SelectedSilverCards[I])] = 0;
        }
        I++;
        // [Loop Continue]
        goto J0x1CB;
    }
    //return;    
}

function UpdateCards()
{
    local int I, J;
    local PainGRI GRI;
    local PKPlayerController PKPC;
    local bool bMyCardNeedFix;

    GRI = PainGRI(GetPC().WorldInfo.GRI);
    PKPC = PKPlayerController(GetPC());
    CurrentMoney = PKPC.ProfileSettings.GetGold();
    // End:0xD5
    if(bIsMPClient)
    {
        GoldTF.SetText(" ");        
    }
    else
    {
        GoldTF.SetText(string(CurrentMoney));
    }
    // End:0x155
    if(bIsCoop)
    {
        SelectedGoldMC.GetObject("GoldSelected3MC").SetVisible(false);
    }
    I = 0;
    J0x160:

    // End:0x2D5 [Loop If]
    if(I < CardGoldBtn.Length)
    {
        // End:0x269
        if(int(AvailableCardsGold[I + 1]) == int(1))
        {
            CardGoldBtn[I].SetString("label", Class'PKTarotManager'.default.GoldenCardsList[I + 1].CardName);
            CardGoldBtn[I].SetBool("disabled", false);
            CardGold_g[I].SetVisible(true);            
        }
        else
        {
            CardGoldBtn[I].SetString("label", " ");
            CardGold_g[I].SetVisible(false);
        }
        I++;
        // [Loop Continue]
        goto J0x160;
    }
    bMyCardNeedFix = true;
    I = 0;
    J0x2EC:

    // End:0x60E [Loop If]
    if(I < SelectedGoldBtn.Length)
    {
        // End:0x4F4
        if(int(GRI.SelectedGoldCards[I]) != int(0))
        {
            SelectedGoldBtn[I].SetString("label", Class'PKTarotManager'.default.GoldenCardsList[int(GRI.SelectedGoldCards[I])].CardName);
            SelectedGold_g[I].SetVisible(true);
            SelectedGold_g[I].GotoAndStopI(int(GRI.SelectedGoldCards[I]));
            // End:0x4F1
            if(bIsCoop)
            {
                J = 0;
                J0x459:

                // End:0x4F1 [Loop If]
                if(J < 2)
                {
                    // End:0x4E3
                    if(int(MyGoldMPCard[J]) == int(GRI.SelectedGoldCards[I]))
                    {
                        OwnageGoldMC[I].GotoAndStopI(J + 2);
                    }
                    J++;
                    // [Loop Continue]
                    goto J0x459;
                }
            }            
        }
        else
        {
            SelectedGoldBtn[I].SetString("label", " ");
            SelectedGold_g[I].SetVisible(false);
            OwnageGoldMC[I].GotoAndStopI(1);
        }
        // End:0x600
        if(int(GRI.SelectedGoldCards[I]) == int(MyGoldMPCard[LocalPlayer(GetPC().Player).ControllerId]))
        {
            bMyCardNeedFix = false;
        }
        I++;
        // [Loop Continue]
        goto J0x2EC;
    }
    // End:0x665
    if(bMyCardNeedFix)
    {
        MyGoldMPCard[LocalPlayer(GetPC().Player).ControllerId] = 0;
    }
    I = 0;
    J0x670:

    // End:0x7E5 [Loop If]
    if(I < CardSilverBtn.Length)
    {
        // End:0x779
        if(int(AvailableCardsSilver[I + 1]) == int(1))
        {
            CardSilverBtn[I].SetString("label", Class'PKTarotManager'.default.SilverCardsList[I + 1].CardName);
            CardSilverBtn[I].SetBool("disabled", false);
            CardSilver_g[I].SetVisible(true);            
        }
        else
        {
            CardSilverBtn[I].SetString("label", " ");
            CardSilver_g[I].SetVisible(false);
        }
        I++;
        // [Loop Continue]
        goto J0x670;
    }
    CardsCostNoMoney = false;
    bMyCardNeedFix = true;
    I = 0;
    J0x808:

    // End:0xB69 [Loop If]
    if(I < SelectedSilverBtn.Length)
    {
        // End:0xA10
        if(int(GRI.SelectedSilverCards[I]) != int(0))
        {
            SelectedSilverBtn[I].SetString("label", Class'PKTarotManager'.default.SilverCardsList[int(GRI.SelectedSilverCards[I])].CardName);
            SelectedSilver_g[I].SetVisible(true);
            SelectedSilver_g[I].GotoAndStopI(int(GRI.SelectedSilverCards[I]));
            // End:0xA0D
            if(bIsCoop)
            {
                J = 0;
                J0x975:

                // End:0xA0D [Loop If]
                if(J < 2)
                {
                    // End:0x9FF
                    if(int(MySilverMPCard[J]) == int(GRI.SelectedSilverCards[I]))
                    {
                        OwnageSilverMC[I].GotoAndStopI(J + 2);
                    }
                    J++;
                    // [Loop Continue]
                    goto J0x975;
                }
            }            
        }
        else
        {
            SelectedSilverBtn[I].SetString("label", " ");
            SelectedSilver_g[I].SetVisible(false);
            OwnageSilverMC[I].GotoAndStopI(1);
        }
        // End:0xAD7
        if(int(GRI.SelectedSilverCards[I]) == int(9))
        {
            CardsCostNoMoney = true;
        }
        // End:0xB5B
        if(int(GRI.SelectedSilverCards[I]) == int(MySilverMPCard[LocalPlayer(GetPC().Player).ControllerId]))
        {
            bMyCardNeedFix = false;
        }
        I++;
        // [Loop Continue]
        goto J0x808;
    }
    // End:0xBC0
    if(bMyCardNeedFix)
    {
        MySilverMPCard[LocalPlayer(GetPC().Player).ControllerId] = 0;
    }
    // End:0xCC2
    if((int(PKPlayerController(GetPC()).IsDLCInstalled(1)) == int(1)) && Class'PKTarotManager'.default.SilverCardsList.Length > 13)
    {
        DLCCard_g.SetVisible(true);
        DLCCardBtn.SetBool("visible", true);
        DLCCardBtn.SetString("label", Class'PKTarotManager'.default.SilverCardsList[13].CardName);
    }
    //return;    
}

function OnCardGoldClick(int Index, int ControllerId)
{
    local int I;
    local PainGRI GRI;

    // End:0x0F
    if(bIsMPClient)
    {
        return;
    }
    GRI = PainGRI(GetPC().WorldInfo.GRI);
    // End:0x85
    if(bIsCoop && int(MyGoldMPCard[ControllerId]) != int(0))
    {
        return;
    }
    // End:0xA9
    if(int(AvailableCardsGold[int(byte(Index))]) == int(0))
    {
        return;
    }
    SelectedCardGold = byte(Index);
    SelectedCardSilver = 0;
    I = 0;
    J0xD5:

    // End:0x14D [Loop If]
    if(I < SelectedGoldBtn.Length)
    {
        // End:0x13F
        if(int(GRI.SelectedGoldCards[I]) == int(0))
        {
            OnSelectedGoldClick(I, ControllerId);
            // [Explicit Break]
            goto J0x14D;
        }
        I++;
        // [Loop Continue]
        goto J0xD5;
    }
    J0x14D:

    SelectedCardGold = 0;
    //return;    
}

function OnSelectedGoldClick(int Index, int ControllerId)
{
    local PainGRI GRI;
    local PKPlayerController PKPC;

    PKPC = PKPlayerController(GetPC());
    GRI = PainGRI(GetPC().WorldInfo.GRI);
    // End:0x73
    if(bIsMPClient)
    {
        return;
    }
    // End:0x22F
    if(((int(SelectedCardGold) > int(0)) && int(GRI.SelectedGoldCards[Index]) == int(0)) && CardsCostNoMoney || CurrentMoney >= Class'PKTarotManager'.default.GoldenCardsList[int(SelectedCardGold)].Cost)
    {
        AvailableCardsGold[int(SelectedCardGold)] = 0;
        StoreSelectedGold(Index, SelectedCardGold);
        // End:0x176
        if(bIsCoop)
        {
            MyGoldMPCard[ControllerId] = SelectedCardGold;
        }
        // End:0x22C
        if(!CardsCostNoMoney)
        {
            CurrentMoney -= Class'PKTarotManager'.default.GoldenCardsList[int(SelectedCardGold)].Cost;
            PKPC.IncrementGlobalIntStat(136, Class'PKTarotManager'.default.GoldenCardsList[int(SelectedCardGold)].Cost);
        }        
    }
    else
    {
        // End:0x3A5
        if((int(SelectedCardGold) == int(0)) && !bIsCoop || int(GRI.SelectedGoldCards[Index]) == int(MyGoldMPCard[ControllerId]))
        {
            // End:0x3A5
            if(int(GRI.SelectedGoldCards[Index]) != int(0))
            {
                AvailableCardsGold[int(GRI.SelectedGoldCards[Index])] = 1;
                // End:0x37A
                if(!CardsCostNoMoney)
                {
                    CurrentMoney += Class'PKTarotManager'.default.GoldenCardsList[int(GRI.SelectedGoldCards[Index])].Cost;
                }
                StoreSelectedGold(Index, 0);
                MyGoldMPCard[ControllerId] = 0;
            }
        }
    }
    PKPC.SetGold(CurrentMoney);
    SelectedCardGold = 0;
    SelectedCardSilver = 0;
    UpdateCards();
    //return;    
}

function StoreSelectedGold(int Index, PKTarotManager.EGoldenTarrotCard CardGold)
{
    local PainGRI GRI;
    local PKPlayerController PKPC;

    PKPC = PKPlayerController(GetPC());
    GRI = PainGRI(GetPC().WorldInfo.GRI);
    GRI.SelectedGoldCards[Index] = CardGold;
    // End:0x1A9
    if(PKPC.PersistentData != none)
    {
        switch(Index)
        {
            // End:0x115
            case 0:
                PKPC.PersistentData.SetValue(37, int(CardGold));
                // End:0x1A9
                break;
            // End:0x15D
            case 1:
                PKPC.PersistentData.SetValue(38, int(CardGold));
                // End:0x1A9
                break;
            // End:0x1A6
            case 2:
                PKPC.PersistentData.SetValue(39, int(CardGold));
                // End:0x1A9
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

function OnCardSilverClick(int Index, int ControllerId)
{
    local int I;
    local PainGRI GRI;

    // End:0x0F
    if(bIsMPClient)
    {
        return;
    }
    GRI = PainGRI(GetPC().WorldInfo.GRI);
    // End:0x85
    if(bIsCoop && int(MySilverMPCard[ControllerId]) != int(0))
    {
        return;
    }
    // End:0xA9
    if(int(AvailableCardsSilver[int(byte(Index))]) == int(0))
    {
        return;
    }
    SelectedCardSilver = byte(Index);
    SelectedCardGold = 0;
    I = 0;
    J0xD5:

    // End:0x14D [Loop If]
    if(I < SelectedSilverBtn.Length)
    {
        // End:0x13F
        if(int(GRI.SelectedSilverCards[I]) == int(0))
        {
            OnSelectedSilverClick(I, ControllerId);
            // [Explicit Break]
            goto J0x14D;
        }
        I++;
        // [Loop Continue]
        goto J0xD5;
    }
    J0x14D:

    SelectedCardSilver = 0;
    //return;    
}

function bool CheckIfBoardIsEmpty()
{
    local PainGRI GRI;
    local int I;

    GRI = PainGRI(GetPC().WorldInfo.GRI);
    I = 0;
    J0x52:

    // End:0xA5 [Loop If]
    if(I < 2)
    {
        // End:0x97
        if(int(GRI.SelectedSilverCards[I]) != int(0))
        {
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0x52;
    }
    I = 0;
    J0xB0:

    // End:0x103 [Loop If]
    if(I < 2)
    {
        // End:0xF5
        if(int(GRI.SelectedGoldCards[I]) != int(0))
        {
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0xB0;
    }
    return true;
    //return ReturnValue;    
}

function bool CheckIfDivineInterventionCanBeRemoved()
{
    local PainGRI GRI;
    local int I;

    GRI = PainGRI(GetPC().WorldInfo.GRI);
    I = 0;
    J0x52:

    // End:0xDA [Loop If]
    if(I < 2)
    {
        // End:0xCC
        if((int(GRI.SelectedSilverCards[I]) != int(0)) && int(GRI.SelectedSilverCards[I]) != int(9))
        {
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0x52;
    }
    I = 0;
    J0xE5:

    // End:0x138 [Loop If]
    if(I < 3)
    {
        // End:0x12A
        if(int(GRI.SelectedGoldCards[I]) != int(0))
        {
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0xE5;
    }
    return true;
    //return ReturnValue;    
}

function OnSelectedSilverClick(int Index, int ControllerId)
{
    local PainGRI GRI;
    local int I;
    local PKPlayerController PKPC;

    // End:0x0F
    if(bIsMPClient)
    {
        return;
    }
    PKPC = PKPlayerController(GetPC());
    GRI = PainGRI(GetPC().WorldInfo.GRI);
    // End:0x2A3
    if(((int(SelectedCardSilver) > int(0)) && int(GRI.SelectedSilverCards[Index]) == int(0)) && CardsCostNoMoney || CurrentMoney >= Class'PKTarotManager'.default.SilverCardsList[int(SelectedCardSilver)].Cost)
    {
        // End:0x16C
        if((int(SelectedCardSilver) == int(9)) && !CheckIfBoardIsEmpty())
        {
            PKPC.PlaySound(DenyRemoveCard);
            return;
        }
        AvailableCardsSilver[int(SelectedCardSilver)] = 0;
        StoreSelectedSilver(Index, SelectedCardSilver);
        // End:0x1CA
        if(bIsCoop)
        {
            MySilverMPCard[ControllerId] = SelectedCardSilver;
        }
        // End:0x1EA
        if(int(SelectedCardSilver) == int(9))
        {
            CardsCostNoMoney = true;
        }
        // End:0x2A0
        if(!CardsCostNoMoney)
        {
            CurrentMoney -= Class'PKTarotManager'.default.SilverCardsList[int(SelectedCardSilver)].Cost;
            PKPC.IncrementGlobalIntStat(136, Class'PKTarotManager'.default.SilverCardsList[int(SelectedCardSilver)].Cost);
        }        
    }
    else
    {
        // End:0x48C
        if(int(SelectedCardSilver) == int(0))
        {
            // End:0x48C
            if((int(GRI.SelectedSilverCards[Index]) != int(0)) && !bIsCoop || int(GRI.SelectedSilverCards[Index]) == int(MySilverMPCard[ControllerId]))
            {
                // End:0x3B4
                if((int(GRI.SelectedSilverCards[Index]) == int(9)) && !CheckIfDivineInterventionCanBeRemoved())
                {
                    PKPC.PlaySound(DenyRemoveCard);
                    return;
                }
                AvailableCardsSilver[int(GRI.SelectedSilverCards[Index])] = 1;
                // End:0x461
                if(!CardsCostNoMoney)
                {
                    CurrentMoney += Class'PKTarotManager'.default.SilverCardsList[int(GRI.SelectedSilverCards[Index])].Cost;
                }
                StoreSelectedSilver(Index, 0);
                MySilverMPCard[ControllerId] = 0;
            }
        }
    }
    PKPC.SetGold(CurrentMoney);
    SelectedCardGold = 0;
    SelectedCardSilver = 0;
    UpdateCards();
    //return;    
}

function StoreSelectedSilver(int Index, PKTarotManager.ESilverTarrotCard CardSilver)
{
    local PainGRI GRI;
    local PKPlayerController PKPC;

    PKPC = PKPlayerController(GetPC());
    GRI = PainGRI(GetPC().WorldInfo.GRI);
    GRI.SelectedSilverCards[Index] = CardSilver;
    // End:0x160
    if(PKPC.PersistentData != none)
    {
        switch(Index)
        {
            // End:0x115
            case 0:
                PKPC.PersistentData.SetValue(45, int(CardSilver));
                // End:0x160
                break;
            // End:0x15D
            case 1:
                PKPC.PersistentData.SetValue(46, int(CardSilver));
                // End:0x160
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

function OnDeselectCards(int ControllerId)
{
    local int I;
    local PainGRI GRI;

    // End:0x0F
    if(bIsMPClient)
    {
        return;
    }
    GRI = PainGRI(GetPC().WorldInfo.GRI);
    SelectedCardGold = 0;
    SelectedCardSilver = 0;
    I = 0;
    J0x79:

    // End:0xEE [Loop If]
    if(I < SelectedGoldBtn.Length)
    {
        // End:0xE0
        if(int(GRI.SelectedGoldCards[I]) != int(0))
        {
            OnSelectedGoldClick(I, ControllerId);
        }
        I++;
        // [Loop Continue]
        goto J0x79;
    }
    I = 0;
    J0xF9:

    // End:0x16E [Loop If]
    if(I < SelectedSilverBtn.Length)
    {
        // End:0x160
        if(int(GRI.SelectedSilverCards[I]) != int(0))
        {
            OnSelectedSilverClick(I, ControllerId);
        }
        I++;
        // [Loop Continue]
        goto J0xF9;
    }
    //return;    
}

function OnCardGoldOver(int Index)
{
    // End:0x15A
    if(int(AvailableCardsGold[Index]) == int(1))
    {
        NameTF.SetText(Class'PKTarotManager'.default.GoldenCardsList[Index].CardName);
        DescTF.SetText(Class'PKTarotManager'.default.GoldenCardsList[Index].CardDesc);
        CostTF.SetText(string(Class'PKTarotManager'.default.GoldenCardsList[Index].Cost));
        CostDescTF.SetText(CostText);
    }
    //return;    
}

function OnSelectedGoldOver(int Index)
{
    local PainGRI GRI;

    GRI = PainGRI(GetPC().WorldInfo.GRI);
    // End:0x219
    if(int(GRI.SelectedGoldCards[Index]) != int(0))
    {
        NameTF.SetText(Class'PKTarotManager'.default.GoldenCardsList[int(GRI.SelectedGoldCards[Index])].CardName);
        DescTF.SetText(Class'PKTarotManager'.default.GoldenCardsList[int(GRI.SelectedGoldCards[Index])].CardDesc);
        CostTF.SetText(string(Class'PKTarotManager'.default.GoldenCardsList[int(GRI.SelectedGoldCards[Index])].Cost));
        CostDescTF.SetText(CostText);
    }
    //return;    
}

function OnCardSilverOver(int Index)
{
    // End:0x15A
    if(int(AvailableCardsSilver[Index]) == int(1))
    {
        NameTF.SetText(Class'PKTarotManager'.default.SilverCardsList[Index].CardName);
        DescTF.SetText(Class'PKTarotManager'.default.SilverCardsList[Index].CardDesc);
        CostTF.SetText(string(Class'PKTarotManager'.default.SilverCardsList[Index].Cost));
        CostDescTF.SetText(CostText);
    }
    //return;    
}

function OnSelectedSilverOver(int Index)
{
    local PainGRI GRI;

    GRI = PainGRI(GetPC().WorldInfo.GRI);
    // End:0x158
    if(Index > 1)
    {
        NameTF.SetText(Localize("PKTarotManager", "BonusSilverCard1Name", "PKHDGame"));
        DescTF.SetText(Localize("PKTarotManager", "BonusSilverDard1Desc", "PKHDGame"));
        CostTF.SetText("0");
        CostDescTF.SetText(CostText);
        return;
    }
    // End:0x32A
    if(int(GRI.SelectedSilverCards[Index]) != int(0))
    {
        NameTF.SetText(Class'PKTarotManager'.default.SilverCardsList[int(GRI.SelectedSilverCards[Index])].CardName);
        DescTF.SetText(Class'PKTarotManager'.default.SilverCardsList[int(GRI.SelectedSilverCards[Index])].CardDesc);
        CostTF.SetText(string(Class'PKTarotManager'.default.SilverCardsList[int(GRI.SelectedSilverCards[Index])].Cost));
        CostDescTF.SetText(CostText);
    }
    //return;    
}

event OnClose()
{
    local PKPostProcessManager PP;

    super.OnClose();
    // End:0x44
    if(footer != none)
    {
        footer.Close();
        footer = none;
    }
    // End:0xCE
    if(bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        // End:0xCE
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.4000000, false);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function OnExit(EventData ev)
{
    local array<name> ButtonAliases;

    // End:0x55
    if((FrontEnd != none) && FrontEnd.OpenMapSelectScreen())
    {
        FrontEnd.CloseTarotScreen();        
    }
    else
    {
        // End:0x145
        if(bIsMPClient)
        {
            ButtonAliases.AddItem('GenericYes');
            ButtonAliases.AddItem('GenericNo');
            Class'PKUIManager'.static.ShowUIMessage('ReturnConfirm', Localize("Online", "BackToMain", "PKHDGame"), Localize("MessageBoxStrings", "ExitGame_Message", "PKHDGame"), ButtonAliases, OnExitOptionSelected, GetLP(),,,, false,,, true);            
        }
        else
        {
            // End:0x1AF
            if(bShowStartText)
            {
                PainGFxHudWrapper(GetPC().myHUD).CloseTarotMenu();
                Class'PKGFxUI_EndStats'.static.StartNextLevel();
            }
        }
    }
    //return;    
}

function OnBack(EventData ev)
{
    local array<name> ButtonAliases;

    // End:0x46
    if(FrontEnd != none)
    {
        FrontEnd.bShouldInstantLoadAfterTarot = false;
        OnExit(ev);        
    }
    else
    {
        ButtonAliases.AddItem('GenericYes');
        ButtonAliases.AddItem('GenericNo');
        Class'PKUIManager'.static.ShowUIMessage('ReturnConfirm', Localize("Online", "BackToMain", "PKHDGame"), Localize("MessageBoxStrings", "ExitGame_Message", "PKHDGame"), ButtonAliases, OnExitOptionSelected, GetLP(),,,, false,,, true);
    }
    //return;    
}

function bool OnExitOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x7F
    if(SelectedInputAlias == 'GenericYes')
    {
        PainGFxHudWrapper(GetPC().myHUD).CloseTarotMenu();
        PKPlayerController(GetPC()).ReturnToMainMenu(false);
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    BackText="Back to menu"
    StartText="Start Game"
    ExitText="Exit Game"
    DeselectText="Discard cards"
    GoldText="Your Gold"
    CostText="Card Cost"
    WaitingText="Waiting for server to start..."
    DenyRemoveCard=SoundCue'a_Cards.Cue.card-cannot_use'
    MovieInfo=SwfMovie'PKHD_UI.PKTarotCards'
    bHideLesserMovies=true
    Priority=65
}