class PaperBoyPawn extends TPPawn
	placeable
	config(Game);




State Dying
{

	//SPMIRROR - overriding BeginState to eliminate destroy timer, just destroy right away.
	function BeginState(Name PreviousStateName)
	{
		local int i;

//		if ( bTearOff && (WorldInfo.NetMode == NM_DedicatedServer) )
//			LifeSpan = 2.0;
//		else
//			SetTimer(5.0, false);

		if ( Physics != PHYS_RigidBody )
		{
			SetPhysics(PHYS_Falling);
		}

		SetCollision(true, false);

		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
			{
				DetachFromController();
			}
			else
			{
				Controller.Destroy();
			}
		}

		for (i = 0; i < Attached.length; i++)
			if (Attached[i] != None)
				Attached[i].PawnBaseDied();
				
				
		//******Destroy pawns right away for now.  (Is it necessary to do things above then?)
		Destroy();
	}
}


