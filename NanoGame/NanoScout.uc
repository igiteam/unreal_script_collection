/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoScout extends Scout
	native
	transient;

cpptext
{
#if WITH_EDITOR
	virtual void Exec( const TCHAR* Str );
	virtual void BuildFlightVolumes();
#endif


	virtual void InitForPathing( ANavigationPoint* Start, ANavigationPoint* End );

	/**
	 * if your game adds custom edge types, you should call Register() on them in your overidden scout class here
	 */
	virtual void InitializeCustomEdgeClasses();
};

defaultproperties
{
	Begin Object NAME=CollisionCylinder
		CollisionRadius=+0034.000000
	End Object

	PathSizes.Empty

	// These need to match the sizes of the Enemies we have in nano
	PathSizes.Add((Desc=Common,Radius=30)  // tattler
	PathSizes.Add((Desc=Common,Radius=60))  // trooper
	PathSizes.Add((Desc=Common,Radius=120)) // policecar
	PathSizes.Add((Desc=Common,Radius=220)) // bullram

	EdgePathColors.Add((R=0,G=0,B=255))
	EdgePathColors.Add((R=0,G=255,B=0))
	EdgePathColors.Add((R=255,G=127,B=39))
	EdgePathColors.Add((R=127,G=255,B=39))


	NavMeshGen_MaxPolyHeight=1102.0

	// this is set to the size of the RiotCop.  This helps alleviate some of the crazy dragon scale polys we are seeing in chl_p
	// with it being big:  We will have issues if we have small tiny pathways that are meant for only small guys to get through
	// so we may need to change this back to being smaller once the simplification process of the navmesh gets another pass
	NavMeshGen_StepSize=60.0f  

	NavMeshGen_ExpansionDoObstacleMeshSimplification=FALSE

}
