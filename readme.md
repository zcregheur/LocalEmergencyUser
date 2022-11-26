#### Known issues
Input validation works just as fine as an engine without oil - it doesn't. The difference is I'd know what's the issue with the engine and I don't with my code.
    Feel free to fix it yourself and I'll gladly approve your pull request. I always like to learn so I'd be glad if you answered my dumb ass on [StackOverflow](https://stackoverflow.com/questions/74571882/powershell-calling-function-in-loops-variable-initialisation-and-if-statement).

# What does the code do
It helps you deploy a local account accross every computer in your organisation to use in last resort when domain is innaccessible.

## Prerequesites
LocalEmergencyUser needs Powershell to work (duh.). I should come preinstalled on any non-prehistorical Windows computer (looking at you Windows 7 users). You can also find documentation to install it on Linux [here](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.3).

It also needs admin permissions level on both your computer and domain. You should't be here if you're a mere mortal (simple user) anyway. Don't forget to start the Powershell Terminal as admin too.

And finaly, it needs RSAT tools. Lucky for you, I was feeling good today and made a one-liner script for your first time set-up. Just run `firsttimeset-up.ps1` before the `main.ps1`.

### Cautions
Having an admin account that you can't manage might be a security risk.

### Disclaimers
By using LocalEmergencyUser, you acknowledge using it on computer you own or are authorized to use to such an extent. I am not liable for any damage done under the use or misuse of the script included nor are any future contributor. You are free to use and modify those scripts to apply them to your situation. If you have any usefull contribution to do, feel free to do a PR.

### Donate
Please consider donating to a charity local to your location (not those big ass charities bloated by administrative costs). "But Zach, how does that helps you?" Good question, it doesn't. While some beer money would be nice, some people need it more than I do. Anyway, with the rising cost of living, if you decide to give to a charity targeting homelessness it might play my way in the end.

### Contact
If you have any questions, feel free to contact me at localemergencyuser@zcregheur.ca and I'd be glad to answer. I speak french and english fluently, I can also work my way around german (brag) so pick and choose.

Cheers!
