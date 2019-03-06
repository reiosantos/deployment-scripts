### Deployment Scripts

#### Files to modify:

[*] **base_dirs.sh**

-  *REPOSITORY_URL* :  This should be the repository you wish to deploy

[*] **deploy-api.service**

- *WorkingDirectory* : 
`<absolute home path>/deployment/deploy`, eg `/home/username/deployment/deploy`

- *ExecStart* :
`<absolute home path>/deployment/deploy/run-server.sh`, eg `/home/username/deployment/deploy/run-server.sh`

[*] **run-server.sh**
- replace  `yarn styart:dev` with the command that starts your server

[*] **env.sh**
- Here you can add multiple env variables as you set them in the instance metadata


##### If you wish to enable https on your server: Please execute the `generate-ssl-certificates.sh` from your bash.
You can execute it by running the following commands:
```bash
~/deployment$ cd deploy
~/deployment$ sh generate-ssl-certificates.sh
``` 

> Enjoy  

