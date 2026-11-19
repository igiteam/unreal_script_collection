class HealthSystem extends Object
    config(Player);

const MAX_WEAPON_TYPE_SP = 25;
const MAX_SP_MISSIONS = 7;
const MAX_SP_MEDALS = 6;
const MAX_HUD_NOTIFICATIONS = 8;
const NUM_MP_MAPS = 6;
const NUM_MP_AWARDS = 19;
const NUM_WEAPON_CLASSES = 7;
const MAX_RIVALS = 8;
const NUM_WEAPON_EXP_LEVELS = 3;
const NUM_MP_MEDALS = 15;
const NUM_MP_WEAPON_UPGRADES = 4;
const MAX_MISSION_SKILL_DROPS = 5;
const MAX_UPGRADEABLE_WEAPONS_SP = 16;
const NUM_XBLACH_UPGRADED_WEAPONS = 5;
const NUM_KILL_TIMES_TO_TRACK = 5;
const NUM_CONSECUTIVE_HEADSHOT_XBLACH = 10;
const MAX_DIFFICULTIES = 3;
const MAX_HUD_RENDERMODES = 4;
const MAX_SP_CHEAT_FLAGS = 7;
const WIDESCREEN_ASPECT_RATIO = 1.7777f;
const WIDESCREEN_INVERSE_ASPECT_RATIO = 0.5625f;
const MAX_HEALTH_DROPPED_PICKUPS = 1;
const MAX_HEALTH_DROPPED_PICKUPS_MP = 10;

var config int HealthSegments;
var transient float SegmentFillRate;
var config float SegmentFillRateSettings[3];
var int SegmentToFill;
var int SegmentSize;
var transient float SafeTime;
var transient float MaxSafeTime;
var config float MaxSafeTimeSettings[3];
var bool bGotHurt;
var bool bFillSegment;
var float fFractionalHealth;
var CCStimulusType Stim_TakingLightDamage;
var CCStimulusType Stim_TakingHeavyDamage;

function SetSegmentSize(int MaxHealth)
{
    SegmentSize = MaxHealth / HealthSegments;
    //return;    
}

function InitDifficultySettings(MOHAIncludeClass.eGameDifficulty GameDifficulty)
{
    local Pawn Owner;

    Owner = Pawn(Outer);
    // End:0x38
    if((Owner == none) || MOHAPlayerController(Owner.Controller) == none)
    {
        return;
    }
    SetSegmentSize(Owner.default.Health);
    MaxSafeTime = MaxSafeTimeSettings[int(GameDifficulty)];
    SegmentFillRate = SegmentFillRateSettings[int(GameDifficulty)];
    //return;    
}

function GotHurt(int LastHealth, int NextHealth)
{
    local Pawn Owner;
    local CCStimulus CCS;
    local int lastSegment, nextSegment;

    bGotHurt = true;
    bFillSegment = false;
    SafeTime = 0.0000000;
    Owner = Pawn(Outer);
    // End:0x53
    if((Owner == none) || MOHAPlayerController(Owner.Controller) == none)
    {
        return;
    }
    lastSegment = LastHealth / SegmentSize;
    nextSegment = NextHealth / SegmentSize;
    // End:0x91
    if((float(LastHealth) % float(SegmentSize)) == float(0))
    {
        return;
    }
    // End:0x1FB
    if((nextSegment < lastSegment) || nextSegment < 1)
    {
        MOHAPlayerController(Owner.Controller).Stimulus.AttachSender('RequestSuppressingFire', 'PlayerRequestSuppressingFire', vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),,, true);
        MOHAPlayerController(Owner.Controller).Stimulus.PushStimuliSenderParamInt('RequestSuppressingFire', 'Player', 1);
        // End:0x1FB
        if(none != MOHAGameInfo(Owner.WorldInfo.Game).GlobalCCDirector)
        {
            // End:0x190
            if(nextSegment < 2)
            {
                CCS.StimulusType = Stim_TakingHeavyDamage;                
            }
            else
            {
                CCS.StimulusType = Stim_TakingLightDamage;
            }
            CCS.SourceActor = Owner;
            MOHAGameInfo(Owner.WorldInfo.Game).GlobalCCDirector.BroadcastStimulus(CCS, 4000.0000000, 1);
        }
    }
    //return;    
}

function GotHealth(float Amount)
{
    bGotHurt = false;
    bFillSegment = false;
    //return;    
}

function Tick(float DeltaTime)
{
    local float fDesiredHealth;
    local Pawn Owner;

    Owner = Pawn(Outer);
    // End:0x33
    if((Owner == none) || Owner.Health <= 0)
    {
        return;
    }
    // End:0x56
    if(SegmentSize == 0)
    {
        SetSegmentSize(Owner.default.Health);
    }
    // End:0xBD
    if(bGotHurt)
    {
        SafeTime += DeltaTime;
        // End:0xBA
        if(SafeTime > MaxSafeTime)
        {
            bGotHurt = false;
            bFillSegment = true;
            fFractionalHealth = 0.0000000;
            SegmentToFill = Min((Owner.Health / SegmentSize) + 1, HealthSegments);
        }        
    }
    else
    {
        // End:0x155
        if(bFillSegment)
        {
            fDesiredHealth = (float(Owner.Health) + (SegmentFillRate * DeltaTime)) + fFractionalHealth;
            // End:0x125
            if(fDesiredHealth >= float(SegmentToFill * SegmentSize))
            {
                bFillSegment = false;
                fDesiredHealth = float(SegmentToFill * SegmentSize);
            }
            Owner.SetHealth(int(fDesiredHealth));
            fFractionalHealth = fDesiredHealth - float(int(fDesiredHealth));
        }
    }
    //return;    
}

defaultproperties
{
    HealthSegments=4
    SegmentFillRateSettings[0]=200.0000000
    SegmentFillRateSettings[1]=150.0000000
    SegmentFillRateSettings[2]=100.0000000
    MaxSafeTimeSettings[0]=1.5000000
    MaxSafeTimeSettings[1]=3.0000000
    MaxSafeTimeSettings[2]=4.0000000
    Stim_TakingLightDamage=CCStimulusType'MOHA_CC.Stimuli.TakingLightDamage'
    Stim_TakingHeavyDamage=CCStimulusType'MOHA_CC.Stimuli.TakingHeavyDamage'
}