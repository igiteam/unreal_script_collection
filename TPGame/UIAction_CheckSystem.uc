class UIAction_CheckSystem extends UIAction;

event Activated()
{
	if (GetWorldInfo().IsConsoleBuild() == false)
		OutputLinks[0].bHasImpulse = TRUE;
	else
		OutputLinks[1].bHasImpulse = TRUE;
}	

