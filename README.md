docker-owncloud7
================

Basic Owncloud 7 Dockerfile from Debian repositories.

Known Bugs:

  * No persistence
  * No restart (no supervisor)
  * Absolutely untested

# Setup

Currently I'm making use of a mysql container as database.
I'm mounting all the directories that need to be persisted
to the host system. I know that this is probably not "the
docker way", but I'm just getting started with it :)

1. Clone [x3ro/docker-mysql](https://github.com/x3ro/docker-mysql)
2. CD into the cloned directory and build it with `docker build -t x3ro/mysql` .
3. Clone this repository
4. CD into the cloned directory and build it with `docker build -t x3ro/owncloud` .
5. Create the following directory structure

		/
		├── var
		│   └── owncloud
		│       ├── data
		│       ├── mysql
		│       └── config
		└── [...]


Now run

	docker run -d --name owncloud-mysql -e MYSQL_ROOT_PASSWORD=foobar \
		-v /var/owncloud/mysql:/var/lib/mysql x3ro/mysql

to create the MySQL container, but please set something more sensible as the password :) After that create the
owncloud container by running

	docker run -d -p 443:443 --name owncloud --link owncloud-mysql:db \
		-v /var/owncloud/data:/var/www/owncloud/data \
		-v /etc/ssl/path-to-ssl:/etc/ssl/owncloud \
		-v /var/owncloud/logs/apache2:/var/log/apache2 \
		-v /var/owncloud/config:/var/www/owncloud/config -t x3ro/owncloud

Make sure that `/etc/ssl/path-to-ssl/` contains an `ssl.key` and an `ssl.pem` or change the configuration in `default-ssl` in this repository before building.

Now you should be able to access your owncloud instance at https://[ip or url]/owncloud.
Configure the databse as MySQL and use the password and host as displayed in
`docker logs owncloud` at the top.

