/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GrenadeBlockingVolume extends DynamicBlockingVolume
	native;

cpptext
{
	virtual UBOOL IgnoreBlockingBy( const AActor *Other ) const;

		/**
	 * Force TRACE_LevelGeometry to still work with us even though bWorldGeometry is cleared
	 * bWorldGeometry is cleared so that actors can base properly on moving volumes
	 *
	 * @param Primitive - the primitive to trace against
	 *
	 * @param SourceActor - the actor doing the trace
	 *
	 * @param TraceFlags - misc flags describing the trace
	 */
	virtual UBOOL ShouldTrace(UPrimitiveComponent* Primitive, AActor *SourceActor, DWORD TraceFlags)
	{
		return ABlockingVolume::ShouldTrace(Primitive,SourceActor,TraceFlags);
	}
}

defaultproperties
{
	bColored=true
	BrushColor=(R=60,G=255,B=200,A=255)
	bWorldGeometry=false
	bProjTarget=true

	Begin Object Name=BrushComponent0
		BlockZeroExtent=true
		BlockRigidBody=true
		bBlockComplexCollisionTrace=true
		RBChannel=RBCC_Untitled2 // grenades
	End Object
}
