# Installation auf einem Entwicklungsrechner für die Nutzung mit dem Portal

## Im Docker Container auf dem Webserver ausführen

```
docker exec -it abus_teams_db bash
mysqldump -uroot -p<PASSWORD> teams acx_access_logs acx_projects acx_project_users acx_security_logs acx_users > /data_exchange/teams.sql
```

***

## Auf dem Zielrechner ausführen

**Docker Konfiguration clonen**
```
cd /var/docker
git clone ssh://git@gitlab.abus-kransysteme.de:2289/docker/teams.git
```

**Docker Container starten**
```
cd /var/docker/teams
docker-compose -f docker-compose.<NAME>.yml up -d --build --force-recreate
```

#### Datenbank

**Sonderfall Teamroom**
Weil hier nur einzelne Tabellen (mehr werden für das Portal nicht benötigt) kopiert werden, erzeugt MySQL Dump kein CREATE DATABASE

```
echo 'DROP DATABASE IF EXISTS teams;
CREATE DATABASE teams;' > /srv/teams/data/exchange/createdatabase.sql
```

**Script für den User erstellen**

```
echo 'USE teams;
DROP USER IF EXISTS 'teams'@'172.%.%.%';
CREATE USER 'teams'@'172.%.%.%' IDENTIFIED BY '<PASSWORD>';
GRANT SELECT, INSERT, UPDATE, DELETE ON teams.* TO 'teams'@'172.%.%.%';' > /srv/teams/data/exchange/users.sql
```

**Daten vom Webserver auf den Zielrechner kopieren und Berechtigungen setzen**
```
sudo scp <LINUX_USERNAME>@192.168.115.235:/srv/teams/data/exchange/teams.sql /srv/teams/data/exchange
sudo chown -R <LINUX_USERNAME>:www-data /srv/teams/data/exchange/
sudo chmod -R 770 /srv/teams/data/exchange/
```

***

## Im Docker Container auf dem Zielrechner ausführen
```
docker exec -it abus_teams_db bash
mysql -uroot -pmariapwd < /data_exchange/createdatabase.sql
mysql -uroot -pmariapwd teams < /data_exchange/teams.sql
mysql -uroot -pmariapwd teams < /data_exchange/users.sql
```