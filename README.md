# Adobe Experience Manager and MongoDB Online Education Course

Hi there!

If you are seeing this that's because you have enrolled on the **Adobe Experience Manager and MongoDB** online education course (good for you!) and you are about to get introduced to the exercises that course will be asking you to complete.

Now, before we get started I would like to run a quick system requirements check:

(if you are running on a MacOsx or Linux machine you can run [preflight.sh] script)

* Vagrant Installed
* VirtualBox Installed
* AEM 6.1 and corresponding license
* MongoDB 3.0 Enterprise

If you have any other questions around the [requirements][0] please let us know!

This is a 4 week course where we will cover the following topics:
* AEM Basics
* MongoDB Basics
* AEM and MongoDB Integration Details
* Tuning and Operational Best Practices
* Production Environment Setup

The exercises will be packaged on the course handouts that you will have access to on a weekly basis.
Each week will have its exercise and samples folder that should be place at the same level has this README file:
```
> ls mongod-aem-course
README.md
AEM
lesson1
lesson2
lesson3
lesson4
preflight.sh
```

## Baseline Structure

As previously mentioned you will need to place your AEM jar file on a specific location with a particular name. We want you to place your your `cq-*.jar` on folder `AEM/author`

Once you have it placed there and all the other requirements meet we are ready to start placing on this root location all the different week handouts.




[0]: https://university.mongodb.com/courses/M212/about
[preflight.sh]: preflight.sh
