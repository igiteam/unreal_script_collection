class LevelLoadController extends PlayerController
	native;

var string NewMapName;

/* SpawnDefaultHUD()
Spawn a HUD (make sure that PlayerController always has valid HUD, even if \
ClientSetHUD() hasn't been called\
*/
function SpawnDefaultHUD()
{
	local class<HUD> NewHUDClass;
	
	NewHUDClass = class<HUD>(DynamicLoadObject("ZombieGame.LevelLoadHUD", class'Class'));
	myHUD = spawn(NewHUDClass, self);
	myHUD.InitHUD();
}


function ClientSetHUD(class<HUD> newHUDType, class<Scoreboard> newScoringType)
{
	local class<HUD> NewHUDClass;
	
	log("Testing LevelLoadHUD: " $ myHUD);
	
	if (myHUD == None)
	{
		NewHUDClass = class<HUD>(DynamicLoadObject("ZombieGame.LevelLoadHUD", class'Class'));

		myHUD = spawn(NewHUDClass, self); 
		myHUD.InitHUD();
	}
}
