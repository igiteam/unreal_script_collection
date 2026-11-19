/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DenseBashedFlyThroughTheAir extends NanoSpecialMove;

/** We save this off as the Bashed pawn can die which will reset all of the InteractionPawn vars that we use. **/
var transient NanoPawn PawnWhoBashedIntoMe;


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local NanoSkill_DenseBash DenseBash;
	local NanoPC NPC;
	local NanoPawn_MetaCorpBase MCB;

	Super.SpecialMoveStarted( bForced, PrevMove );


	PawnWhoBashedIntoMe = MyNP.InteractionPawn;

	NPC = NanoPC(PawnWhoBashedIntoMe.Controller);

	if( NPC != None )
	{
		MCB = NanoPawn_MetaCorpBase(MyNP);

		if( MCB != None )
		{
			// play the effects for the pawn being hit (e.g. small robot might have different sounds than fleshy trooper)
			NPC.PlaySound(MCB.BoulderSound);
			NPC.ClientPlayCameraShake(MCB.BoulderScreenShake);
			NPC.ClientPlayForceFeedbackWaveform(MCB.BoulderWaveForm);
		}
	}


	// this is who bashed into us
	DenseBash = PawnWhoBashedIntoMe.GetSkill(class'NanoSkill_DenseBash');

	//`log( "KNOCK BACK!" @ DenseBash.GetDenseBashDamage() );
	MyNP.Knockback( (vect(0,0,1)*DenseBash.GetDenseBashVelocityUp())+(MyNP.DenseBash_BashDir*DenseBash.GetDenseBashVelocity()), TRUE, 'DenseBash' );

	MyNP.TakeDamage( DenseBash.GetDenseBashDamage(), PawnWhoBashedIntoMe.Controller, vect(0,0,0), (vect(0,0,1)*DenseBash.GetDenseBashVelocityUp())+(MyNP.DenseBash_BashDir*DenseBash.GetDenseBashVelocity()), DenseBash.GetDenseBashDamageType(), , PawnWhoBashedIntoMe );
	

}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );
}


function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( MyNP.Physics == PHYS_Walking && !MyNP.bKnockDownOnLanding && !MyNP.bKnockedDown )
	{
		//`log( "ending ending NSM_DenseBashedFlyThroughTheAir" );
		MyNP.EndSpecialMove();
	}
}



defaultproperties
{
}


