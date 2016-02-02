# Welcome to Week1

So its time to get ready for week 1 exercises, great!

Let's get start with a brief overview of this handout:
- You will find 2 folders
-- AEM - contains all files required to set the AEM instances environment
-- MongoDB - same has the above but for the MongoDB instances
- Each folder will boot different virtual machines so we can isolate the instances
- If you are following the lesson videos you might find some variations from the video examples and the configuration that you will find on your environment (mostly differences on ip addresses)

You will also find the baseline commands in this file

## Week 1 folder
```
> ls .
AEM
README.md
lesson1
preflight.sh
```

## Boot MongoDB Environment
Raise one virtual machine dedicated to MongoDB standalone instance
```
cd lesson1/MongoDB
vagrant up
```
Verify instance status
```
vagrant status mongod
```
## Setup MongoDB
Now that we have an running vm dedicated to MongoDB is time to setup the instance

Let's check if `mongod` is properly installed
```
cd lesson1/MongoDB
vagrant ssh mongod
> mongod -version
```
Let's boot up `mongod`
```
> mongod --dbpath data --storageEngine wiredTiger --logpath data/log --fork
```

## Boot Jackrabbit Oak Standalone
For the purposed exercises on Jackrabbit Oak Standalone we will need to boot and virtual machine where we  should install the JCR standalone module
```
cd lesson1/JCR
vagrant up jcr
```
Let's check if the image is correctly boot up
```
vagrant status jcr
```
If all went well now it's time to setup the JCR

## Setup JCR Standalone
We need to install in the `jcr` instance oak-run and point it to the previously instantiated `mongod` instance.
For this particular setup we are going to use `screen` to run our instance of oak-run on the background.
```
vagrant ssh jcr
> screen -a
> java -jar ...
```
To detach from the loaded screen just press `ctrl+a+d`

## Boot AEM Environment
Raise one virtual machine dedicated to AEM standalone instance
```
cd lesson1/AEM
vagrant up
```
Verify instance status
```
vagrant status aem
```
