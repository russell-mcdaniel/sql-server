## Change Data Capture (CDC)

This is a demonstration  project for SQL Server Change Data Capture (CDC). It approximates a medication tracking scenario to generate realistic transaction workloads for observing CDC behavior.

## Getting Started

Start the SQL Server container from `platform/docker/` using `Start.ps1`.

To use the existing database files, attach the database from within SSMS or SQLCMD:

```sql
CREATE DATABASE MedicationTracker ON
    PRIMARY (FILENAME = '/var/opt/cdc/data/MedicationTracker.mdf'),
    FILEGROUP CoreData (FILENAME = '/var/opt/cdc/data/MedicationTrackerCoreData.ndf'),
    FILEGROUP CoreCdc (FILENAME = '/var/opt/cdc/data/MedicationTrackerCoreCdc.ndf'),
    FILEGROUP TransactionData (FILENAME = '/var/opt/cdc/data/MedicationTrackerTransactionData.ndf'),
    FILEGROUP TransactionCdc (FILENAME = '/var/opt/cdc/data/MedicationTrackerTransactionCdc.ndf')
    LOG ON (FILENAME = '/var/opt/cdc/data/MedicationTracker.ldf')
FOR ATTACH;
```

To create the database from scratch, run `database/DatabaseSchema.sql`.

To start Kafka, use `docker compose --file platform/kafka/kafka.yml up`.

## Overview

### Components

Storage

* **Database.** Transaction data.
* **Message broker.** Message data.

Programs

* **Generator.** Transaction workload.
* **Reader.** Query workload.
* **Publisher.** Publishing workload (from CDC to broker).
* **Purger.** Purge workload.
* **Maintainer.** Maintenance workload (e.g. database indexes).

### Data Generation

The list of items is static because pharmacy catalogs are relatively stable. Reference entities are periodically generated to simulate ongoing entry. Transactions are generated with randomly selected entities from a sliding window cache. This way transactions reference entities within a window of recency approximating actual usage.

#### Entities

Rates are specified per company.

| Entity      | Disposition | Ratio      | Rate (Hr)  | Rate (Day) |
|-------------|-------------|-----------:|-----------:|-----------:|
| Company     | Static      |          c |          - |          - |
| User        | Static      |  1,000 x c |          - |          - |
| Facility    | Static      |     10 x c |          - |          - |
| Device      | Static      |     50 x f |          - |          - |
| Item        | Static      |  5,000 x f |          - |          - |
| Patient     | Cycled      |     20 x f |        200 |      4,800 |
| Encounter   | Cycled      |      6 x p |      1,200 |     28,800 |
| Order       | Cycled      |      2 x e |      2,400 |     57,600 |
| Transaction | Continuous  |     12 x d |      6,000 |    144,000 |

#### Notes

General Information

* Static entities have a fixed number of instances generated.
* Cycled entities regularly have new instances generated that have a fixed lifespan of 24 hours. Records for expired instances are removed from the selection pool, but remain in the database.
* Encounter and order life cycles are bound to their containing patient life cycle.

Transaction Creation

* Patient lifespan enables selection for encounters.
* Encounter lifespan enables selection for orders.
* Order lifespan enables selection for transactions.
* Transactions do not directly select patients or encounters - only orders. The patient and encounter is determined from the order.

## File System Performance

In its default configuration, SQL Server on Linux in Docker will saturate the file I/O capacity under modest workloads. This will manifest itself with `PREEMPTIVE_OS_FLUSHFILEBUFFERS` waits and spinlock yield messages on the service console. To resolve this, set trace flag 3979 to disable the forced flush behavior on Linux.

* [GitHub Issue](https://github.com/Microsoft/mssql-docker/issues/355) | [MS KB4131496](https://support.microsoft.com/en-us/help/4131496/kb4131496-enable-forced-flush-mechanism-in-sql-server-2017-on-linux)

Log in to the SQL Server container as `root`:

```
docker exec -u root -it sql-server_mssql_1 /bin/bash
```

Change to the directory with `mssql-conf` and run:

```
cd /opt/mssql/bin
./mssql-conf traceflag 3979 on
```

Restart the container to apply the change.

## Generator

The generator requires Python 3.7+ with `pyodbc`, `cachetools`, and `faker` packages.

Run from the `generator/` directory:

```
python generator.py
```
