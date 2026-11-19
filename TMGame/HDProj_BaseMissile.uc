//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_BaseMissile extends HDBaseProjectile;

var transient Actor              TrackTarget;
var transient bool               bExplode;

simulated function PostBeginPlay()
{
	// force ambient sound if not vehicle game mode
	bImportantAmbientSound = !WorldInfo.bDropDetail;
	Super.PostBeginPlay();
}

event Tick( float DeltaTime )
{
    Super.Tick(DeltaTime);
    if ( ROLE == ROLE_Authority )
    {
        if ( TrackTarget == None )
        {
            Shutdown();
        }

        if ( TrackTarget != none && !TrackTarget.bDeleteMe )
        {
            Init(Normal(TrackTarget.Location-Location));
        }

        if ( VSizeSq(TrackTarget.Location-Location) < 900.0f && !bExplode )
        {
            Explode(Location, vect(0,0,1));
            bExplode = True;
            LifeSpan = 0.1f;
        }
    }
}

simulated event Destroyed()
{
    Super.Destroyed();
}
