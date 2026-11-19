//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDPlayerInput extends TMPlayerInput within HDPlayerController;

var	float		             InputTime;
// sprint
var transient   float		 LastSprintTime;

// duck logic
simulated exec function Duck()
{
	if ( HDPawn(Pawn) != none && HDPawn(Pawn).bCanCrouch )
	{
		if ( WorldInfo.TimeSeconds - LastDuckTime > InputTime )
		{
			bDuck = ~bDuck;
			if (bDuck != 0)
				bProne = 0;
			LastDuckTime = WorldInfo.TimeSeconds;
		}
	}
}

simulated exec function UnDuck()
{
	return;
}

// prone logic
simulated exec function Prone()
{
	if ( HDPawn(Pawn) != none && HDPawn(Pawn).bCanProne )
	{
		if ( WorldInfo.TimeSeconds - LastDuckTime > InputTime )
		{
			bProne = ~bProne;
			if (bProne != 0)
				bDuck = 0;
			LastDuckTime = WorldInfo.TimeSeconds;
		}
	}
}


simulated exec function UnSprint()
{
    bReadySprint = False;
}

simulated exec function Sprint()
{
	if ( TMPawn(Pawn) != none )
	{
        if ( bRecoverSprint == 0 && WorldInfo.TimeSeconds - LastSprintTime > InputTime )
		{
			bSprint = ~bSprint;
			LastSprintTime = WorldInfo.TimeSeconds;
		}
		bReadySprint = True;
	}
}


exec function Jump()
{
	local HDPawn P;

	if (!IsMoveInputIgnored())
	{
		// jump cancels feign death
		P = HDPawn(Pawn);
	 	if (bProne>0)
	 	{
	 		bProne = 0;
	 	}
    	if (bDuck>0)
		{
			bDuck = 0;
	 	}
	 	if ( bSprint != 0 )
        {
            P.LeaveSprint();
            P.EndSprint();
            if ( bReadySprint )
            {
                SetTimer( 0.2, false, 'DoRecoverSprint');
                bJumpSprint = True;
            }
	 	}

		Super(PlayerInput).Jump();
	}
}

// Postprocess the player's input.
event PlayerInput( float DeltaTime )
{
    local HDPawn HDP;
    super.PlayerInput(DeltaTime);
    HDP = HDPawn(Pawn);
    if ( HDP != none && ViewTarget == HDP )
    {

        if ( aTurn != 0 && HDP.TestProneCollision( aTurn ) )
        {
            aTurn = 0;
        }

        if ( aForward < 0 && HDP.TestProneCollision( 0 ) )
        {
            aForward = 0;
        }
    }
}

// bindings setting
function HDSetBind(const out name BindName, string Command)
{
	local KeyBind	NewBind;
	local int		BindIndex;

	if ( Left(Command,1) == "\"" && Right(Command,1) == "\"" )
	{
		Command = Mid(Command, 1, Len(Command) - 2);
	}

	for(BindIndex = Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(Bindings[BindIndex].Name == BindName)
		{
			Bindings[BindIndex].Command = Command;
			// `log("Binding '"@BindName@"' found, setting command '"@Command@"'");
			return;
		}
	}

	// `log("Binding '"@BindName@"' NOT found, adding new binding with command '"@Command@"'");
	NewBind.Name = BindName;
	NewBind.Command = Command;
	Bindings[Bindings.Length] = NewBind;
}

function SwitchBindName( const out name OldName, const out name NewName, const out name CommandName )
{
	local int		BindIndex;
	local name      tempCommand;
	for(BindIndex = Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(Bindings[BindIndex].Name == OldName)
		{
			tempCommand = Name(Bindings[BindIndex].Command);
            if (  tempCommand == CommandName )
                Bindings[BindIndex].Name = NewName;
		}
	}
	return;
}

