-- MySQL/MariaDB initialization script for ArkCase
-- This script configures the database for large row support

SET GLOBAL innodb_strict_mode = 0;
SET GLOBAL innodb_default_row_format = 'DYNAMIC';
SET GLOBAL innodb_file_per_table = 1;

-- Flush settings
FLUSH STATUS;
