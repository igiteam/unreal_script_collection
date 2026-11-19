class SFRMVehiclePawn extends KVehicle
    native
    abstract;

var (SFRMVehiclePawn)	vector			ViewOffset;
var (SFRMVehiclePawn)	vector			DriverOffset;
var (SFRMVehiclePawn)	vector			PassengerOffset;
var (SFRMVehiclePawn)	bool			bIsDrivable;
var						bool			bAlwaysTurnPlayerReticuleRed;
var						bool			bEasyAiming;

// Internal
var ZombieBipedPawn	PassengerPawn;
var	bool			bExternalView;

// The pawn Driver has tried to take control of this vehicle
function TryToDrive(Pawn p)
{
	local Controller C;
	C = p.Controller;

	if( (Driver == None) && (C != None) && C.bIsPlayer && !C.IsInState('PlayerDriving') && p.IsHumanControlled() && bIsDrivable )
	{        
		KDriverEnter(p);
    	}
}

function SetPassenger(Pawn Other)
{
	PassengerPawn = ZombieBipedPawn( Other );
	PassengerPawn.SetLocation( Location + (PassengerOffset >> Rotation) );
	PassengerPawn.SetBase(self);
	log('Added passenger');
}

function UpdatePassenger()
{
	if( PassengerPawn != None ){	
		PassengerPawn.SetLocation( Location + (PassengerOffset >> Rotation) );
		PassengerPawn.SetBase(self);
		log('Updated passenger');
	}
}

// Events called on driver entering/leaving vehicle
simulated function ClientKDriverEnter(PlayerController pc)
{	

	pc.bBehindView = true;
	pc.bFixedCamera = false;
	pc.bFreeCamera = true;
	
	pc.SetRotation(rotator( vect(-1, 0, 0) >> Rotation ));
}

function KDriverEnter(Pawn p)
{
	local PlayerController pc;

	Driver = p;

	// Move the driver into position, and attach to car.
	Driver.SetCollision(false, false, false);
	Driver.bCollideWorld = false;
	Driver.bPhysicsAnimUpdate = false;
	Driver.Velocity = vect(0,0,0);
	Driver.SetPhysics(PHYS_None);
	Driver.SetBase(self);

	pc = PlayerController(p.Controller);

	// Disconnect PlyaerController from Driver and connect to SFRMVehiclePawn.
	pc.Unpossess();
	Driver.SetOwner(pc); // This keeps the driver relevant.
	pc.Possess(self);

	pc.ClientSetViewTarget(self); // Set playercontroller to view the vehicle

	pc.GotoState('PlayerDriving');
	ClientKDriverEnter(pc);
}

// Toggle player views
function VehicleFire(bool bWasAltFire)
{
	if( !bWasAltFire ){
		bExternalView = !bExternalView;
	}
}

// Just to intercept 'getting out' request.
simulated event Tick(float deltaSeconds)
{
	local bool gotOut;

	if(bGetOut && ROLE==Role_Authority)
	{
		gotOut = KDriverLeave(false);

		if(!gotOut )
		{
			Log("Couldn't Leave - staying in!");
		}
	}

	bGetOut = false;

}

//---------------------------------------------------
// special view calculation while controlling vehicle.

simulated function bool SpecialCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local vector CamLookAt, HitLocation, HitNormal;
	local PlayerController pc;
	local int i, averageOver;

	if( bExternalView ){

		pc = PlayerController(Controller);

		// Only do this mode we have a playercontroller viewing this vehicle
		if(pc == None || pc.ViewTarget != self)
			return false;

		ViewActor = self;
		CamLookAt = Location + (vect(-100, 0, 100) >> Rotation); 

		//////////////////////////////////////////////////////
		// Smooth lookat position over a few frames.
		CameraHistory[NextHistorySlot] = CamLookAt;
		NextHistorySlot++;

		if(bHistoryWarmup)
			averageOver = NextHistorySlot;
		else
			averageOver = FilterFrames;

		CamLookAt = vect(0, 0, 0);
		for(i=0; i<averageOver; i++)
			CamLookAt += CameraHistory[i];	

		CamLookAt /= float(averageOver);

		if(NextHistorySlot == FilterFrames)
		{
			NextHistorySlot = 0;
			bHistoryWarmup=false;
		}

		CameraLocation = CamLookAt + (vect(-600, 0, 0) >> CameraRotation);

		if( Trace( HitLocation, HitNormal, CameraLocation, CamLookAt, false, vect(10, 10, 10) ) != None )
		{
			CameraLocation = HitLocation;
		}
	}else{
		CameraLocation = Location  + ( ViewOffset >> Rotation );
		CameraRotation = rotator( vect(-1, 0, 0) >> Rotation );

	}
	
	return true;

}

