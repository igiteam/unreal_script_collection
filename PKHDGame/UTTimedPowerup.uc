class UTTimedPowerup extends UTInventory
    abstract
    hidecategories(Navigation);

var float TimeRemaining;
var int HudIndex;
var SoundCue PowerupOverSound;
var name PowerupStatName;
var TextureCoordinates IconCoords;
var float TransitionTime;
var float TransitionDuration;
var float WarningTime;
var Vector PP_Scene_HighLights;
var float PP_Scene_Desaturation;

simulated event Tick(float DeltaTime)
{
    // End:0x80
    if((Owner != none) && TimeRemaining > 0.0000000)
    {
        CustomTimeDilation = Owner.CustomTimeDilation;
        TimeRemaining -= DeltaTime;
        // End:0x7D
        if(TimeRemaining <= 0.0000000)
        {
            TimeExpired();
        }        
    }
    else
    {
        CustomTimeDilation = 1.0000000;
    }
    //return;    
}

function GivenTo(Pawn NewOwner, optional bool bDoNotActivate)
{
    super(Inventory).GivenTo(NewOwner, bDoNotActivate);
    ClientSetTimeRemaining(TimeRemaining);
    TimeRemaingUpdated();
    EvilPlayerReplicationInfo(NewOwner.PlayerReplicationInfo).StartPowerupTimeStat(GetPowerupStatName());
    //return;    
}

reliable client simulated function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    super(Inventory).ClientGivenTo(NewOwner, bDoNotActivate);
    AdjustPPEffects(NewOwner, false);
    //return;    
}

simulated function AdjustPPEffects(Pawn P, bool bRemove)
{
    local UTPlayerController PC;

    // End:0x1CA
    if(P != none)
    {
        PC = UTPlayerController(P.Controller);
        // End:0xBB
        if((PC == none) && P.DrivenVehicle != none)
        {
            PC = UTPlayerController(P.DrivenVehicle.Controller);
        }
        // End:0x1CA
        if(PC != none)
        {
            // End:0x152
            if(bRemove)
            {
                PC.PostProcessModifier.Scene_HighLights -= PP_Scene_HighLights;
                PC.PostProcessModifier.Scene_Desaturation -= PP_Scene_Desaturation;                
            }
            else
            {
                PC.PostProcessModifier.Scene_HighLights += PP_Scene_HighLights;
                PC.PostProcessModifier.Scene_Desaturation += PP_Scene_Desaturation;
            }
        }
    }
    //return;    
}

reliable client simulated function ClientLostItem()
{
    AdjustPPEffects(Pawn(Owner), true);
    super.ClientLostItem();
    //return;    
}

reliable client simulated function ClientSetTimeRemaining(float NewTimeRemaining)
{
    TimeRemaining = NewTimeRemaining;
    TimeRemaingUpdated();
    //return;    
}

simulated function TimeRemaingUpdated()
{
    TransitionTime = TransitionDuration;
    //return;    
}

simulated function DisplayPowerup(Canvas Canvas, UTHUD HUD, float ResolutionScale, out float YPos)
{
    local float FlashAlpha, Scaler, XPos;
    local string TimeRemainingAsString;
    local int TimeRemainingAsInt;
    local LinearColor TeamColor;

    // End:0x5E
    if(TransitionTime > 0.0000000)
    {
        TransitionTime -= HUD.RenderDelta;
        // End:0x5E
        if(TransitionTime < 0.0000000)
        {
            TransitionTime = 0.0000000;
        }
    }
    Scaler = TransitionTime / TransitionDuration;
    // End:0xA5
    if(TimeRemaining < 1.0000000)
    {
        FlashAlpha = TimeRemaining;        
    }
    else
    {
        FlashAlpha = ((TimeRemaining <= WarningTime) ? 0.2500000 + (0.7500000 * Abs(Cos(TimeRemaining))) : 1.0000000);
    }
    TeamColor = HUD.TeamHUDColor;
    TeamColor.A = FlashAlpha;
    Scaler = 1.0000000 + (float(12) * Scaler);
    XPos = Canvas.ClipX * 0.0250000;
    Canvas.SetPos(XPos + (float(20) * ResolutionScale), YPos + (float(20) * ResolutionScale));
    HUD.DrawTileCentered(HUD.AltHudTexture, (IconCoords.UL * ResolutionScale) * Scaler, (IconCoords.VL * ResolutionScale) * Scaler, IconCoords.U, IconCoords.V, IconCoords.UL, IconCoords.VL, TeamColor);
    TimeRemainingAsInt = Max(0, int(TimeRemaining + float(1)));
    TimeRemainingAsString = string(TimeRemainingAsInt);
    XPos += (float(35) * ResolutionScale);
    Canvas.SetDrawColor(255, 255, 255, byte(float(255) * FlashAlpha));
    HUD.DrawGlowText(TimeRemainingAsString, XPos, YPos, 40.0000000 * ResolutionScale);
    YPos -= (float(50) * ResolutionScale);
    //return;    
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    local DroppedPickup Drop;

    // End:0x18C
    if(ItemClass == Class)
    {
        Drop = DroppedPickup(Pickup);
        // End:0xBB
        if((Drop != none) && UTTimedPowerup(Drop.Inventory) != none)
        {
            TimeRemaining += UTTimedPowerup(Drop.Inventory).TimeRemaining;            
        }
        else
        {
            TimeRemaining += default.TimeRemaining;
        }
        ClientSetTimeRemaining(TimeRemaining);
        // End:0x12E
        if(PickupFactory(Pickup) != none)
        {
            PickupFactory(Pickup).PickedUpBy(Instigator);            
        }
        else
        {
            // End:0x177
            if(DroppedPickup(Pickup) != none)
            {
                DroppedPickup(Pickup).PickedUpBy(Instigator);
            }
        }
        AnnouncePickup(Instigator);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function TimeExpired()
{
    local EvilPlayerReplicationInfo UTPRI;

    // End:0x3C
    if(PowerupOverSound != none)
    {
        Instigator.PlaySound(PowerupOverSound);
    }
    // End:0xA9
    if(Instigator.DrivenVehicle != none)
    {
        UTPRI = EvilPlayerReplicationInfo(Instigator.DrivenVehicle.PlayerReplicationInfo);        
    }
    else
    {
        UTPRI = EvilPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
    }
    // End:0x112
    if(UTPRI != none)
    {
        UTPRI.StopPowerupTimeStat(GetPowerupStatName());
    }
    Destroy();
    //return;    
}

static function float BotDesireability(Actor PickupHolder, Pawn P, Controller C)
{
    return default.MaxDesireability;
    //return ReturnValue;    
}

static function float DetourWeight(Pawn Other, float PathWeight)
{
    return default.MaxDesireability / PathWeight;
    //return ReturnValue;    
}

function name GetPowerupStatName()
{
    // End:0x21
    if(default.PowerupStatName != 'None')
    {
        return default.PowerupStatName;
    }
    return 'INVALID_POWERUPSTAT';
    //return ReturnValue;    
}

defaultproperties
{
    TimeRemaining=30.0000000
    TransitionDuration=0.5000000
    WarningTime=3.0000000
    bDropOnDeath=true
    bDelayedSpawn=true
    bPredictRespawns=true
    RespawnTime=90.0000000
    MaxDesireability=2.0000000
}