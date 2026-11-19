class SPHud extends HUD
    transient
    native
    config(Game);

const ASPECTRATIO_Normal = 1.333333f;
const ASPECTRATIO_Monitor = 1.25f;
const ASPECTRATIO_Widescreen = 1.777778f;
const Delta = 0.00001;

enum ReticleDirection
{
    RET_NORTH,                      // 0
    RET_EAST,                       // 1
    RET_WEST,                       // 2
    RET_SOUTH,                      // 3
    RET_MAX                         // 4
};

struct native HudElement
{
    var Material mat;
    var Vector canvasSize;
    var Vector imageSize;
    var Vector Position;

    structdefaultproperties
    {
        mat=none
        canvasSize=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        imageSize=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native HudElementN
{
    var Material mat;
    var Vector2D canvasSize;
    var Vector2D imageSize;
    var Vector2D Position;

    structdefaultproperties
    {
        mat=none
        canvasSize=(X=0.0000000,Y=0.0000000)
        imageSize=(X=0.0000000,Y=0.0000000)
        Position=(X=0.0000000,Y=0.0000000)
    }
};

struct native MinigameTackleKillshotInfo
{
    var PandoraPlayerController Player;
    var SPBaseWerewolfAIController Werewolf;

    structdefaultproperties
    {
        Player=none
        Werewolf=none
    }
};

var SPGameDifficultyTuneGamePlay m_GameplayGDTuneData;
var HudElementN multiplayer_miniscore_BG;
var HudElementN multiplayer_miniscore_Player;
var HudElementN multiplayer_miniscore_Leader;
var HudElementN multiplayer_FillMonsterMachineTextBG;
var CanvasIcon multiplayer_DesertEagle;
var CanvasIcon multiplayer_UMP;
var CanvasIcon multiplayer_Pistol;
var CanvasIcon multiplayer_Saw;
var CanvasIcon multiplayer_AssaultRifle;
var CanvasIcon multiplayer_Shotgun;
var CanvasIcon multiplayer_Grenade;
var CanvasIcon multiplayer_WerewolfSlash;
var CanvasIcon multiplayer_WerewolfIcon;
var CanvasIcon multiplayer_HitByObject;
var CanvasIcon multiplayer_Flame;
var private float buttonAnimFrameCounter;
var private string minigameStatus;
var bool m_bMiniGameActive;
var bool bBindStoryDataProvider;
var bool bDisplayNotificationOnHud;
var bool bShowPickupWeaponMessage;
var bool bStartFadeIn;
var bool bStartFadeOut;
var bool bUseNewHud;
var config bool m_bShowLowMemoryWarning;
var bool m_bShowGlobalMemoryStatus;
var config bool bShowCopyrightText;
var config bool bShowNetModeText;
var config bool bShowBuildVersion;
var bool bDisplayCheckpointText;
var bool bShowingAllBases;
var MinigameTackleKillshotInfo minigame_TackleKillshotInfo;
var HudElementN m_MiniGameButtonStage1;
var HudElementN m_MiniGameButtonStage2A;
var HudElementN m_MiniGameButtonStage2X;
var HudElementN m_MiniGameButtonStage2Y;
var HudElementN m_MiniGameButtonTrigger;
var SPStoryDataProvider storyDataProvider;
var private Material PDAMsgMaterial;
var private int PDAMsgCanvasX;
var private int PDAMsgCanvasY;
var string weaponPickupMsg;
var SPMaterialEffectsManager m_MatEffectsManager;
var Material testBar;
var MaterialInstanceConstant testMat;
var float sprintBarPosX;
var float sprintBarPosY;
var float sprintBarSizeX;
var float sprintBarSizeY;
var float FadeInOpacity;
var float fadeInAmount;
var int FadeInTime;
var float FadeOutOpacity;
var float fadeOutAmount;
var int sprintBarFadeOutTime;
var UIImage buttonB_Normal;
var UIImage buttonRT_Normal;
var UIImage buttonB_Glowing;
var UIImage buttonRT_Glowing;
var SPPawn HitAccTargetPawn;
var float LastHitAccTest;
var int m_fadeOutWeaponMessageAlpha;
var const localized string WordMsgReceived;
var const localized string WordCheckpointReached;
var const localized string WordCheckpointReachedDEMO;
/** The class of the scene to create */
var(SP_SOUNDS) SoundCue mSoundCue_MessageReceivedSound;
var string HudSceneClass;
var int currHudScene;
var int maxHudScenes;
var SPHudScene HudSceneAsset[3];
var SPHudScene HudScene;
var SPUIScene tackleMiniGameUISceneAsset;
var SPUIScene tackleMiniGameUIScene;
var RadarTargetManagerPersistent RTM;
var SPQueuedSoundPlayer QueuedSounds;
var LCDUIInterface G15LCD;

// Export USPHud::execTogglePlayerIsTargetable(FFrame&, void* const)
native static final function TogglePlayerIsTargetable(bool isTargetable);

// Export USPHud::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPHud::execTestAvailMemory(FFrame&, void* const)
native function float TestAvailMemory();

// Export USPHud::execGetBuildVersion(FFrame&, void* const)
native function string GetBuildVersion();

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    SetTimer(1.0000000, true);
    currHudScene = 0;
    CreateHudScene();
    // End:0x86
    if((HudScene != none) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        bShowHUD = false;
        HudScene.SetVisibility(false);
    }
    m_MatEffectsManager = Spawn(Class'SPMaterialEffectsManager', self);
    // End:0xD6
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        OpenDeathScene();
        SetTimer(1.0000000, true, 'SortPRIArray');
    }
    InitTargetManager();
    QueuedSounds = Spawn(Class'SPQueuedSoundPlayer',,, Location, Rotation);
    // End:0x163
    if(!GetWorldInfo().IsConsoleBuild())
    {
        G15LCD = Spawn(Class'LCDUIInterface', self);
        G15LCD.Initialize(PandoraPlayerController(Owner));
        G15LCD.UpdateLCDInformation();
    }
    //return;    
}

simulated function Destroyed()
{
    G15LCD.Destroy();
    super.Destroyed();
    //return;    
}

simulated function SortPRIArray()
{
    // End:0x33
    if(WorldInfo.GRI != none)
    {
        WorldInfo.GRI.SortPRIArray();
    }
    //return;    
}

simulated event Timer()
{
    super(Actor).Timer();
    // End:0x39
    if(WorldInfo.GRI != none)
    {
        WorldInfo.GRI.SortPRIArray();
    }
    //return;    
}

function OpenDeathScene()
{
    local UIScene_MPDeathScene DeathScene;

    DeathScene = UIScene_MPDeathScene(DynamicLoadObject("MegaMPScenes.MPDeathScene", Class'UIScene_MPDeathScene'));
    PandoraPlayerController(Owner).OpenScene(DeathScene);
    //return;    
}

simulated function InitTargetManager()
{
    local SPMonsterMachinePersistent Machine;
    local PandoraPlayerController PC;
    local SPTeamInfo Team;
    local class<RadarTargetManagerPersistent> RadarTargetManagerClass;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x25
    if(PGRI == none)
    {
    }
    // End:0xF3
    if(RTM == none)
    {
        // End:0x8B
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            RadarTargetManagerClass = class<RadarTargetManagerPersistent>(DynamicLoadObject("PandoraGameContent.RadarTargetManager", Class'Core.Class'));            
        }
        else
        {
            RadarTargetManagerClass = class<RadarTargetManagerPersistent>(DynamicLoadObject("PandoraGameContent.RadarTargetManagerSinglePlayer", Class'Core.Class'));
        }
        // End:0xE3
        if(RadarTargetManagerClass == none)
        {            
        }
        else
        {
            RTM = new RadarTargetManagerClass;
        }
    }
    RTM.ClearTargets();
    // End:0x278
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x277
        foreach AllActors(Class'SPMonsterMachinePersistent', Machine)
        {
            PC = PandoraPlayerController(Owner);
            // End:0x276
            if(PC != none)
            {
                Team = PC.GetTeam();
                // End:0x1C7
                if(PGRI.bShowAllBasesOnRadar)
                {
                    // End:0x1AB
                    if(int(Machine.OwningTeam) == int(0))
                    {
                        RTM.AddTargetOrder(Machine);                        
                    }
                    else
                    {
                        RTM.AddTargetChaos(Machine);
                    }
                    // End:0x276
                    continue;
                }
                // End:0x276
                if(((Team.TeamIndex == 1) && int(Machine.OwningTeam) == int(0)) || (Team.TeamIndex == 2) && int(Machine.OwningTeam) == int(1))
                {
                    // End:0x25D
                    if(Team.TeamIndex == 1)
                    {
                        RTM.AddTargetOrder(Machine);
                        // End:0x276
                        continue;
                    }
                    RTM.AddTargetChaos(Machine);
                }
            }            
        }        
    }
    //return;    
}

exec function ShowCopyright()
{
    bShowCopyrightText = !bShowCopyrightText;
    //return;    
}

exec function RESHAT()
{
    local Pawn TestPawn;
    local SPPawn hatPawn;

    TestPawn = WorldInfo.PawnList;
    J0x15:

    // End:0x75 [Loop If]
    if(TestPawn != none)
    {
        hatPawn = SPPawn(TestPawn);
        // End:0x5D
        if(hatPawn != none)
        {
            hatPawn.HitsPerSec = 0;
            hatPawn.ShotsPerSec = 0;
        }
        TestPawn = TestPawn.NextPawn;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

exec function SHAT(name thePawn)
{
    local Pawn TestPawn;

    HitAccTargetPawn = none;
    TestPawn = WorldInfo.PawnList;
    J0x1C:

    // End:0x6B [Loop If]
    if(TestPawn != none)
    {
        // End:0x53
        if(TestPawn.Name == thePawn)
        {
            HitAccTargetPawn = SPPawn(TestPawn);
            // [Explicit Break]
            goto J0x6B;
        }
        TestPawn = TestPawn.NextPawn;
        // [Loop Continue]
        goto J0x1C;
    }
    J0x6B:

    //return;    
}

exec function ShowBuild()
{
    bShowBuildVersion = !bShowBuildVersion;
    //return;    
}

function SPMaterialEffectsManager GetEffectsManager()
{
    // End:0x11
    if(m_MatEffectsManager != none)
    {
        return m_MatEffectsManager;
    }
    return none;
    //return ReturnValue;    
}

function Update(HUD H)
{
    sprintBarSizeX = float(H.Canvas.SizeX / 8);
    sprintBarSizeY = sprintBarSizeX;
    sprintBarPosX = (float(H.Canvas.SizeX) - sprintBarSizeX) / float(2);
    sprintBarPosY = (float(H.Canvas.SizeY) - sprintBarSizeY) / float(2);
    //return;    
}

event Tick(float Time)
{
    // End:0x24
    if(HudScene != none)
    {
        HudScene.Tick_Widgets(Time);
    }
    // End:0x43
    if(QueuedSounds != none)
    {
        QueuedSounds.PlayNextSoundIfNecessary();
    }
    // End:0x67
    if(RTM != none)
    {
        RTM.Update(Time);
    }
    //return;    
}

function RegisterTackleMinigame(SPBaseWerewolfAIController Werewolf, PandoraPlayerController Player)
{
    minigame_TackleKillshotInfo.Player = Player;
    minigame_TackleKillshotInfo.Werewolf = Werewolf;
    m_bMiniGameActive = true;
    minigame_TackleKillshotInfo.Player.tackleMinigameManager.m_MiniGameStage2Button = Rand(3) + 1;
    minigame_TackleKillshotInfo.Player.tackleMinigameManager.m_MiniGameWinButton = Rand(3) + 1;
    //return;    
}

function UnRegisterTackleMinigame()
{
    minigame_TackleKillshotInfo.Werewolf = none;
    m_bMiniGameActive = false;
    //return;    
}

function UpdateTackleGameInfo(SButtonMashInfo buttonMashInfo)
{
    m_MiniGameButtonStage1.mat = buttonMashInfo.mashButtonMat.mat;
    m_MiniGameButtonStage2A.mat = buttonMashInfo.mashButtonMatStage2A.mat;
    m_MiniGameButtonStage2X.mat = buttonMashInfo.mashButtonMatStage2X.mat;
    m_MiniGameButtonStage2Y.mat = buttonMashInfo.mashButtonMatStage2Y.mat;
    m_MiniGameButtonTrigger.mat = buttonMashInfo.mashButtonMatTrigger.mat;
    //return;    
}

simulated event PlayerShotSomething()
{
    HudScene.ShowHitTargetIndicator();
    //return;    
}

function RenderHelicopterHealth(HUD H, float helicopterHealthPercentage)
{
    //return;    
}

function StartSprintBarFadeIn(float NewOpacity, int Time)
{
    // End:0x34
    if(testMat == none)
    {
        testMat = new (none) Class'Engine.MaterialInstanceConstant';
        testMat.SetParent(testBar);
    }
    // End:0xA7
    if(!bStartFadeIn)
    {
        bStartFadeIn = true;
        // End:0x81
        if(bStartFadeOut)
        {
            bStartFadeOut = false;
            sprintBarFadeOutTime = 0;
            testMat.SetScalarParameterValue('Sprint_fade', FadeInOpacity);
        }
        fadeInAmount = (NewOpacity - FadeInOpacity) / float(Time);
        FadeInTime = Time;
    }
    //return;    
}

function SprintBarFadeIn()
{
    local float currOpacity;

    // End:0x0B
    if(bStartFadeOut)
    {
        return;
    }
    // End:0x80
    if(bUseNewHud)
    {
        // End:0x29
        if(FadeInTime == 0)
        {
            bStartFadeIn = false;
            return;
        }
        FadeInTime--;
        testMat.GetScalarParameterValue('Sprint_fade', currOpacity);
        currOpacity += fadeInAmount;
        testMat.SetScalarParameterValue('Sprint_fade', currOpacity);
    }
    //return;    
}

function StartSprintBarFadeOut(float NewOpacity, int Time)
{
    // End:0x34
    if(testMat == none)
    {
        testMat = new (none) Class'Engine.MaterialInstanceConstant';
        testMat.SetParent(testBar);
    }
    // End:0xA7
    if(!bStartFadeOut)
    {
        bStartFadeOut = true;
        // End:0x81
        if(bStartFadeIn)
        {
            bStartFadeIn = false;
            FadeInTime = 0;
            testMat.SetScalarParameterValue('Sprint_fade', FadeOutOpacity);
        }
        fadeOutAmount = (NewOpacity - FadeOutOpacity) / float(Time);
        sprintBarFadeOutTime = Time;
    }
    //return;    
}

function SprintBarFadeOut()
{
    local float currOpacity;

    // End:0x0B
    if(bStartFadeIn)
    {
        return;
    }
    // End:0x80
    if(bUseNewHud)
    {
        // End:0x29
        if(sprintBarFadeOutTime == 0)
        {
            bStartFadeOut = false;
            return;
        }
        sprintBarFadeOutTime--;
        testMat.GetScalarParameterValue('Sprint_fade', currOpacity);
        currOpacity += fadeOutAmount;
        testMat.SetScalarParameterValue('Sprint_fade', currOpacity);
    }
    //return;    
}

function RenderSprintBar(HUD H, float playerSprintPercentage, float Opacity)
{
    local float Radius;

    // End:0x10B
    if(bUseNewHud)
    {
        // End:0x3D
        if(testMat == none)
        {
            testMat = new (none) Class'Engine.MaterialInstanceConstant';
            testMat.SetParent(testBar);
        }
        // End:0x7C
        if((playerSprintPercentage >= 0.0000000) && playerSprintPercentage <= 1.0000000)
        {
            Radius = (-float(1) - playerSprintPercentage * float(4)) * 3.1415930;
        }
        testMat.SetScalarParameterValue('Sprint_meter', Radius);
        testMat.SetScalarParameterValue('Sprint_fade', Opacity);
        H.SetPos(sprintBarPosX, sprintBarPosY);
        H.Canvas.DrawMaterialTile(testMat, sprintBarSizeX, sprintBarSizeY);
    }
    //return;    
}

function DrawMinigameAssets(HUD H)
{
    // End:0x130
    if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.IsState('ButtonMash1') || minigame_TackleKillshotInfo.Player.tackleMinigameManager.IsState('ButtonMash2'))
    {
        H.SetPos(H.CenterX - float(94), H.CenterY + (H.RatioY * float(155)));
        H.Canvas.DrawMaterialTile(m_MiniGameButtonStage1.mat, m_MiniGameButtonStage1.canvasSize.X * 0.7500000, m_MiniGameButtonStage1.canvasSize.Y * 0.7500000);        
    }
    else
    {
        // End:0x440
        if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.IsState('ButtonMash1Pass'))
        {
            // End:0x258
            if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.CheckMash1PassTransitionNumber() == 1)
            {
                H.SetPos(H.CenterX - float(94), H.CenterY + (H.RatioY * float(155)));
                H.Canvas.DrawMaterialTile(m_MiniGameButtonStage2A.mat, m_MiniGameButtonStage2A.canvasSize.X * 0.7500000, m_MiniGameButtonStage2A.canvasSize.Y * 0.7500000);                
            }
            else
            {
                // End:0x34C
                if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.CheckMash1PassTransitionNumber() == 2)
                {
                    H.SetPos(H.CenterX - float(94), H.CenterY + (H.RatioY * float(155)));
                    H.Canvas.DrawMaterialTile(m_MiniGameButtonStage2X.mat, m_MiniGameButtonStage2X.canvasSize.X * 0.7500000, m_MiniGameButtonStage2X.canvasSize.Y * 0.7500000);                    
                }
                else
                {
                    // End:0x43D
                    if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.CheckMash1PassTransitionNumber() == 3)
                    {
                        H.SetPos(H.CenterX - float(94), H.CenterY + (H.RatioY * float(155)));
                        H.Canvas.DrawMaterialTile(m_MiniGameButtonStage2Y.mat, m_MiniGameButtonStage2Y.canvasSize.X * 0.7500000, m_MiniGameButtonStage2Y.canvasSize.Y * 0.7500000);
                    }
                }
            }            
        }
        else
        {
            // End:0x74D
            if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.IsState('ButtonMash2Pass'))
            {
                // End:0x568
                if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.CheckMashWinTransitionNumber() == 1)
                {
                    H.SetPos(H.CenterX - float(94), H.CenterY + (H.RatioY * float(155)));
                    H.Canvas.DrawMaterialTile(m_MiniGameButtonStage2A.mat, m_MiniGameButtonStage2A.canvasSize.X * 0.7500000, m_MiniGameButtonStage2A.canvasSize.Y * 0.7500000);                    
                }
                else
                {
                    // End:0x65C
                    if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.CheckMashWinTransitionNumber() == 2)
                    {
                        H.SetPos(H.CenterX - float(94), H.CenterY + (H.RatioY * float(155)));
                        H.Canvas.DrawMaterialTile(m_MiniGameButtonStage2X.mat, m_MiniGameButtonStage2X.canvasSize.X * 0.7500000, m_MiniGameButtonStage2X.canvasSize.Y * 0.7500000);                        
                    }
                    else
                    {
                        // End:0x74D
                        if(minigame_TackleKillshotInfo.Player.tackleMinigameManager.CheckMashWinTransitionNumber() == 3)
                        {
                            H.SetPos(H.CenterX - float(94), H.CenterY + (H.RatioY * float(155)));
                            H.Canvas.DrawMaterialTile(m_MiniGameButtonStage2Y.mat, m_MiniGameButtonStage2Y.canvasSize.X * 0.7500000, m_MiniGameButtonStage2Y.canvasSize.Y * 0.7500000);
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function DrawMultiplayerScore(HUD H, string LeaderName, string SecondName, int leaderScore, int secondScore)
{
    local int leaderPlayerOffset, secondPlayerOffset, textOffset;

    // End:0x5CA
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        textOffset = 5;
        leaderPlayerOffset = 0;
        secondPlayerOffset = int(multiplayer_miniscore_Leader.imageSize.Y);
        H.SetPos(float(H.Canvas.SizeX - H.OverscanX) - multiplayer_miniscore_BG.imageSize.X, float(H.OverscanY));
        H.Canvas.DrawMaterialTile(multiplayer_miniscore_BG.mat, multiplayer_miniscore_BG.canvasSize.X, multiplayer_miniscore_BG.canvasSize.Y);
        H.SetPos(float(H.Canvas.SizeX - H.OverscanX) - multiplayer_miniscore_Leader.imageSize.X, float(H.OverscanY + leaderPlayerOffset));
        H.Canvas.DrawMaterialTile(multiplayer_miniscore_Leader.mat, multiplayer_miniscore_Leader.canvasSize.X, multiplayer_miniscore_Leader.canvasSize.Y);
        H.Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
        H.Canvas.SetDrawColor(255, 255, 255, 255);
        H.SetPos((float(H.Canvas.SizeX - H.OverscanX) - multiplayer_miniscore_Leader.imageSize.X) + float(20), float((H.OverscanY + leaderPlayerOffset) + textOffset));
        H.Canvas.DrawText(LeaderName, false);
        H.SetPos(float((H.Canvas.SizeX - H.OverscanX) - 20), float((H.OverscanY + leaderPlayerOffset) + textOffset));
        H.Canvas.DrawText(string(leaderScore), false);
        // End:0x57E
        if(secondScore >= 0)
        {
            H.SetPos(float(H.Canvas.SizeX - H.OverscanX) - multiplayer_miniscore_Player.imageSize.X, float(H.OverscanY + secondPlayerOffset));
            H.Canvas.DrawMaterialTile(multiplayer_miniscore_Player.mat, multiplayer_miniscore_Player.canvasSize.X, multiplayer_miniscore_Player.canvasSize.Y);
            H.SetPos((float(H.Canvas.SizeX - H.OverscanX) - multiplayer_miniscore_Player.imageSize.X) + float(20), float((H.OverscanY + secondPlayerOffset) + textOffset));
            H.Canvas.DrawText(SecondName, false);
            H.SetPos(float((H.Canvas.SizeX - H.OverscanX) - 20), float((H.OverscanY + secondPlayerOffset) + textOffset));
            H.Canvas.DrawText(string(secondScore), false);
        }
        H.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
        H.Canvas.SetDrawColor(255, 255, 255, 255);
    }
    //return;    
}

function Draw(HUD H)
{
    H.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    H.Canvas.SetDrawColor(255, 255, 255, 255);
    // End:0x70
    if(m_MatEffectsManager != none)
    {
        m_MatEffectsManager.UpdateEffectsManager(H);
    }
    // End:0x8A
    if(m_bMiniGameActive)
    {
        DrawMinigameAssets(H);
        return;
    }
    H.SetPos(float(H.OverscanX), float((H.Canvas.SizeY - H.OverscanY) - 150));
    H.Canvas.DrawText(minigameStatus, false);
    Update(H);
    HudScene.DrawReticleWeaponSpread(H);
    //return;    
}

function DrawHUD()
{
    // End:0x24
    if(m_MatEffectsManager != none)
    {
        m_MatEffectsManager.RenderMaterialEffects(Canvas);
    }
    super.DrawHUD();
    //return;    
}

function BindStoryDataProvider()
{
    local DataStoreClient DataStoreManager;
    local SPStoryDataStore CurrentGameData;

    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x6D
    if(DataStoreManager != none)
    {
        CurrentGameData = SPStoryDataStore(DataStoreManager.FindDataStore('SPStoryDataStore'));
        // End:0x6A
        if(CurrentGameData != none)
        {
            storyDataProvider = CurrentGameData.GetStoryDataProvider();            
        }        
    }
    //return;    
}

function DisplayNotificationOnHud(HUD H, string Text)
{
    local float XL, YL, startX, startY;

    H.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    H.Canvas.SetDrawColor(255, 230, 80);
    H.Canvas.StrLen(Text, XL, YL);
    startX = (float(H.Canvas.SizeX - H.OverscanX) - XL) - float(PDAMsgCanvasX);
    startY = float(H.Canvas.SizeY - H.OverscanY) - (YL * 6.0000000);
    H.SetPos(startX, startY);
    H.Canvas.DrawMaterialTile(PDAMsgMaterial, float(PDAMsgCanvasX), float(PDAMsgCanvasY));
    H.SetPos(startX + float(PDAMsgCanvasX), startY);
    H.Canvas.DrawText(Text, false);
    H.Canvas.SetDrawColor(255, 255, 255);
    //return;    
}

function DisplayWeaponPickupMsg(HUD H, string Text)
{
    local float XL, YL, startX, startY;

    // End:0x165
    if(m_fadeOutWeaponMessageAlpha > 0)
    {
        H.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
        H.Canvas.SetDrawColor(255, 255, 255, byte(m_fadeOutWeaponMessageAlpha));
        H.Canvas.StrLen(Text, XL, YL);
        startX = H.CenterX - (H.RatioX * float(400));
        startY = H.CenterY - (H.RatioY * float(250));
        H.SetPos(startX, startY);
        H.Canvas.DrawText(Text, false);
        H.Canvas.SetDrawColor(255, 255, 255, byte(m_fadeOutWeaponMessageAlpha));
        // End:0x15C
        if(m_fadeOutWeaponMessageAlpha <= 0)
        {
            m_fadeOutWeaponMessageAlpha = 0;            
        }
        else
        {
            m_fadeOutWeaponMessageAlpha -= 2;
        }
    }
    //return;    
}

function ToggleNewHud(optional float FadeTime = 0.0000000)
{
    ToggleHUD();
    // End:0x5A
    if(HudScene != none)
    {
        // End:0x40
        if(bShowHUD)
        {
            HudScene.FadeIn(FadeTime);            
        }
        else
        {
            HudScene.FadeOut(FadeTime);
        }
    }
    //return;    
}

exec function ToggleHUD()
{
    ToggleNewHud(2.0000000);
    //return;    
}

function CreateHudScene()
{
    local UIInteraction UIController;
    local LocalPlayer localPlaya;
    local UIScene OpenedScene;

    OpenedScene = none;
    UIController = LocalPlayer(PlayerOwner.Player).ViewportClient.UIController;
    // End:0xC5
    if(HudScene == none)
    {
        localPlaya = LocalPlayer(PlayerOwner.Player);
        // End:0xC5
        if(UIController.OpenScene(HudSceneAsset[currHudScene], localPlaya, OpenedScene))
        {
            HudScene = SPHudScene(OpenedScene);
            // End:0xC2
            if(HudScene != none)
            {
                HudScene.Init_Widgets();
                HudScene.HudSceneOwner = self;
            }            
        }
    }
    //return;    
}

function CloseHudScene()
{
    local UIInteraction UIController;

    UIController = LocalPlayer(PlayerOwner.Player).ViewportClient.UIController;
    // End:0x61
    if(HudScene != none)
    {
        // End:0x61
        if(UIController.CloseScene(HudSceneAsset[currHudScene]))
        {
            HudScene = none;            
        }
    }
    //return;    
}

function bool CreateMiniGameScene(UIScene UISceneAsset, out UIScene createdUIScene)
{
    local UIInteraction UIController;
    local LocalPlayer localPlaya;
    local bool Result;

    Result = false;
    UIController = LocalPlayer(PlayerOwner.Player).ViewportClient.UIController;
    // End:0x93
    if((HudScene == none) && bUseNewHud)
    {
        localPlaya = LocalPlayer(PlayerOwner.Player);
        // End:0x93
        if(UIController.OpenScene(UISceneAsset, localPlaya, createdUIScene))
        {
            Result = true;            
        }
    }
    return Result;
    //return ReturnValue;    
}

function GetTackleMiniGameWidgetsReference()
{
    //return;    
}

function DrawEngineHUD()
{
    local bool canDebug;
    local PlayerPawn Player;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    Player = PlayerPawn(PlayerOwner.Pawn);
    // End:0x41
    if(Player == none)
    {
        return;
    }
    // End:0x7A
    if((PandoraPlayerController(PlayerOwner) != none) && PandoraPlayerController(PlayerOwner).CanIDebug())
    {
        canDebug = true;        
    }
    else
    {
        canDebug = false;
    }
    // End:0x8E
    if(canDebug)
    {        
    }
    else
    {
        // End:0x12F
        if(RTM != none)
        {
            // End:0x12F
            if(PGRI != none)
            {
                // End:0x12F
                if(int(PGRI.RadarMode) != int(2))
                {
                    // End:0x116
                    if((int(WorldInfo.NetMode) != int(NM_Standalone)) && PGRI.bShowAllBasesOnRadar != bShowingAllBases)
                    {
                        InitTargetManager();
                        bShowingAllBases = PGRI.bShowAllBasesOnRadar;
                    }
                    RTM.Render(Canvas);
                }
            }
        }
    }
    //return;    
}

final function StartDrawingCheckpointText()
{
    // End:0x1C
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    // End:0xB5
    if((HudScene != none) && !bDisplayCheckpointText)
    {
        // End:0x6A
        if(Class'Engine.Engine'.static.IsSPDemoBuild())
        {
            HudScene.AddTextToBuffer(WordCheckpointReachedDEMO, 5, 5.0000000);            
        }
        else
        {
            HudScene.AddTextToBuffer(WordCheckpointReached, 5, 5.0000000);
        }
        bDisplayCheckpointText = true;
        SetTimer(5.0000000, true, 'ClearDisplayCheckpointText');
        PlaySound(SoundCue'S_PDA.PDA_Checkpoint_Cue');
    }
    //return;    
}

function ClearDisplayCheckpointText()
{
    bDisplayCheckpointText = false;
    //return;    
}

function PDAMessageReceived()
{
    // End:0x1C
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    bDisplayNotificationOnHud = true;
    // End:0x64
    if(HudScene != none)
    {
        HudScene.AddTextToBuffer(WordMsgReceived, 5, 5.0000000);
        HudScene.SetEMailIcon(true);
    }
    PlaySound(mSoundCue_MessageReceivedSound);
    //return;    
}

function ClearMessageNotification()
{
    bDisplayNotificationOnHud = false;
    //return;    
}

function ShowPickupWeaponMessage()
{
    // End:0x3A
    if((HudScene != none) && Len(weaponPickupMsg) > 0)
    {
        HudScene.AddTextToBuffer(weaponPickupMsg, 5, 5.0000000);
    }
    //return;    
}

function UIScene OpenHUDScene(UIScene Scene, optional LocalPlayer Player)
{
    local UIInteraction UIController;
    local UIScene OutputScene;

    UIController = PlayerOwner.GetUIController();
    // End:0x4E
    if((Scene != none) && UIController != none)
    {
        UIController.OpenScene(Scene, Player, OutputScene);
    }
    return OutputScene;
    //return ReturnValue;    
}

simulated function BeginMonsterMachineBarGlowCycle(int TeamID)
{
    HudScene.MonsterMachineGlowStatus[TeamID - 1].destGlowValue = HudScene.GlowMaxValue;
    HudScene.MonsterMachineGlowStatus[TeamID - 1].holdAtMaxGlowTime = HudScene.GlowHoldTime;
    //return;    
}

function UpdateMonsterMachineValues(int machine1Value, int machine2Value)
{
    // End:0x0D
    if(HudScene == none)
    {
        return;
    }
    // End:0x29
    if(HudScene.ShouldDisplayMultiplayerHud() == false)
    {
        return;
    }
    // End:0x42
    if(HudScene.IsHudFadeIn())
    {
        return;
    }
    // End:0x50
    if(bUseNewHud == false)
    {
        return;
    }
    PlayMonsterMachineLevelSounds(1, HudScene.team1MonsterMachineProgressBar.GetValue(), float(machine1Value));
    HudScene.team1MonsterMachineProgressBar.SetValue(float(machine1Value));
    PlayMonsterMachineLevelSounds(2, HudScene.team2MonsterMachineProgressBar.GetValue(), float(machine2Value));
    HudScene.team2MonsterMachineProgressBar.SetValue(float(machine2Value));
    //return;    
}

function PlayMonsterMachineLevelSounds(int TeamID, float preFillPercent, float postFillPercent)
{
    local int preFillLevel, postFillLevel;
    local SoundCue SoundToPlay;
    local PandoraGRI PGRI;
    local SPPointEventMachineBonusPersistent theMachineBonus;

    // End:0x11
    if(preFillPercent == postFillPercent)
    {
        return;
    }
    PGRI = PandoraGRI(WorldInfo.GRI);
    theMachineBonus = PGRI.GetPointEventMachineBonus();
    preFillLevel = theMachineBonus.GetLevelForFillPercent(int(preFillPercent));
    postFillLevel = theMachineBonus.GetLevelForFillPercent(int(postFillPercent));
    // End:0x98
    if(preFillLevel == postFillLevel)
    {
        return;
    }
    SoundToPlay = theMachineBonus.GetSoundCueForLevelAndTeam(postFillLevel, TeamID);
    QueuedSounds.AddSound(SoundToPlay);
    //return;    
}

function bool UpdateHUDTeamColor()
{
    // End:0x23
    if(HudScene != none)
    {
        return HudScene.UpdateTeamColors();        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function Reset()
{
    weaponPickupMsg = "";
    // End:0x27
    if(HudScene != none)
    {
        HudScene.ResetHud();
    }
    //return;    
}

function int GetNumMessageTokens(string Str)
{
    local int I;
    local bool bInBegin;
    local int TagCount;
    local string Char;

    TagCount = 0;
    bInBegin = false;
    I = 0;
    J0x16:

    // End:0x7E [Loop If]
    if(I < Len(Str))
    {
        Char = Mid(Str, I, 1);
        // End:0x4F
        if(Char == "[")
        {
            bInBegin = true;
        }
        // End:0x74
        if(bInBegin)
        {
            // End:0x74
            if(Char == "]")
            {
                bInBegin = false;
                TagCount++;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x16;
    }
    return TagCount;
    //return ReturnValue;    
}

function string GetNextToken(out string Str)
{
    local int TagStartPos, TagEndPos;
    local string TagContents;

    TagStartPos = InStr(Str, "[");
    TagEndPos = InStr(Str, "]");
    // End:0x5E
    if((TagStartPos == -1) || TagEndPos == -1)
    {
        TagContents = Str;
        Str = "";
        return TagContents;        
    }
    else
    {
        // End:0xA9
        if(TagStartPos == 0)
        {
            TagContents = Mid(Str, TagStartPos, (TagEndPos + 1) - TagStartPos);
            Str = Mid(Str, TagEndPos + 1);
            return TagContents;            
        }
        else
        {
            TagContents = Left(Str, TagStartPos);
            Str = Mid(Str, TagStartPos);
            return TagContents;
        }
    }
    //return ReturnValue;    
}

function string StripTags(string Str)
{
    local string TokenStr, Token, OutStr;

    TokenStr = Str;
    Token = GetNextToken(TokenStr);
    J0x20:

    // End:0x7B [Loop If]
    if(Len(Token) > 0)
    {
        // End:0x63
        if(!(Left(Token, 1) == "[") && Right(Token, 1) == "]")
        {
            OutStr = OutStr $ Token;
        }
        Token = GetNextToken(TokenStr);
        // [Loop Continue]
        goto J0x20;
    }
    return OutStr;
    //return ReturnValue;    
}

function DisplayLocalMessages()
{
    local float PosY, DY, DX, MessageWidth;
    local int I, J, LocalMessagesArrayCount, AreaMessageCount;
    local float FadeValue;
    local int FontSize;

    // End:0x1A
    if(LocalMessages[0].Message == none)
    {
        return;
    }
    Canvas.Reset(true);
    LocalMessagesArrayCount = 8;
    I = 0;
    J0x3E:

    // End:0x2B8 [Loop If]
    if(I < LocalMessagesArrayCount)
    {
        // End:0x6C
        if(LocalMessages[I].Message == none)
        {
            // [Explicit Break]
            goto J0x2B8;
        }
        LocalMessages[I].Drawn = false;
        // End:0x212
        if(LocalMessages[I].StringFont == none)
        {
            FontSize = LocalMessages[I].FontSize + MessageFontOffset;
            LocalMessages[I].StringFont = GetFontSizeIndex(FontSize);
            Canvas.Font = Font'SPFonts.MMBlackSC12';
            GetTokenizedImageMessageWidth(LocalMessages[I].StringMessage, MessageWidth);
            Canvas.StrLen(StripTags(LocalMessages[I].StringMessage), DX, DY);
            LocalMessages[I].DX = MessageWidth;
            LocalMessages[I].DY = DY;
            // End:0x212
            if(LocalMessages[I].StringFont == none)
            {
                J = I;
                J0x1BD:

                // End:0x1F3 [Loop If]
                if(J < (LocalMessagesArrayCount - 1))
                {
                    LocalMessages[J] = LocalMessages[J + 1];
                    J++;
                    // [Loop Continue]
                    goto J0x1BD;
                }
                ClearMessage(LocalMessages[J]);
                I--;
                // [Explicit Continue]
                goto J0x2AE;
            }
        }
        FadeValue = LocalMessages[I].EndOfLife - WorldInfo.RealTimeSeconds;
        // End:0x2AE
        if(FadeValue <= 0.0000000)
        {
            J = I;
            J0x259:

            // End:0x28F [Loop If]
            if(J < (LocalMessagesArrayCount - 1))
            {
                LocalMessages[J] = LocalMessages[J + 1];
                J++;
                // [Loop Continue]
                goto J0x259;
            }
            ClearMessage(LocalMessages[J]);
            I--;
            // [Explicit Continue]
        }
        J0x2AE:

        I++;
        // [Loop Continue]
        goto J0x3E;
    }
    J0x2B8:

    I = 0;
    J0x2BF:

    // End:0x411 [Loop If]
    if(I < LocalMessagesArrayCount)
    {
        // End:0x2ED
        if(LocalMessages[I].Message == none)
        {
            // [Explicit Break]
            goto J0x411;
        }
        // End:0x30A
        if(LocalMessages[I].Drawn)
        {
            // [Explicit Continue]
            goto J0x407;
        }
        PosY = LocalMessages[I].PosY;
        AreaMessageCount = 0;
        J = I;
        J0x338:

        // End:0x3D2 [Loop If]
        if(J < LocalMessagesArrayCount)
        {
            // End:0x397
            if(LocalMessages[J].Drawn || LocalMessages[I].PosY != LocalMessages[J].PosY)
            {
                // [Explicit Continue]
                goto J0x3C8;
            }
            DrawMessage(J, PosY, DX, DY);
            PosY += DY;
            AreaMessageCount++;
            J0x3C8:

            J++;
            // [Loop Continue]
            goto J0x338;
        }
        // End:0x407
        if(AreaMessageCount > MaxHUDAreaMessageCount)
        {
            LocalMessages[I].EndOfLife = WorldInfo.RealTimeSeconds;
        }
        J0x407:

        I++;
        // [Loop Continue]
        goto J0x2BF;
    }
    J0x411:

    //return;    
}

function GetScreenCoords(float PosY, out float ScreenX, out float ScreenY, out HudLocalizedMessage InMessage)
{
    local float Offset, XL, YL;

    // End:0xAB
    if(PosY > 1.0000000)
    {
        Offset = PosY - float(int(PosY));
        // End:0x44
        if(Offset < float(0))
        {
            Offset = Offset + 1.0000000;
        }
        Canvas.StrLen("XXX", XL, YL);
        ScreenY = (0.1500000 + Offset) * Canvas.ClipY;
        ScreenX = (0.0500000 * Canvas.ClipX) + XL;
        return;
    }
    ScreenX = 0.5000000 * Canvas.ClipX;
    ScreenY = ((PosY * HudCanvasScale) * Canvas.ClipY) + (((1.0000000 - HudCanvasScale) * 0.5000000) * Canvas.ClipY);
    ScreenX -= (InMessage.DX * 0.5000000);
    ScreenY -= (InMessage.DY * 0.5000000);
    //return;    
}

function DrawWeaponIconMessage(CanvasIcon Icon, out float ScreenX, out float ScreenY, float TextHeight)
{
    local float ImageScale, ResolutionScale;

    ResolutionScale = Canvas.ClipY / float(768);
    Canvas.DrawColor.R = 255;
    Canvas.DrawColor.G = 255;
    Canvas.DrawColor.B = 255;
    ImageScale = (ResolutionScale * Icon.VL) / TextHeight;
    Canvas.DrawIcon(Icon, ScreenX, ScreenY, ResolutionScale / ImageScale);
    ScreenX += ((ResolutionScale * Icon.UL) / ImageScale);
    Canvas.SetPos(ScreenX, ScreenY);
    //return;    
}

function DrawFillMessageBG(string Message)
{
    local float XL, YL, BorderPadding;
    local string MyString;

    MyString = StripTags(Message);
    Canvas.StrLen(MyString, XL, YL);
    BorderPadding = YL / float(8);
    Canvas.CurX -= (BorderPadding * float(4));
    Canvas.CurY -= BorderPadding;
    Canvas.DrawMaterialTile(multiplayer_FillMonsterMachineTextBG.mat, XL + (BorderPadding * float(8)), YL + (BorderPadding * float(2)), 0.0000000, 0.0000000, 1.0000000, 1.0000000);
    //return;    
}

function DrawMessageText(HudLocalizedMessage LocalMessage, float ScreenX, float ScreenY)
{
    local string TokenStr, Token;
    local float XSize, YSize, TextHeight;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x28
    if(PGRI == none)
    {
        return;
    }
    Canvas.Font = Font'SPFonts.MMBlackSC12';
    Canvas.StrLen(LocalMessage.StringMessage, XSize, TextHeight);
    Canvas.SetPos(ScreenX, ScreenY);
    TokenStr = LocalMessage.StringMessage;
    Token = GetNextToken(TokenStr);
    J0xAC:

    // End:0x683 [Loop If]
    if(Len(Token) > 0)
    {
        switch(Token)
        {
            // End:0x16E
            case "[0]":
                Canvas.DrawColor.R = LocalMessage.DrawColor.R;
                Canvas.DrawColor.G = LocalMessage.DrawColor.G;
                Canvas.DrawColor.B = LocalMessage.DrawColor.B;
                // End:0x66B
                break;
            // End:0x239
            case "[1]":
                Canvas.DrawColor.R = byte(PGRI.m_TeamColors[1].R * 255.0000000);
                Canvas.DrawColor.G = byte(PGRI.m_TeamColors[1].G * 255.0000000);
                Canvas.DrawColor.B = byte(PGRI.m_TeamColors[1].B * 255.0000000);
                // End:0x66B
                break;
            // End:0x307
            case "[2]":
                Canvas.DrawColor.R = byte(PGRI.m_TeamColors[2].R * 255.0000000);
                Canvas.DrawColor.G = byte(PGRI.m_TeamColors[2].G * 255.0000000);
                Canvas.DrawColor.B = byte(PGRI.m_TeamColors[2].B * 255.0000000);
                // End:0x66B
                break;
            // End:0x33A
            case "[DesertEagle]":
                DrawWeaponIconMessage(multiplayer_DesertEagle, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x365
            case "[UMP]":
                DrawWeaponIconMessage(multiplayer_UMP, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x394
            case "[Shotgun]":
                DrawWeaponIconMessage(multiplayer_Shotgun, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x3C8
            case "[AssaultRifle]":
                DrawWeaponIconMessage(multiplayer_AssaultRifle, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x3F3
            case "[9MM]":
                DrawWeaponIconMessage(multiplayer_Pistol, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x41E
            case "[Saw]":
                DrawWeaponIconMessage(multiplayer_Saw, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x44D
            case "[Grenade]":
                DrawWeaponIconMessage(multiplayer_Grenade, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x482
            case "[WerewolfSlash]":
                DrawWeaponIconMessage(multiplayer_WerewolfSlash, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x4B5
            case "[HitByObject]":
                DrawWeaponIconMessage(multiplayer_HitByObject, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x4E2
            case "[Flame]":
                DrawWeaponIconMessage(multiplayer_Flame, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x516
            case "[WerewolfIcon]":
                DrawWeaponIconMessage(multiplayer_WerewolfIcon, ScreenX, ScreenY, TextHeight);
                // End:0x66B
                break;
            // End:0x608
            case "[FillMachineMessage]":
                Canvas.DrawColor.R = LocalMessage.DrawColor.R;
                Canvas.DrawColor.G = LocalMessage.DrawColor.G;
                Canvas.DrawColor.B = LocalMessage.DrawColor.B;
                DrawFillMessageBG(LocalMessage.StringMessage);
                Canvas.SetPos(ScreenX, ScreenY);
                // End:0x66B
                break;
            // End:0xFFFF
            default:
                Canvas.DrawTextClipped(Token, false);
                Canvas.StrLen(Token, XSize, YSize);
                ScreenX += XSize;
                Canvas.SetPos(ScreenX, ScreenY);
                // End:0x66B
                break;
                break;
        }
        Token = GetNextToken(TokenStr);
        // [Loop Continue]
        goto J0xAC;
    }
    //return;    
}

function GetTokenizedImageMessageWidth(string TokenMessage, out float MessageWidth)
{
    local string Token;
    local float XSize, YSize, ImageScale, CurrWidth, CurrHeight, MaxWidth,
	    ResolutionScale;

    ResolutionScale = Canvas.ClipY / float(768);
    Canvas.StrLen(TokenMessage, XSize, YSize);
    Token = GetNextToken(TokenMessage);
    MaxWidth = 0.0000000;
    J0x5D:

    // End:0x4C4 [Loop If]
    if(Len(Token) > 0)
    {
        CurrWidth = 0.0000000;
        switch(Token)
        {
            // End:0x88
            case "[0]":
                // End:0x4A0
                break;
            // End:0x93
            case "[1]":
                // End:0x4A0
                break;
            // End:0x9E
            case "[2]":
                // End:0x4A0
                break;
            // End:0xFB
            case "[DesertEagle]":
                ImageScale = (ResolutionScale * multiplayer_DesertEagle.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_DesertEagle.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x150
            case "[UMP]":
                ImageScale = (ResolutionScale * multiplayer_UMP.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_UMP.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x1A9
            case "[Shotgun]":
                ImageScale = (ResolutionScale * multiplayer_Shotgun.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_Shotgun.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x207
            case "[AssaultRifle]":
                ImageScale = (ResolutionScale * multiplayer_AssaultRifle.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_AssaultRifle.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x25C
            case "[9MM]":
                ImageScale = (ResolutionScale * multiplayer_Pistol.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_Pistol.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x2B1
            case "[Saw]":
                ImageScale = (ResolutionScale * multiplayer_Saw.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_Saw.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x30A
            case "[Grenade]":
                ImageScale = (ResolutionScale * multiplayer_Grenade.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_Grenade.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x369
            case "[WerewolfSlash]":
                ImageScale = (ResolutionScale * multiplayer_WerewolfSlash.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_WerewolfSlash.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x3C6
            case "[HitByObject]":
                ImageScale = (ResolutionScale * multiplayer_HitByObject.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_HitByObject.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x41D
            case "[Flame]":
                ImageScale = (ResolutionScale * multiplayer_Flame.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_Flame.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0x47B
            case "[WerewolfIcon]":
                ImageScale = (ResolutionScale * multiplayer_WerewolfIcon.VL) / YSize;
                CurrWidth = (ResolutionScale * multiplayer_WerewolfIcon.UL) / ImageScale;
                // End:0x4A0
                break;
            // End:0xFFFF
            default:
                Canvas.StrLen(Token, CurrWidth, CurrHeight);
                // End:0x4A0
                break;
                break;
        }
        MaxWidth += CurrWidth;
        Token = GetNextToken(TokenMessage);
        // [Loop Continue]
        goto J0x5D;
    }
    MessageWidth = MaxWidth;
    //return;    
}
