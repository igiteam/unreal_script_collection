class MOHASniperRifleDamageType extends MOHABulletDamageType;

static function OnKilledPawn(Pawn Target, Controller Killer, Vector HitLocation)
{
    local MOHAControllerInterface localController;
    local name stimulusTableID;

    // End:0x57
    if(Target.Controller == none)
    {
        // End:0x54
        if(Pawn(Target.Owner) != none)
        {
            localController = MOHAControllerInterface(Pawn(Target.Owner).Controller);
        }        
    }
    else
    {
        localController = MOHAControllerInterface(Target.Controller);
    }
    // End:0x178
    if((NotEqual_InterfaceInterface(localController, MOHAControllerInterface(none)) && Killer != none) && Killer.Pawn != none)
    {
        // End:0xD3
        if(localController.GetTeamIndex() == 0)
        {
            stimulusTableID = 'AlliedSniperDeath';            
        }
        else
        {
            stimulusTableID = 'AxisSniperDeath';
        }
        localController.GetStimulusComponent().AttachSender('SniperFire', stimulusTableID, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),,, true);
        localController.GetStimulusComponent().PushStimuliSenderParamName('SniperFire', 'Shooter', Killer.Pawn.Name);
    }
    //return;    
}
