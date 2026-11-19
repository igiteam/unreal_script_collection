// Description of purpose of this class - Please flesh out
// Adding Author
// Date Added

class FHPlayerController extends UTPlayerController
    config(ForeverHunted);

var SkeletalMesh clarkesMesh;
var FHHUD        messageHud;

//////////////////////////////////////////////////////////////////////////////
// Unknown Purpose - Please flesh out
// Unknown Author

simulated function PostBeginPlay()
{
	FHPlayerInput(PlayerInput).SetPlayer(Pawn);
	super.PostBeginPlay();

	messageHud.playerController = self;
	//////SetCameraMode('ThirdPerson');
}

// overridden to remove "Press [Fire] to start!" message
reliable client function PlayStartupMessage(byte StartupStage)
{

}

function DrawGameMessage (string message, float time, color c, vector pos, font msgFont)
	{
	local Vector2D screenSize;

	LocalPlayer(Player).ViewportClient.GetViewportSize (screenSize);
	pos.X *= screenSize.X;
	pos.Y *= screenSize.Y;
	FHHUD(myHUD).DrawGameMessage(message, time, c, pos, msgFont);
	}

function RemoveGameMesage (string message)
	{
	FHHUD(myHUD).RemoveGameMessage(message);
	}

function DrawInventory (array <FHSeqVar_InventoryCategory> inv)
	{
	local Vector2D screenSize;

	LocalPlayer(Player).ViewportClient.GetViewportSize (screenSize);
	screenSize.X *= 0.05;
	screenSize.Y *= 0.05;
	FHHUD(myHUD).DrawInventory (inv, screenSize.X, screenSize.Y);
	}

function SetInventory (array <FHSeqVar_InventoryCategory> inv)
{
	FHHUD(myHUD).myInventory = inv;
}

simulated function Duck()
{
	UTPlayerInput(PlayerInput).Duck();
}

simulated function UnDuck()
{
	UTPlayerInput(PlayerInput).UnDuck();
}

function PawnDied(Pawn inPawn)
{
	local int idx;


	if ( inPawn != Pawn )
	{	// if that's not our current pawn, leave
		return;
	}

	// abort any latent actions
	TriggerEventClass(class'SeqEvent_Death',self);
	for (idx = 0; idx < LatentActions.Length; idx++)
	{
		if (LatentActions[idx] != None)
		{
			LatentActions[idx].AbortFor(self);
		}
	}
	LatentActions.Length = 0;

	if ( Pawn != None )
	{
		SetLocation(Pawn.Location);
		Pawn.UnPossessed();
	}
	Pawn = None;

	// if we are a player, transition to the dead state
	if ( bIsPlayer )
	{
		// only if the game hasn't ended,
		if ( !GamePlayEndedState() )
		{
			// so that we can respawn
			//GotoState('Dead');
			GotoState('DebugMe');
			//RestartLevel();
		}
	}
	// otherwise destroy this controller
	else
	{
		Destroy();
	}
}


state DebugMe
{
	exec function StartFire(optional byte FireModeNum)
	{
		ConsoleCommand("ToggleAllScreenMessages");
		RestartLevel();
	}
}


public function ResetMesh()
{
	//self.Pawn.Mesh.SetSkeletalMesh(clarkesMesh);
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
	Super.Possess(inPawn, bVehicleTransition);

	if(FHPlayer(inPawn) != none)
	{
		FHPlayer(inPawn).SetController(self);
	}
	ResetMesh();
	SetBehindView(true);	
}

//function SetBehindView(bool bNewBehindView)
//{
//	bBehindView = !bNewBehindView; // Allows third person mesh and weapon at same time
//	if ( !bBehindView )
//	{
//		bFreeCamera = false;
//	}

//	if (LocalPlayer(Player) == None)
//	{
//		ClientSetBehindView(bNewBehindView);
//	}
//	else if (UTPawn(ViewTarget) != None)
//	{
//		UTPawn(ViewTarget).SetThirdPersonCamera(bNewBehindView);
//	}
//	// make sure we recalculate camera position for this frame
//	LastCameraTimeStamp = WorldInfo.TimeSeconds - 1.0;
//}


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__FHPlayerController.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__FHPlayerController.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    PostProcessModifier=(ColorGradingLUT=none)
    // Reference: CylinderComponent'Default__FHPlayerController.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UTGame.Default__UTPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}