# ElastAlert Rules Folder #
By default, the Docker image for ElastAlert uses the rule files found in `../windowsservercore/rules-example`. To use your own custom rule files, use the volume mounts to use them within the Docker container.

## Using volume mounts for custom config ##
If you placed that custom config in this folder, then your Docker run command would be:
`docker run -v .\myrules:C:\\ElastAlert\\rules tonyhernandezatms/elastalert:0.1.29_python-2.7.14_windowsservercore-ltsc2016`
> Note the above command does not include any links that might be necessary to connect to other containers.

## Using Docker Compose ##
I've included a few Docker Compose files to simplify deployment.

When using Docker Compose with the
`docker-compose.elastalert.yml` file, you will need to place your custom rules in this folder. Docker Compose will take care of mounting the volumes to the container.

If there is not any rule files ending with `.yaml` located in this folder, the container will default to using the sample rules that is already in the Docker image.

### More information on ElastAlert Rules ###

You can find more details about rules here: [http://elastalert.readthedocs.io/en/latest/running_elastalert.html#creating-a-rule](http://elastalert.readthedocs.io/en/latest/running_elastalert.html#creating-a-rule)