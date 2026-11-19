class SkyProj_Shotgun_Alt extends SkyProjectile
    native;

var() bool bDefaultBehavior;
var() bool bFriendlyFire;
var transient bool bHadClose;
var() float DetonateRadius;
var transient float ClosestPawnDist;

simulated function Tick(float DeltaTime)
{
    local Pawn P;
    local float Dist;
    local bool bApproaching;
    local SkyEmitter Emit;
    local Pawn CurClosePawn;
    local float CurCloseDist;
    local Vector VPawnToProj, Vel;

    super(Actor).Tick(DeltaTime);
    // End:0x16
    if(bDefaultBehavior)
    {
        return;
    }
    // End:0x2B
    if(VSizeSq(Velocity) <= float(0))
    {
        return;
    }
    // End:0x11F
    foreach OverlappingActors(Class'Engine.Pawn', P, DetonateRadius)
    {
        // End:0x11E
        if((P != Instigator) && P.Health > 0)
        {
            // End:0xAD
            if(!bFriendlyFire && int(P.GetTeamNum()) == int(Instigator.GetTeamNum()))
            {
                continue;                
            }
            Dist = VSizeSq(Location - P.Location);
            bHadClose = true;
            // End:0xF9
            if(Dist <= ClosestPawnDist)
            {
                ClosestPawnDist = Dist;
                bApproaching = true;
            }
            // End:0x11E
            if(Dist <= CurCloseDist)
            {
                CurCloseDist = Dist;
                CurClosePawn = P;
            }
        }        
    }    
    // End:0x2EC
    if(bHadClose && !bApproaching)
    {
        Vel = Velocity * DeltaTime;
        // End:0x1D1
        if(CurClosePawn != none)
        {
            VPawnToProj = CurClosePawn.Location - Location;
            // End:0x1CE
            if(((VPawnToProj Dot -Vel) > float(0)) && VSizeSq(Vel) > (1.0000000 - float(6)))
            {
                SetLocation(Location - (Vel * ((VPawnToProj Dot -Vel) / VSizeSq(Vel))));
            }            
        }
        else
        {
            SetLocation(Location - Vel);
        }
        // End:0x2C3
        if(ProjExplosionTemplate != none)
        {
            // End:0x2C2
            foreach OverlappingActors(Class'Engine.Pawn', P, DetonateRadius)
            {
                // End:0x2C1
                if((P != Instigator) && P.Health > 0)
                {
                    // End:0x2C1
                    if(SkyPlayerController(P.Controller) == none)
                    {
                        Emit = Spawn(Class'SkyEmitter', P,, P.Location, P.Rotation);
                        Emit.SetTemplate(ProjExplosionTemplate, true);
                        Emit.SetBase(P,, P.Mesh, 'skt_efx_chest');
                    }
                }                
            }            
        }
        Explode(Location, vect(0.0000000, 0.0000000, 1.0000000), none);
        ClosestPawnDist = 10000000000.0000000;
    }
    //return;    
}

// Export USkyProj_Shotgun_Alt::execReset(FFrame&, void* const)
native simulated function Reset();
