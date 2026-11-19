Class TripWire extends Actor
	hidecategories ( Actor, Advanced, Lighting, LightColor, Karma, Force, Sound )
	placeable;

var(TripWire) bool bInitiallyActive;
var(TripWire) bool bActiveToggled;
var(TripWire) enum ETriggerType
{
	TT_PlayerProximity,		// Trigger is activated by player proximity.
	TT_HumanPlayerProximity, 	// Trigger activated by human player (not bot)
	TT_ClassProximity,		// Trigger activated by specific class type
} TriggerType;

var(TripWire) class<actor> ClassProximityType;

// Internal Variables
var bool bIsActive;

event Trigger( Actor Other, Pawn EventInstigator ){
	if(bActiveToggled){
		ToggleActive();
	}else{
		destroy();
	}
}

function Bump(actor Other){
	if(IsRelevant(Other) && bIsActive){
		TriggerEvent(Event, self, Other.Instigator);
		destroy();
	}
}

function bool IsRelevant( actor Other )
{
	switch( TriggerType )
	{
		case TT_HumanPlayerProximity:
			return (Pawn(Other) != None) && Pawn(Other).IsHumanControlled();
		case TT_PlayerProximity:
			return (Pawn(Other) != None) && (Pawn(Other).IsPlayerPawn() || Pawn(Other).WasPlayerPawn());
		case TT_ClassProximity:
			return ClassIsChildOf(Other.Class, ClassProximityType);
	}
}

function ToggleActive(){

	bIsActive = !bIsActive;
	bhidden = !bhidden;

	if(bIsActive){
		SetCollision(true, true, true);
	}else{
		SetCollision(false, false, false);
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    bIsActive=true
    DrawType=8
    StaticMesh=StaticMesh'CBS_SetSpecificGroup.jungle.boobytrap_Wire'
    bBlockActors=true
    bBlockPlayers=true
    bBlockPawns=true
    bBlockKarma=true
}