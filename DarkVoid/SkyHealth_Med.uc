class SkyHealth_Med extends SkyInvPickupFactory;

var int HealingAmount;
var() float SoundPitch;
var SoundCue PickupSound;

function SpawnCopyFor(Pawn Recipient)
{
    Recipient.Health += (HealAmount(Recipient));
    PlaySound(PickupSound);
    // End:0x7A
    if(PlayerController(Recipient.Controller) != none)
    {
        PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass,,,, Class);
    }
    //return;    
}

function int HealAmount(Pawn Recipient)
{
    return Recipient.default.Health - Recipient.Health;
    //return ReturnValue;    
}

function PickedUpBy(Pawn P)
{
    local SkyGame GI;

    super(PickupFactory).PickedUpBy(P);
    GI = SkyGame(WorldInfo.Game);
    // End:0x99
    if(((GI != none) && GI.GameStats != none) && P.PlayerReplicationInfo != none)
    {
        GI.GameStats.PickupInventoryEvent(Class, P.PlayerReplicationInfo, 'Pickup');
    }
    //return;    
}

auto state Pickup
{
    function float DetourWeight(Pawn Other, float PathWeight)
    {
        // End:0x17
        if(PathWeight > float(500))
        {
            return 0.0000000;
        }
        return super.DetourWeight(Other, PathWeight);
        //return ReturnValue;        
    }

    function bool ValidTouch(Pawn Other)
    {
        // End:0x12
        if(!super.ValidTouch(Other))
        {
            return false;
        }
        return (HealAmount(Other)) > 0;
        //return ReturnValue;        
    }
    stop;    
}
