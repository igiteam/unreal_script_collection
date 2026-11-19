class SeqAct_TankTurretLookAt extends SeqAct_Latent
										dependsOn(TPBaseTank);

var Actor Destination;
var() TurretFocusType FocusType;
var() bool bResetTurret;

