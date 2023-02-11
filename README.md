# Azure Secure Backend WebApp
Azure Project to convert azure cli commands into Azure bicep IaC 



(https://azure.github.io/AppService/2021/04/22/Site-with-secure-backend-communication.html#4-connect-the-dots)
![securebackend-final-setup](https://user-images.githubusercontent.com/87688021/217966930-671723fb-0be4-44f6-ba38-dc85041ec94d.png)



# Instructions
Clone repo, change directory to `infra` folder and execute azure cli command to deployment config:

example:

`cd secure-backend-webapp/infra/`

`az deployment sub create -l eastus2 -n secure-backend-webapp -f main.bicep`
