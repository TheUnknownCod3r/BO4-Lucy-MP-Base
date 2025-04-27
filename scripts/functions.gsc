/*
###########################################
Basic Modifications
###########################################
*/
Godmode()
{
    self.godmode = isDefined(self.godmode) ? undefined : true;
 
    if(isDefined(self.godmode))
    {
        self endon("disconnect");
 
        while(isDefined(self.godmode)) 
        {
            self EnableInvulnerability();
            wait 0.1;
        }
    }
    else
        self DisableInvulnerability();
}

NoclipToggle1(player)
{
    player.Noclip = isDefined(player.Noclip) ? undefined : true;
    
    if(isDefined(player.Noclip))
    {
        player endon("disconnect");
        self S("Noclip ^2Enabled");
        if(player hasMenu() && player isInMenu())
            player closeMenu1();
        player DisableWeapons();
        player DisableOffHandWeapons();
        player.nocliplinker = spawnSM(player.origin, "tag_origin");
        player PlayerLinkTo(player.nocliplinker, "tag_origin");
        
        while(isDefined(player.Noclip) && isAlive(player))
        {
            if(player AttackButtonPressed())
                player.nocliplinker.origin = (player.nocliplinker.origin + (AnglesToForward(player GetPlayerAngles()) * 60));
            else if(player AdsButtonPressed())
                player.nocliplinker.origin = (player.nocliplinker.origin - (AnglesToForward(player GetPlayerAngles()) * 60));
            if(player MeleeButtonPressed())
                break;
            
            wait 0.01;
        }

        if(isDefined(player.Noclip))
            player NoclipToggle1(player);
    }
    else
    {
        player Unlink();
        player.nocliplinker delete();
        player EnableWeapons();
        player EnableOffHandWeapons();
        self S("Noclip ^1Disabled");
    }
}


UnlimitedAmmo()
{
    self.UnlimitedAmmo = isDefined(self.UnlimitedAmmo) ? undefined : true;
    if(isDefined(self.UnlimitedAmmo))
    {
        while(isDefined(self.UnlimitedAmmo))
        {
            self GiveMaxAmmo(self GetCurrentWeapon());
            self SetWeaponAmmoClip(self GetCurrentWeapon(), self GetCurrentWeapon().clipsize);
            wait .05;
        }
    }
}

ClientOpts(func, player)
{
    switch(func)
    {
        case 0: break;
        case 1: break;
    }
}

TestOption()
{
    self iPrintLn("Test");
}

S(Message)
{
    self iPrintLnBold(Message);
}

BO4Level55(player)
{
    player AddRankXpValue("kill", 25160000);
    player rank::updaterank();
    wait .1;
    uploadStats(player);
    player iPrintLnBold("^2In order for the rank to save, please end the game via the pause menu and not the fast end!!!");
}

MP_UnlockAll(player)//No idea if this is right, pretty much basing this off the one for Zombies, instead. CURRENTLY NOT THREADED / DOESN'T WORK
{
    if(isDefined(player.UnlockAll))
        return;
    player.UnlockAll = true;

    player endon("disconnect");
    player iPrintLnBold("Unlock All ^2Started");
    if(player != self)
        self iPrintLnBold(player getName() + ": Unlock All ^2Started");
    
    for(z=1;z<6;z++)
    {
        if(z == 6) z++; //StatMileStones6.csv is empty, so we skip it.
        switch(z_)
        {
            case 1:
                start=1;
                end=255;
                break;
            case 2:
                start=256;
                end=511;
                break;
            case 3:
                start = 512;
                end = 747;
                break;
            case 4:
                start = 768;
                end = 1023;
                break;
            case 5: 
                start = 1024;
                end = 1368;
                break;
            case default:
                start=0;
                end=0;
                break;
        }
        for(value=start;value<end;value++)
        {
            stat         = SpawnStruct();
            stat.value   = Int(TableLookup("gamedata/stats/mp/statsmilestones" + a + ".csv", 0, value, 2));
            stat.type    = TableLookup("gamedata/stats/mp/statsmilestones" + a + ".csv", 0, value, 3);
            stat.name    = TableLookup("gamedata/stats/mp/statsmilestones" + a + ".csv", 0, value, 4);            
            switch(stat.type)
            {
                case "global":
                    player stats::set_stat(#"PlayerStatsList", stat.name, #"StatValue", stat.value);
                    player stats::set_stat(#"PlayerStatsList", stat.name, #"Challengevalue", stat.value);
                    break;
                case "attachment":
                    break; //Without column 13 on the tables, it's pretty useless. So we skip the attachment challenges.
                case "group":
                    groups = Array(#"weapon_pistol", #"weapon_smg", #"weapon_assault", #"weapon_lmg", #"weapon_cqb", #"weapon_sniper", #"weapon_tactical", #"weapon_launcher", #"weapon_cqb", #"weapon_knife", #"weapon_special");
                    foreach(group in groups)
                    {
                        player stats::set_stat(#"GroupStats", group, #"stats", stat.name, #"StatValue", stat.value);
                        player stats::set_stat(#"GroupStats", group, #"stats", stat.name, #"Challengevalue", stat.value);
                        wait 0.01;
                    }
                    break;
            }
            wait 0.1;
            UploadStats(player);
        }
    }
}