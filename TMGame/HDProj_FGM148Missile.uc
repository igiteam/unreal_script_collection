//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_FGM148Missile extends HDProj_BaseMissile;

var transient   int         TrackStep;

event Tick( float DeltaTime )
{
    local vector    StepOLocation;

    Super(HDBaseProjectile).Tick(DeltaTime);
    if ( ROLE == ROLE_Authority )
    {
        if ( TrackTarget == None || TrackTarget.bDeleteMe )
        {
            Explode(Location, vect(0,0,1));
        }

        if ( TrackStep == 0 )
        {
            StepOLocation = TrackTarget.Location + vect(0,0,5000);
            Init(Normal(StepOLocation - Location ));
            if ( VSize(StepOLocation - Location ) < 100 )
            {
                TrackStep = 1;
            }
        }
        else if ( TrackStep == 1 )
        {
            Init(Normal(TrackTarget.Location-Location));
        }
    }
}

