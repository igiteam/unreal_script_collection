
class BulletDecalManager extends Object
						config(Game);

var int CurrentIndex;
var config int MaxCount;					// Max count before the list removing the first
var array<DecalComponent> BulletDecals;
var float DepthBias;

function Initialize()
{
	BulletDecals.Insert(0, MaxCount);
}

function Add(DecalComponent Decal)
{
	if( BulletDecals.Length == 0 )
	{
		;
		return;
	}

	if (CurrentIndex >= MaxCount)
		CurrentIndex = 0;
	
// 	if (BulletDecals[CurrentIndex] != none)
// 		DecalLifetimeDataAge(BulletDecals[CurrentIndex].LifetimeData).LifeSpan = 0.0;
	
	DepthBias -= 0.00002;
	Decal.DepthBias = DepthBias;
	BulletDecals[CurrentIndex] = Decal;
	CurrentIndex++;
}

