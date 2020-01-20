# Create database for wordpress

```
mysql> CREATE DATABASE databasename;
Query OK, 1 row affected (0.00 sec)


mysql> CREATE USER wordpressuser;
Query OK, 0 rows affected (0.00 sec)


mysql> SET PASSWORD FOR wordpressuser = PASSWORD("wordpresspassword");
Query OK, 0 rows affected (0.00 sec)


GRANT ALL PRIVILEGES ON databasename.* TO "wordpressuser"@"%" IDENTIFIED BY "wordpresspassword";

mysql> GRANT ALL PRIVILEGES ON databasename.* TO "wordpressuser"@"localhost" IDENTIFIED BY "wordpresspassword";
Query OK, 0 rows affected (0.00 sec)


mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)


mysql> EXIT
```