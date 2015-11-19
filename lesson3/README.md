# Lesson 3 - Operational and Deployment
## Replica Set Configuration Instruction Set

Over the course of this lesson we will be using virtual machines, booted up by the vagrant files available on this folder, to set up our MongoDB instances.
Where's the list of instructions for the different tasks:

### Use Lesson 3 branch

We need to use `lesson3` branch of our course git repository:

```sh
git checkout lesson3
```


### Bootup virtual environment

Raise 3 virtual machines using vagrant:

```sh
cd lesson3/MongoDB
vagrant up
```


### Get VM's Status

```sh
vagrant status
```

### Get Specific VM Status

As an example, if you want to know the status of vm `mongod0` type the following

```sh
vagrant status mongod0
```

### Connect to VM
In order to configure the different MongoDB instances we need to ssh to that VM

```sh
vagrant ssh mongod0
```


### Start MongoDB Instance on AEM Replica Set
We want o enable MongoDB to belong to **AEM** Replica Set

```sh
screen -a
mongod --dbpath data --storageEngine wiredTiger --port 30000 --replSet AEM
```

Doing this set of instructions you are placed in a screen shell meaning that to get out without killing the process you need to press `ctrl + a + d` keys  


### Initiate Replica Set configuration
After repeating the previous instruction on all different VM's (mongod0, mongod1, mongod2) we need to initiate our Replica Set
```sh
mongo --host 192.168.15.100:30000
```
Once we are on the MongoDB shell we need to provide the following instructions

```javascript
var rsconf = {'_id': 'AEM', 'members': [
  {'_id':0, 'host': '192.168.15.100:30000' },
  {'_id':1, 'host': '192.168.15.101:30000' },
  {'_id':2, 'host': '192.168.15.102:30000' },
]}

rs.initiate(rsconf)
```

### Change the Replica Nodes **Priority**
If we want to give the Replica Set a more hiearchical configuration we can. To do that we need the following instructions:

```sh
mongo --host 192.168.15.100:30000
```
Once in the MongoDB shell:

```javascript
var rsconf = rs.conf()

//set mongod0 instance to priority:10
rsconf.members[0].priority = 10
//set mongod1 instance to priority: 5
rsconf.members[1].priority = 5
//reconfigure your replica set
rs.reconfig(rsconf)
```

## AEM Instance Connection

So now that we have a Replica Set we might just well use it to support our AEM instances.
To do that we just need the following instructions:

### BootUp AEM VM
Once on *mongodb-aem-course* main repository folder we need to do the following:

```sh
cd ../AEM
vagrant status
```

If the VM's are still running we need to *destroy* them

```sh
#(Reply `y` to both VM's)
vagrant destroy
```

Raise one back clean
```sh
vagrant up aem1
```

### Boot AEM Instance

Now we want to boot up our AEM instance (just one for now)
```sh
vagrant ssh aem1
screen -a
#raise the process connecting to our recently created Replica Set "mongodb://192.168.15.100:30000,192.168.15.101:30000,192.168.15.102:30000/?replicaSet=AEM"
java -Xmx2g -XX:MaxPermSize=512m -jar /home/vagrant/aem/cq-author-p4503.jar -r crx3,crx3mongo -Doak.mongo.uri="mongodb://192.168.15.100:30000,192.168.15.101:30000,192.168.15.102:30000/?replicaSet=AEM"
```
to detach don't forget to press `ctrl + a + d` keys



### Boot AEM Instance w/ JMX access

Now we want to boot up our AEM instance (just one for now)
```sh
vagrant ssh aem1
screen -a
# raises the instance enabling access from the jmxremote console
java -Dcom.sun.management.jmxremote.port=8463 -Dcom.sun.management.jmxremote.authenticate=false, -Dcom.sun.management.jmxremote.ssl=false -Xmx2g -XX:MaxPermSize=512m -jar /home/vagrant/aem/cq-author-p4503.jar -r crx3,crx3mongo -Doak.mongo.uri="mongodb://192.168.15.100:30000,192.168.15.101:30000,192.168.15.102:30000/?replicaSet=AEM"
```
to detach don't forget to press `ctrl + a + d` keys


### Monitoring Tools

For monitoring MongoDB instances our distribution comes with a few different shell based tools:

#### Mongostat

```sh
mongostat --host 192.168.15.100:30000
```

To have the full view of all nodes in a Replica Set you need pass `--discover`

```sh
mongostat --host 192.168.15.100:30000
```

#### Mongotop

```sh
mongotop --host 192.168.15.100:30000
```
