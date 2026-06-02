# ORP-RBLXLINK
Helper plugin for roblox studio that connects to [Obbying Revival Project](https://github.com/GameabillityOnYt/obbying-revival-project) through a webserver.
For the best UI experience, enable the enhanced UI capabilities in the roblox studio betas.

If you wanna know how ot use certain libraries, read their description at the top of the luau file!

Requests are structured like this:
ACTION|ARGUMENT 1|ARGUMENT 2 ...

### Request types:
|  Trigger  |  Arguments  |  What it does  | Finished |
| --------  | ------- | ------- | :-------: |
| sync      | The JSON-ified version of the selected group/folder | Syncs changes between roblox studio and ORP | ❌️ |
| run      | code | runs lua code through [vLua](https://devforum.roblox.com/t/vlua-loadstring-reimplemented-in-lua/2495756) in roblox studio (it's very limited) | ✅️ |

curent look at UI:

<img width="568" height="291" alt="image" src="https://github.com/user-attachments/assets/77432ae5-bae5-4c96-ba11-7b61dd073e3f" />

Please note that if you wanna contribute: this was made using rojo!
