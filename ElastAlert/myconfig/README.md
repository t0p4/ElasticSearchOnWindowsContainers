# ElastAlert Config Folder #
By default, the Docker image for ElastAlert uses the config file found in `../windowsservercore/config-example`. If that file doesn't suite your needs, you can create a custom `config.yaml` file and use volume mounts to use it within the Docker container. 

## Using volume mounts for custom config ##
If you placed that custom config in this folder, then your Docker run command would be:
`docker run -v .\myconfig:C:\\ElastAlert\\config tonyhernandezatms/elastalert:0.1.29_python-2.7.14_windowsservercore-ltsc2016`
> Note the above command does not include any links that might be necessary to connect to other containers.

## Using Docker Compose ##
I've included a few Docker Compose files to simplify deployment.

When using Docker Compose with the 
`docker-compose.elastalert.yml` file, you will need to place your custom `config.yaml` file here. Docker Compose will take care of mounting the volumes to the container. 

If there is not a `config.yaml` located in this folder, the container will default to using the sample `config.yaml` that is already in the Docker image.

### More information on ElastAlert Configuration ###

You can find more details about the config file options here: [http://elastalert.readthedocs.io/en/latest/running_elastalert.html](http://elastalert.readthedocs.io/en/latest/running_elastalert.html)