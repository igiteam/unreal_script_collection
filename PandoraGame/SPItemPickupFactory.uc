class SPItemPickupFactory extends SPPickup
    abstract
    native;

var const localized string PickupMessage;
var float RespawnTime;

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return default.PickupMessage;
    //return ReturnValue;    
}

function SpawnCopyFor(Pawn Recipient)
{
    // End:0x3F
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x3F
        if(PickupSound != none)
        {
            Recipient.PlaySound(PickupSound);
        }
    }
    // End:0x89
    if(PlayerController(Recipient.Controller) != none)
    {
        PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass,,,, Class);
    }
    //return;    
}

function SetRespawn()
{
    // End:0x2F
    if(WorldInfo.Game.ShouldRespawn(self))
    {
        StartSleeping();        
    }
    else
    {
        GotoState('Disabled');
    }
    //return;    
}

function float GetRespawnTime()
{
    // End:0x15
    if(RespawnTimeOverride > 0.0000000)
    {
        return RespawnTimeOverride;
    }
    return RespawnTime;
    //return ReturnValue;    
}
