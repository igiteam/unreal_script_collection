class OLHidingSpot extends OLGameplayMarker
	native
	placeable;

var() OLDoor AssociatedDoor;

var() OLWaitPointComponent WaitPointComponent;

var() float FindHiddenPlayerProbability;

var OLBot ActiveBot;
var array<OLBot> Bots;

cpptext
{
	virtual void PostLoad();
	virtual void PostEditMove(UBOOL bFinished);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	virtual UBOOL Tick( FLOAT DeltaSeconds, ELevelTick TickType );

	virtual UBOOL IsValid() const { return AssociatedDoor != NULL; }
}

defaultproperties
{
	FindHiddenPlayerProbability=-1.0

	Begin Object Class=ArrowComponent Name=ArrowComponent0
		ArrowColor=(R=173,G=183,B=243)
		bTreatAsASprite=True
		SpriteCategoryName="OutlastGameplay"
	End Object
	Components.Add(ArrowComponent0)

	Begin Object Class=OLWaitPointComponent Name=WPC
		StartOffset=(X=140.0f,Y=70.0f,Z=0.0f)
		AdditionalOffset=(X=60.0f,Y=0.0f,Z=0.0f)	
		bOneSideOnly=true
	End Object
	WaitPointComponent=WPC
	Components.Add(WPC)
}