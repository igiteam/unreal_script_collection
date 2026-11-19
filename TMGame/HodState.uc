class HodState extends AICommand within TGAI;

function Pushed()
{
	Super.Pushed();
	pawn.ZeroMovementVariables();
}

function Popped()
{
	Super.Popped();
	pawn.ZeroMovementVariables();
}
