// Description of purpose of this class - Please flesh out
// Adding Author
// Date Added

class FHGame extends UTGame
    config(ForeverHunted);


//////////////////////////////////////////////////////////////////////////////
// Unknown Purpose - Please flesh out
// Unknown Author

    // do not edit
    function StartMatch()
        {
	    super(UTGame).StartMatch();
	    Initialize();
        }

    function Initialize()
        {
	    LogInternal("FHGame.Initialize(): Testing");
		ConsoleCommand("ToggleAllScreenMessages");
        }

function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> DamageType)
{
}

	//virtual UBOOL Tick( FLOAT DeltaTime, enum ELevelTick TickType );


function Tick (float deltaTime)
	{
	TimeLimit = 0; // stupid frakkin udk, why do i need to do this just to disable the countdown warnings
	}


// Decompiled with UE Explorer.
defaultproperties
{
    bUseClassicHUD=true
    bGivePhysicsGun=false
    Acronym="FH"
    DefaultInventory=/* Array type was not detected. */
    DefaultPawnClass=Class'FHNormalPlayer'
    HUDType=Class'FHHUD'
    PlayerControllerClass=Class'FHPlayerController'
}