### The initial architecture

local > git push > over optiplex's IP > nginx > fcgiwrap > git-http-backend > /srv/git/repo > post-receive hook > checkout into /srv/deploy > git diff > plaatformio > compile > .hex > flashing onto the teensy firmware using the inbuilt usb 

#### the first flaw in the way I uderstood the process

this was the architecture. 
what I thought was that we would be sending only the hex files. 

### the problems encountered yesterday. 

1. Since the compilation was supposed to happen on the optiplex, post-receive script runs as git, but pio is currently locate at ''' /home/administrator/...''' and hence git cannot access this directory.

2. now the git useer being a nologin system user was perfectly fine for git hooks, but not if it doesn't have even read into the directory. 

We could now have either/both of these two approaches:
- Send just the .hex file like I though we were doing, that would use only a small ampunt of the optiplex cpu, have a smaller network transfer and the build environment dependecy would be only the laptop. 

- Or we could send the entire code/folder, and have it build on the optiplex that does require us to solve [1]. THe entire pipeline here would be pushing code, and the rover automatically building and deploying all of them. 

Or we could have both, it's upto the user to send over a .hex file or compile everything onboard. 