#!/bin/bash

mysql -e "create database stackoverflow"
mysql -p stackoverflow < create_tables.sql
mysql -p stackoverflow < load_data.sql
