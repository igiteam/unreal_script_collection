class OLGameplayVolume extends PhysicsVolume
	native
	abstract;

cpptext
{
	virtual UBOOL IsValid() const { return bEnabled; }
}
