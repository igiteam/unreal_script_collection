class Trigger_LOS extends Trigger
    placeable
    hidecategories(lighting);

simulated function Tick(float DeltaTime)
{
    local array<SequenceEvent> losEvents;
    local SeqEvent_LOS evt;
    local PlayerController Player;
    local int idx;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local float cameraDist;

    // End:0x178
    if(FindEventsOfClass(Class'SeqEvent_LOS', losEvents))
    {
        // End:0x177
        foreach WorldInfo.AllControllers(Class'PlayerController', Player)
        {
            // End:0x176
            if(Player.Pawn != none)
            {
                Player.GetPlayerViewPoint(cameraLoc, cameraRot);
                cameraDist = PointDistToLine(Location, Vector(cameraRot), cameraLoc);
                idx = 0;
                J0x82:

                // End:0x176 [Loop If]
                if(idx < losEvents.Length)
                {
                    evt = SeqEvent_LOS(losEvents[idx]);
                    // End:0x16C
                    if((((cameraDist <= evt.ScreenCenterDistance) && VSize(Player.Pawn.Location - Location) <= evt.TriggerDistance) && (Normal(Location - cameraLoc) Dot Vector(cameraRot)) > 0.0000000) && !evt.bCheckForObstructions || Player.LineOfSightTo(self, cameraLoc))
                    {
                        losEvents[idx].CheckActivate(self, Player.Pawn, false);
                    }
                    idx++;
                    // [Loop Continue]
                    goto J0x82;
                }
            }            
        }        
    }
    return;
}

defaultproperties
{
    bStatic=false
    SupportedEvents[0]=Class'SeqEvent_LOS'
}