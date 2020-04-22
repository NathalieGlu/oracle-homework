@service/patch_ver.sql

spool uninstall_&patch_num..log replace

whenever sqlerror exit failure

set appinfo 'Uninstall Script Oracle patch &patch_num'

set define off

prompt ================

prompt drop trigger product_b_iud_stmt_restrict;
drop trigger product_b_iud_stmt_restrict;

prompt drop package test_product_pack;
drop package test_product_pack;

prompt drop package product_pack;
drop package product_pack;

prompt drop table product;
drop table product;

prompt drop sequence product_pk;
drop sequence product_pk;

prompt ================
prompt
prompt Patch was successfull uninstalled


spool off

exit;