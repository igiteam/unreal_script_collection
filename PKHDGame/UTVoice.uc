class UTVoice extends UTLocalMessage
    abstract;

const ACKINDEXSTART = 600;
const FRIENDLYFIREINDEXSTART = 700;
const GOTYOURBACKINDEXSTART = 800;
const NEEDOURFLAGINDEXSTART = 900;
const SNIPERINDEXINDEXSTART = 1000;
const LOCATIONUPDATEINDEXSTART = 1100;
const INPOSITIONINDEXSTART = 1200;
const ENEMYSTATUSINDEXSTART = 1300;
const KILLEDVEHICLEINDEXSTART = 1400;
const ENEMYFLAGCARRIERINDEXSTART = 1500;
const HOLDINGFLAGINDEXSTART = 1600;
const AREASECUREINDEXSTART = 1700;
const GOTOURFLAGINDEXSTART = 1900;
const NODECONSTRUCTEDINDEXSTART = 2000;

var array<SoundNodeWave> AckSounds;
var array<SoundNodeWave> FriendlyFireSounds;
var array<SoundNodeWave> GotYourBackSounds;
var array<SoundNodeWave> NeedOurFlagSounds;
var array<SoundNodeWave> SniperSounds;
var array<SoundNodeWave> InPositionSounds;
var array<SoundNodeWave> HaveFlagSounds;
var array<SoundNodeWave> AreaSecureSounds;
var SoundNodeWave IncomingSound;
var SoundNodeWave EnemyFlagCarrierSound;
var SoundNodeWave EnemyFlagCarrierHereSound;
var SoundNodeWave EnemyFlagCarrierHighSound;
var SoundNodeWave EnemyFlagCarrierLowSound;
var SoundNodeWave MidfieldSound;
var SoundNodeWave GotOurFlagSound;
var int LocationSpeechOffset;

static function int GetAckMessageIndex(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    // End:0x16
    if(default.AckSounds.Length == 0)
    {
        return -1;
    }
    return 600 + Rand(default.AckSounds.Length);
    //return ReturnValue;    
}

static function int GetFriendlyFireMessageIndex(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    // End:0x56
    if(((default.FriendlyFireSounds.Length == 0) || Recipient == none) || UTPlayerController(Recipient.Owner) == none)
    {
        return -1;
    }
    UTPlayerController(Recipient.Owner).LastFriendlyFireTime = Sender.WorldInfo.TimeSeconds;
    return 700 + Rand(default.FriendlyFireSounds.Length);
    //return ReturnValue;    
}

static function int GetGotYourBackMessageIndex(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    // End:0x16
    if(default.GotYourBackSounds.Length == 0)
    {
        return -1;
    }
    return 800 + Rand(default.GotYourBackSounds.Length);
    //return ReturnValue;    
}

static function int GetNeedOurFlagMessageIndex(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    // End:0x16
    if(default.NeedOurFlagSounds.Length == 0)
    {
        return -1;
    }
    return 900 + Rand(default.NeedOurFlagSounds.Length);
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    UTPlayerController(P).PlayAnnouncement(default.Class, Switch, RelatedPRI_1, OptionalObject);
    //return;    
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    local EvilPickupFactory F;
    local EvilGameObjective O;

    MessageIndex -= 500;
    // End:0x21
    if(MessageIndex < 0)
    {
        return none;
    }
    MessageIndex -= 100;
    // End:0x3F
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x6B
    if(MessageIndex < default.AckSounds.Length)
    {
        return default.AckSounds[MessageIndex];
    }
    MessageIndex -= 100;
    // End:0x89
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0xB5
    if(MessageIndex < default.FriendlyFireSounds.Length)
    {
        return default.FriendlyFireSounds[MessageIndex];
    }
    MessageIndex -= 100;
    // End:0xD3
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0xFF
    if(MessageIndex < default.GotYourBackSounds.Length)
    {
        return default.GotYourBackSounds[MessageIndex];
    }
    MessageIndex -= 100;
    // End:0x11D
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x149
    if(MessageIndex < default.NeedOurFlagSounds.Length)
    {
        return default.NeedOurFlagSounds[MessageIndex];
    }
    MessageIndex -= 100;
    // End:0x167
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x193
    if(MessageIndex < default.SniperSounds.Length)
    {
        return default.SniperSounds[MessageIndex];
    }
    MessageIndex -= 100;
    // End:0x1B1
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x2E0
    if(MessageIndex < 100)
    {
        // End:0x1EC
        if((OptionalObject == none) || MessageIndex == 10)
        {
            return default.MidfieldSound;
        }
        O = EvilGameObjective(OptionalObject);
        // End:0x252
        if(O != none)
        {
            return O.GetLocationSpeechFor(PC, default.LocationSpeechOffset, MessageIndex);
        }
        F = EvilPickupFactory(OptionalObject);
        // End:0x2D6
        if(F != none)
        {
            return ((default.LocationSpeechOffset < F.LocationSpeech.Length) ? F.LocationSpeech[default.LocationSpeechOffset] : none);
        }
        return default.MidfieldSound;
    }
    MessageIndex -= 100;
    // End:0x2FE
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x32A
    if(MessageIndex < default.InPositionSounds.Length)
    {
        return default.InPositionSounds[MessageIndex];
    }
    MessageIndex -= 100;
    // End:0x348
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x374
    if(MessageIndex == 0)
    {
        return EnemySound(PC, OptionalObject);
    }
    MessageIndex -= 100;
    // End:0x392
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x3BE
    if(MessageIndex == 0)
    {
        return KilledVehicleSound(PC, OptionalObject);
    }
    MessageIndex -= 100;
    // End:0x3DC
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x42D
    if(MessageIndex < 100)
    {
        // End:0x409
        if(MessageIndex == 2)
        {
            return default.EnemyFlagCarrierHighSound;            
        }
        else
        {
            // End:0x423
            if(MessageIndex == 3)
            {
                return default.EnemyFlagCarrierLowSound;
            }
        }
        return default.EnemyFlagCarrierHereSound;
    }
    MessageIndex -= 100;
    // End:0x44B
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x4A7
    if(MessageIndex < 100)
    {
        MessageIndex -= 50;
        // End:0x479
        if(MessageIndex < 0)
        {
            return none;
        }
        // End:0x4A5
        if(MessageIndex < default.HaveFlagSounds.Length)
        {
            return default.HaveFlagSounds[MessageIndex];
        }
        return none;
    }
    MessageIndex -= 100;
    // End:0x4C5
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x4F1
    if(MessageIndex < default.AreaSecureSounds.Length)
    {
        return default.AreaSecureSounds[MessageIndex];
    }
    MessageIndex -= 200;
    // End:0x50F
    if(MessageIndex < 0)
    {
        return none;
    }
    // End:0x528
    if(MessageIndex == 0)
    {
        return default.GotOurFlagSound;
    }
    MessageIndex -= 100;
    // End:0x546
    if(MessageIndex < 0)
    {
        return none;
    }
    return none;
    //return ReturnValue;    
}

static function SoundNodeWave EnemySound(PlayerController PC, Object OptionalObject)
{
    local class<EvilVehicle_Base> VehicleClass;
    local EvilPlayerReplicationInfo PRI;
    local EvilPlayerController UTPC;

    VehicleClass = class<EvilVehicle_Base>(OptionalObject);
    // End:0x2D3
    if(VehicleClass == none)
    {
        PRI = EvilPlayerReplicationInfo(OptionalObject);
        // End:0x1EE
        if((((PRI == none) || !PRI.bHasFlag) || PC.WorldInfo.GRI == none) || PC.WorldInfo.GRI.GameClass == none)
        {
            UTPC = EvilPlayerController(PC);
            // End:0x1EC
            if((UTPC != none) && (UTPC.WorldInfo.TimeSeconds - UTPC.LastIncomingMessageTime) > float(35))
            {
                UTPC.LastIncomingMessageTime = UTPC.WorldInfo.TimeSeconds;
                return default.IncomingSound;
            }
            return none;
        }
        // End:0x208
        if(default.LocationSpeechOffset < 3)
        {
            return default.EnemyFlagCarrierSound;
        }
        // End:0x2D1
        if((UTPC != none) && (UTPC.WorldInfo.TimeSeconds - UTPC.LastIncomingMessageTime) > float(25))
        {
            UTPC.LastIncomingMessageTime = UTPC.WorldInfo.TimeSeconds;
            return default.EnemyFlagCarrierSound;
        }
        return none;
    }
    // End:0x329
    if(VehicleClass.default.EnemyVehicleSound.Length > default.LocationSpeechOffset)
    {
        return VehicleClass.default.EnemyVehicleSound[default.LocationSpeechOffset];
    }
    UTPC = EvilPlayerController(PC);
    // End:0x40E
    if((UTPC != none) && (UTPC.WorldInfo.TimeSeconds - UTPC.LastIncomingMessageTime) > float(35))
    {
        UTPC.LastIncomingMessageTime = UTPC.WorldInfo.TimeSeconds;
        return default.IncomingSound;
    }
    return none;
    //return ReturnValue;    
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return "";
    //return ReturnValue;    
}

static function bool AllowVoiceMessage(name MessageType, UTPlayerController PC, PlayerController Recipient)
{
    local float CurrentTime;

    // End:0x40
    if(int(PC.WorldInfo.NetMode) == int(NM_Standalone))
    {
        return true;
    }
    CurrentTime = PC.WorldInfo.TimeSeconds;
    // End:0xFB
    if((CurrentTime - PC.OldMessageTime) < float(4))
    {
        // End:0xFB
        if((MessageType == 'Taunt') || (CurrentTime - PC.OldMessageTime) < float(1))
        {
            return false;
        }
    }
    // End:0x163
    if((Recipient != none) && Recipient.IsPlayerMuted(PC.PlayerReplicationInfo.UniqueId))
    {
        return false;
    }
    // End:0x1C6
    if((CurrentTime - PC.OldMessageTime) < float(6))
    {
        PC.OldMessageTime = CurrentTime + float(3);        
    }
    else
    {
        PC.OldMessageTime = CurrentTime;
    }
    return true;
    //return ReturnValue;    
}

static function SendVoiceMessage(Controller Sender, PlayerReplicationInfo Recipient, name MessageType, class<DamageType> DamageType)
{
    local UTPlayerController PC, SenderPC, RecipientPC;
    local int MessageIndex;
    local bool bFoundFriendlyPlayer;
    local EvilPlayerReplicationInfo SenderPRI;

    SenderPRI = EvilPlayerReplicationInfo(Sender.PlayerReplicationInfo);
    // End:0x42
    if(SenderPRI == none)
    {
        return;
    }
    SenderPC = UTPlayerController(Sender);
    RecipientPC = ((Recipient != none) ? UTPlayerController(Recipient.Owner) : none);
    // End:0x239
    if((RecipientPC == none) && Sender.WorldInfo.Game.bTeamGame)
    {
        // End:0x227
        foreach Sender.WorldInfo.AllControllers(Class'UTPlayerController', PC)
        {
            // End:0x226
            if((((Sender.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo != none) && Sender.PlayerReplicationInfo.Team == PC.PlayerReplicationInfo.Team) && Sender != PC)
            {
                bFoundFriendlyPlayer = true;
                // End:0x227
                break;
            }            
        }        
        // End:0x239
        if(!bFoundFriendlyPlayer)
        {
            return;
        }
    }
    // End:0x276
    if((SenderPC != none) && !AllowVoiceMessage(MessageType, SenderPC, RecipientPC))
    {
        return;
    }
    MessageIndex = GetMessageIndex(Sender, Recipient, MessageType, DamageType);
    // End:0x2C3
    if(MessageIndex == -1)
    {
        return;
    }
    // End:0x315
    if(Recipient != none)
    {
        // End:0x313
        if(RecipientPC != none)
        {
            RecipientPC.ReceiveBotVoiceMessage(SenderPRI, MessageIndex, none);
        }
        return;
    }
    // End:0x558
    foreach Sender.WorldInfo.AllControllers(Class'UTPlayerController', PC)
    {
        // End:0x557
        if(((((PC == Sender) || !Sender.WorldInfo.Game.bTeamGame) || Sender.WorldInfo.GRI.bMatchIsOver) || ((Sender.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo != none) && Sender.PlayerReplicationInfo.Team == PC.PlayerReplicationInfo.Team) && !PC.IsPlayerMuted(Sender.PlayerReplicationInfo.UniqueId))
        {
            PC.ReceiveBotVoiceMessage(SenderPRI, MessageIndex, none);
        }        
    }    
    //return;    
}

static function int GetMessageIndex(Controller Sender, PlayerReplicationInfo Recipient, name MessageType, class<DamageType> DamageType)
{
    switch(MessageType)
    {
        // End:0x25
        case 'Taunt':
            return -1;
        // End:0x5C
        case 'injured':
            InitCombatUpdate(Sender, Recipient, MessageType);
            return -1;
        // End:0x93
        case 'Status':
            InitStatusUpdate(Sender, Recipient, MessageType);
            return -1;
        // End:0x9F
        case 'Incoming':
        // End:0xD6
        case 'INCOMINGVEHICLE':
            SendEnemyStatusUpdate(Sender, Recipient, MessageType);
            return -1;
        // End:0x168
        case 'Location':
            SendLocationUpdate(Sender, Recipient, MessageType, EvilGame(Sender.WorldInfo.Game), Sender.Pawn);
            return -1;
        // End:0x19F
        case 'InPosition':
            SendInPositionMessage(Sender, Recipient, MessageType);
            return -1;
        // End:0x1B1
        case 'MANDOWN':
            return -1;
        // End:0x1E3
        case 'FRIENDLYFIRE':
            return GetFriendlyFireMessageIndex(Sender, Recipient, MessageType);
        // End:0x1F5
        case 'ENCOURAGEMENT':
            return -1;
        // End:0x207
        case 'FLAGKILL':
            return -1;
        // End:0x239
        case 'ACK':
            return GetAckMessageIndex(Sender, Recipient, MessageType);
        // End:0x270
        case 'Sniper':
            InitSniperUpdate(Sender, Recipient, MessageType);
            return -1;
        // End:0x2A2
        case 'GOTYOURBACK':
            return GetGotYourBackMessageIndex(Sender, Recipient, MessageType);
        // End:0x2D9
        case 'HOLDINGFLAG':
            SetHoldingFlagUpdate(Sender, Recipient, MessageType);
            return -1;
        // End:0x2EB
        case 'GOTOURFLAG':
            return 1900;
        // End:0x31D
        case 'NEEDOURFLAG':
            return GetNeedOurFlagMessageIndex(Sender, Recipient, MessageType);
        // End:0x354
        case 'ENEMYFLAGCARRIERHERE':
            SendEnemyFlagCarrierHereUpdate(Sender, Recipient, MessageType);
            return -1;
        // End:0x38B
        case 'VEHICLEKILL':
            SendKilledVehicleMessage(Sender, Recipient, MessageType);
            return -1;
        // End:0xFFFF
        default:
            return -1;
            break;
    }
    //return ReturnValue;    
}

static function InitStatusUpdate(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    //return;    
}

static function InitCombatUpdate(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    local int MessageIndex;

    // End:0x56
    if(Sender.Enemy == none)
    {
        // End:0x36
        if(default.AreaSecureSounds.Length == 0)
        {
            return;
        }
        MessageIndex = 1700 + Rand(default.AreaSecureSounds.Length);        
    }
    else
    {
        return;
    }
    SendLocalizedMessage(Sender, Recipient, MessageType, MessageIndex);
    //return;    
}

static function SetHoldingFlagUpdate(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    local int MessageIndex;

    MessageIndex = 1600;
    // End:0x21
    if(default.HaveFlagSounds.Length == 0)
    {
        return;
    }
    MessageIndex += (50 + Rand(default.HaveFlagSounds.Length));
    SendLocalizedMessage(Sender, Recipient, MessageType, MessageIndex);
    //return;    
}

static function SendLocalizedMessage(Controller Sender, PlayerReplicationInfo Recipient, name MessageType, int MessageIndex, optional Object LocationObject)
{
    local UTPlayerController PC;
    local EvilPlayerReplicationInfo SenderPRI;

    SenderPRI = EvilPlayerReplicationInfo(Sender.PlayerReplicationInfo);
    // End:0x43
    if(SenderPRI == none)
    {
        return;
    }
    // End:0xCF
    if(Recipient != none)
    {
        PC = UTPlayerController(Recipient.Owner);
        // End:0xCC
        if(PC != none)
        {
            PC.ReceiveBotVoiceMessage(SenderPRI, MessageIndex, LocationObject);
        }        
    }
    else
    {
        // End:0x2B3
        foreach Sender.WorldInfo.AllControllers(Class'UTPlayerController', PC)
        {
            // End:0x2B2
            if((!Sender.WorldInfo.Game.bTeamGame || ((Sender.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo != none) && Sender.PlayerReplicationInfo.Team == PC.PlayerReplicationInfo.Team) && !PC.IsPlayerMuted(Sender.PlayerReplicationInfo.UniqueId))
            {
                PC.ReceiveBotVoiceMessage(SenderPRI, MessageIndex, LocationObject);
            }            
        }        
    }
    //return;    
}

static function SendEnemyFlagCarrierHereUpdate(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    local Actor LocationObject;
    local int MessageIndex;
    local EvilGame G;
    local Pawn StatusPawn;
    local EvilCarriedObject Flag;

    G = EvilGame(Sender.WorldInfo.Game);
    StatusPawn = Sender.Enemy;
    // End:0x7F
    if(StatusPawn == none)
    {
        return;
    }
    Flag = EvilPlayerReplicationInfo(StatusPawn.PlayerReplicationInfo).GetFlag();
    // End:0xD7
    if(Flag == none)
    {
        return;
    }
    // End:0x30A
    if((((G != none) && G.bTeamGame) && StatusPawn != none) && G.GetLocationFor(StatusPawn, LocationObject, MessageIndex, default.LocationSpeechOffset))
    {
        // End:0x1EF
        if(((Sender.WorldInfo.TimeSeconds - Flag.LastFlagSeeTime) < float(20)) && MessageIndex == Flag.LastSeeMessageIndex)
        {
            return;
        }
        Flag.LastFlagSeeTime = Sender.WorldInfo.TimeSeconds;
        Flag.LastSeeMessageIndex = MessageIndex;
        MessageIndex += 1500;
        SendLocalizedMessage(Sender, Recipient, MessageType, MessageIndex, Flag);
        // End:0x30A
        if(MessageIndex < 1502)
        {
            MessageIndex -= 400;
            SendLocalizedMessage(Sender, Recipient, MessageType, MessageIndex, LocationObject);
        }
    }
    //return;    
}

static function InitSniperUpdate(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    local int MessageIndex;
    local EvilGame G;

    // End:0x12
    if(default.SniperSounds.Length == 0)
    {
        return;
    }
    MessageIndex = 1000 + Rand(default.SniperSounds.Length);
    SendLocalizedMessage(Sender, Recipient, MessageType, MessageIndex);
    G = EvilGame(Sender.WorldInfo.Game);
    // End:0xDB
    if((G == none) || G.Sniper == none)
    {
        return;
    }
    SendLocationUpdate(Sender, Recipient, MessageType, G, G.Sniper);
    //return;    
}

static function SendEnemyStatusUpdate(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    local EvilPlayerReplicationInfo EnemyPRI;
    local Object EnemyObject;
    local EvilVehicle_Base V;
    local int MessageIndex;

    // End:0x26
    if(Sender.Enemy == none)
    {
        return;
    }
    MessageIndex = 1300;
    EnemyPRI = EvilPlayerReplicationInfo(Sender.Enemy.PlayerReplicationInfo);
    EnemyObject = EnemyPRI;
    // End:0x1DE
    if((EnemyObject == none) || !EnemyPRI.bHasFlag)
    {
        V = EvilVehicle_Base(Sender.Enemy);
        // End:0x1D3
        if(((V != none) && V.bHasEnemyVehicleSound) && V.EnemyVehicleSound.Length > default.LocationSpeechOffset)
        {
            EnemyObject = V.Class;
            V.LastEnemyWarningTime = Sender.WorldInfo.TimeSeconds;            
        }
        else
        {
            V = none;
        }
    }
    SendLocalizedMessage(Sender, Recipient, MessageType, MessageIndex, EnemyObject);
    // End:0x24C
    if((V == none) && !EnemyPRI.bHasFlag)
    {
        return;
    }
    SendLocationUpdate(Sender, Recipient, MessageType, EvilGame(Sender.WorldInfo.Game), Sender.Enemy);
    //return;    
}

static function SendKilledVehicleMessage(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    //return;    
}

static function SoundNodeWave KilledVehicleSound(PlayerController PC, Object OptionalObject)
{
    local class<EvilVehicle_Base> VehicleClass;

    VehicleClass = class<EvilVehicle_Base>(OptionalObject);
    // End:0x2D
    if(VehicleClass == none)
    {
        return none;
    }
    return ((VehicleClass.default.VehicleDestroyedSound.Length > default.LocationSpeechOffset) ? VehicleClass.default.VehicleDestroyedSound[default.LocationSpeechOffset] : none);
    //return ReturnValue;    
}

static function bool SendLocationUpdate(Controller Sender, PlayerReplicationInfo Recipient, name MessageType, EvilGame G, Pawn StatusPawn, optional bool bDontSendMidfield)
{
    local Actor LocationObject;
    local int MessageIndex;

    // End:0xF7
    if((((G != none) && G.bTeamGame) && StatusPawn != none) && G.GetLocationFor(StatusPawn, LocationObject, MessageIndex, default.LocationSpeechOffset))
    {
        // End:0xAE
        if(bDontSendMidfield && MessageIndex == 10)
        {
            return false;
        }
        MessageIndex += 1100;
        SendLocalizedMessage(Sender, Recipient, MessageType, MessageIndex, LocationObject);
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function SendInPositionMessage(Controller Sender, PlayerReplicationInfo Recipient, name MessageType)
{
    // End:0x49
    if(default.InPositionSounds.Length > 0)
    {
        SendLocalizedMessage(Sender, Recipient, MessageType, 1200 + Rand(default.InPositionSounds.Length));
    }
    InitCombatUpdate(Sender, Recipient, MessageType);
    //return;    
}

static function bool ShouldBeRemoved(UTQueuedAnnouncement MyAnnouncement, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
    local UTQueuedAnnouncement A;
    local int VoiceMessageCount, MaxCount;

    // End:0x19
    if(NewAnnouncementClass == Class'UTScriptedVoiceMessage')
    {
        return true;
    }
    // End:0x148
    if(ClassIsChildOf(NewAnnouncementClass, Class'UTVoice'))
    {
        MaxCount = (((MyAnnouncement.MessageIndex >= 1100) && MyAnnouncement.MessageIndex < (1100 + 100)) ? 0 : 1);
        A = MyAnnouncement.nextAnnouncement;
        J0xBD:

        // End:0x148 [Loop If]
        if(A != none)
        {
            // End:0x11D
            if(ClassIsChildOf(A.AnnouncementClass, Class'UTVoice'))
            {
                VoiceMessageCount++;
                // End:0x11D
                if(VoiceMessageCount > MaxCount)
                {
                    return true;
                }
            }
            A = A.nextAnnouncement;
            // [Loop Continue]
            goto J0xBD;
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool AddAnnouncement(UTAnnouncer Announcer, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    local UTQueuedAnnouncement A;

    A = Announcer.Queue;
    J0x2A:

    // End:0x92 [Loop If]
    if(A != none)
    {
        // End:0x67
        if(A.AnnouncementClass == Class'UTScriptedVoiceMessage')
        {
            return false;
        }
        A = A.nextAnnouncement;
        // [Loop Continue]
        goto J0x2A;
    }
    super.AddAnnouncement(Announcer, MessageIndex, PRI, OptionalObject);
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    AnnouncementPriority=-1
    bShowPortrait=true
    AnnouncementDelay=0.7500000
    bIsConsoleMessage=false
}