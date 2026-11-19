class EvilPickupMessage extends UTLocalMessage;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local UTHUDBase HUD;
    local UTHUD MyUTHUD;

    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    HUD = UTHUDBase(P.myHUD);
    // End:0x1B5
    if(HUD != none)
    {
        HUD.LastPickupTime = HUD.WorldInfo.TimeSeconds;
        MyUTHUD = UTHUD(HUD);
        // End:0x1B5
        if(MyUTHUD != none)
        {
            // End:0x144
            if(class<EvilPickupFactory>(OptionalObject) != none)
            {
                class<EvilPickupFactory>(OptionalObject).static.UpdateHUD(MyUTHUD);                
            }
            else
            {
                // End:0x1B5
                if(class<EvilWeap_Base>(OptionalObject) != none)
                {
                    MyUTHUD.LastWeaponBarDrawnTime = HUD.WorldInfo.TimeSeconds + 2.0000000;
                }
            }
        }
    }
    //return;    
}

defaultproperties
{
    MessageArea=5
    bIsUnique=true
    bIsConsoleMessage=false
    bCountInstances=true
    DrawColor=(R=255,G=255,B=128,A=255)
    FontSize=1
}