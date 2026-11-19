class TurokShooter extends Component;

var() class<Class> DamageType;
var() int Damage;
var() float Momentum;
var() byte ShotDirection;
var() bool HeadShot;

function @NULL DirectionToVector(byte Dir)
{
    local @NULL Ret;

    // End:0x4C
    if(((int(Dir) == int(0)) || int(Dir) == int(7)) || int(Dir) == int(1))
    {
        Ret.X = 1.0000000;        
    }
    else
    {
        // End:0x98
        if(((int(Dir) == int(4)) || int(Dir) == int(5)) || int(Dir) == int(3))
        {
            Ret.X = -1.0000000;            
        }
        else
        {
            Ret.X = 0.0000000;
        }
    }
    // End:0xF9
    if(((int(Dir) == int(6)) || int(Dir) == int(7)) || int(Dir) == int(5))
    {
        Ret.Y = 1.0000000;        
    }
    else
    {
        // End:0x145
        if(((int(Dir) == int(2)) || int(Dir) == int(1)) || int(Dir) == int(3))
        {
            Ret.Y = -1.0000000;            
        }
        else
        {
            Ret.Y = 0.0000000;
        }
    }
    Ret = Normal(Ret);
    return Ret;
    //return ReturnValue;    
}

function @NULL PerformStupidRaycast(out @NULL HitLocation, out @NULL HitNormal, @NULL TraceEnd, @NULL TraceStart, @NULL Spawner)
{
    local @NULL Dummy, Ret;

    Dummy = Spawner.__NFUN_278__(Class'TurokSpriteActor', none,, TraceEnd);
    Dummy.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, vect(1.0000000, 1.0000000, 1.0000000), Ret);
    Dummy.Destroy();
    return Ret;
    //return ReturnValue;    
}

function ComputeAndSendDamage(@NULL Player)
{
    local @NULL pHitLocation, pHitNormal, pMomentum, TraceStart, TraceEnd;

    local float ShotHeight;

    ShotHeight = ((HeadShot) ? Player.BaseEyeHeight : Player.BaseEyeHeight / float(4));
    pMomentum = QuatRotateVector(QuatFromRotator(Player.GetBaseAimRotation()), DirectionToVector(ShotDirection));
    pMomentum *= float(-1);
    TraceEnd = Player.Location + (vect(0.0000000, 0.0000000, 1.0000000) * ShotHeight);
    TraceStart = TraceEnd + ((pMomentum * float(-1)) * float(64));
    pMomentum *= Momentum;
    PerformStupidRaycast(pHitLocation, pHitNormal, TraceEnd, TraceStart, Player);
    // End:0x1F3
    if(TurokPlayerController(Player.Controller) != none)
    {
        TurokPlayerController(Player.Controller).mHitReactionInfo.Damage = Damage;
        TurokPlayerController(Player.Controller).mHitReactionInfo.DamageType = DamageType;
        TurokPlayerController(Player.Controller).mHitReactionInfo.hitFromLocation = Player.Location + (pMomentum * float(-1));
        TurokPlayerController(Player.Controller).mHitReactionInfo.HitLocation = pHitLocation;
        TurokPlayerController(Player.Controller).ApplyHitReaction();
    }
    //return;    
}

defaultproperties
{
    DamageType=Class'TurokDamageTypeHandgun'
    Damage=10
    Momentum=10.0000000
}