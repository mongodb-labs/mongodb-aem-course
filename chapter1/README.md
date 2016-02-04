# Welcome to Chapter 1

So its time to get ready for chapter 1 exercises.

Let's get start with a brief overview of this handout:
- You will find the following folders:
  - **AEM** - contains all files required to set the AEM instances environment
  - **MongoDB** - same has the above but for the MongoDB instances
  - **JCR** - environment setup to launch Apache Jackrabbit Oak standalone process
- Each folder will boot different virtual machines so we can isolate the instances
- If you are following the lesson videos you might find some variations from the video examples and the configuration that you will find on your environment (mostly differences on ip addresses)

You will also find all command helpers in this file

## Chapter 1 folder

```sh
> ls .
AEM
README.md
lesson1
preflight.sh
```

## Boot MongoDB Environment
Raise one virtual machine dedicated to MongoDB standalone instance
```bash
cd lesson1/MongoDB
vagrant up
```
Verify instance status
```bash
vagrant status mongod
```
## Launch MongoDB Instance
Now that we have an running vm dedicated to MongoDB is time to setup the instance

Let's check if `mongod` is properly installed
```bash
cd lesson1/MongoDB
vagrant ssh mongod
mongod -version
```
Let's boot up `mongod`
```bash
mongod --dbpath data --storageEngine wiredTiger --logpath data/log --fork
```
Alternatively you can also run the following command:
```bash
mongod -f mongod.conf
```
We recommend you to proceed with the first command so you can get a better understanding of different options we are setting MongoDB with.

## Boot Jackrabbit Oak Standalone
For the purposed exercises on Jackrabbit Oak Standalone we will need to boot and virtual machine where we  should install the JCR standalone module
```bash
cd lesson1/JCR
vagrant up jcr
```
Let's check if the image is correctly boot up
```bash
vagrant status jcr
```
If all went well now it's time to setup the JCR

## Launch JCR Standalone
We need to install in the `jcr` instance oak-run and point it to the previously instantiated `mongod` instance.
For this particular setup we are going to use `screen` to run our instance of oak-run on the background.
```bash
vagrant ssh jcr
screen -a
java -jar /vagrant/oak-run-1.4-SNAPSHOT.jar server http://localhost:7979 Oak-Mongo --db oak --host 192.168.11.100 --port 27017
```
To detach from the loaded screen just press `ctrl+a+d`

## Mount Webdav JCR folder
One of the options we have to drill down on the data contained on the content repository is through it's [Webdav][webdav] plugin.
This will be a bit different for each version of the OS that you might be running so let's highlight the most common ones:

### Windows
1. Go to your Windows Explorer address bar and type paste the following
  - `\\192.168.11.200@7979\webdav\default`
- Once the system requires you to provide user name and password
  - user = `admin`
  - password = `admin`

### MacOSX
1. Go to Finder -> Go -> Connect To Server
2. On the server address please type
  - `http://192.168.11.200:7979/webdav/default`
3. Once the system requires you to provide user name and password
  - user = `admin`
  - password = `admin`


## Boot AEM Environment
Raise one virtual machine dedicated to AEM standalone instance
```bash
cd lesson1/AEM
vagrant up
```
Verify instance status
```bash
vagrant status aem
```

## Launch AEM Instance
Once we have an environment for our AEM installation, its time to launch our `author` instance

```bash
vagrant ssh
#let's create a screen
screen -a
java -Xmx2g -XX:MaxPermSize=512m -jar /vagrant/cq-author-p4502.jar -r crx3,crx3mongo -Doak.mongo.uri="mongodb://192.168.11.100:27017"
```
To detach from the loaded screen just press ctrl+a+d

## Stop Instances
Make sure to stop the vagrant VM's after you finished the exercises.
```bash
cd MongoDB
vagrant halt
cd ../AEM
vagrant halt
cd ../JCR
vagrant halt
```


[webdav]: https://en.wikipedia.org/wiki/WebDAV
