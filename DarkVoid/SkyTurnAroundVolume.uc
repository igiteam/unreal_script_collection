class SkyTurnAroundVolume extends Volume
    native;

var deprecated Actor TetherActor;
var() bool bDisabled;

event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x39
    if(bDisabled)
    {
        bBlockActors = false;
        CollisionComponent.SetBlockActors(false);
        CollisionComponent.SetBlockNonZeroExtent(false);
    }
    //return;    
}

event Destroyed()
{
    local SkyGame Info;

    // End:0x43
    if(WorldInfo != none)
    {
        Info = SkyGame(WorldInfo.Game);
        // End:0x43
        if(Info != none)
        {
            Info.AvailTurnAroundVolumes.RemoveItem(self);
        }
    }
    super(Actor).Destroyed();
    //return;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local SkyAirVehicle SAV;
    local SkyPawn SP;
    local int I;
    local SkyBotControllerPilot SBCP;

    // End:0x0E
    if(bDisabled == true)
    {
        return;
    }
    SAV = SkyAirVehicle(Other);
    // End:0x5E
    if(SAV == none)
    {
        SP = SkyPawn(Other);
        // End:0x5E
        if(SP != none)
        {
            SAV = SkyAirVehicle(SP.DrivenVehicle);
        }
    }
    // End:0xA6
    if(SAV != none)
    {
        SBCP = SkyBotControllerPilot(SAV.Controller);
        // End:0xA6
        if(SBCP != none)
        {
            // End:0xA6
            if(SBCP.bCareAboutTurnAroundVolumes == false)
            {
                return;
            }
        }
    }
    // End:0x2FC
    if((SAV != none) && SAV.TouchedTurnAroundVolume(self, HitNormal) == true)
    {
        // End:0x2FC
        if(SAV.TurnAroundVolumeList.Length == 1)
        {
            // End:0x2FC
            if((VSizeSq(SAV.Velocity) < 1.0000000) || (Normal(HitNormal) Dot Normal(SAV.Velocity)) < float(0))
            {
                I = 0;
                J0x133:

                // End:0x2FC [Loop If]
                if(I < SAV.AvailableSpecialManeuvers.Length)
                {
                    // End:0x2F2
                    if(SAV.AvailableSpecialManeuvers[I].ManeuverName == 'SnapTurn')
                    {
                        // End:0x1BF
                        if(SAV.CurrentActiveSpecialManeuver != 'None')
                        {
                            SAV.Mesh.SetRBRotation(Rotator(-HitNormal));                            
                        }
                        else
                        {
                            SAV.ModCollisionRot = true;
                            SAV.OldCollisionRotQuat = QuatFromRotator(Rotation);
                            SAV.CollisionRotSlerpTime = 1.0000000;
                            SAV.CollisionRot = Rotator(-HitNormal);
                        }
                        // End:0x249
                        if(SAV.CurrentActiveSpecialManeuver == 'SnapTurn')
                        {
                            SAV.bResetSpecialManeuver = true;
                        }
                        // End:0x26B
                        if(SBCP != none)
                        {
                            SBCP.EnterTurnAroundVolumes();                            
                        }
                        else
                        {
                            SAV.SetCurrentActiveSpecialManeuver(SAV.AvailableSpecialManeuvers[I].ManeuverName);
                            // End:0x2DD
                            if(SkyPlayerController(SAV.Controller) != none)
                            {
                                SkyPlayerController(SAV.Controller).LockoutExitRocketpackTimerAfterTurnAroundVolume = 1.5000000;
                            }
                        }
                        SAV.bTurningAroundFromVolume = true;
                        // [Explicit Break]
                        goto J0x2FC;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x133;
                }
            }
        }
    }
    J0x2FC:

    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

event UnTouch(Actor Other)
{
    local SkyAirVehicle SAV;
    local SkyPawn SP;
    local SkyBotControllerPilot SBCP;

    // End:0x0E
    if(bDisabled == true)
    {
        return;
    }
    SAV = SkyAirVehicle(Other);
    // End:0x5E
    if(SAV == none)
    {
        SP = SkyPawn(Other);
        // End:0x5E
        if(SP != none)
        {
            SAV = SkyAirVehicle(SP.DrivenVehicle);
        }
    }
    // End:0xA6
    if(SAV != none)
    {
        SBCP = SkyBotControllerPilot(SAV.Controller);
        // End:0xA6
        if(SBCP != none)
        {
            // End:0xA6
            if(SBCP.bCareAboutTurnAroundVolumes == false)
            {
                return;
            }
        }
    }
    // End:0xC6
    if(SAV != none)
    {
        SAV.UnTouchedTurnAroundVolume(self);
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x55
    if(Action.InputLinks[0].bHasImpulse)
    {
        bDisabled = false;
        bBlockActors = true;
        CollisionComponent.SetBlockActors(true);
        CollisionComponent.SetBlockNonZeroExtent(true);        
    }
    else
    {
        // End:0xAA
        if(Action.InputLinks[1].bHasImpulse)
        {
            bDisabled = true;
            bBlockActors = false;
            CollisionComponent.SetBlockActors(false);
            CollisionComponent.SetBlockNonZeroExtent(false);            
        }
        else
        {
            // End:0x119
            if(Action.InputLinks[2].bHasImpulse)
            {
                bDisabled = !bDisabled;
                bBlockActors = !bDisabled;
                CollisionComponent.SetBlockActors(!bDisabled);
                CollisionComponent.SetBlockNonZeroExtent(!bDisabled);
            }
        }
    }
    //return;    
}
