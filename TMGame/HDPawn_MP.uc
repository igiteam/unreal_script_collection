//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDPawn_MP extends HDPawn;

var repnotify   vector              CommandSystemLocation;
var repnotify   bool                bCommandSystemActived;

replication
{
    if ( bNetInitial || (bNetDirty) )
        bCommandSystemActived, CommandSystemLocation;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'CommandSystemLocation')
    {
        SetLocalCommandSystemLocation(CommandSystemLocation);
    }
    else if ( VarName == 'bCommandSystemActived' )
    {
        SetLocalCommandSystemActived(bCommandSystemActived);
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
}

// set sprint speed
reliable sync function SyncSetSprintScale(float value )
{
    SprintPct = value;
}
exec function   SprintScale( float value )
{
    SyncSetSprintScale(value);
}

// health hacking
reliable server function ServerExpandHDPawnMPHealth( float value )
{
    Health = value;
}

exec function   IAMBIGBOSS( float value )
{
    if ( Role < Role_Authority )
    {
        ServerExpandHDPawnMPHealth(value);
    }
    Health = value;
}

// stop pawn moving
reliable Server function  ServerStopPawnMoving()
{
    StopPawnMoving();
}

simulated function StopPawnMoving()
{
    Acceleration=vect(0,0,0);
    Velocity=vect(0,0,0);
}

simulated function StopMoving()
{
    if ( Role < Role_Authority )
        ServerStopPawnMoving();

    StopPawnMoving();
}

// do not crushed
function CrushedBy(Pawn OtherPawn);

// dn not encroachedBy
event EncroachedBy( actor Other );

simulated function SetLocalCommandSystemActived( bool bActive )
{
    local HDAttachment_CommandSystem    CA;
    CA = HDAttachment_CommandSystem(CurrentWeaponAttachment);
    if ( !IsLocallyControlled() && CA != None )
        CA.SetLaserEffectActive(bActive);

    bCommandSystemActived = bActive;
}

reliable server function ServerSetCommandSystemActived( bool bActive )
{
    SetLocalCommandSystemActived(bActive);
    bNetDirty = True;
}

simulated function SetCommandSystemActived( bool bActive )
{
    ServerSetCommandSystemActived(bActive);
}

simulated function SetCommandSystemLocation( vector Loc )
{
    ServerSetCommandSystemLocation(Loc);
}

simulated function SetLocalCommandSystemLocation( vector Loc )
{
    local HDAttachment_CommandSystem    CA;
    CommandSystemLocation = Loc;
    CA = HDAttachment_CommandSystem(CurrentWeaponAttachment);
    if ( !IsLocallyControlled() && CA != None )
    {
        CA.SetLaserEffectActive(True);
        CA.SetLaserEffectLocation(CommandSystemLocation);
    }
}

reliable server function ServerSetCommandSystemLocation( vector Loc )
{
    SetLocalCommandSystemLocation(Loc);
    bNetDirty = True;
}


