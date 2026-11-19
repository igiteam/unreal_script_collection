class UTObjectiveAnnouncement extends UTObjectiveSpecificMessage;

static function ObjectiveAnnouncementInfo GetObjectiveAnnouncement(byte MessageIndex, Object Objective, PlayerController PC)
{
    local EvilGameObjective GameObj;
    local EvilCarriedObject Flag;
    local ObjectiveAnnouncementInfo EmptyAnnouncement;
    local EvilPickupFactory Pickup;
    local EvilVehicle_Base Vehicle;

    GameObj = EvilGameObjective(Objective);
    // End:0xCB
    if(GameObj != none)
    {
        return ((GameObj.WorldInfo.GRI.OnSameTeam(GameObj, PC)) ? GameObj.DefendAnnouncement : GameObj.AttackAnnouncement);        
    }
    else
    {
        Flag = EvilCarriedObject(Objective);
        // End:0x1C9
        if(Flag != none)
        {
            // End:0x1C6
            if((Flag.Team != none) && Flag.Team.TeamIndex < Flag.NeedToPickUpAnnouncements.Length)
            {
                return Flag.NeedToPickUpAnnouncements[Flag.Team.TeamIndex];
            }            
        }
        else
        {
            Pickup = EvilPickupFactory(Objective);
            // End:0x261
            if(Pickup != none)
            {
                // End:0x25E
                if(class<EvilWeap_Base>(Pickup.InventoryType) != none)
                {
                    return class<EvilWeap_Base>(Pickup.InventoryType).default.NeedToPickUpAnnouncement;
                }                
            }
            else
            {
                Vehicle = EvilVehicle_Base(Objective);
                // End:0x2AB
                if(Vehicle != none)
                {
                    return Vehicle.NeedToPickUpAnnouncement;
                }
            }
        }
    }
    return EmptyAnnouncement;
    //return ReturnValue;    
}

static function bool ShouldBeRemoved(UTQueuedAnnouncement MyAnnouncement, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
    return default.Class == NewAnnouncementClass;
    //return ReturnValue;    
}

static simulated function SetHUDDisplay(PlayerController P, int Switch, string Text, PlayerReplicationInfo RelatedPRI_1, PlayerReplicationInfo RelatedPRI_2, Object OptionalObject)
{
    // End:0x73
    if(UTHUD(P.myHUD) != none)
    {
        UTHUD(P.myHUD).SetDisplayedOrders(Text);
    }
    //return;    
}

defaultproperties
{
    MessageArea=3
    bIsUnique=true
    FontSize=1
}