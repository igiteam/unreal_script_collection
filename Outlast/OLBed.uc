class OLBed extends OLGameplayMarker
	native
	placeable;

var() OLWaitPointComponent WaitPointComponent;

var() float ThrowOffsetLeft;
var() float ThrowOffsetRight;

var() float FindHiddenPlayerProbability;

var OLBot ActiveBot;
var array<OLBot> Bots;

cpptext
{
	virtual void PostLoad();
	virtual void PostEditMove(UBOOL bFinished);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	virtual UBOOL Tick( FLOAT DeltaSeconds, ELevelTick TickType );

	virtual UBOOL IsValid() const { return TRUE; }
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

	Begin Object Name=Sprite
		Sprite=Texture2D'Utility.HideUnderBed-01_D'
		Scale=0.10
	End Object

	Begin Object Class=OLWaitPointComponent Name=WPC
		StartOffset=(X=70.0f,Y=140.0f,Z=0.0f)
		AdditionalOffset=(X=0.0f,Y=60.0f,Z=0.0f)
		bFlipOnYAxis=true
	End Object
	WaitPointComponent=WPC
	Components.Add(WPC)

	ThrowOffsetLeft=90.0
	ThrowOffsetRight=-90.0
}