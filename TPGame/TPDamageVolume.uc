class TPDamageVolume extends Volume
    placeable;


var() array<class<Actor> > ExemptActorClasses;

var() float             DamageAmount;
var() float             DamageTimeSeconds;
var() class<DamageType>	DamageType;

var() float             MovementDamageAmount;
var() float             MovementDamageDistance;
var() class<DamageType>	MovementDamageType;

var array<Actor>  Actors;
var array<vector> Locations;


function PostBeginPlay()
{
    Super.PostBeginPlay();

    if (DamageAmount > 0)
        SetTimer(DamageTimeSeconds, true, 'DamageTimer');

    if (MovementDamageAmount > 0)
        SetTimer(0.1, true, 'MovementTimer');
}

function OnTPDamageVolumeModifier (SeqAct_TPDamageVolumeModifier Act)
{
    ExemptActorClasses = Act.ExemptActorClasses;

    DamageAmount      = Act.DamageAmount;
    DamageTimeSeconds = Act.DamageTimeSeconds;
    DamageType        = Act.DamageType;

    MovementDamageAmount   = Act.MovementDamageAmount;
    MovementDamageDistance = Act.MovementDamageDistance;
    MovementDamageType     = Act.MovementDamageType;

    if (DamageAmount > 0)
        SetTimer(DamageTimeSeconds, true, 'DamageTimer');
    else
        ClearTimer('DamageTimer');

    if (MovementDamageAmount > 0)
        SetTimer(0.1, true, 'MovementTimer');
    else
        ClearTimer('MovementTimer');
}

function DamageTimer()
{
    local Actor A;
    local bool  bExempt;
    local int   i;

    bExempt = false;

    if (DamageAmount > 0)
    {
        // @optimization Maybe use Actors array so we don't have to loop through
        // ExemptActorClasses if this becomes expensive
        ForEach TouchingActors(class'Actor', A)
        {
            for(i = 0; i < ExemptActorClasses.Length; i++)
            {
                //if (ExemptActors[i] == A.class || ClassIsChildOf(A.class, ExemptActors[i]))
                if (ClassIsChildOf(A.class, ExemptActorClasses[i]))
                {
                    bExempt = true;
                    break;
                }
            }

            if (!bExempt && A.bCanBeDamaged && !A.bStatic)
            {
                if ( (DamageType == None) || (DamageType == class'DamageType') )
			        ;

                A.TakeDamage(DamageAmount, None, Location, A.Location-Location, DamageType,, self);
            }

            bExempt = false;
        }
    }
}

function MovementTimer()
{
    local int    Num;
    local int    i,j;
    local vector Dir;
    local vector DirN;
    local float  Dist;

    if (MovementDamageAmount <= 0)
        return;

    for (i = 0; i < Actors.Length; i++)
    {
        Dir  = Actors[i].Location - Locations[i];
        DirN = Normal(Dir); 
        Dist = VSize(Dir);
        Num  = int(Dist/MovementDamageDistance); // Rounds down

        for(j = 0; j < Num; ++j)
        {
            Locations[i] += DirN*MovementDamageDistance; // Update new 'old' location
            Actors[i].TakeDamage(MovementDamageAmount, None, Location, Actors[i].Location-Location, DamageType,, self);
        }
    }
}

// @optimization This may become expensive if many, many actors are
// touching/untouching this volume frequently for some reason
event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
    local int i;

    if (MovementDamageAmount <= 0)
        return;

    for(i = 0; i < ExemptActorClasses.Length; i++)
        if (ClassIsChildOf(Other.class, ExemptActorClasses[i]))
            return;

    if (Actors.Find(Other) == -1)
    {
        Actors.Insert(Actors.Length, 1);
        Actors[Actors.Length-1] = Other;

        Locations.Insert(Locations.Length, 1);
        Locations[Locations.Length-1] = Other.Location;
    }
}

event Untouch(Actor Other)
{
    local int i;

    if (MovementDamageAmount <= 0)
        return;

    for(i = 0; i < ExemptActorClasses.Length; i++)
        if (ClassIsChildOf(Other.class, ExemptActorClasses[i]))
            return;

    i = Actors.Find(Other);

    if (i != -1)
    {
        Actors.Remove(i, 1);
        Locations.Remove(i, 1);
    }
}

