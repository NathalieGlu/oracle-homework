@service/patch_ver.sql

spool install_&patch_num..log replace

whenever sqlerror exit failure

set appinfo 'Install Script Oracle patch &patch_num'

set define off

prompt ================

-- таблицы
prompt >>>> table/tables.sql
prompt
@table/tables.sql

-- пакеты
prompt >>>> package/packages.sql
prompt
@package/packages.sql

prompt >>>> test/packages.sql
prompt
@test/packages.sql

-- триггеры
prompt >>>> trigger/triggers.sql
prompt
@trigger/triggers.sql

prompt ================
prompt
prompt Patch was successfull installed

prompt ================ Tests

-- тесты
prompt >>>> test/ut_run.sql
@test/ut_run.sql

prompt ================ End of tests

spool off

exit;