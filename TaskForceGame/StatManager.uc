class StatManager extends info;

var float GameStartTime;
var float TotalGameTime;
var int EnemiesKilled;
var int EnemiesHit;
var int ShotsFired;

var int PlayerHits;
var int PlayerDamage;

function ResetStats()
{
	GameStartTime = 0;
	TotalGameTime = 0;
	EnemiesKilled = 0;
	ShotsFired = 0;
	EnemiesHit = 0;

	PlayerHits = 0;
	PlayerDamage = 0;
}

//called from SFRMSinglePlayer postLogin
function MapStart()
{
	ResetStats();
	GameStartTime = Level.TimeSeconds;
}

//called from MenuManager showStats
function MapEnd()
{
	TotalGameTime = Level.TimeSeconds - GameStartTime;
}

//called whenever an enemy is killed
function EnemyKilled()
{
	++EnemiesKilled;
}

//called whenever the player shoots
function ShotFired()
{
	++ShotsFired;
}

//called whenever the player hits an enemy
function EnemyHit ( )
{
	++EnemiesHit;
}

//called whenever the player gets hit
function PlayerHit(int damage)
{
	++PlayerHits;
	PlayerDamage += damage;
}

//All the following called from the	StatMenu to determine results
function string GetTime()
{
	return FormatTime(TotalGameTime);
}

function int GetEnemiesKilled()
{
	return EnemiesKilled;
}

function int GetAccuracy()
{
	local int acc;

	if (ShotsFired <= 0)
	{
		return 0;
	}

	acc = (100 * EnemiesHit) / ShotsFired;
	
	return acc;
}

function int GetPlayerHits()
{
	return PlayerHits;
}
