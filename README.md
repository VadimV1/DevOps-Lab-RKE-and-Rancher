# LAB2
DevOps Lab - RKE and Rancher

**<span style="text-decoration:underline;">1. Lab environment configurations:</span>**

**VM 1:** **‘k8s-master@192.168.1.139’ -**

functions as the master/control node with the roles: **controlplane** and **etcd**.

**VM 2:** **‘k8s-worker1’@192.168.1.140’ -** 

functions as the master/control node with the roles: **worker**

**VM 3:** **‘k8s-worker2‘@192.168.1.138‘ -** 

functions as the master/control node with the roles: **worker**

**VM 4:** **‘rancher@192.168.1.144’ -**

functions as a machine that deploys a container with **rancher UI** web app with **docker compose.**

**VM 5: ‘DNS@192.168.1.143’ -**

functions as a machine that is a local DNS server.

**Host**: **‘v.v@192.168.1.101’**  - \
Personal computer that runs the 5 VM’s, has ‘**RKE**’, ‘**Helm3**’, installed and ‘**kubectl’** for the cluster configuration.

**<span style="text-decoration:underline;">1.1. Deployment process of the VM’s:</span>**

***Note that I intended to use a local domain of ‘lab2.cloud’ for all of the machines for an easier involvement with them and as a practice to make the IPs static and change dns in the machines, so I installed PiHole on one of the machines to act as a local dns server for all of the machines to resolve the ip in the local network through it.**

**1.1.1.** Deployment of the 5 VM’s consisted of  installing **Ubuntu 20.04** as their main os.

**1.1.2.** After finishing the installment process of the 4 VM’s, the procedure required the additional installment of ‘**vim**’, ‘**net-tools’**, ’**openssh-server**’ and enabling the ‘ssh’ process with ‘**systemctl enable ssh**’.

**1.1.3.** Proceeding on  **‘v.v@192.168.1.101** and making an SSH key for distribution across the 4 VM’s with the ‘**ssh-keygen**’ command.

**1.1.4.** In precedence to the previous step, commence distribution of the ssh key across the 4 VM’s with the ‘**ssh-copy-id**’ command.

**1.1.5.** After the ssh key distribution, the ‘**scp**’ command was used  to send to bash scripts, ‘**make_ip_static.sh**’ and ‘**docker_install.sh**’ across the VM’s.

**1.1.6.** Running the two bash scripts to make the ip of the machine static and installing ‘Docker’ engine with 24.0.9 version. 

***note that RKE is not compatible with ‘Docker’ engine version 25.X.X and up at the time of writing of this README**

**1.1.7.** Verification that all of the VM’s are running ‘Docker’ engine 24.0.9 and the user has privilege for docker commands without ‘**sudo**’ command or ‘**root**’ privileges.

**<span style="text-decoration:underline;">2. Creation of the cluster:</span>**

**2.1.** Installation of **‘RKE’** on **‘v.v@192.168.1.101**, giving it exec property and adding it to the ‘**$PATH**’ variable.

**Url:** [RKE installation guide](https://github.com/rancher/rke)

**2.2.** Installation of **‘kubectl’** on **‘v.v@192.168.1.101’**, giving it exec property and adding it to the ‘**$PATH**’ variable.

**Url:** [kubectl installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management) 

**2.3.** Creation of a directory for the Cluster config files on **‘v.v@192.168.1.101’.**

**2.4.** Creation of **‘cluster.yml’** file for ‘**RKE**’.

**2.5.** Deployment of the cluster with ‘**rke up –config cluster.yml**’ command.

**2.6.** Proceeding to copy the ‘**kube_config_cluster.yml**’ file that was created after ‘**RKE**’ runtime into the /.kube directory.

**2.7.** Running the **‘kubectl get nodes**’ command to see that all of the 3 nodes in the cluster are at ‘**READY**’ state.

**<span style="text-decoration:underline;">3. ‘Rancher’ with ‘Docker Compose’</span>**

**<span style="text-decoration:underline;">3.1. Initial deployment of ‘Rancher’ with ‘docker compose’:</span>**

**3.1.1.** Creation of a directory for the ‘docker compose’ yml file and files for ‘Rancher’ docker (i.e “Rancer”).

**3.1.2.** Creation of ‘**docker-compose.yml**’ file for ‘**Docker Compose**’.

**<span style="text-decoration:underline;">3.1.1. Creation of self-signed SSL certificates with OpenSSl</span>**

**3.1.1.1.** Make a self-signed SSl certificate for the desired domain using a bash script (I chose ‘rancher.lab2.cloud’) with OpenSSL, for more information about how to make the certificates please check: [How to make self-signed SSL certificates](https://devopscube.com/create-self-signed-certificates-openssl/)

**3.1.1.2.** After the creation of the files, rename the files:

‘**rootCA.crt’ to ‘’cacerts.pem’**

**‘“Domain.crt”’ to “cert.pem’**

**‘“Domain.key”’ to “key.pem’**

***note that the original files are already encoded in pem format we just need the exact string format of the names to work with rancher through docker compose**

**3.1.1.3.** Create a folder (i.e ‘certs’) in the “Rancher” folder

**3.1.1.4.** Transfer the files from **3.1.1.2** into the certificate folder

**3.1.1.5.** Specify the certificate folder inside the **docker compose yml** file as volume and bind it into ‘**/etc/rancher/ssl**‘ in the docker for more information about how to assign certificates into “Racher” that is deployed with **docker compose** check: [Check how to configure SSL on Rancher](https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/other-installation-methods/rancher-on-a-single-node-with-docker#option-b-bring-your-own-certificate-self-signed)

**3.1.1.5.** Add ‘**cacerts.pem**’/‘**rootCA.crt**’ to your browser, so that the browser will trust the Rancher UI app that will run with the self-signed SSL certificates.

***Note that the same process would be that same for acquiring through a trusted/real CA you just would not need to add ‘’cacerts.pem’ in step 3.1.1.2. Into the docker filesystem.**

**3.1.3.** Running the ‘**docker compose up -d**’ command to deploy the container with **‘Rancher’**

**3.1.4.** After the successful deployment of ‘**Docker Compose**’ with ‘**Rancher**’ on it enter the site with domain name that you have binded to the docker net driver’s ip, you should see a green lock meaning the web app is trusted and follow the specified steps to make the initial login into the app, using the docker logs of the rancher deployment for the password.

**<span style="text-decoration:underline;">3.2. Adding an existing RKE cluster to the ‘Rancher UI’ web app:</span>**

**3.2.1.** In the home screen click on ‘Add existing cluster’.

**3.2.2.** Choose a name for that cluster in the rancher UI web app 

**3.2.3.** After clicking run the specified command to run the deployment file of the ranchers agents on the cluster machines.

**3.2.4.** After waiting for 2 to 3 minutes, the rancher agents on the cluster should be deployed and the status of the cluster should be updated with the resources currently in its possession with the ‘Active’ tag.

**<span style="text-decoration:underline;">4. Deploying an application to the ‘lab2’ existing cluster:</span>**

**4.1.** Installation of Helm3 on **‘v.v@192.168.1.101’**, the deployment machine, using the [Helm official documentation](https://helm.sh/docs/intro/install/).

***Note that the RKE preinstalls/deploys the NGINX ingress controller by default so I didnt deploy an ingress controller of any kind manually, but for installing the ngninx ingress controller on the cluster, make sure the desired cluster is in the default config path, or specify the desired cluster config with helm an them follow the quick [installlation steps for nginx ingress controller](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx)**

**<span style="text-decoration:underline;">4.2 Creation of the web app Docker Image:</span>**

**4.2.1.** Make a folder for the web app.

**4.2.2.** Create a simple web app using JavaScript and html to be intended yo use with node.js and listen on port 3000.

**4.2.3.** Create a Dockerfile that will deploy the node.js image, then install the npm dependencies and run the web-app.

**4.2.4.** Run** ‘docker build -t webapp:1.0 .’ **to create an Image for the web-app.

**4.2.5.** Upload the** ‘webapp:1.0’ **to the docker **‘Docker Hub’ **repository(my account) with the ‘**docker image push**’ command (also making sure that the image be downloaded publicly).

**<span style="text-decoration:underline;">4.3 Creation of k8s deployment file for the ‘webapp:1.0’ image:</span>**

**4.3.1.** Firstly I chose to create a new namespace through the yml configuration file and not do it manually with the ‘**kubectl create namespace**’ command.

**4.3.2.** Continuing with** **the deployment of the image itself in a new yml segment inside the yml configuration file and specifying the relevant image from docker hub and exposing the 3000 port inside the pod.

**4.3.3.** Then declaring a new segment for a service named **‘webapp-service’ **and binding the** ‘targetport’ **to 3000 for the pod that will run the web-app image and binding the incoming traffic to that service on port 3000.

**4.3.4.** Lastly, declaring a new Ingress and configuring it to work with the ‘**webapp-service**’ and redirect traffic to port 3000 of the service.

 

**<span style="text-decoration:underline;">4.4 Deployment of the webapp:</span>**

**4.4.1.** Run the** ‘kubectl apply -f’ **command on the relevant yml configuration that was created.

**4.4.2.** The deployment should be successful, then enter ‘**k8s.lab2.cloud**’ address (any local IP address of a machine in the cluster) to see that app deployed and to see ‘Task Completed!’ in red.

**<span style="text-decoration:underline;">5. Restoration of the cluster with the ‘Snapshot’ function of RKE:</span>**

**5.1.** Run the following command from the deployment machine ‘**rke etcd snapshot-save --config cluster.yml --name lab2-snap1**’ the process should take a minute and save a zip file containing the snapshot in the machines/node that are running ‘**etcd**’.

**5.2.** Run the following command ‘**rke remove --config cluster.yml**’ to destroy the cluster. 

**5.3.** Making sure that the process of destruction was successful with trying to connect to the webapp of **step 4.3** and seeing an error that the address isn't reachable, also check the **Rancher UI** to see that there is a problem with data/statistics from the cluster.

**5.4.** Run the following command from the deployment machine ‘**rke etcd snapshot-restore --config cluster.yml --name lab2-snap1**’ the process should take 2 to 3 minutes to complete.

**5.5.** After **step 5.4** is done, you should see that the webapp in **step 4.3** is accessible again in the browser and after a minute the cluster in the **Rancher UI** should be updated again with  ‘**Active**’ status and displaying its resources and statistics again. 
