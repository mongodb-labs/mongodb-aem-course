# Chapter 4 - Project Implementation
For this chapter we want to have a deep dive into steps necessary to bring an AEM deployment into production.
All the steps necessary to enable:

- Deployment Architecture
- Sizing
- Security
- Monitoring
- Backup & Recovery
- Automation

For most of these operations you will have to perform certain tasks that are list on this document.

## Instruction Set


### Generate Keyfile
To enable security on a MongoDB instance you need to start by creating a keyfile to store the authentication information.
To setup a Replica Set you need to share the same keyfile amongst all Replica Set members.
On each MongoDB VM you will find a shared folder called `/vagrant` that is shared amongst all MongoDB VMs, so one can use this shared folder to place the generated keyfile.
> In production environments you should not use shared folders but copy the keyfile to all members of that replica set


```bash
cd /vagrant
./generate_keyfile.sh
Generated `aem-replica-keyfile`
```

### Boot Up instance on Standalone mode
In order to fully configure the system under a secure environment we first need to create our users and set the authentication parameters on a node running on standalone mode.
After one of the instances is correctly created, through the replication mechanism, all other instances will follow the same credentials and setup.

To make this task easier with the handout material we can just simply edit our `mongod.conf` file.

```bash
cat mongod.conf
systemLog:
  destination: "file"
  path: "/home/vagrant/data/mongod.log"
  logAppend: true
storage:
  dbPath: "/home/vagrant/data"
  journal:
    enabled: true
  engine: "wiredTiger"
  wiredTiger:
    engineConfig:
      cacheSizeGB: 2
    collectionConfig:
      blockCompressor: "snappy"
#replication:
#   oplogSizeMB: 100
#   replSetName: "AEM-PROD"
processManagement:
  fork: true
security:
  keyFile: /vagrant/aem-replica-keyfile
setParameter:
  authenticationMechanisms: "MONGODB-CR"
net:
  port: 50000
```
By default the file should already be set with the Replication settings disabled so we can go ahead and just spin out a `mongod` instance
```bash
mongod -f mongod.conf
```
Once you connect to this machine you will find that the `mongo` shell prompt does not indicate any replication setup. If we actually run the `rs.status()` command we will get another indication that something else might be missing:
```bash
mongo --port 50000
> rs.status()
{
	"ok" : 0,
	"errmsg" : "not authorized on admin to execute command { replSetGetStatus: 1.0 }",
	"code" : 13
}
```
Which means that need to create our users first!



### Create Administrative Users & Roles
On each deployment we should create certain administrative roles that have different responsability and should remain separate.


#### `siteroot` User
The `siteroot` user can be understood has the deployment and system administration user. This user will be used to add members to the Replica Set, create specific roles etc. This user should be used mainly has last resource user, therefore the name `root`

```javascript
use admin
db.createUser({
  user: "siteroot",
  pwd: "super+root",
  roles: [
    {
      role: "root",
      db: "admin"
    }
  ]
})
```

##### `versionAdmin` Role
For compatability reasons we need to make sure we set our application users to use **MONGODB-CR** authentication mechanism.
To do that we need to first create this `versionAdmin` role and add it to our `siteroot` user inorder for to update the authentication system version to allow **MONGODB-CR**. Simple right!?

```javascript
db.createRole({
  role: "versionAdmin",
  privileges: [
    {
      resource: {
        db: "admin",
        collection: "system.version"
      },
      actions: ["insert", "update", "find"],
      roles: []
    }
  ]
})
```


##### Add Role to User
After we created the `versionAdmin` role we should add it to our system root level user `siteroot`.

```javascript
db.update("siteroot", {
  roles: [
    {role: "root", db: "admin"},
    {role: "versionAdmin", db: "admin"}
  ]
})
```

##### Update `system.version`
Now that our `siteroot` user has the role to update our authentication schema version by having role `versionAdmin` we need to do that before adding the application users, like the one that our developers will use to connect and the one we will be given AEM instances to connect to MongoDB.

```javascript
use admin
db.auth("siteroot", "super+root")
db.system.version.update(
  {_id: "authSchema", {$set: {currentVersion: 3}}, upsert=true
)
```

Validate that `authSchema` is now on version `3`
```javascript
db.system.version.find([{_id: "authSchema"}])
3
```


#### `userAdmin` User
The `userAdmin` user is created to enable the creation of other users.
You want to have this responsability separate from your System Administration or DBA to avoid becoming dependent one  single user to do both the adminstration of users and the administration of the cluster/database.

```javascript
use admin
db.createUser({
  user: "userAdmin",
  pwd: "super+admin"
  roles: [
    {
      role: "userAdminAnyDatabase",
      db: "admin"
    }
  ]
})
```

Validate that the user has been correctly created by calling the authentication method:
```javascript
db.auth("userAdmin", "super+admin")
```


### Create Application Users
Application users are generally created to allow applications and users that are not requiered to perform adminstrative tasks.
For instance, AEM instances are not required to databases or collections apart from the one where AEM is going to store is information (default `aem-author`).
It might require the need to perform actions on the database itself (create instances, indexes ...) during the initialization process but apart from that the only requirement is to insert, find, update and remove data from the application namespace itself.

#### Create AEM instance `author` user
To enable AEM instance to operate fully we are going to create an user named `author`:

```javascript
use admin
db.auth("userAdmin", "super+admin")
db.createUser(
  {
    user: "author",
    pwd: "super",
    roles: [
      {role: "readWrite", db: "aem-author"},
      {role: "dbOwner", db: "aem-author"}
    ]
  }
)
```
In order to be able to enable the AEM instance to perform all *CRUD* operations we should give it the `readWrite` built-in role.
To enable the full set of ownership over that particular database we can also add `dbOwner` role.
