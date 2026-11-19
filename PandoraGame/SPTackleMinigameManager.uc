class SPTackleMinigameManager extends Actor
    native
    notplaceable;

struct native TackleHUDElement
{
    var Material mat;
    var Vector2D canvasSize;
    var Vector2D Position;

    structdefaultproperties
    {
        mat=none
        canvasSize=(X=0.0000000,Y=0.0000000)
        Position=(X=0.0000000,Y=0.0000000)
    }
};

struct native SButtonMashInfo
{
    var float TimeLeft;
    var float tickTimer;
    var float playerPushAmountPass1;
    var float playerPushAmountPass2;
    var float werewolfPushTickPass1;
    var float werewolfPushTickPass2;
    var float werewolfPushAmountPass1;
    var float werewolfPushAmountPass2;
    var float damageTotalNeededPass1;
    var float damageTotalNeededPass2;
    var TackleHUDElement mashButtonMat;
    var TackleHUDElement mashButtonMatStage2A;
    var TackleHUDElement mashButtonMatStage2X;
    var TackleHUDElement mashButtonMatStage2Y;
    var TackleHUDElement mashButtonMatTrigger;

    structdefaultproperties
    {
        TimeLeft=5.0000000
        tickTimer=0.0000000
        playerPushAmountPass1=0.0150000
        playerPushAmountPass2=0.0150000
        werewolfPushTickPass1=0.0100000
        werewolfPushTickPass2=0.0100000
        werewolfPushAmountPass1=0.0100000
        werewolfPushAmountPass2=0.0100000
        damageTotalNeededPass1=1.0000000
        damageTotalNeededPass2=1.0000000
        mashButtonMat=(mat=none,canvasSize=(X=0.0000000,Y=0.0000000),Position=(X=0.0000000,Y=0.0000000))
        mashButtonMatStage2A=(mat=none,canvasSize=(X=0.0000000,Y=0.0000000),Position=(X=0.0000000,Y=0.0000000))
        mashButtonMatStage2X=(mat=none,canvasSize=(X=0.0000000,Y=0.0000000),Position=(X=0.0000000,Y=0.0000000))
        mashButtonMatStage2Y=(mat=none,canvasSize=(X=0.0000000,Y=0.0000000),Position=(X=0.0000000,Y=0.0000000))
        mashButtonMatTrigger=(mat=none,canvasSize=(X=0.0000000,Y=0.0000000),Position=(X=0.0000000,Y=0.0000000))
    }
};

var SPBaseWerewolfAIController Werewolf;
var PandoraPlayerController Player;
var float Timer;
var float buttonPressedTime;
var float CurrentTime;
var float buttonPressedTimeHit;
/** Data that is used for the button mash portion of the tackle minigame */
var(ButtonMash) SButtonMashInfo buttonMashInfo;
var private float buttonAnimFrameCounter;
var Material buttonBFrame1;
var Material buttonBFrame2;
var Material buttonStage2AFrame1;
var Material buttonStage2AFrame2;
var Material buttonStage2XFrame1;
var Material buttonStage2XFrame2;
var Material buttonStage2YFrame1;
var Material buttonStage2YFrame2;
var bool Mash1Pass;
var bool Mash1Fail;
var bool Mash1Aborted;
var bool Mash2Pass;
var bool Mash2Fail;
var bool TMGActive;
var bool TMGButtonHit;
var bool TMGStage2Transition;
var int m_MiniGameStage2Button;
var int m_MiniGameWinButton;
var SPGameDifficultyTuneGamePlay m_GameplayGDTuneData;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    SetButtonMaterials(none);
    //return;    
}

simulated function SetButtonMaterials(PandoraPlayerController PlayerController)
{
    local bool bUsingGamepad;

    // End:0x1FC
    if(WorldInfo != none)
    {
        // End:0xFF
        if(WorldInfo.IsConsoleBuild())
        {
            // End:0x8F
            if(WorldInfo.IsConsoleBuild(2))
            {
                buttonBFrame1 = Material'SP_Hud.Material.Button_O_Color_PS3';
                buttonBFrame2 = Material'SP_Hud.Material.Button_O_Gray_PS3';
                buttonStage2AFrame1 = Material'SP_Hud.Material.Button_X_Color_PS3';
                buttonStage2AFrame2 = Material'SP_Hud.Material.Button_X_Gray_PS3';
                buttonStage2XFrame1 = Material'SP_Hud.Material.Button_SQR_Color_PS3';
                buttonStage2XFrame2 = Material'SP_Hud.Material.Button_SQR_Gray_PS3';
                buttonStage2YFrame1 = Material'SP_Hud.Material.Button_TRG_Color_PS3';
                buttonStage2YFrame2 = Material'SP_Hud.Material.Button_TRG_Gray_PS3';                
            }
            else
            {
                // End:0xFC
                if(WorldInfo.IsConsoleBuild(1))
                {
                    buttonBFrame1 = Material'SP_Hud.Material.Button_B_Color';
                    buttonBFrame2 = Material'SP_Hud.Material.Button_B_Gray';
                    buttonStage2AFrame1 = Material'SP_Hud.Material.Button_A_Color';
                    buttonStage2AFrame2 = Material'SP_Hud.Material.Button_A_Gray';
                    buttonStage2XFrame1 = Material'SP_Hud.Material.Button_X_Color';
                    buttonStage2XFrame2 = Material'SP_Hud.Material.Button_X_Gray';
                    buttonStage2YFrame1 = Material'SP_Hud.Material.Button_Y_Color';
                    buttonStage2YFrame2 = Material'SP_Hud.Material.Button_Y_Gray';
                }
            }            
        }
        else
        {
            // End:0x140
            if(PlayerController != none)
            {
                // End:0x140
                if(PlayerController.PlayerInput != none)
                {
                    bUsingGamepad = PlayerController.PlayerInput.bUsingGamepad;
                }
            }
            // End:0x1A4
            if(bUsingGamepad)
            {
                buttonBFrame1 = Material'SP_Hud.Material.Button_B_Color';
                buttonBFrame2 = Material'SP_Hud.Material.Button_B_Gray';
                buttonStage2AFrame1 = Material'SP_Hud.Material.Button_A_Color';
                buttonStage2AFrame2 = Material'SP_Hud.Material.Button_A_Gray';
                buttonStage2XFrame1 = Material'SP_Hud.Material.Button_X_Color';
                buttonStage2XFrame2 = Material'SP_Hud.Material.Button_X_Gray';
                buttonStage2YFrame1 = Material'SP_Hud.Material.Button_Y_Color';
                buttonStage2YFrame2 = Material'SP_Hud.Material.Button_Y_Gray';                
            }
            else
            {
                buttonBFrame1 = Material'SP_Hud.Material.Key_All_Up';
                buttonBFrame2 = Material'SP_Hud.Material.Key_Right_Gray';
                buttonStage2AFrame1 = Material'SP_Hud.Material.Key_All_Up';
                buttonStage2AFrame2 = Material'SP_Hud.Material.Key_Down_Gray';
                buttonStage2XFrame1 = Material'SP_Hud.Material.Key_All_Up';
                buttonStage2XFrame2 = Material'SP_Hud.Material.Key_Left_Gray';
                buttonStage2YFrame1 = Material'SP_Hud.Material.Key_All_Up';
                buttonStage2YFrame2 = Material'SP_Hud.Material.Key_Up_Gray';
            }
        }
    }
    //return;    
}

function DBG_MsgTMGM(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

function StartMinigame(SPBaseWerewolfAIController werewolfController, PandoraPlayerController PlayerController)
{
    Werewolf = werewolfController;
    Player = PlayerController;
    SetButtonMaterials(PlayerController);
    // End:0x45
    if(Player != none)
    {
        Player.ResetAndPushLookDownSiteState(true);
    }
    TMGActive = true;
    TMGButtonHit = false;
    GotoState('ButtonMash1');
    //return;    
}

function BeginTackleMinigame(PandoraPlayerController PlayerController)
{
    local SButtonMashInfo buttonMashDefaults;

    SetButtonMaterials(PlayerController);
    buttonMashInfo = buttonMashDefaults;
    buttonAnimFrameCounter = 0.0000000;
    buttonMashInfo.mashButtonMat.mat = buttonBFrame1;
    buttonMashInfo.mashButtonMat.canvasSize.X = 256.0000000;
    buttonMashInfo.mashButtonMat.canvasSize.Y = 256.0000000;
    buttonMashInfo.mashButtonMat.Position.X = 474.0000000;
    buttonMashInfo.mashButtonMat.Position.Y = 252.0000000;
    buttonMashInfo.mashButtonMatStage2A.mat = buttonStage2AFrame1;
    buttonMashInfo.mashButtonMatStage2A.canvasSize.X = 256.0000000;
    buttonMashInfo.mashButtonMatStage2A.canvasSize.Y = 256.0000000;
    buttonMashInfo.mashButtonMatStage2A.Position.X = 474.0000000;
    buttonMashInfo.mashButtonMatStage2A.Position.Y = 252.0000000;
    buttonMashInfo.mashButtonMatStage2X.mat = buttonStage2XFrame1;
    buttonMashInfo.mashButtonMatStage2X.canvasSize.X = 256.0000000;
    buttonMashInfo.mashButtonMatStage2X.canvasSize.Y = 256.0000000;
    buttonMashInfo.mashButtonMatStage2X.Position.X = 474.0000000;
    buttonMashInfo.mashButtonMatStage2X.Position.Y = 252.0000000;
    buttonMashInfo.mashButtonMatStage2Y.mat = buttonStage2YFrame1;
    buttonMashInfo.mashButtonMatStage2Y.canvasSize.X = 256.0000000;
    buttonMashInfo.mashButtonMatStage2Y.canvasSize.Y = 256.0000000;
    buttonMashInfo.mashButtonMatStage2Y.Position.X = 474.0000000;
    buttonMashInfo.mashButtonMatStage2Y.Position.Y = 252.0000000;
    //return;    
}

function bool IsMiniGameInProgress()
{
    // End:0x26
    if((GetStateName() == 'ButtonMash1') || GetStateName() == 'ButtonMash2')
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsKillshotInProgress()
{
    // End:0x16
    if(GetStateName() == 'ButtonMash2Pass')
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool IsExpired(float t_timer)
{
    // End:0x11
    if(t_timer < 0.0000000)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function TMGButtonHitTimerMash1()
{
    //return;    
}

function TMGButtonHitTimerMash2()
{
    //return;    
}

function int CheckMash1PassTransitionNumber()
{
    return m_MiniGameStage2Button;
    //return ReturnValue;    
}

function int CheckMashWinTransitionNumber()
{
    return m_MiniGameWinButton;
    //return ReturnValue;    
}

function TransitionToStages()
{
    // End:0x2F
    if(GetStateName() == 'ButtonMash1Pass')
    {
        TMGButtonHit = false;
        TMGStage2Transition = true;
        GotoState('ButtonMash2');
    }
    //return;    
}

function PushWerewolfOffPlayer()
{
    buttonPressedTimeHit = CurrentTime - buttonPressedTime;
    buttonPressedTime = WorldInfo.TimeSeconds;
    // End:0x4E
    if(GetStateName() == 'ButtonMash2Pass')
    {
        TMGButtonHit = true;
        GotoState('MiniGameWin');
    }
    // End:0x9C
    if(TMGButtonHit)
    {
        // End:0x7B
        if(GetStateName() == 'ButtonMash1')
        {
            ClearTimer('TMGButtonHitTimerMash1');            
        }
        else
        {
            // End:0x9C
            if(GetStateName() == 'ButtonMash2')
            {
                ClearTimer('TMGButtonHitTimerMash2');
            }
        }
    }
    TMGButtonHit = true;
    // End:0xCB
    if(GetStateName() == 'ButtonMash1')
    {
        SetTimer(0.2000000, false, 'TMGButtonHitTimerMash1');        
    }
    else
    {
        // End:0xEF
        if(GetStateName() == 'ButtonMash2')
        {
            SetTimer(0.2000000, false, 'TMGButtonHitTimerMash2');
        }
    }
    return;
    //return;    
}

function EndTackleMinigame()
{
    buttonMashInfo.mashButtonMat.mat = none;
    buttonMashInfo.mashButtonMatTrigger.mat = none;
    buttonMashInfo.mashButtonMatStage2A.mat = none;
    buttonMashInfo.mashButtonMatStage2X.mat = none;
    buttonMashInfo.mashButtonMatStage2Y.mat = none;
    TMGActive = false;
    // End:0xB8
    if(Player != none)
    {
        Player.RestorePushedLookDownSiteState();
    }
    //return;    
}

function bool IsState(name CurState)
{
    // End:0x0F
    if(CurState == GetStateName())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function AnimateButtonPress(float TickTime)
{
    buttonAnimFrameCounter += TickTime;
    // End:0xC1
    if((GetStateName() == 'ButtonMash1') || GetStateName() == 'ButtonMash2')
    {
        // End:0xBE
        if(buttonAnimFrameCounter >= m_GameplayGDTuneData.Stage1And2ButtonAnimationSpeed)
        {
            buttonAnimFrameCounter = 0.0000000;
            // End:0x9D
            if(buttonMashInfo.mashButtonMat.mat == buttonBFrame1)
            {
                buttonMashInfo.mashButtonMat.mat = buttonBFrame2;                
            }
            else
            {
                buttonMashInfo.mashButtonMat.mat = buttonBFrame1;
            }
        }        
    }
    else
    {
        // End:0x260
        if(GetStateName() == 'ButtonMash2Pass')
        {
            // End:0x25D
            if(buttonAnimFrameCounter >= m_GameplayGDTuneData.KillShotAnimationSpeed)
            {
                buttonAnimFrameCounter = 0.0000000;
                // End:0x16E
                if(m_MiniGameWinButton == 1)
                {
                    // End:0x14A
                    if(buttonMashInfo.mashButtonMatStage2A.mat == buttonStage2AFrame1)
                    {
                        buttonMashInfo.mashButtonMatStage2A.mat = buttonStage2AFrame2;                        
                    }
                    else
                    {
                        buttonMashInfo.mashButtonMatStage2A.mat = buttonStage2AFrame1;
                    }                    
                }
                else
                {
                    // End:0x1E7
                    if(m_MiniGameWinButton == 2)
                    {
                        // End:0x1C3
                        if(buttonMashInfo.mashButtonMatStage2X.mat == buttonStage2XFrame1)
                        {
                            buttonMashInfo.mashButtonMatStage2X.mat = buttonStage2XFrame2;                            
                        }
                        else
                        {
                            buttonMashInfo.mashButtonMatStage2X.mat = buttonStage2XFrame1;
                        }                        
                    }
                    else
                    {
                        // End:0x25D
                        if(m_MiniGameWinButton == 3)
                        {
                            // End:0x23C
                            if(buttonMashInfo.mashButtonMatStage2Y.mat == buttonStage2YFrame1)
                            {
                                buttonMashInfo.mashButtonMatStage2Y.mat = buttonStage2YFrame2;                                
                            }
                            else
                            {
                                buttonMashInfo.mashButtonMatStage2Y.mat = buttonStage2YFrame1;
                            }
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0x3FC
            if(GetStateName() == 'ButtonMash1Pass')
            {
                // End:0x3FC
                if(buttonAnimFrameCounter >= m_GameplayGDTuneData.Stage2ChoiceButtonAnimationSpeed)
                {
                    buttonAnimFrameCounter = 0.0000000;
                    // End:0x30D
                    if(m_MiniGameStage2Button == 1)
                    {
                        // End:0x2E9
                        if(buttonMashInfo.mashButtonMatStage2A.mat == buttonStage2AFrame1)
                        {
                            buttonMashInfo.mashButtonMatStage2A.mat = buttonStage2AFrame2;                            
                        }
                        else
                        {
                            buttonMashInfo.mashButtonMatStage2A.mat = buttonStage2AFrame1;
                        }                        
                    }
                    else
                    {
                        // End:0x386
                        if(m_MiniGameStage2Button == 2)
                        {
                            // End:0x362
                            if(buttonMashInfo.mashButtonMatStage2X.mat == buttonStage2XFrame1)
                            {
                                buttonMashInfo.mashButtonMatStage2X.mat = buttonStage2XFrame2;                                
                            }
                            else
                            {
                                buttonMashInfo.mashButtonMatStage2X.mat = buttonStage2XFrame1;
                            }                            
                        }
                        else
                        {
                            // End:0x3FC
                            if(m_MiniGameStage2Button == 3)
                            {
                                // End:0x3DB
                                if(buttonMashInfo.mashButtonMatStage2Y.mat == buttonStage2YFrame1)
                                {
                                    buttonMashInfo.mashButtonMatStage2Y.mat = buttonStage2YFrame2;                                    
                                }
                                else
                                {
                                    buttonMashInfo.mashButtonMatStage2Y.mat = buttonStage2YFrame1;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function ResumePlayerControl()
{
    Player.EndTackle();
    Player.NoLongerBeingTackled();
    Player.DoUnLookDownSite(true);
    Player.GotoState('ResumePlayerControl');
    GotoState('Sleeping');
    //return;    
}

function Mash1TransitionFinished()
{
    GotoState('ButtonMash2');
    //return;    
}

function CheckButtonMeter(float pushAmount, float pushAmountPlayer, float pushTick, float TickTime)
{
    local float totalPushAmount;

    // End:0x65B
    if(buttonMashInfo.tickTimer > pushTick)
    {
        buttonMashInfo.tickTimer -= pushTick;
        buttonMashInfo.TimeLeft -= pushTick;
        // End:0x353
        if(GetStateName() == 'ButtonMash1')
        {
            // End:0x1ED
            if(TMGButtonHit)
            {
                // End:0x86
                if(buttonPressedTimeHit > 0.2500000)
                {
                    totalPushAmount = pushAmountPlayer - pushAmount;                    
                }
                else
                {
                    totalPushAmount = pushAmountPlayer - (pushAmountPlayer * buttonPressedTimeHit);
                }
                // End:0x10D
                if(Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations >= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage1TopThreshold))
                {
                    totalPushAmount *= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage1TopThresholdValue);                    
                }
                else
                {
                    // End:0x1BB
                    if((Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations >= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage1LowRangeThreshold)) && Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations < m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage1HighRangeThreshold))
                    {
                        totalPushAmount *= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage1HighLowRangeThresholdValue);
                    }
                }
                // End:0x1EA
                if(TickTime > m_GameplayGDTuneData.FPSThreshold)
                {
                    totalPushAmount += m_GameplayGDTuneData.FPSBoost;
                }                
            }
            else
            {
                totalPushAmount = -pushAmount;
                // End:0x265
                if(Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations <= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage1BottomThreshold))
                {
                    totalPushAmount *= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage1BottomThresholdValue);
                }
            }
            // End:0x2A0
            if((Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations + totalPushAmount) >= 1.0000000)
            {
                GotoState('ButtonMash1Pass');                
            }
            else
            {
                // End:0x342
                if(((Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations + totalPushAmount) < 1.0000000) && (Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations + totalPushAmount) > 0.0000000)
                {
                    Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations += totalPushAmount;
                    Player.m_blendValueForMash1Animations = Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations;                    
                }
                else
                {
                    GotoState('ButtonMash1Fail');
                }
            }            
        }
        else
        {
            // End:0x65B
            if(GetStateName() == 'ButtonMash2')
            {
                // End:0x4F8
                if(TMGButtonHit)
                {
                    // End:0x391
                    if(buttonPressedTimeHit > 0.2500000)
                    {
                        totalPushAmount = pushAmountPlayer - pushAmount;                        
                    }
                    else
                    {
                        totalPushAmount = pushAmountPlayer - (pushAmountPlayer * buttonPressedTimeHit);
                    }
                    // End:0x418
                    if(Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations >= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2TopThreshold))
                    {
                        totalPushAmount *= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2TopThresholdValue);                        
                    }
                    else
                    {
                        // End:0x4C6
                        if((Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations >= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2LowRangeThreshold)) && Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations < m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2HighRangeThreshold))
                        {
                            totalPushAmount *= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2HighLowRangeThresholdValue);
                        }
                    }
                    // End:0x4F5
                    if(TickTime > m_GameplayGDTuneData.FPSThreshold)
                    {
                        totalPushAmount += m_GameplayGDTuneData.FPSBoost;
                    }                    
                }
                else
                {
                    totalPushAmount = -pushAmount;
                    // End:0x570
                    if(Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations <= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2BottomThreshold))
                    {
                        totalPushAmount *= m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2BottomThresholdValue);
                    }
                }
                // End:0x5AB
                if((Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations + totalPushAmount) >= 1.0000000)
                {
                    GotoState('ButtonMash2Pass');                    
                }
                else
                {
                    // End:0x64D
                    if(((Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations + totalPushAmount) < 1.0000000) && (Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations + totalPushAmount) > 0.0000000)
                    {
                        Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations += totalPushAmount;
                        Player.m_blendValueForMash2Animations = Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations;                        
                    }
                    else
                    {
                        GotoState('ButtonMash2Fail');
                    }
                }
            }
        }
    }
    //return;    
}

function Tick(float TickTime)
{
    // End:0x0D
    if(!TMGActive)
    {
        return;
    }
    CurrentTime = WorldInfo.TimeSeconds;
    switch(GetStateName())
    {
        // End:0xE1
        case 'ButtonMash1':
            AnimateButtonPress(TickTime);
            Timer -= TickTime;
            buttonMashInfo.tickTimer += TickTime;
            CheckButtonMeter(m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.WerewolfPushAmountStage1), m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.PlayerPushAmountStage1), m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.WerewolfPushTickStage1), TickTime);
            // End:0x22D
            break;
        // End:0xF0
        case 'ButtonMash1Fail':
            // End:0x22D
            break;
        // End:0x11A
        case 'ButtonMash1Pass':
            AnimateButtonPress(TickTime);
            Timer -= TickTime;
            // End:0x22D
            break;
        // End:0x129
        case 'ButtonMash1Abort':
            // End:0x22D
            break;
        // End:0x1E2
        case 'ButtonMash2':
            AnimateButtonPress(TickTime);
            Timer -= TickTime;
            buttonMashInfo.tickTimer += TickTime;
            CheckButtonMeter(m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.WerewolfPushAmountStage2), m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.PlayerPushAmountStage2), m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.WerewolfPushTickStage2), TickTime);
            // End:0x22D
            break;
        // End:0x1F1
        case 'ButtonMash2Fail':
            // End:0x22D
            break;
        // End:0x21B
        case 'ButtonMash2Pass':
            AnimateButtonPress(TickTime);
            Timer -= TickTime;
            // End:0x22D
            break;
        // End:0x22A
        case 'MiniGameWin':
            // End:0x22D
            break;
        // End:0xFFFF
        default:
            break;
    }
    PlayerPawn(Player.Pawn).playerHud.UpdateTackleGameInfo(buttonMashInfo);
    Player.UpdateTMGPostProcessing();
    //return;    
}

state Sleeping
{Begin:

    stop;                
}

state ButtonMash1
{
    function BeginState(name PreviousStateName)
    {
        Mash1Pass = false;
        Mash1Fail = false;
        Mash1Aborted = false;
        buttonMashInfo.mashButtonMat.mat = buttonBFrame1;
        SetTimer(m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage1FailTimer), false, 'ButtonFailTimer');
        Werewolf.m_WerewolfPawn.m_blendValueForMash1Animations = 0.5000000;
        Player.m_blendValueForMash1Animations = 0.5000000;
        Werewolf.StartAction(50, false, WorldInfo.TimeSeconds + 0.0100000);
        Player.StartMinigameTackleAction(9, WorldInfo.TimeSeconds + 0.0100000);
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('ButtonFailTimer');
        ClearTimer('TMGButtonHitTimerMash1');
        //return;        
    }

    function TMGButtonHitTimerMash1()
    {
        TMGButtonHit = false;
        //return;        
    }

    function ButtonFailTimer()
    {
        GotoState('ButtonMash1Fail');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimers();
        //return;        
    }
Begin:

    stop;                
}

state ButtonMash1Fail
{
    function BeginState(name PreviousStateName)
    {
        PlayerPawn(Player.Pawn).DoToggleTargettable(true);
        Player.m_TMGBlendState = 0;
        Werewolf.StartAction(54, false, WorldInfo.TimeSeconds + 0.0100000);
        Player.StartMinigameTackleAction(13, WorldInfo.TimeSeconds + 0.0100000);
        //return;        
    }
Begin:

    stop;                
}

state ButtonMash1Pass
{
    function BeginState(name PreviousStateName)
    {
        TMGStage2Transition = false;
        Player.m_TMGBlendState = 0;
        Werewolf.StartAction(51, false, WorldInfo.TimeSeconds + 0.0100000);
        Player.StartMinigameTackleAction(10, WorldInfo.TimeSeconds + 0.0100000);
        SetTimer(m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2ChoiceTimer), false, 'Stage2ChoiceTimedOut');
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('Stage2ChoiceTimedOut');
        //return;        
    }

    function Stage2ChoiceTimedOut()
    {
        GotoState('ButtonMash1Abort');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimers();
        //return;        
    }
Begin:

    stop;                
}

state ButtonMash1Abort
{
    function BeginState(name PreviousStateName)
    {
        Player.m_TMGBlendState = 0;
        Werewolf.StartAction(52, false, WorldInfo.TimeSeconds + 0.0100000);
        Player.StartMinigameTackleAction(11, WorldInfo.TimeSeconds + 0.0100000);
        //return;        
    }
Begin:

    stop;                
}

state ButtonMash2
{
    function BeginState(name PreviousStateName)
    {
        Werewolf.m_WerewolfPawn.m_blendValueForMash2Animations = 0.5000000;
        Player.m_blendValueForMash2Animations = 0.5000000;
        buttonMashInfo.mashButtonMat.mat = buttonBFrame1;
        SetTimer(m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.Stage2FailTimer), false, 'ButtonFailTimer2');
        Werewolf.StartAction(55, false, WorldInfo.TimeSeconds + 0.0100000);
        Player.StartMinigameTackleAction(14, WorldInfo.TimeSeconds + 0.0100000);
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimers();
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('ButtonFailTimer2');
        ClearTimer('TMGButtonHitTimerMash2');
        //return;        
    }

    function ButtonFailTimer2()
    {
        GotoState('ButtonMash2Fail');
        //return;        
    }

    function TMGButtonHitTimerMash2()
    {
        TMGButtonHit = false;
        //return;        
    }
Begin:

    stop;                
}

state ButtonMash2Fail
{
    function BeginState(name PreviousStateName)
    {
        PlayerPawn(Player.Pawn).DoToggleTargettable(true);
        Player.m_TMGBlendState = 0;
        Werewolf.StartAction(56, false, WorldInfo.TimeSeconds + 0.0100000);
        Player.StartMinigameTackleAction(15, WorldInfo.TimeSeconds + 0.0100000);
        //return;        
    }
Begin:

    stop;                
}

state ButtonMash2Pass
{
    function BeginState(name PreviousStateName)
    {
        Player.m_TMGBlendState = 0;
        SetTimer(m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.KillShotTimeOut), false, 'KillshotTimedOut');
        TMGButtonHit = false;
        //return;        
    }

    function KillshotTimedOut()
    {
        GotoState('ButtonMash2Fail');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimers();
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('KillshotTimedOut');
        //return;        
    }
Begin:

    stop;                
}

state MiniGameWin
{
    function BeginState(name PreviousStateName)
    {
        Player.m_TMGBlendState = 0;
        Player.SwapToMeleeWeaponIfApplicable();
        //return;        
    }
Begin:

    Sleep(0.5000000);
    Werewolf.StartAction(58, false, WorldInfo.TimeSeconds + 0.0100000);
    Player.StartMinigameTackleAction(17, WorldInfo.TimeSeconds + 0.0100000);
    stop;            
}
