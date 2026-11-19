//=============================================================================
// DiscoBall.
//=============================================================================
class DiscoBall extends KActor placeable;

var (DiscoTek) vector m_StartVec;
var (DiscoTek) float m_UpdateTime;
var (DiscoTek) bool m_bFlyer;
var (DiscoTek) PointLightComponent m_DiscoLight1;
var (DiscoTek) vector m_DiscoLight1Loc;
var (DiscoTek) bool m_bDisplayLightOneLoc;
var (DiscoTek) PointLightComponent m_DiscoLight2;
var (DiscoTek) vector m_DiscoLight2Loc;
var (DiscoTek) bool m_bDisplayLightTwoLoc;


var (DiscoTekBinding) bool m_bUseZBinding;
var (DiscoTekBinding) bool m_bUseXBinding;
var (DiscoTekBinding) bool m_bUseYBinding;
var (DiscoTekBinding) float m_X_Orgin;
var (DiscoTekBinding) float m_Y_Orgin;
var (DiscoTekBinding) float m_Z_Orgin;
var (DiscoTekBinding) float m_X_MaxRange;
var (DiscoTekBinding) float m_Y_MaxRange;
var (DiscoTekBinding) float m_Z_MaxRange;

var (DiscoTekMaxVelocity) float m_MaxX_Velocity;
var (DiscoTekMaxVelocity) float m_MaxY_Velocity;
var (DiscoTekMaxVelocity) float m_MaxZ_Velocity;


simulated function PreBeginPlay() 
{
	// # 1
	// Sets the timer to go off every 9 seconds
	// The 'true' arguement means call the Timer function each time the timer
	// goes off, not just the first time.
    SetTimer(m_UpdateTime, true);
    ;

}

simulated function PostBeginPlay() 
{
	local vector lightLoc1;
	local vector lightLoc2;
	
	AttachComponent(m_DiscoLight1);
	AttachComponent(m_DiscoLight2);
	
	
	lightLoc1 = Location + m_DiscoLight1Loc;
	
	lightLoc2 = Location + m_DiscoLight2Loc;
	
	m_DiscoLight1.Owner.Move(lightLoc1);
	
	m_DiscoLight2.Owner.Move(lightLoc2);
	
	// # 2
	// Sets the initial velocity vector to point down and sets the speed to 30
     Velocity = m_StartVec;
	;
	;
   	;


}

function Tick( FLOAT DeltaTime ) 
{
	local color newlightColor1;
	local color newlightColor2;
	local float brightness;

	super.Tick(DeltaTime);
	
	newlightColor1.R = Rand(255);
	newlightColor1.G = Rand(255);
	newlightColor1.B = Rand(255);

	newlightColor2.R = Rand(255);
	newlightColor2.G = Rand(255);
	newlightColor2.B = Rand(255);
	
	brightness = Rand(10.0);
	
	m_DiscoLight1.SetLightProperties( brightness, newlightColor1, );
	
	m_DiscoLight2.SetLightProperties( brightness, newlightColor2, );
	
	if( m_bDisplayLightOneLoc )
	{
	
		DrawDebugSphere(	m_DiscoLight1.Owner.Location,
							100,
							10,
							newlightColor1.R,
							newlightColor1.G,
							newlightColor1.B, 
							false);
						
	}
	
	if( m_bDisplayLightTwoLoc )
	{
						
		DrawDebugSphere(	m_DiscoLight2.Owner.Location,
							100,
							10,
							newlightColor2.R,
							newlightColor2.G,
							newlightColor2.B, 
							false);
						
	}

}

function Timer() 
{
	local float xnegRand;
	local float ynegRand;
	local float znegRand;

	// # 3
	// Multipy by -1 each time the executes
	if(m_bFlyer)
	{
		xnegRand = Rand(2.0);
		
		//`log(" DISCO BALL: " @ Name @ "  - " @ "xnegRand: " @ xnegRand @ " -*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#");

		
		Velocity.X = Rand(m_MaxX_Velocity);
		
		//`log(" DISCO BALL: " @ Name @ "  - " @ "Velocity.X: " @ Velocity.X @ " -*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#");

		
		if( xnegRand > 0 )
		{
			Velocity.X = (-1) * Velocity.X;
		}
		
		   	//`log(Tag @ " DISCO BALL Before Y: " @ Name @ "  - " @ "Vel: " @ Velocity.X @ ", " @ Velocity.Y @ ", " @ Velocity.Z @ " -*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#");

		
		ynegRand = Rand(2.0);

		Velocity.Y = Rand(m_MaxY_Velocity);
		
		if( ynegRand > 0 )
		{
			Velocity.Y = (-1) * Velocity.Y;
		}
		
		   	//`log(Tag @ " DISCO BALL Before Z: " @ Name @ "  - " @ "Vel: " @ Velocity.X @ ", " @ Velocity.Y @ ", " @ Velocity.Z @ " -*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#-*#");

		
		znegRand = Rand(2.0);
		
		Velocity.Z = Rand(m_MaxZ_Velocity);
		
		if( znegRand > 0 )
		{
			Velocity.Z = (-1) * Velocity.Z;
		}
		
		RotationRate.Roll = 5000.0;
		DesiredRotation.Roll = Rotation.Roll + 5000.0;
		
		RotationRate.Pitch = 500.0;
		DesiredRotation.Pitch = Rotation.Pitch + 5000.0;


		RotationRate.Yaw = 5000.0;
		DesiredRotation.Yaw = Rotation.Yaw + 5000.0;
		
	}
	else
	{
		Velocity = (-1) * Velocity;
	}
	
	//m_DiscoLight.Location = Location;
	
	//m_DiscoLight.Location.Z = m_DiscoLight.Location.Z + 100.0;
	
	;
	;
   	;
}

