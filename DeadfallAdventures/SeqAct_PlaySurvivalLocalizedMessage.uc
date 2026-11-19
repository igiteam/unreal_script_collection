class SeqAct_PlaySurvivalLocalizedMessage extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum ESurvivalMessages
{
    MESSAGE_VaultOpen,              // 0
    MESSAGE_VaultClose,             // 1
    MESSAGE_WaveStart,              // 2
    MESSAGE_CountDown,              // 3
    MESSAGE_LightDiamond,           // 4
    MESSAGE_CountDown_5,            // 5
    MESSAGE_MAX                     // 6
};

var() SeqAct_PlaySurvivalLocalizedMessage.ESurvivalMessages SurvivalMessage;
var() float Delay;
var string MessageKey;
var string MessageSection;
var SoundCue Sound;
var int CountDown;
var AdvGameSurvivalBase Game;

event Activated()
{
    Game = AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0x392
    if(Game != none)
    {
        switch(SurvivalMessage)
        {
            // End:0xC0
            case 0:
                MessageKey = "ANNO_SUR_VOP_001";
                MessageSection = "MultiplayerAnnouncer";
                Sound = SoundCue'a_anno_sur01_cue.ANNO_SUR_VOP_001';
                // End:0x332
                break;
            // End:0x117
            case 1:
                MessageKey = "ANNO_SUR_VCL_001";
                MessageSection = "MultiplayerAnnouncer";
                Sound = SoundCue'a_anno_sur01_cue.ANNO_SUR_VCL_001';
                // End:0x332
                break;
            // End:0x1F6
            case 2:
                MessageSection = "MultiplayerAnnouncer";
                switch(Rand(3))
                {
                    // End:0x181
                    case 0:
                        MessageKey = "ANNO_SUR_NWAV_001";
                        Sound = SoundCue'a_anno_sur01_cue.ANNO_SUR_NWAV_001';
                        // End:0x1F3
                        break;
                    // End:0x1B8
                    case 1:
                        MessageKey = "ANNO_SUR_NWAV_002";
                        Sound = SoundCue'a_anno_sur01_cue.ANNO_SUR_NWAV_002';
                        // End:0x1F3
                        break;
                    // End:0x1F0
                    case 2:
                        MessageKey = "ANNO_SUR_NWAV_003";
                        Sound = SoundCue'a_anno_sur01_cue.ANNO_SUR_NWAV_003';
                        // End:0x1F3
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                // End:0x332
                break;
            // End:0x276
            case 3:
                MessageSection = "MultiplayerAnnouncer";
                CountDown = 3;
                // End:0x269
                if(Delay > 0.0000000)
                {
                    Game.SetTimer(Delay, false, 'PlayCountDownMessage', self);                    
                }
                else
                {
                    PlayCountDownMessage();
                }
                // End:0x332
                break;
            // End:0x2F1
            case 5:
                MessageSection = "AdvGameSurvival";
                CountDown = 5;
                // End:0x2E4
                if(Delay > 0.0000000)
                {
                    Game.SetTimer(Delay, false, 'PlayCountDownMessage', self);                    
                }
                else
                {
                    PlayCountDownMessage();
                }
                // End:0x332
                break;
            // End:0x32F
            case 4:
                MessageSection = "AdvGameSurvival";
                MessageKey = "LightTheDiamond";
                // End:0x332
                break;
            // End:0xFFFF
            default:
                break;
        }
        // End:0x392
        if(int(SurvivalMessage) != int(3))
        {
            // End:0x388
            if(Delay > 0.0000000)
            {
                Game.SetTimer(Delay, false, 'PlayMessage', self);                
            }
            else
            {
                PlayMessage();
            }
        }
    }
    OutputLinks[1].bHasImpulse = true;
    //return;    
}

function PlayMessage()
{
    local AdvPlayerControllerMP PC;

    // End:0xBE
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        PC.SetAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString(MessageSection, MessageKey, "AdvGame"), Sound, int(SurvivalMessage) != int(0));        
    }    
    //return;    
}

function PlayCountDownMessage()
{
    switch(CountDown)
    {
        // End:0x6C
        case 5:
            MessageKey = "Countdown5";
            Sound = SoundCue'a_anno_global01_cue.a_Countdown_05';
            Game.SetTimer(1.0000000, false, 'PlayCountDownMessage', self);
            // End:0x28E
            break;
        // End:0xC5
        case 4:
            MessageKey = "Countdown4";
            Sound = SoundCue'a_anno_global01_cue.a_Countdown_04';
            Game.SetTimer(1.0000000, false, 'PlayCountDownMessage', self);
            // End:0x28E
            break;
        // End:0x15F
        case 3:
            // End:0x10B
            if(MessageSection ~= "MultiplayerAnnouncer")
            {
                MessageKey = "a_Countdown_03";                
            }
            else
            {
                MessageKey = "Countdown3";
            }
            Sound = SoundCue'a_anno_global01_cue.a_Countdown_03';
            Game.SetTimer(1.0000000, false, 'PlayCountDownMessage', self);
            // End:0x28E
            break;
        // End:0x1F9
        case 2:
            // End:0x1A5
            if(MessageSection ~= "MultiplayerAnnouncer")
            {
                MessageKey = "a_Countdown_02";                
            }
            else
            {
                MessageKey = "Countdown2";
            }
            Sound = SoundCue'a_anno_global01_cue.a_Countdown_02';
            Game.SetTimer(1.0000000, false, 'PlayCountDownMessage', self);
            // End:0x28E
            break;
        // End:0x28B
        case 1:
            // End:0x23E
            if(MessageSection ~= "MultiplayerAnnouncer")
            {
                MessageKey = "a_Countdown_01";                
            }
            else
            {
                MessageKey = "Countdown1";
            }
            Sound = SoundCue'a_anno_global01_cue.a_Countdown_01';
            OutputLinks[1].bHasImpulse = true;
            // End:0x28E
            break;
        // End:0xFFFF
        default:
            break;
    }
    CountDown--;
    PlayMessage();
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Message Played",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks=none
    ObjName="Play Survival Localized Message"
}