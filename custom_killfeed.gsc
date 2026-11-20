#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
    if(!isDefined(level.original_callbackPlayerKilled))
    {
        level.original_callbackPlayerKilled = level.callbackPlayerKilled;
    }
    level.callbackPlayerKilled = ::custom_callbackPlayerKilled;
}

custom_callbackPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
    // Resolvemos el atacante (jugador directo o dueño de la racha)
    realAttacker = attacker;
    if((!isDefined(realAttacker) || !isPlayer(realAttacker)) && isDefined(eInflictor))
    {
        if(isDefined(eInflictor.owner) && isPlayer(eInflictor.owner))
            realAttacker = eInflictor.owner;
    }
    else if(isDefined(realAttacker) && !isPlayer(realAttacker) && isDefined(realAttacker.owner) && isPlayer(realAttacker.owner))
    {
        realAttacker = realAttacker.owner;
    }

    if(isDefined(realAttacker) && isPlayer(realAttacker) && realAttacker != self)
    {
        weaponName = getEventWeaponName(sWeapon);
        
        headshotTag = "";
        if(isDefined(sHitLoc) && (sHitLoc == "head" || sHitLoc == "helmet"))
        {
            headshotTag = " ^3[Headshot]";
        }

        // Mensaje para el ATACANTE
        realAttacker iPrintLn("^2" + realAttacker.name + " ^7[" + weaponName + "^7] ^1" + self.name + headshotTag);

        // Mensaje para la VÍCTIMA
        self iPrintLn("^1" + realAttacker.name + " ^7[" + weaponName + "^7] ^5" + self.name + headshotTag);
    }

    [[level.original_callbackPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
}

getEventWeaponName(sWeapon)
{
    if(!isDefined(sWeapon) || sWeapon == "" || sWeapon == "none")
        return "Scorestreak";

    // 1. Quitamos accesorios (+extclip+holo...) y el sufijo _mp
    baseWeapon = strtok(sWeapon, "+")[0];
    if(isSubStr(baseWeapon, "_mp"))
    {
        baseWeapon = getSubStr(baseWeapon, 0, baseWeapon.size - 3);
    }

    // 2. Buscamos el nombre oficial en la tabla interna del juego (mp/statstable.csv)
    displayName = tableLookup("mp/statstable.csv", 4, baseWeapon, 3);

    if(isDefined(displayName) && displayName != "")
    {
        // Solo quitamos la primera palabra si es un prefijo de sistema
        if(isSubStr(displayName, "_"))
        {
            parts = strtok(displayName, "_");
            startIndex = 0;
            if(parts[0] == "WEAPON" || parts[0] == "KILLSTREAK" || parts[0] == "MENU")
            {
                startIndex = 1;
            }

            cleanName = "";
            for(i = startIndex; i < parts.size; i++)
            {
                if(i > startIndex) cleanName += " ";
                cleanName += parts[i];
            }
            return cleanName;
        }
        return displayName;
    }

    // 3. Si es una sub-munición o variante (ej. knife_held), la formateamos limpia
    parts = strtok(baseWeapon, "_");
    cleanFallback = "";
    for(i = 0; i < parts.size; i++)
    {
        if(i > 0) cleanFallback += " ";
        cleanFallback += parts[i];
    }
    return cleanFallback;
}
