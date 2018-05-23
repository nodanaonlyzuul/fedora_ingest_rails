| Branch        | Status                                                                                                                                   |
|:--------------|:-----------------------------------------------------------------------------------------------------------------------------------------|
| `master`      | [![Build Status](https://travis-ci.org/NYPL/fedora_ingest_rails.svg?branch=master)](https://travis-ci.org/NYPL/fedora_ingest_rails)      |
| `development` | [![Build Status](https://travis-ci.org/NYPL/fedora_ingest_rails.svg?branch=development)](https://travis-ci.org/NYPL/fedora_ingest_rails) |
| `qa`          | [![Build Status](https://travis-ci.org/NYPL/fedora_ingest_rails.svg?branch=qa)](https://travis-ci.org/NYPL/fedora_ingest_rails)          |
| `production`  | [![Build Status](https://travis-ci.org/NYPL/fedora_ingest_rails.svg?branch=production)](https://travis-ci.org/NYPL/fedora_ingest_rails)  |

## Fedora Ingest Rails

This is a Rails port of the Java application [FedoraIngest](https://github.com/NYPL/FedoraIngest/blob/master/README.md).

It an endpoint that [MMS](https://bitbucket.org/NYPL/mms/) hits (with
an items' UUIDs as a parameter). It records the UUID in an internal database.

Then (via DelayedJob):

* Iterates through those UUIDS and asks MMS for the latest information.
  - Asks other services (like Filestore DB) for more information about the item.

* Turns around and posts that information to Fedora & RELS-EXT Solr

This decouples MMS from direct communication with Fedora in the event of Fedora API changes or downtime.

## Installing & Running

This application uses [docker-compose.yml](./docker-compose.yml) to run _most_ of what it needs.
As time goes on, we're trying to Dockerize more dependencies and have `docker-compose` be
one-stop shopping for running locally. **You can edit code as on your machine and expect it to hot-reload like you usually would.
Forget Docker is there.**

1. Clone [NYPL/fedoracommons-3.4.2-dockerized](https://github.com/NYPL/fedoracommons-3.4.2-dockerized) in the directory above this.
1. In this app's root directory `./.env.example` to `./.env` and fill it out.
1. Ensure MMS is running on port 3000
1. `docker-compose up --scale worker=2`

### What Does Compose Spin Up?

It brings up the following services:

#### The App Itself

The app reachable at http://localhost:3000.
It also spins up 2 workers.

#### PostgreSQL

The app's database persists in `./database-data/postgres` of _your_ machine.

#### Fedora

Our [dockerized Fedora instance](https://github.com/NYPL/fedoracommons-3.4.2-dockerized) reachable at http://localhost:8080.

## Testing

`docker run --workdir /home/app/fedora_ingest_rails --env-file .env fedora_ingest_rails_webapp /usr/bin/bundle exec rspec`

### Creating and Bootstrapping Databases

In addition to its own database, this application communicates to

* A MySQL database that stores the images that are in isilon.
* A MySQL database that stores audio/videos that are in isilon.

They are in different databases for historic reasons and one
day, they should be combined.

#### Bootstrapping the image filestore database

1. Create MySQL Database
  - `create database ami_filestore_development;`
  - `create database ami_filestore_test;`
  - `create database image_filestore_development;`
  - `create database image_filestore_test;`

2. Load its contents with a command like `mysql -uroot DBNAME < ./db/resources/image_filestore_schema.sql`

#### Bootstrapping the AMI filestore database

1. Create a MySQL database
2. Load its contents with a command like `mysql -uroot DBNAME < ./db/resources/ami_filestore_schema.sql`

### Setting Environment Variables

Copy `./.env.example` to `./.env`.

Fill it out with:

* Credentials to the two databases mentioned above.
* Host and credentials for making requests to MMS's API.
* Host and credentials for connecting to Fedora.

## Running Delayed Job

The rails application accepts work by being hit by HTTP requests but
does all its hard work in DelayedJob workers. This allows it to answer
requests quickly while being horizontally scalable by spinning up
additional workers.

## Git Workflow & Deployment

Our branches (in order or stability are):

| Branch      | Environment | AWS Account     |
|:------------|:------------|:----------------|
| master      | none        | none            |
| development | development | aws-sandbox     |
| qa          | qa          | aws-digital-dev |
| production  | production  | aws-digital-dev |

### Cutting A Feature Branch

1. Feature branches are cut from `master`.
2. Once the feature branch is ready to be merged, file a pull request of the branch _into_ master.

### Deploying

We use Travis for continuous deployment.
Merging to certain branches automatically deploys to the environment associated to
that branch.

| Merge from    | Into          | Deploys to (after tests pass) |
|:--------------|:--------------|:------------------------------|
| `master`      | `development` | development env               |
| `development` | `qa`          | qa env                        |
| `qa`          | `production`  | production env                |

For insight into how CD works look at [.travis.yml](./.travis.yml) and the
[provisioning/travis_ci_and_cd](./provisioning/travis_ci_and_cd) directory.
The approach is inspired by [this blog post](https://dev.mikamai.com/2016/05/17/continuous-delivery-with-travis-and-ecs/) ([google cached version](https://webcache.googleusercontent.com/search?q=cache:NodZ-GZnk6YJ:https://dev.mikamai.com/2016/05/17/continuous-delivery-with-travis-and-ecs/+&cd=1&hl=en&ct=clnk&gl=us&client=firefox-b-1-ab)).

## Amazon & ECS Deployment Configuration

See [Amazon And ECS](./documentation/amazon-and-ecs.md).

## Debugging

See [Debugging](./documentation/debugging.md).
