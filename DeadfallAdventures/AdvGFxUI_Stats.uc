class AdvGFxUI_Stats extends AdvGfxMoviePlayer
    config(UI);

var GFxObject RootMC;
var GFxObject ContinueMC;
var GFxObject StatsMC;
var GFxObject ContinueTF;
var GFxObject GameTimeMC;
var GFxObject DifficultyMC;
var GFxObject KillsMC;
var GFxObject SoulsMC;
var GFxObject GoldMC;
var GFxObject ArmorsMC;
var GFxObject HolyMC;
var GFxObject AmmoMC;
var GFxObject ObjectsMC;
var GFxObject SecretsMC;
var GFxObject StatusMC;
var GFxObject StatusInfoMC;
var GFxObject Status2MC;
var GFxObject StatusInfo2MC;
var GFxObject GameTimeDescTF;
var GFxObject DifficultyDescTF;
var GFxObject KillsDescTF;
var GFxObject SoulsDescTF;
var GFxObject GoldDescTF;
var GFxObject ArmorsDescTF;
var GFxObject HolyDescTF;
var GFxObject AmmoDescTF;
var GFxObject ObjectsDescTF;
var GFxObject SecretsDescTF;
var GFxObject StatusDescTF;
var GFxObject StatusInfoDescTF;
var GFxObject StatusDesc2TF;
var GFxObject StatusInfoDesc2TF;
var GFxObject GameTimeValueTF;
var GFxObject DifficultyValueTF;
var GFxObject KillsValueTF;
var GFxObject SoulsValueTF;
var GFxObject GoldValueTF;
var GFxObject ArmorsValueTF;
var GFxObject HolyValueTF;
var GFxObject AmmoValueTF;
var GFxObject ObjectsValueTF;
var GFxObject SecretsValueTF;
var GFxObject StatusValueTF;
var GFxObject StatusInfoValueTF;
var GFxObject StatusValue2TF;
var GFxObject StatusInfoValue2TF;
var GFxObject KillsTotalTF;
var GFxObject SoulsTotalTF;
var GFxObject GoldTotalTF;
var GFxObject ArmorsTotalTF;
var GFxObject HolyTotalTF;
var GFxObject AmmoTotalTF;
var GFxObject ObjectsTotalTF;
var GFxObject SecretsTotalTF;
var GFxObject GoldBonusTF;
var GFxObject ArmorsStarMC;
var GFxObject HolyStarMC;
var GFxObject AmmoStarMC;
var GFxObject ObjectsStarMC;
var GFxObject SecretsStarMC;
var transient bool bContinueBlock;
var const localized string ContinueLabel;
var const localized string GameTimeDesc;
var const localized string DifficultyDesc;
var const localized string KillsDesc;
var const localized string SoulsDesc;
var const localized string GoldDesc;
var const localized string ArmorsDesc;
var const localized string HolyDesc;
var const localized string AmmoDesc;
var const localized string ObjectsDesc;
var const localized string SecretsDesc;
var const localized string StatusDesc;
var const localized string StatusInfoDesc;
var const localized string StatusDesc2;
var const localized string StatusInfoDesc2;
var const localized string StatusUnlockedString;
var const localized string LockedString;
var const localized string StatusFailedString;
var const localized string NAString;
var const localized string TEMPSTATUSINFO;
var AdvTypes.ELevelID LevelIDOverride;
var() LevelStatistics LocalMenuLevelStatistics;

simulated function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    ContinueMC = RootMC.GetObject("continueMC");
    StatsMC = RootMC.GetObject("statsMC");
    ContinueTF = ContinueMC.GetObject("continueTF").GetObject("textField");
    GameTimeMC = StatsMC.GetObject("gametimeMC");
    DifficultyMC = StatsMC.GetObject("difficultyMC");
    KillsMC = StatsMC.GetObject("killsMC");
    SoulsMC = StatsMC.GetObject("soulsMC");
    GoldMC = StatsMC.GetObject("goldMC");
    ArmorsMC = StatsMC.GetObject("armorsMC");
    HolyMC = StatsMC.GetObject("holyMC");
    AmmoMC = StatsMC.GetObject("ammoMC");
    ObjectsMC = StatsMC.GetObject("objectsMC");
    SecretsMC = StatsMC.GetObject("secretsMC");
    StatusInfoMC = StatsMC.GetObject("statusinfoMC");
    StatusMC = StatsMC.GetObject("statusMC");
    StatusInfo2MC = StatsMC.GetObject("statusinfoMC2");
    Status2MC = StatsMC.GetObject("statusMC2");
    GameTimeDescTF = GameTimeMC.GetObject("desc");
    GameTimeValueTF = GameTimeMC.GetObject("value");
    DifficultyDescTF = DifficultyMC.GetObject("desc");
    DifficultyValueTF = DifficultyMC.GetObject("value");
    KillsDescTF = KillsMC.GetObject("desc");
    KillsValueTF = KillsMC.GetObject("value");
    KillsTotalTF = KillsMC.GetObject("total");
    SoulsDescTF = SoulsMC.GetObject("desc");
    SoulsValueTF = SoulsMC.GetObject("value");
    SoulsTotalTF = SoulsMC.GetObject("total");
    GoldDescTF = GoldMC.GetObject("desc");
    GoldValueTF = GoldMC.GetObject("value");
    GoldTotalTF = GoldMC.GetObject("total");
    GoldBonusTF = GoldMC.GetObject("bonusgold");
    ArmorsDescTF = ArmorsMC.GetObject("desc");
    ArmorsValueTF = ArmorsMC.GetObject("value");
    ArmorsTotalTF = ArmorsMC.GetObject("total");
    ArmorsStarMC = ArmorsMC.GetObject("star_armours");
    HolyDescTF = HolyMC.GetObject("desc");
    HolyValueTF = HolyMC.GetObject("value");
    HolyTotalTF = HolyMC.GetObject("total");
    HolyStarMC = HolyMC.GetObject("star_holy");
    AmmoDescTF = AmmoMC.GetObject("desc");
    AmmoValueTF = AmmoMC.GetObject("value");
    AmmoTotalTF = AmmoMC.GetObject("total");
    AmmoStarMC = AmmoMC.GetObject("star_ammo");
    ObjectsDescTF = ObjectsMC.GetObject("desc");
    ObjectsValueTF = ObjectsMC.GetObject("value");
    ObjectsTotalTF = ObjectsMC.GetObject("total");
    ObjectsStarMC = ObjectsMC.GetObject("star_objects");
    SecretsDescTF = SecretsMC.GetObject("desc");
    SecretsValueTF = SecretsMC.GetObject("value");
    SecretsTotalTF = SecretsMC.GetObject("total");
    SecretsStarMC = SecretsMC.GetObject("star_secrets");
    StatusInfoDescTF = StatusInfoMC.GetObject("desc");
    StatusInfoValueTF = StatusInfoMC.GetObject("value");
    StatusInfoDesc2TF = StatusInfo2MC.GetObject("desc");
    StatusInfoValue2TF = StatusInfo2MC.GetObject("value");
    StatusDescTF = StatusMC.GetObject("desc");
    StatusValueTF = StatusMC.GetObject("value");
    StatusDesc2TF = Status2MC.GetObject("desc");
    StatusValue2TF = Status2MC.GetObject("value");
    ContinueTF.SetText(ContinueLabel);
    GameTimeDescTF.SetText(GameTimeDesc);
    DifficultyDescTF.SetText(DifficultyDesc);
    KillsDescTF.SetText(KillsDesc);
    SoulsDescTF.SetText(SoulsDesc);
    GoldDescTF.SetText(GoldDesc);
    ArmorsDescTF.SetText(ArmorsDesc);
    HolyDescTF.SetText(HolyDesc);
    AmmoDescTF.SetText(AmmoDesc);
    ObjectsDescTF.SetText(ObjectsDesc);
    SecretsDescTF.SetText(SecretsDesc);
    StatusInfoDescTF.SetText(StatusInfoDesc);
    StatusDescTF.SetText(StatusDesc);
    StatusInfoDesc2TF.SetText(StatusInfoDesc);
    StatusDesc2TF.SetText(StatusDesc);
    UpdateStatistics();
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    RootMC.GotoAndPlay("stats");
    StatsMC.GotoAndStop("stats");
    //return;    
}

function PlayCloseAnimation()
{
    RootMC.GotoAndPlay("statsclose");
    //return;    
}

function OnNextLine()
{
    //return;    
}

function OnOpenAnimationComplete()
{
    //return;    
}

static function string ConvertSecondsToTimeString(int InSeconds)
{
    local string ret;
    local int minutes, Seconds, Hour;
    local string minStr, secStr, hoursStr;

    minutes = InSeconds / 60;
    Seconds = InSeconds % 60;
    minStr = ((minutes > 9) ? "" $ string(minutes) : "0" $ string(minutes));
    secStr = ((Seconds > 9) ? "" $ string(Seconds) : "0" $ string(Seconds));
    // End:0xDA
    if(minutes < 60)
    {
        ret = (minStr @ ":") @ secStr;        
    }
    else
    {
        Hour = minutes / 60;
        minutes = minutes - (Hour * 60);
        minStr = ((minutes > 9) ? "" $ string(minutes) : "0" $ string(minutes));
        hoursStr = ((Hour > 9) ? "" $ string(Hour) : "0" $ string(Hour));
        ret = (((hoursStr @ ":") @ minStr) @ ":") @ secStr;
    }
    return ret;
    //return ReturnValue;    
}

function UpdateStatisticsFromLocalLevelStatistics()
{
    local class<EvilDifficultySettings> DiffSettings;

    GameTimeValueTF.SetText("" $ (ConvertSecondsToTimeString(LocalMenuLevelStatistics.GameplayTime)));
    DiffSettings = Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(LocalMenuLevelStatistics.Difficulty);
    DifficultyValueTF.SetText("" $ DiffSettings.default.DifficultyName);
    KillsValueTF.SetText("" $ string(LocalMenuLevelStatistics.MonstersKilled));
    KillsTotalTF.SetText("" $ string(LocalMenuLevelStatistics.TotalMonsters));
    GoldValueTF.SetText("" $ string(LocalMenuLevelStatistics.GoldFound));
    GoldBonusTF.SetText("" $ ((LocalMenuLevelStatistics.BonusItems > 0) ? "+" $ string(LocalMenuLevelStatistics.BonusItems) : ""));
    AmmoValueTF.SetText("" $ string(LocalMenuLevelStatistics.AmmoFound));
    AmmoTotalTF.SetText("" $ string(LocalMenuLevelStatistics.TotalAmmo));
    AmmoStarMC.SetVisible(((LocalMenuLevelStatistics.AmmoFound != 0) ? LocalMenuLevelStatistics.AmmoFound >= LocalMenuLevelStatistics.TotalAmmo : false));
    ObjectsValueTF.SetText("" $ string(LocalMenuLevelStatistics.ObjectsDestroyed));
    ObjectsTotalTF.SetText("" $ string(LocalMenuLevelStatistics.TotalObjects));
    ObjectsStarMC.SetVisible(((LocalMenuLevelStatistics.ObjectsDestroyed != 0) ? LocalMenuLevelStatistics.ObjectsDestroyed >= LocalMenuLevelStatistics.TotalObjects : false));
    SecretsValueTF.SetText("" $ string(LocalMenuLevelStatistics.SecretsFound));
    SecretsTotalTF.SetText("" $ string(LocalMenuLevelStatistics.TotalSecrets));
    SecretsStarMC.SetVisible(((LocalMenuLevelStatistics.SecretsFound != 0) ? LocalMenuLevelStatistics.SecretsFound >= LocalMenuLevelStatistics.TotalSecrets : false));
    //return;    
}

simulated function UpdateStatistics()
{
    local AdvPRI PCPRi;
    local AdvPlayerController PC;
    local AdvGRI_SP PKGRI;

    PKGRI = AdvGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x58
    if(PKGRI == none)
    {
        return;
    }
    PC = AdvPlayerController(GetPC());
    PCPRi = AdvPRI(PC.PlayerReplicationInfo);
    GameTimeValueTF.SetText("" $ (ConvertSecondsToTimeString(PKGRI.GameplayTime)));
    // End:0x16D
    if(PCPRi.Difficulty != none)
    {
        DifficultyValueTF.SetText("" $ PCPRi.Difficulty.default.DifficultyName);
    }
    KillsValueTF.SetText("" $ string(PCPRi.MonstersKilled));
    KillsTotalTF.SetText("" $ string(PKGRI.TotalMonsters));
    GoldBonusTF.SetText("" $ ((PKGRI.BonusItems > 0) ? "+" $ string(PKGRI.BonusItems) : ""));
    AmmoValueTF.SetText("" $ string(PCPRi.AmmoFound));
    AmmoTotalTF.SetText("" $ string(PKGRI.TotalAmmo));
    AmmoStarMC.SetVisible(PCPRi.AmmoFound >= PKGRI.TotalAmmo);
    ObjectsValueTF.SetText("" $ string(PCPRi.DestroyedObjects));
    ObjectsTotalTF.SetText("" $ string(PKGRI.TotalObjects));
    ObjectsStarMC.SetVisible(PCPRi.DestroyedObjects >= PKGRI.TotalObjects);
    SecretsValueTF.SetText("" $ string(PCPRi.SecretsFound));
    SecretsTotalTF.SetText("" $ string(PKGRI.TotalSecrets));
    SecretsStarMC.SetVisible(PCPRi.SecretsFound >= PKGRI.TotalSecrets);
    //return;    
}

function OnContinue()
{
    //return;    
}

function SetLevelIDOverride(AdvTypes.ELevelID LevelID)
{
    // End:0x38
    if(int(LevelID) != int(LevelIDOverride))
    {
        LevelIDOverride = LevelID;
        UpdateStatisticsFromLocalLevelStatistics();
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    UpdateStatistics();
    //return;    
}

defaultproperties
{
    bAllowFocus=false
}