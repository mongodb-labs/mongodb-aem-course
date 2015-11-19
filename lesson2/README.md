# Lesson 2
Over the course of this lesson we will be focussing on the following aspects
- Understand the different data formats that AEM stores in MongoDB
- Internal data structure
- Introduction to MongoDB
- How to configure MongoDB

## Lesson repository structure
For this lesson we will be using 2 vagrant instances
- mongodb instance: virtual machine that where we will be installing a standalone MongoDB instance
- aem instance: here we will be installing the AEM and connecting that to MongoDB instance

Do not forget that for a correct installation and operation of *aem* instances you need to have a copy and license of your AEM 6.0 or 6.1 in the _AEM/author_ folder


## Instruction Set
We are going to use in this lesson a single MongoDB standalone instance and use that to support a standalone AEM instance
The following block of instructions describe the steps necessary to get the system up and running.

### Checkout `lesson2` branch from repository
If you are reading this file this means that you have already checked out that proper branch but in case you following the instructions from github page it makes sense to reenforce that step:
```
git checkout lesson2
```
To avoid any issues make sure you have previously fetch all set of available branches from the remote repository
```
git fetch origin
```

### Boot up MongoDB virtual machine
So let's get started by booting up the virtual machine that will host MongoDB

```
cd lesson2/MongoDB
vagrant up
```

### Connect to VM and run `mongod` standalone instance
```
vagrant ssh
mongod --dbpath data --storageEngine wiredTiger --fork --logpath data/logpath
```

### Boot up AEM virtual machine
The same exercise has before but now we are going to do it for the AEM instance
```
cd ../AEM
vagrant up
```
### Install AEM using MongoDB as backend

```
vagrant ssh
screen -a
java -Xmx2g -XX:MaxPermSize=512m -jar /home/vagrant/aem/cq-author-p4503.jar -r crx3,crx3mongo -Doak.mongo.uri="mongodb://192.168.19.100"
```
