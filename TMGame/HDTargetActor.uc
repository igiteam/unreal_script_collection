//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDTargetActor extends InterpActor
placeable;

const CHPI = 16384;
const CPI  = 32768;
const C2PI = 65535;

var(Target) int  DownSpeed;  //degree/s
var(Target) array< class<DamageType> > DamageTypes<AllowAbstract>;

var transient int    InitRot;
var transient int    DstRot;
var transient float  RealDownSpeed;


simulated event PostBeginPlay()
{
    Super.PostBeginPlay();

    InitRot = 0; //Rotation.Pitch;
}

final function UpdateRot(float DeltaTime)
{
    local rotator NewRot;
    local int Delta, RotDiff;

    RotDiff = (DstRot & C2PI) - (Rotation.Pitch & C2PI);
    if(RotDiff == 0 || RotDiff == C2PI || RotDiff == -C2PI)  //done
    {
        if(DstRot == InitRot)
        {
            GotoState('Up');
        }
        else
        {
            GotoState('Down');
        }
    }
    else  //go on
    {
        NewRot = Rotation;
        Delta = RealDownSpeed * DeltaTime;

        //`logd("***UpdateAnim RotDiff="@RotDiff@"NewRot="@NewRot.Pitch@"Delta="@Delta);

        NewRot.Pitch = fixedTurn(Rotation.Pitch, DstRot, Delta);
        SetRotation(NewRot);
    }
}

final function StartRotaion(bool bDown)
{
    RealDownSpeed = DownSpeed * CPI / 180.0;

    if(bDown)
    {
         DstRot = CHPI;
    }
    else
    {
        DstRot = InitRot;
        RealDownSpeed = -RealDownSpeed;
    }

    GotoState('DesireRoation');
}

function OnToggle(SeqAct_Toggle inAction)
{
	if(inAction.InputLinks[0].bHasImpulse)
	{
        if(IsInState('Down'))
            StartRotaion(false);
	}
	else if(inAction.InputLinks[1].bHasImpulse)
	{
        if(IsInState('Up'))
            StartRotaion(true);
	}
}

final function bool IsValidDamageType(class<DamageType> inDamageType)
{
	local int Idx;
	local bool bValidDamageType;

	// if any damage types are specified, then verify the inDamageType is a child of at least one
	if (DamageTypes.Length > 0)
	{
		bValidDamageType = FALSE;
		for (Idx = 0; Idx < DamageTypes.Length; Idx++)
		{
			if (ClassIsChildOf(inDamageType,DamageTypes[Idx]))
			{
				bValidDamageType = TRUE;
				// no need to keep looking
				break;
			}
		}

		if (!bValidDamageType)
		{
			return FALSE;
		}
	}

	return TRUE;
}

auto state Up
{
    event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        //local vector n, TestLoc;
//        local float d, f;

        //`logd("***TakeDamage"@EventInstigator@DamageCauser);

        if( IsValidDamageType(DamageType) )
        {
            Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

            //compute dir - temp disable
            //    n = vector(Rotation);
            //    d = - (n dot Location);
            //    TestLoc = HitLocation - Normal(Momentum) * 5;
            //    f = (n dot TestLoc ) + d;
            //    //`log("***TakeDamage f"@f@"n.X"@n.X@"Y"@n.Y@"Z"@n.Z);
            //
            //    DstRot = CHPI;
            //    RealDownSpeed = DownSpeed * CPI / 180.0;
            //    if(f < 0)
            //    {
            //       DstRot = -DstRot;
            //       RealDownSpeed = -RealDownSpeed;
            //    }

            StartRotaion(true);
        }
    }
}

state Down
{
    ignores TakeDamage;
}

state DesireRoation
{
    ignores TakeDamage;

    event Tick(float DeltaTime)
    {
        UpdateRot(DeltaTime);
    }
}


