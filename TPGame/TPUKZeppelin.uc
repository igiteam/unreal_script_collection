class TPUKZeppelin extends TPBaseVehicle;

// Enemies to spawn that are to be attached to the blimp
var array<WehrmachtPawn>         WehrmachtR;
var array<WehrmachtPawn>         WehrmachtL;

// Enemy states 
var array<AB_Action>             WehrmachtStatesR;
var array<AB_Action>             WehrmachtStatesL;

// Used to keep track of which enemies have had their state modified in
// a single kismet action.  These would be arrays of booleans but setting
// a local array of booleans to reference it in a function causes a crash!
var array<AB_Action>             ModifiedR;
var array<AB_Action>             ModifiedL;

// Socket names where enemies will attach to
var array<Name>                  HangarSocketsR;
var array<Name>                  HangarSocketsL;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if ( Controller == None )
	{
    	if ( ControllerClass != None )
	    	Controller = Spawn(ControllerClass);

    	if ( Controller != None )
	       	Controller.Possess( Self, false );
	}
}

function Tick (float DeltaTime)
{
    local int     i;

    for (i=0; i < WehrmachtL.Length; i++)
    {
        if (WehrmachtL[i] != None && !WehrmachtL[i].IsInState('Dying') && 
            !TPAIController(WehrmachtL[i].Controller).IsInState('Rappelling'))
        {
            // Do nothing
        }
        else
        {
            WehrmachtL[i] = None;
        }
    }
    
    for (i=0; i < WehrmachtR.Length; i++)
    {
        if (WehrmachtR[i] != None && !WehrmachtR[i].IsInState('Dying') && 
            !TPAIController(WehrmachtR[i].Controller).IsInState('Rappelling'))
        {
            // Do nothing
        }
        else
        {
            WehrmachtR[i] = None;
        }
    }

    Super.Tick(DeltaTime);
}

